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
public class UserDAO {

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

    // change password (nguoi dung tu doi)
    public boolean changePassword(int userId, String newPass) {
        String sql = "UPDATE Users SET password_hash=?, is_force_change=0 WHERE user_id=?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPass);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // reset password (admin hoac quen mat khau - se bat buoc doi)
    public boolean resetPassword(int userId, String newPass) {
        String sql = "UPDATE Users SET password_hash=?, is_force_change=1 WHERE user_id=?";
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

    public UserDto getUserByEmail(String email) {
        String sql = "SELECT u.*, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.email = ?";
        try (java.sql.Connection con = new DBContext().getConnection();
                java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserDto(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public UserDto getUserByPhone(String phone) {
        String sql = "SELECT u.*, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.phone = ?";
        try (java.sql.Connection con = new DBContext().getConnection();
                java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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

    public String getRoleNameByUserId(int userId) {
        String sql = "SELECT r.role_name FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role_name");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tìm kiếm người dùng với bộ lọc đơn giản, dễ hiểu
    public List<UserDto> searchUsers(String query, Integer roleId, int page, int pageSize) {
        List<UserDto> list = new ArrayList<>();
        
        // 1. Khởi tạo câu lệnh SQL gốc
        String sql = "SELECT u.*, r.role_name FROM Users u "
                   + "JOIN Roles r ON u.role_id = r.role_id "
                   + "WHERE 1=1 "; // 1=1 là mẹo để dễ dàng cộng thêm các điều kiện AND phía sau

        // 2. Cộng thêm điều kiện nếu có nhập ô tìm kiếm (Tên/Email)
        if (query != null && !query.trim().isEmpty()) {
            sql += " AND (u.username LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?) ";
        }

        // 3. Cộng thêm điều kiện nếu có chọn Role
        if (roleId != null && roleId > 0) {
            sql += " AND u.role_id = ? ";
        }

        // 4. Thêm phần phân trang (Sắp xếp và lấy số lượng bản ghi)
        sql += " ORDER BY u.user_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int index = 1;
            // 5. Truyền giá trị vào các dấu hỏi (?) theo đúng thứ tự đã cộng ở trên
            if (query != null && !query.trim().isEmpty()) {
                String value = "%" + query.trim() + "%";
                ps.setString(index++, value);
                ps.setString(index++, value);
                ps.setString(index++, value);
            }
            if (roleId != null && roleId > 0) {
                ps.setInt(index++, roleId);
            }
            
            // 6. Truyền tham số phân trang (luôn ở cuối cùng)
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index++, pageSize);

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

    // Đếm tổng số bản ghi thỏa mãn điều kiện lọc (để tính tổng số trang)
    public int countSearchUsers(String query, Integer roleId) {
        String sql = "SELECT COUNT(*) FROM Users u WHERE 1=1 ";

        if (query != null && !query.trim().isEmpty()) {
            sql += " AND (u.username LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?) ";
        }
        if (roleId != null && roleId > 0) {
            sql += " AND u.role_id = ? ";
        }

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int index = 1;
            if (query != null && !query.trim().isEmpty()) {
                String value = "%" + query.trim() + "%";
                ps.setString(index++, value);
                ps.setString(index++, value);
                ps.setString(index++, value);
            }
            if (roleId != null && roleId > 0) {
                ps.setInt(index++, roleId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
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
        
        // Doc cot moi: is_force_change
        try {
            user.setForceChange(rs.getBoolean("is_force_change"));
        } catch (Exception e) {
            // Phong truong hop dev chua chay SQL thi mac dinh la false
            user.setForceChange(false);
        }
        
        return user;
    }

}
