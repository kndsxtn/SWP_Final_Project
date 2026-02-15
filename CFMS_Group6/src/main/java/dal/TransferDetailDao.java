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
import model.Room;
import model.TransferDetail;

/**
 *
 * @author Admin
 */
public class TransferDetailDao {

    public List<TransferDetail> getByTransferId(int id) {
        String sql = "select * from transfer_details join assets on transfer_details.asset_id = assets.asset_id where transfer_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            List<TransferDetail> transferDetails = new ArrayList<>();
            while (rs.next()) {
                TransferDetail td = new TransferDetail();
                Asset a = new Asset();
                td.setAssetId(id);
                td.setTransferDate(rs.getDate("transfer_date"));
                td.setStatusAtTransfer(rs.getString("status_at_transfer"));

                a.setAssetName(rs.getString("asset_name"));
                a.setAssetCode(rs.getString("asset_code"));
                a.setAssetId(rs.getInt("asset_id"));

                td.setAsset(a);
                transferDetails.add(td);
            }
            return transferDetails;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
