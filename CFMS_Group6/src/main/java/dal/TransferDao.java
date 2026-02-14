/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import model.Asset;
import model.TransferOrder;

/**
 *
 * @author Admin
 */
public class TransferDao {

    public int createTransfer(TransferOrder t, List<Asset> assetList) throws Exception {

        String insertOrder = "INSERT INTO transfer_orders(created_by, source_room_id, dest_room_id, note) VALUES (?, ?, ?, ?)";
        String insertDetail = "INSERT INTO transfer_details(transfer_id, asset_id, status_at_transfer) VALUES (?, ?, ?)";

        try (Connection con = new DBContext().getConnection()) {
            con.setAutoCommit(false);

            // 1️⃣ Insert order
            PreparedStatement ps = con.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, t.getCreatedBy());
            ps.setInt(2, t.getSourceRoomId());
            ps.setInt(3, t.getDestRoomId());
            ps.setString(4, t.getNote());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            int transferId = rs.getInt(1);

            // 2️⃣ Insert details
            PreparedStatement ps2 = con.prepareStatement(insertDetail);
            for (Asset a : assetList) {
                ps2.setInt(1, transferId);
                ps2.setInt(2, a.getAssetId());
                ps2.setString(3, a.getStatus());
                ps2.addBatch();
            }
            ps2.executeBatch();

            con.commit();
            return transferId;
        }
    }
}
