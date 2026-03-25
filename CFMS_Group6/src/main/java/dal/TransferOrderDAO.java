/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

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

                // map src_room
                Room src_room = new Room();
                src_room.setRoomId(rs.getInt("src_id"));
                src_room.setRoomName(rs.getString("src_name"));
                t.setSourceRoom(src_room);

                // map src_room
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

    public List<TransferOrder> getByStaff(int id) {
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
                + "WHERE u.user_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
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

                    // map src_room
                    Room src_room = new Room();
                    src_room.setRoomId(rs.getInt("src_id"));
                    src_room.setRoomName(rs.getString("src_name"));
                    t.setSourceRoom(src_room);

                    // map src_room
                    Room dest_room = new Room();
                    dest_room.setRoomId(rs.getInt("dest_id"));
                    dest_room.setRoomName(rs.getString("dest_name"));
                    t.setDestRoom(dest_room);

                    list.add(t);
                }
            } catch (Exception e) {
                e.getStackTrace();
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
                t.setCreatedDate(rs.getTimestamp("created_date"));
                return t;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tạo phiếu điều chuyển mới
    public int create(TransferOrder t) {
        String sql = "INSERT INTO transfer_orders (created_by, source_room_id, dest_room_id, status, note) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, t.getCreatedBy());
            ps.setInt(2, t.getSourceRoomId());
            ps.setInt(3, t.getDestRoomId());
            ps.setString(4, t.getStatus());
            ps.setString(5, t.getNote());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Update trạng thái (Approve, Reject, Complete)
    public void updateStatus(int transferId, String status) {
        String sql = "UPDATE transfer_orders SET status = ?, "
                + "completed_date = (CASE WHEN ? = 'Completed' THEN GETDATE() ELSE completed_date END) "
                + "WHERE transfer_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, transferId);
            ps.executeUpdate();

            if ("Completed".equals(status) || "Cancelled".equals(status)
                    || "Failed".equals(status) || "Return_Confirmed".equals(status)) {
                String unlockSql = "UPDATE asset_details SET is_locked = 0 WHERE instance_id IN (SELECT instance_id FROM transfer_details WHERE transfer_id = ?)";
                try (PreparedStatement psUnlock = con.prepareStatement(unlockSql)) {
                    psUnlock.setInt(1, transferId);
                    psUnlock.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // set id người duyệt và thời gian duyệt đơn
    public void setApproveBy(int transferId, int userId) {
        String sql = "UPDATE transfer_orders SET approved_by = ?, approved_date = GETDATE() WHERE transfer_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, transferId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // set id người duyệt và thời gian duyệt đơn
    public void setRejectedBy(int transferId, int userId) {
        String sql = "UPDATE transfer_orders SET rejected_by = ?, rejected_date = GETDATE() WHERE transfer_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, transferId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /// lấy thông tin transfer order theo phòng nguồn
    public List<TransferOrder> selectByDeptId(int deptId) {
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
                + "    sr.dept_id AS src_dept,"
                + "\n"
                + "    dr.room_id AS dest_id,\n"
                + "    dr.room_name AS dest_name,\n"
                + "    dr.dept_id AS dest_dept"
                + "\n"
                + "FROM transfer_orders t\n"
                + "JOIN users u ON t.created_by = u.user_id\n"
                + "JOIN rooms sr ON t.source_room_id = sr.room_id\n"
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id\n"
                + "WHERE sr.dept_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, deptId);
            try (ResultSet rs = ps.executeQuery()) {
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

                    // map src_room
                    Room src_room = new Room();
                    src_room.setRoomId(rs.getInt("src_id"));
                    src_room.setRoomName(rs.getString("src_name"));
                    t.setSourceRoom(src_room);

                    // map src_room
                    Room dest_room = new Room();
                    dest_room.setRoomId(rs.getInt("dest_id"));
                    dest_room.setRoomName(rs.getString("dest_name"));
                    t.setDestRoom(dest_room);

                    // Map User
                    list.add(t);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return list;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /// lấy thông tin transfer order theo phòng đích
    public List<TransferOrder> selectByDeptId2(int deptId) {
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
                + "    sr.dept_id AS src_dept,"
                + "\n"
                + "    dr.room_id AS dest_id,\n"
                + "    dr.room_name AS dest_name,\n"
                + "    dr.dept_id AS dest_dept"
                + "\n"
                + "FROM transfer_orders t\n"
                + "JOIN users u ON t.created_by = u.user_id\n"
                + "JOIN rooms sr ON t.source_room_id = sr.room_id\n"
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id\n"
                + "WHERE dr.dept_id = ?";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, deptId);
            try (ResultSet rs = ps.executeQuery()) {
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

                    // map src_room
                    Room src_room = new Room();
                    src_room.setRoomId(rs.getInt("src_id"));
                    src_room.setRoomName(rs.getString("src_name"));
                    src_room.setDeptId(rs.getInt("src_dept"));
                    t.setSourceRoom(src_room);

                    // map dest_room
                    Room dest_room = new Room();
                    dest_room.setRoomId(rs.getInt("dest_id"));
                    dest_room.setRoomName(rs.getString("dest_name"));
                    dest_room.setDeptId(rs.getInt("dest_dept"));
                    t.setDestRoom(dest_room);

                    // Map User
                    list.add(t);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return list;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ========== PAGINATION METHODS ==========

    // --- Transfer List (getAll) pagination ---
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM transfer_orders t "
                + "JOIN users u ON t.created_by = u.user_id "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countByStaff(int userId) {
        String sql = "SELECT COUNT(*) FROM transfer_orders WHERE created_by = ?";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<TransferOrder> getAllByPage(int page, int pageSize) {
        List<TransferOrder> list = new ArrayList<>();
        String sql = " SELECT t.transfer_id, t.created_by, t.source_room_id, t.dest_room_id, "
                + "t.created_date, t.status, t.note, u.user_id, u.full_name, "
                + "sr.room_id AS src_id, sr.room_name AS src_name, "
                + "dr.room_id AS dest_id, dr.room_name AS dest_name "
                + "FROM transfer_orders t "
                + "JOIN users u ON t.created_by = u.user_id "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id "
                + "ORDER BY t.created_date DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransferAll(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TransferOrder> getByStaffByPage(int userId, int page, int pageSize) {
        List<TransferOrder> list = new ArrayList<>();
        String sql = " SELECT t.transfer_id, t.created_by, t.source_room_id, t.dest_room_id, "
                + "t.created_date, t.status, t.note, u.user_id, u.full_name, "
                + "sr.room_id AS src_id, sr.room_name AS src_name, "
                + "dr.room_id AS dest_id, dr.room_name AS dest_name "
                + "FROM transfer_orders t "
                + "JOIN users u ON t.created_by = u.user_id "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id "
                + "WHERE u.user_id = ? "
                + "ORDER BY t.created_date DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransferAll(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // helper map cho getAll/getByStaff (khong co dept_id)
    private TransferOrder mapTransferAll(ResultSet rs) throws Exception {
        TransferOrder t = new TransferOrder();
        t.setTransferId(rs.getInt("transfer_id"));
        t.setCreatedBy(rs.getInt("created_by"));
        t.setSourceRoomId(rs.getInt("source_room_id"));
        t.setDestRoomId(rs.getInt("dest_room_id"));
        t.setStatus(rs.getString("status"));
        t.setNote(rs.getString("note"));
        t.setCreatedDate(rs.getTimestamp("created_date"));
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        t.setCreator(u);
        Room src = new Room();
        src.setRoomId(rs.getInt("src_id"));
        src.setRoomName(rs.getString("src_name"));
        t.setSourceRoom(src);
        Room dest = new Room();
        dest.setRoomId(rs.getInt("dest_id"));
        dest.setRoomName(rs.getString("dest_name"));
        t.setDestRoom(dest);
        return t;
    }

    // --- Handover (source dept) pagination ---
    public int countBySourceDept(int deptId) {
        String sql = "SELECT COUNT(*) FROM transfer_orders t "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "WHERE sr.dept_id = ? AND t.status NOT IN ('Pending','Rejected','Cancelled')";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<TransferOrder> selectByDeptIdByPage(int deptId, int page, int pageSize) {
        List<TransferOrder> list = new ArrayList<>();
        String sql = " SELECT t.transfer_id, t.created_by, t.source_room_id, t.dest_room_id, "
                + "t.created_date, t.status, t.note, u.user_id, u.full_name, "
                + "sr.room_id AS src_id, sr.room_name AS src_name, sr.dept_id AS src_dept, "
                + "dr.room_id AS dest_id, dr.room_name AS dest_name, dr.dept_id AS dest_dept "
                + "FROM transfer_orders t "
                + "JOIN users u ON t.created_by = u.user_id "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id "
                + "WHERE sr.dept_id = ? AND t.status NOT IN ('Pending','Rejected','Cancelled') "
                + "ORDER BY t.created_date DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransferDept(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Receive (dest dept) pagination ---
    public int countByDestDept(int deptId) {
        String sql = "SELECT COUNT(*) FROM transfer_orders t "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id "
                + "WHERE dr.dept_id = ? AND t.status NOT IN ('Pending','Rejected','Cancelled')";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<TransferOrder> selectByDeptId2ByPage(int deptId, int page, int pageSize) {
        List<TransferOrder> list = new ArrayList<>();
        String sql = " SELECT t.transfer_id, t.created_by, t.source_room_id, t.dest_room_id, "
                + "t.created_date, t.status, t.note, u.user_id, u.full_name, "
                + "sr.room_id AS src_id, sr.room_name AS src_name, sr.dept_id AS src_dept, "
                + "dr.room_id AS dest_id, dr.room_name AS dest_name, dr.dept_id AS dest_dept "
                + "FROM transfer_orders t "
                + "JOIN users u ON t.created_by = u.user_id "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id "
                + "WHERE dr.dept_id = ? AND t.status NOT IN ('Pending','Rejected','Cancelled') "
                + "ORDER BY t.created_date DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTransferDept(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // helper map co dept_id
    private TransferOrder mapTransferDept(ResultSet rs) throws Exception {
        TransferOrder t = new TransferOrder();
        t.setTransferId(rs.getInt("transfer_id"));
        t.setCreatedBy(rs.getInt("created_by"));
        t.setSourceRoomId(rs.getInt("source_room_id"));
        t.setDestRoomId(rs.getInt("dest_room_id"));
        t.setStatus(rs.getString("status"));
        t.setNote(rs.getString("note"));
        t.setCreatedDate(rs.getTimestamp("created_date"));
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        t.setCreator(u);
        Room src = new Room();
        src.setRoomId(rs.getInt("src_id"));
        src.setRoomName(rs.getString("src_name"));
        src.setDeptId(rs.getInt("src_dept"));
        t.setSourceRoom(src);
        Room dest = new Room();
        dest.setRoomId(rs.getInt("dest_id"));
        dest.setRoomName(rs.getString("dest_name"));
        dest.setDeptId(rs.getInt("dest_dept"));
        t.setDestRoom(dest);
        return t;
    }
    // Lấy lịch sử trung chuyển của một cá thể tài sản
    public List<TransferOrder> getTransferHistoryByInstanceId(int instanceId) {
        List<TransferOrder> list = new ArrayList<>();
        String sql = "SELECT t.transfer_id, t.created_date, t.completed_date, t.status, "
                + "sr.room_name AS src_name, dr.room_name AS dest_name, u.full_name "
                + "FROM transfer_orders t "
                + "JOIN transfer_details td ON t.transfer_id = td.transfer_id "
                + "JOIN rooms sr ON t.source_room_id = sr.room_id "
                + "JOIN rooms dr ON t.dest_room_id = dr.room_id "
                + "JOIN users u ON t.created_by = u.user_id "
                + "WHERE td.instance_id = ? AND t.status = 'Completed' "
                + "ORDER BY t.completed_date DESC";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, instanceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransferOrder t = new TransferOrder();
                    t.setTransferId(rs.getInt("transfer_id"));
                    t.setCreatedDate(rs.getTimestamp("created_date"));
                    t.setCompletedDate(rs.getTimestamp("completed_date"));
                    t.setStatus(rs.getString("status"));

                    Room src = new Room();
                    src.setRoomName(rs.getString("src_name"));
                    t.setSourceRoom(src);

                    Room dest = new Room();
                    dest.setRoomName(rs.getString("dest_name"));
                    t.setDestRoom(dest);

                    User u = new User();
                    u.setFullName(rs.getString("full_name"));
                    t.setCreator(u);

                    list.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
