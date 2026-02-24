/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import model.TransferOrder;

/**
 *
 * @author Admin
 */
public class AssetHistoryDao {
    public void create(int assetId, int userId,String action,String description) {
        String sql = "INSERT INTO asset_history (asset_id, action, performed_by, description) VALUES (?, ?, ?, ?)";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql) ) {

            ps.setInt(1, assetId);
            ps.setString(2, action);
            ps.setInt(3, userId);
            ps.setString(4, description);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
