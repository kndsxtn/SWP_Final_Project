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

/**
 *
 * @author pham-van-tung
 */
public class AssetDetailDAO {
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
