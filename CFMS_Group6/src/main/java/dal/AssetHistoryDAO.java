/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author admin
 */
/**
 * DAO xử lý bảng asset_history – ghi lịch sử thao tác trên CÁ THỂ tài sản.
 *
 * @author admin
 */
public class AssetHistoryDAO {
    /**
     * Ghi 1 bản ghi lịch sử cho cá thể tài sản.
     *
     * @param instanceId  ID cá thể (asset_details.instance_id)
     * @param userId      Người thực hiện
     * @param action      Hành động (VD: Status_Change, Stock_In, Transfer...)
     * @param description Mô tả chi tiết
     */
    public void create(int instanceId, int userId, String action, String description) {
        String sql = "INSERT INTO asset_history (instance_id, action, performed_by, description) VALUES (?, ?, ?, ?)";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, instanceId);
            ps.setString(2, action);
            ps.setInt(3, userId);
            ps.setString(4, description);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy toàn bộ lịch sử thao tác của 1 cá thể tài sản.
     */
    public java.util.List<model.AssetHistory> getByInstanceId(int instanceId) {
        java.util.List<model.AssetHistory> list = new java.util.ArrayList<>();
        String sql = "SELECT h.*, u.full_name FROM asset_history h "
                   + "JOIN users u ON h.performed_by = u.user_id "
                   + "WHERE h.instance_id = ? "
                   + "ORDER BY h.action_date DESC";
        
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, instanceId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.AssetHistory h = new model.AssetHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    // Do schema tạo bảng có cột history_id hay không?
                    // Nếu không có, set tạm bằng 0 hoặc bỏ qua
                    // Dựa vào sample-data, ta không thấy cột history_id insert, có thể là tự tăng
                    try { h.setHistoryId(rs.getInt("history_id")); } catch (Exception e) {}
                    
                    h.setAssetId(rs.getInt("instance_id")); // trong model là assetId nhưng thực chất map với instance_id
                    h.setAction(rs.getString("action"));
                    h.setPerformedBy(rs.getInt("performed_by"));
                    h.setDescription(rs.getString("description"));
                    h.setActionDate(rs.getTimestamp("action_date"));
                    
                    model.User u = new model.User();
                    u.setFullName(rs.getString("full_name"));
                    h.setPerformer(u);
                    
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
