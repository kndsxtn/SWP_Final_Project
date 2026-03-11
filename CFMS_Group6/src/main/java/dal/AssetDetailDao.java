package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.AssetDetail;
import dto.CreateTransferDto;

/**
 * DAO for working with asset_details (physical asset instances).
 */
public class AssetDetailDao {

    /**
     * Get all available instances for a given asset that are considered "in stock":
     * - status = 'New'
     * - room is NULL or mapped to a room whose name looks like a storage/warehouse.
     */
    public List<AssetDetail> getAvailableInstancesByAsset(int assetId) {
        List<AssetDetail> list = new ArrayList<>();

        String sql = "SELECT ad.instance_id, ad.asset_id, ad.instance_code, ad.room_id, ad.status "
                + "FROM asset_details ad "
                + "LEFT JOIN rooms r ON ad.room_id = r.room_id "
                + "WHERE ad.asset_id = ? "
                + "AND ad.status = N'New' "
                + "AND (ad.room_id IS NULL OR (r.room_name LIKE N'%Kho%' OR r.room_name LIKE N'%lưu trữ%')) "
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

    public List<CreateTransferDto> getByRoomId(int id) {
        String sql = "SELECT ad.instance_id, ad.instance_code, ad.status, a.asset_name, ad.room_id FROM asset_details ad JOIN assets a ON ad.asset_id = a.asset_id WHERE ad.room_id = ?";
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

}
