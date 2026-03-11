package dal;

import dto.CreateTransferDto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.AssetDetail;

/**
 * DAO for working with asset_details (physical asset instances).
 */
public class AssetDetailDao {

    public List<CreateTransferDto> getByRoomId(int roomId) {
        String sql = "SELECT ad.instance_id, ad.instance_code, ad.status, a.asset_name, ad.room_id "
                + "FROM asset_details ad "
                + "JOIN assets a ON ad.asset_id = a.asset_id "
                + "WHERE ad.room_id = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                List<CreateTransferDto> assets = new ArrayList<>();
                while (rs.next()) {
                    CreateTransferDto a = new CreateTransferDto();
                    a.setInstanceId(rs.getInt("instance_id"));
                    a.setInstanceCode(rs.getString("instance_code"));
                    a.setRoomId(rs.getInt("room_id"));
                    a.setStatus(rs.getString("status"));
                    a.setAssetName(rs.getString("asset_name"));
                    assets.add(a);
                }
                return assets;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public CreateTransferDto getById(int instanceId) {
        String sql = "SELECT ad.instance_id, ad.instance_code, ad.status, a.asset_name, ad.room_id "
                + "FROM asset_details ad "
                + "JOIN assets a ON ad.asset_id = a.asset_id "
                + "WHERE ad.instance_id = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, instanceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CreateTransferDto a = new CreateTransferDto();
                    a.setInstanceId(rs.getInt("instance_id"));
                    a.setInstanceCode(rs.getString("instance_code"));
                    a.setRoomId(rs.getInt("room_id"));
                    a.setStatus(rs.getString("status"));
                    a.setAssetName(rs.getString("asset_name"));
                    return a;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get all available instances for a given asset that are considered "in stock":
     * - status = 'New' (định nghĩa mới: đang ở kho)
     * - room_id IS NULL (đang ở kho => chắc chắn chưa gán phòng)
     */
    public List<AssetDetail> getAvailableInstancesByAsset(int assetId) {
        List<AssetDetail> list = new ArrayList<>();

        String sql = "SELECT ad.instance_id, ad.asset_id, ad.instance_code, ad.room_id, ad.status "
                + "FROM asset_details ad "
                + "WHERE ad.asset_id = ? "
                + "AND ad.status = N'In_Stock' "
                + "AND ad.room_id IS NULL "
                + "ORDER BY ad.instance_code";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, assetId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssetDetail inst = new AssetDetail();
                    inst.setInstanceId(rs.getInt("instance_id"));
                    inst.setAssetId(rs.getInt("asset_id"));
                    inst.setInstanceCode(rs.getString("instance_code"));
                    int roomId = rs.getInt("room_id");
                    inst.setRoomId(rs.wasNull() ? null : roomId);
                    inst.setStatus(rs.getString("status"));
                    list.add(inst);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Stock-in new physical instances for a given asset lot.
     * Creates rows in asset_details with:
     * - room_id = NULL
     * - status = In_Stock
     * Also writes asset_history (action = Stock_In) for each created instance.
     *
     * Assumes caller manages the transaction (uses provided Connection).
     */
    public void stockInInstances(Connection con,
                                 int assetId,
                                 String assetCode,
                                 int quantity,
                                 int performedByUserId,
                                 String description) throws Exception {
        if (con == null) {
            throw new IllegalArgumentException("Connection is required");
        }
        if (assetId <= 0 || quantity <= 0) {
            return;
        }
        if (assetCode == null || assetCode.isBlank()) {
            assetCode = getAssetCodeById(con, assetId);
        }
        if (assetCode == null || assetCode.isBlank()) {
            throw new IllegalArgumentException("assetCode is required");
        }

        int nextSeq = getNextInstanceSequence(con, assetId);

        String sqlInsert = "INSERT INTO asset_details (asset_id, instance_code, room_id, status) "
                + "OUTPUT INSERTED.instance_id "
                + "VALUES (?, ?, NULL, N'In_Stock')";

        String sqlHistory = "INSERT INTO asset_history "
                + "(instance_id, action, performed_by, description, action_date) "
                + "VALUES (?, N'Stock_In', ?, ?, GETDATE())";

        try (PreparedStatement psIns = con.prepareStatement(sqlInsert);
             PreparedStatement psHis = con.prepareStatement(sqlHistory)) {

            for (int i = 0; i < quantity; i++) {
                int attempt = 0;
                while (true) {
                    String instanceCode = assetCode + "-" + String.format("%03d", nextSeq);
                    attempt++;
                    try {
                        psIns.setInt(1, assetId);
                        psIns.setString(2, instanceCode);

                        int instanceId;
                        try (ResultSet rs = psIns.executeQuery()) {
                            if (!rs.next()) {
                                throw new IllegalStateException("Failed to insert asset_details for " + instanceCode);
                            }
                            instanceId = rs.getInt(1);
                        }

                        psHis.setInt(1, instanceId);
                        psHis.setInt(2, performedByUserId);
                        psHis.setString(3, description != null ? description : ("Nhập kho từ mua sắm: " + instanceCode));
                        psHis.addBatch();

                        nextSeq++;
                        break;
                    } catch (Exception e) {
                        // If instance_code collision happens, skip to next seq and retry a few times.
                        nextSeq++;
                        if (attempt >= 5) {
                            throw e;
                        }
                    }
                }
            }

            psHis.executeBatch();
        }
    }

    private int getNextInstanceSequence(Connection con, int assetId) throws Exception {
        // Find the maximum numeric suffix after the last dash: <assetCode>-NNN
        String sql = "SELECT ISNULL(MAX(TRY_CONVERT(INT, RIGHT(instance_code, CHARINDEX('-', REVERSE(instance_code)) - 1))), 0) + 1 "
                + "FROM asset_details WHERE asset_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 1;
    }

    private String getAssetCodeById(Connection con, int assetId) throws Exception {
        String sql = "SELECT asset_code FROM assets WHERE asset_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString(1);
                }
            }
        }
        return null;
    }

}
