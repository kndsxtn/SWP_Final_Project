/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Asset;

/**
 *
 * @author Admin
 */
public class AssetDao {
    public List<Asset> getByRoomId(int id) {
        String sql = "SELECT * FROM assets WHERE room_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            List<Asset> assets = new ArrayList<>();
            while (rs.next()) {
                Asset a = new Asset();
                a.setAssetId(rs.getInt("asset_id"));
                a.setAssetCode(rs.getString("asset_code"));
                a.setAssetName(rs.getString("asset_name"));
                a.setStatus(rs.getString("status"));
                assets.add(a);
            }
            return assets;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
