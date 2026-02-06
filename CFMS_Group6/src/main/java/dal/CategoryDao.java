/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import dto.CategoryDto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;

/**
 *
 * @author quang
 */
public class CategoryDao {

    public List<Category> loadCategory() {
        String sql = "select * from categories";
        List<Category> catList = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt(1);
                String name = rs.getString(2);
                String prefix_code = rs.getString(3);
                String description = rs.getString(4);
                catList.add(new Category(id, name, prefix_code, description));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return catList;
    }

    public CategoryDto createCategory(String categoryName, String prefixCode, String description) {
        String sql = "insert into categories(category_name, prefix_code, description) values (?,?,?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, categoryName);
            ps.setString(2, prefixCode);
            ps.setString(3, description);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                return new CategoryDto(categoryName, prefixCode, description);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCategory(int categoryId, String categoryName, String description) {
        String sql = "update category set categoryName = ? , description = ? where category_id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            ps.setString(2, description);
            ps.setInt(3, categoryId);
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategory(int categoryId) {
        String sql = "delete from categories where category_id = ? ";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.executeUpdate();
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Category> searchCategory(String keyword) {
        List<Category> list = new ArrayList<>();
        String sql = "select * from Category where categoryName like ? or description like ? or prefixCode like ?";
        String searchKeyword = "%" + keyword + "%";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, searchKeyword);
            ps.setString(2, searchKeyword);
            ps.setString(3, searchKeyword);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("category_id");
                    String name = rs.getString("category_name");
                    String prefix = rs.getString("prefix_code");
                    String description = rs.getString("description");
                    Category c = new Category(id, name, prefix, description);
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
