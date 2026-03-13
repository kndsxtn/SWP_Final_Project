/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.CreateTransferDto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import model.TransferOrder;

/**
 *
 * @author Admin
 */
public class TransferDAO {

    public int createTransfer(TransferOrder t, List<CreateTransferDto> assetList) throws Exception {

        String insertOrder = "INSERT INTO transfer_orders(created_by, source_room_id, dest_room_id, note) VALUES (?, ?, ?, ?)";
        String insertDetail = "INSERT INTO transfer_details(transfer_id, instance_id, status_at_transfer) VALUES (?, ?, ?)";
        String lockInstance = "UPDATE asset_details SET is_locked = 1 WHERE instance_id = ?";

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

            // 2️⃣ Insert details and lock asset instance
            PreparedStatement ps2 = con.prepareStatement(insertDetail);
            PreparedStatement ps3 = con.prepareStatement(lockInstance);
            for (CreateTransferDto a : assetList) {
                ps2.setInt(1, transferId);
                ps2.setInt(2, a.getInstanceId());
                ps2.setString(3, a.getStatus());
                ps2.addBatch();

                ps3.setInt(1, a.getInstanceId());
                ps3.addBatch();
            }
            ps2.executeBatch();
            ps3.executeBatch();

            con.commit();
            return transferId;
        }
    }
}
