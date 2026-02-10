package dao;

import model.Asset;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.time.LocalDate;

public class AssetDAO {

    public List<Asset> getAll() {
        List<Asset> assets = new ArrayList<>();
        // Sửa SQL khớp với db_draft.sql
        String sql = "SELECT * FROM assets";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Asset a = new Asset();
                // 1. Các trường cơ bản
                a.setAssetId(rs.getInt("asset_id"));
                a.setAssetCode(rs.getString("asset_code"));
                a.setAssetName(rs.getString("asset_name"));
                a.setCategoryId(rs.getInt("category_id"));
                a.setRoomId(rs.getInt("room_id"));
                a.setStatus(rs.getString("status"));
                a.setDescription(rs.getString("description"));

                // 2. Xử lí kiểu tiền tệ
                a.setPrice(rs.getBigDecimal("price"));

                // 3. Xử lí thời gian
                a.setPurchaseDate(rs.getDate("purchase_date"));
                a.setWarrantyExpiryDate(rs.getDate("warranty_expiry_date"));
                a.setCreatedAt(rs.getTimestamp("created_at")); // Timestamp lấy được cả ngày và giờ
                assets.add(a);
            }
        } catch (Exception e) { // Catch chung Exception cho nhanh hoặc catch từng cái
            e.printStackTrace();
        }
        return assets;
    }

    public String generateAssetCode(int categoryId) {
        String prefix = "";
        String sqlGetPrefix = "SELECT prefix_code FROM categories WHERE category_id = ?";

        // 1. Lấy Prefix từ Category
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlGetPrefix)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                prefix = rs.getString("prefix_code");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null; // Lỗi DB
        }
        if (prefix.isEmpty())
            return null; // Không tìm thấy Category
        // 2. Tìm mã lớn nhất hiện tại của Prefix này trong năm nay
        // Ví dụ mã: LAP-2024-XXX. Ta cần tìm cái có đuôi XXX lớn nhất.
        int currentYear = LocalDate.now().getYear();
        String codePattern = prefix + "-" + currentYear + "-%"; // VD: LAP-2024-%

        // Câu lệnh này lấy ra mã tài sản cuối cùng (lớn nhất) theo thứ tự Alpha
        String sqlGetMaxCode = "SELECT TOP 1 asset_code FROM assets WHERE asset_code LIKE ? ORDER BY asset_code DESC";

        String nextCode = prefix + "-" + currentYear + "-001"; // Mặc định nếu chưa có cái nào
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlGetMaxCode)) {
            ps.setString(1, codePattern);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String maxCode = rs.getString("asset_code");
                // maxCode dạng: LAP-2024-005
                // Cắt chuỗi lấy phần số đuôi (3 ký tự cuối)
                String sequenceStr = maxCode.substring(maxCode.lastIndexOf("-") + 1);

                try {
                    int sequence = Integer.parseInt(sequenceStr);
                    sequence++; // Tăng lên 1
                    // Format lại thành 3 chữ số (VD: 6 -> "006")
                    nextCode = prefix + "-" + currentYear + "-" + String.format("%03d", sequence);
                } catch (NumberFormatException e) {
                    // Phòng trường hợp mã cũ bị sai định dạng thì reset về 001 hoặc ném lỗi
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return nextCode;
    }

    public boolean insertAsset(Asset asset) {
        // Sinh mã tài sản tự động trước khi insert
        String generatedCode = generateAssetCode(asset.getCategoryId());
        if (generatedCode == null)
            return false; // Lỗi sinh mã

        asset.setAssetCode(generatedCode);

        String sql = "INSERT INTO assets (asset_code, asset_name, category_id, supplier_id, room_id, "
                + "price, purchase_date, warranty_expiry_date, status, description, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, asset.getAssetCode());
            ps.setString(2, asset.getAssetName());
            ps.setInt(3, asset.getCategoryId());

            // Xử lý các trường có thể null (supplier_id, room_id)
            if (asset.getSupplierId() > 0)
                ps.setInt(4, asset.getSupplierId());
            else
                ps.setNull(4, java.sql.Types.INTEGER);

            if (asset.getRoomId() > 0)
                ps.setInt(5, asset.getRoomId());
            else
                ps.setNull(5, java.sql.Types.INTEGER);

            ps.setBigDecimal(6, asset.getPrice());

            // Chuyển đổi util.Date sang sql.Date
            // Dùng java.sql.Date cho trường DATE trong SQL
            if (asset.getPurchaseDate() != null)
                ps.setDate(7, new java.sql.Date(asset.getPurchaseDate().getTime()));
            else
                ps.setNull(7, java.sql.Types.DATE);

            if (asset.getWarrantyExpiryDate() != null)
                ps.setDate(8, new java.sql.Date(asset.getWarrantyExpiryDate().getTime()));
            else
                ps.setNull(8, java.sql.Types.DATE);

            ps.setString(9, "New"); // Mặc định khi thêm mới là 'New'
            ps.setString(10, asset.getDescription());

            // Trường created_at là DATETIME nên dùng sql.Timestamp
            ps.setTimestamp(11, new java.sql.Timestamp(new java.util.Date().getTime()));

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}