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
import model.AssetDetail;
import model.TransferDetail;

/**
 *
 * @author Admin
 */
public class TransferDetailDAO {

    public List<TransferDetail> getByTransferId(int id) {
        String sql = "SELECT td.*, ad.instance_code, a.asset_name " +
                     "FROM transfer_details td " +
                     "JOIN asset_details ad ON td.instance_id = ad.instance_id " +
                     "JOIN assets a ON ad.asset_id = a.asset_id " +
                     "WHERE td.transfer_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            List<TransferDetail> transferDetails = new ArrayList<>();
            while (rs.next()) {
                TransferDetail td = new TransferDetail();
                AssetDetail a = new AssetDetail();
                td.setTransferId(id);
                td.setInstanceId(rs.getInt("instance_id"));
                td.setTransferDate(rs.getDate("transfer_date"));
                td.setStatusAtTransfer(rs.getString("status_at_transfer"));
                td.setAssetName(rs.getString("asset_name"));
                
                a.setInstanceCode(rs.getString("instance_code")); // Set specifically to show correct value on jsp page

                td.setAssetDetail(a);
                transferDetails.add(td);
            }
            return transferDetails;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
