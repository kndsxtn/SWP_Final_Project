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
}
