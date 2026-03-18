/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.CreateTransferDto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Asset;
import model.AssetDetail;
import model.Category;
import model.Room;

/**
 *
 * @author admin
 */
public class AssetDetailDAO {
    public List<CreateTransferDto> getByRoomId(int id) {
        String sql = "SELECT ad.instance_id, ad.instance_code, ad.status, a.asset_name, ad.room_id FROM asset_details ad JOIN assets a ON ad.asset_id = a.asset_id WHERE ad.room_id = ? AND (ad.is_locked = 0 OR ad.is_locked IS NULL)";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
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

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public CreateTransferDto getById(int id) {
        String sql = "SELECT ad.instance_id, ad.instance_code, ad.status, a.asset_name, ad.room_id FROM asset_details ad JOIN assets a ON ad.asset_id = a.asset_id WHERE ad.instance_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CreateTransferDto a = new CreateTransferDto();
                a.setInstanceId(rs.getInt("instance_id"));
                a.setInstanceCode(rs.getString("instance_code"));
                a.setRoomId(rs.getInt("room_id"));
                a.setStatus(rs.getString("status"));
                a.setAssetName(rs.getString("asset_name"));
                return a;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void setRoomId(int roomId, int instanceId) {
        String sql = "UPDATE asset_details SET room_id = ? WHERE instance_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, instanceId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Get all available instances for a given asset that are considered "in stock":
     * - status = 'In_Stock'
     * - room is NULL or mapped to a room whose name looks like a storage/warehouse.
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
                        psHis.setString(3,
                                description != null ? description : ("Nhập kho từ mua sắm: " + instanceCode));
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

    // Lấy ra danh sách các cá thể vừa được sinh thành công trong quá trình nhập kho
    // PO
    public List<AssetDetail> getInstancesStockedInForProcurement(int procurementId) {
        List<AssetDetail> list = new ArrayList<>();
        // Tìm các cá thể thông qua asset_history với mô tả 'Nhập kho từ PO: PROC-[id]'
        String sql = "SELECT ad.*, a.asset_code, a.asset_name, c.category_name "
                + "FROM asset_details ad "
                + "JOIN assets a ON ad.asset_id = a.asset_id "
                + "JOIN categories c ON a.category_id = c.category_id "
                + "WHERE EXISTS ("
                + "   SELECT 1 FROM asset_history ah "
                + "   WHERE ah.instance_id = ad.instance_id "
                + "     AND ah.action = N'Stock_In' "
                + "     AND ah.description = ? "
                + ") ORDER BY ad.instance_code";

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "Nhập kho từ PO: PROC-" + procurementId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssetDetail ad = new AssetDetail();
                    ad.setInstanceId(rs.getInt("instance_id"));
                    ad.setAssetId(rs.getInt("asset_id"));
                    ad.setInstanceCode(rs.getString("instance_code"));
                    ad.setStatus(rs.getString("status"));

                    Asset asset = new Asset();
                    asset.setAssetId(rs.getInt("asset_id"));
                    asset.setAssetCode(rs.getString("asset_code"));
                    asset.setAssetName(rs.getString("asset_name"));
                    Category cat = new Category();
                    cat.setCategoryName(rs.getString("category_name"));
                    asset.setCategory(cat);

                    ad.setAsset(asset);
                    list.add(ad);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //
    public List<AssetDetail> getAssetDetailByAssetId(int assetId) {
        List<AssetDetail> assetDetails = new ArrayList<>();
        String sql = "SELECT ad.*, a.asset_name, r.room_name FROM asset_details ad LEFT JOIN assets a ON ad.asset_id = a.asset_id LEFT JOIN rooms r ON ad.room_id = r.room_id WHERE ad.asset_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AssetDetail ad = mapAssetDetail(rs);
                assetDetails.add(ad);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return assetDetails;
    }

    /**
     * Tìm kiếm và phân trang danh sách cá thể theo asset_id.
     *
     * @param assetId  ID tài sản cha
     * @param keyword  Tìm theo mã cá thể hoặc tên phòng (null = bỏ qua)
     * @param status   Lọc theo trạng thái cá thể (null = tất cả)
     * @param page     Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số bản ghi mỗi trang
     * @return Danh sách cá thể khớp điều kiện
     */
    public List<AssetDetail> searchByAssetId(int assetId, String keyword, String status,
            int page, int pageSize) {
        List<AssetDetail> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ad.*, a.asset_name, r.room_name "
                        + "FROM asset_details ad "
                        + "LEFT JOIN assets a ON ad.asset_id = a.asset_id "
                        + "LEFT JOIN rooms r ON ad.room_id = r.room_id "
                        + "WHERE ad.asset_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(assetId);

        // Filter theo keyword (mã cá thể hoặc tên phòng)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (ad.instance_code LIKE ? OR r.room_name LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
        }

        // Filter theo trạng thái
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND ad.status = ? ");
            params.add(status.trim());
        }

        sql.append("ORDER BY ad.instance_code ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {

            setParams(ps, params);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapAssetDetail(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm tổng số cá thể khớp filter (dùng cho phân trang).
     */
    public int countByAssetId(int assetId, String keyword, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM asset_details ad "
                        + "LEFT JOIN rooms r ON ad.room_id = r.room_id "
                        + "WHERE ad.asset_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(assetId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (ad.instance_code LIKE ? OR r.room_name LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND ad.status = ? ");
            params.add(status.trim());
        }

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {

            setParams(ps, params);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Set params cho PreparedStatement từ danh sách Object.
     */
    private void setParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            Object p = params.get(i);
            if (p instanceof String) {
                ps.setString(i + 1, (String) p);
            } else if (p instanceof Integer) {
                ps.setInt(i + 1, (Integer) p);
            }
        }
    }

    /**
     * Map 1 dòng ResultSet thành AssetDetail object (kèm Category, Supplier, Room).
     */
    private AssetDetail mapAssetDetail(ResultSet rs) throws Exception {
        AssetDetail ad = new AssetDetail();
        ad.setInstanceId(rs.getInt("instance_id"));
        ad.setAssetId(rs.getInt("asset_id"));
        ad.setInstanceCode(rs.getString("instance_code"));
        ad.setRoomId(rs.getInt("room_id"));
        ad.setStatus(rs.getString("status"));
        // Set related objects
        try {
            Room r = new Room();
            r.setRoomId(ad.getRoomId());
            r.setRoomName(rs.getString("room_name"));
            ad.setRoom(r);
        } catch (Exception ignored) {
        }

        try {
            Asset a = new Asset();
            a.setAssetName(rs.getString("asset_name"));
            ad.setAsset(a);
        } catch (Exception ignored) {
        }

        return ad;
    }

    // UC xx: phục vụ xem tài sản của 1 phòng nhất định dựa vào id
    public List<AssetDetail> getAssetDetailByRoomId(int roomId) {
        List<AssetDetail> assetDetails = new ArrayList<>();
        String sql = "SELECT ad.instance_code, a.asset_name, ad.status FROM asset_details ad LEFT JOIN assets a ON ad.asset_id = a.asset_id LEFT JOIN rooms r ON ad.room_id = r.room_id WHERE r.room_id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AssetDetail ad = new AssetDetail();
                ad.setInstanceCode(rs.getString("instance_code"));
                ad.setStatus(rs.getString("status"));

                Asset a = new Asset();
                a.setAssetName(rs.getString("asset_name"));
                ad.setAsset(a);
                assetDetails.add(ad);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return assetDetails;
    }

    // test các hàm
    public static void main(String[] args) {
        AssetDetailDAO dao = new AssetDetailDAO();
        // Thay số 1 bằng một assetId thực tế đang có trong DB của bạn (ví dụ lấy từ
        // sample-data.sql)
        int testAssetId = 1;

        List<AssetDetail> list = dao.getAssetDetailByRoomId(testAssetId);

        if (list != null && !list.isEmpty()) {
            System.out.println("✅ Test thành công! Tìm thấy " + list.size() + " cá thể cho Asset ID: " + testAssetId);
            for (AssetDetail ad : list) {
                System.out.println("--------------------------------------------------");
                System.out.println("Mã cá thể: " + ad.getInstanceCode());
                System.out.println("Tên tài sản: " + (ad.getAsset() != null ? ad.getAsset().getAssetName() : "N/A"));
                System.out.println("Vị trí: " + (ad.getRoom() != null ? ad.getRoom().getRoomName() : "Trong kho"));
                System.out.println("Trạng thái: " + ad.getStatus());
            }
        } else {
            System.out.println("❌ Test thất bại hoặc không tìm thấy cá thể nào cho Asset ID: " + testAssetId);
        }
    }

}
