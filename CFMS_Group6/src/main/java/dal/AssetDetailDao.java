package dal;

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

}
