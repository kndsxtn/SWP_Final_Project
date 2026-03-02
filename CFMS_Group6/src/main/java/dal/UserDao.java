/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.UserDto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyen Dinh Giap
 */
public class UserDao {

    // login
    public UserDto checkLogin(String userName, String password) {
        String sql = "SELECT u.*, r.role_name FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.username = ? AND u.password_hash = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userName);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserDto(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // get profile
    public UserDto getUserByid(int userId) {
        String sql = "SELECT u.*, r.role_name FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserDto(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // update profile
    public boolean updateProfile(UserDto user) {
        String sql = "UPDATE Users SET full_name=?,"
                + " phone=?, email=? WHERE user_id=?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getEmail());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // change password
    public boolean changePassword(int userId, String newPass) {
        String sql = "UPDATE Users SET password_hash=? WHERE user_id=?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPass);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // lay pasword bang usename
    public String getPasswordByUserName(String username) {
        String sql = "SELECT [password_hash] FROM Users WHERE username = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // get all user
    public List<UserDto> getAllUser() {
        List<UserDto> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapUserDto(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // dem tong so user
    public int countAllUser() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // lay danh sach user theo trang (phan trang)
    public List<UserDto> getUsersByPage(int page, int pageSize) {
        List<UserDto> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "ORDER BY u.user_id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUserDto(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // kiem tra xem user co ton tai ko
    public UserDto getUserByUserName(String userName) {
        String sql = "SELECT u.*, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.username = ?";

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            // truyen gia tri ?
            ps.setString(1, userName);

            // thuc thi cau lenh sql
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    // Map data
                    return mapUserDto(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // them nguoi dung moi vao DB, mat khau luu dang plain (co the hash sau)
    public boolean createUser(String username, String password, String fullName,
            String email, String phone, int roleId) {
        // kiem tra username da ton tai chua
        if (getUserByUserName(username) != null) {
            return false;
        }
        String sql = "INSERT INTO Users (username, password_hash, full_name, email, phone, role_id, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'Active')";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, fullName);
            ps.setString(4, email);
            ps.setString(5, phone);
            ps.setInt(6, roleId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // lay danh sach tat ca role de hien thi dropdown trong form
    public List<model.Role> getAllRoles() {
        List<model.Role> roles = new ArrayList<>();
        String sql = "SELECT role_id, role_name FROM Roles";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                model.Role r = new model.Role();
                r.setRoleId(rs.getInt("role_id"));
                r.setRoleName(rs.getString("role_name"));
                roles.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }

    // cap nhat role cho user
    public boolean updateUserRole(int userId, int roleId) {
        String sql = "UPDATE Users SET role_id = ? WHERE user_id = ?";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // cap nhat trang thai user (Active / Inactive)
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE Users SET status = ? WHERE user_id = ?";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // mapping
    private UserDto mapUserDto(ResultSet rs) throws Exception {
        UserDto user = new UserDto();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRoleId(rs.getInt("role_id"));
        user.setRoleName(rs.getString("role_name"));
        int deptId = rs.getInt("dept_id");
        user.setDeptId(rs.wasNull() ? 0 : deptId);
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }

}
