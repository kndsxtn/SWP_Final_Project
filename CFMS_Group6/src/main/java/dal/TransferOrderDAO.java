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
import model.Room;
import model.TransferOrder;
import model.User;

/**
 *
 * @author Admin
 */
public class TransferOrderDAO {
    // Lấy toàn bộ phiếu điều chuyển

    public List<TransferOrder> getAll() {
        List<TransferOrder> list = new ArrayList<>();

        String sql = " SELECT \n"
                + "    t.transfer_id,\n"
                + "    t.created_by,\n"
                + "    t.source_room_id,\n"
                + "    t.dest_room_id,\n"
                + "    t.created_date,\n"
                + "    t.status,\n"
                + "    t.note,\n"
                + "\n"
                + "    u.user_id,\n"
                + "    u.full_name,\n"
                + "\n"
                + "    sr.room_id AS src_id,\n"
                + "    sr.room_name AS src_name,\n"
                + "\n"
                + "    dr.room_id AS dest_id,\n"
                + "    dr.room_name AS dest_name\n"
                + "\n"
                + "FROM transfer_orders t\n"
                + "JOIN users u ON t.created_by = u.user_id\n"
                + "JOIN rooms sr ON t.source_room_id = sr.room_id\n"
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id\n"
                + "ORDER BY t.created_date DESC;";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TransferOrder t = new TransferOrder();
                t.setTransferId(rs.getInt("transfer_id"));
                t.setCreatedBy(rs.getInt("created_by"));
                t.setSourceRoomId(rs.getInt("source_room_id"));
                t.setDestRoomId(rs.getInt("dest_room_id"));
                t.setStatus(rs.getString("status"));
                t.setNote(rs.getString("note"));
                t.setCreatedDate(rs.getTimestamp("created_date"));

                // Map User
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                t.setCreator(u);

                //map src_room
                Room src_room = new Room();
                src_room.setRoomId(rs.getInt("src_id"));
                src_room.setRoomName(rs.getString("src_name"));
                t.setSourceRoom(src_room);

                //map src_room
                Room dest_room = new Room();
                dest_room.setRoomId(rs.getInt("dest_id"));
                dest_room.setRoomName(rs.getString("dest_name"));
                t.setDestRoom(dest_room);

                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy 1 phiếu theo ID
    public TransferOrder getById(int id) {
        String sql = "SELECT * FROM transfer_orders WHERE transfer_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                TransferOrder t = new TransferOrder();
                t.setTransferId(rs.getInt("transfer_id"));
                t.setCreatedBy(rs.getInt("created_by"));
                t.setSourceRoomId(rs.getInt("source_room_id"));
                t.setDestRoomId(rs.getInt("dest_room_id"));
                t.setStatus(rs.getString("status"));
                t.setNote(rs.getString("note"));
                t.setCreatedDate(rs.getTimestamp("created_at"));
                return t;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tạo phiếu điều chuyển mới
//    public int create(TransferOrder t) {
//        String sql = """
//            INSERT INTO transfer_orders
//            (created_by, source_room_id, dest_room_id, status, note)
//            VALUES (?, ?, ?, ?, ?)
//        """;
//
//        try (Connection con = new DBContext().getConnection();
//             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
//
//            ps.setInt(1, t.getCreatedBy());
//            ps.setInt(2, t.getSourceRoomId());
//            ps.setInt(3, t.getDestRoomId());
//            ps.setString(4, t.getStatus());
//            ps.setString(5, t.getNote());
//
//            ps.executeUpdate();
//            ResultSet rs = ps.getGeneratedKeys();
//            if (rs.next()) return rs.getInt(1);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return -1;
//    }
    // Update trạng thái (Approve, Reject, Complete)
    public void updateStatus(int transferId, String status) {
        String sql = "UPDATE transfer_orders SET status = ? WHERE transfer_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, transferId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá phiếu (chỉ dùng khi Pending)
    public void delete(int transferId) {
        String sql = "DELETE FROM transfer_orders WHERE transfer_id = ? AND status = 'Pending'";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, transferId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
