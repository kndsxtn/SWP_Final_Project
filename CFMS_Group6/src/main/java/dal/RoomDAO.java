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

import model.Department;

/**
 *
 * @author Admin
 */
public class RoomDAO {
    public List<Room> getByDeptId(int deptId) {
        String sql = "SELECT * FROM rooms WHERE dept_id = ? ORDER BY room_name";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, deptId);
            ResultSet rs = ps.executeQuery();
            List<Room> rooms = new ArrayList<>();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomName(rs.getString("room_name"));
                r.setDeptId(rs.getInt("dept_id"));
                r.setCapacity(rs.getInt("capacity"));
                rooms.add(r);
            }
            return rooms;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    public List<Room> getAll() {
        String sql = "SELECT * FROM rooms";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            List<Room> rooms = new ArrayList<>();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomName(rs.getString("room_name"));
                r.setDeptId(rs.getInt("dept_id"));
                r.setCapacity(rs.getInt("capacity"));
                rooms.add(r);
            }
            return rooms;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public Room getById(int id) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1,id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomName(rs.getString("room_name"));
                r.setDeptId(rs.getInt("dept_id"));
                r.setCapacity(rs.getInt("capacity"));
                return r;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách toàn bộ phòng ban (dùng cho dropdown lọc kiểm kê).
     */
    public List<Department> getAllDepartments() {
        String sql = "SELECT dept_id, dept_name, description FROM departments ORDER BY dept_name";
        List<Department> list = new ArrayList<>();
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Department d = new Department();
                d.setDeptId(rs.getInt("dept_id"));
                d.setDeptName(rs.getString("dept_name"));
                d.setDescription(rs.getString("description"));
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}
