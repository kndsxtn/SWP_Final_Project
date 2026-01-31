/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ADMIN
 */

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    
    // Hàm kiểm tra đăng nhập: Trả về object User nếu đúng, null nếu sai
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password_hash = ?"; // Cần mã hóa password sau này
        
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection();
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Nếu tìm thấy, map dữ liệu từ SQL vào Model User
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRoleId(rs.getInt("role_id"));
                user.setDeptId(rs.getInt("dept_id"));
                
                return user;
            }
        } catch (Exception e) {
            System.out.println("Loi Login: " + e.getMessage());
        }
        return null; // Đăng nhập thất bại
    }
    
    // Hàm main để test DAO ngay lập tức (Không cần chạy web)
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        User u = dao.checkLogin("admin", "123456"); // Thay bằng user thật trong DB của bạn
        
        if (u != null) {
            System.out.println("Dang nhap thanh cong! Hello " + u.getFullName());
        } else {
            System.out.println("Dang nhap that bai!");
        }
    }
}

