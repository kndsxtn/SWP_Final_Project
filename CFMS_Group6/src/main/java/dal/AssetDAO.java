package dal;

import model.Asset;
import model.AssetImage;
import model.Category;
import model.Supplier;
import model.Room;
import java.util.List;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;

/**
 * DAO xử lý nghiệp vụ truy vấn bảng assets.
 * Phục vụ UC05-UC10: Thêm / Xem / Tìm kiếm / Sửa / Cập nhật trạng thái / Xóa
 * tài sản.
 *
 * @author Vũ Quang Hiếu
 */
public class AssetDAO {

    // ─── SQL chung dùng JOIN để lấy tên category, supplier, room ───
    private static final String SELECT_WITH_JOIN = "SELECT a.*, "
            + "c.category_name, c.prefix_code, "
            + "s.supplier_name, "
            + "r.room_name "
            + "FROM assets a "
            + "LEFT JOIN categories c ON a.category_id = c.category_id "
            + "LEFT JOIN suppliers s ON a.supplier_id = s.supplier_id "
            + "LEFT JOIN rooms r ON a.room_id = r.room_id ";

    // UC06: Xem danh sách (có search, filter, paging)
    /**
     * Lấy tất cả tài sản (không paging – dùng cho export hoặc dropdown).
     */
    public List<Asset> getAll() {
        List<Asset> assets = new ArrayList<>();
        String sql = SELECT_WITH_JOIN + "ORDER BY a.asset_id DESC";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                assets.add(mapAsset(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return assets;
    }

    /**
     * Tìm kiếm và lọc danh sách tài sản với phân trang.
     *
     * @param keyword    Tìm theo mã, tên, mô tả (null = bỏ qua)
     * @param categoryId Lọc theo danh mục (0 = tất cả)
     * @param status     Lọc theo trạng thái (null = tất cả)
     * @param page       Trang hiện tại (bắt đầu từ 1)
     * @param pageSize   Số bản ghi mỗi trang
     */
    public List<Asset> search(String keyword, int categoryId, String status, int page, int pageSize) {
        List<Asset> assets = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_WITH_JOIN);
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, keyword, categoryId, status);

        sql.append("ORDER BY a.asset_id DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            setParams(ps, params);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                assets.add(mapAsset(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return assets;
    }

    /**
     * Đếm tổng số bản ghi khớp filter (dùng cho phân trang).
     */
    public int countAssets(String keyword, int categoryId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM assets a WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, keyword, categoryId, status);

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            setParams(ps, params);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ═══════════════════════════════════════════
    // UC07: Xem chi tiết tài sản
    // ═══════════════════════════════════════════

    /**
     * Lấy 1 tài sản theo ID, kèm thông tin category/supplier/room.
     */
    public Asset getById(int assetId) {
        String sql = SELECT_WITH_JOIN + "WHERE a.asset_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assetId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapAsset(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // UC05: Thêm mới tài sản
    /**
     * Sinh mã tài sản tự động theo format: PREFIX-YYYY-NNN (VD: LAP-2026-001).
     */
    public String generateAssetCode(int categoryId) {
        String prefix = "";
        String sqlGetPrefix = "SELECT prefix_code FROM categories WHERE category_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlGetPrefix)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                prefix = rs.getString("prefix_code");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        if (prefix.isEmpty())
            return null;

        int currentYear = LocalDate.now().getYear();
        String codePattern = prefix + "-" + currentYear + "-%";
        String sqlGetMaxCode = "SELECT TOP 1 asset_code FROM assets WHERE asset_code LIKE ? ORDER BY asset_code DESC";
        String nextCode = prefix + "-" + currentYear + "-001";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sqlGetMaxCode)) {
            ps.setString(1, codePattern);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String maxCode = rs.getString("asset_code");
                String sequenceStr = maxCode.substring(maxCode.lastIndexOf("-") + 1);
                try {
                    int sequence = Integer.parseInt(sequenceStr) + 1;
                    nextCode = prefix + "-" + currentYear + "-" + String.format("%03d", sequence);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return nextCode;
    }

    /**
     * Thêm mới tài sản. Mã tài sản được tự động sinh.
     * Trả về asset_id vừa tạo (dùng để insert ảnh), trả -1 nếu lỗi.
     */
    public int insertAsset(Asset asset) {
        String generatedCode = generateAssetCode(asset.getCategoryId());
        if (generatedCode == null)
            return -1;

        asset.setAssetCode(generatedCode);

        String sql = "INSERT INTO assets (asset_code, asset_name, category_id, supplier_id, room_id, "
                + "price, purchase_date, warranty_expiry_date, status, description, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, asset.getAssetCode());
            ps.setString(2, asset.getAssetName());
            ps.setInt(3, asset.getCategoryId());
            setNullableInt(ps, 4, asset.getSupplierId());
            setNullableInt(ps, 5, asset.getRoomId());
            ps.setBigDecimal(6, asset.getPrice());
            setNullableDate(ps, 7, asset.getPurchaseDate());
            setNullableDate(ps, 8, asset.getWarrantyExpiryDate());
            ps.setString(9, "New");
            ps.setString(10, asset.getDescription());
            ps.setTimestamp(11, new java.sql.Timestamp(System.currentTimeMillis()));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int newId = keys.getInt(1);
                    asset.setAssetId(newId);
                    return newId;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Quản lý ảnh tài sản (asset_images)
    /**
     * Thêm 1 bản ghi ảnh cho tài sản.
     */
    public boolean insertImage(int assetId, String imageUrl, String description) {
        String sql = "INSERT INTO asset_images (asset_id, image_url, description) VALUES (?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assetId);
            ps.setString(2, imageUrl);
            ps.setString(3, description);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách ảnh của 1 tài sản.
     */
    public List<AssetImage> getImagesByAssetId(int assetId) {
        List<AssetImage> images = new ArrayList<>();
        String sql = "SELECT * FROM asset_images WHERE asset_id = ? ORDER BY uploaded_at DESC";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, assetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AssetImage img = new AssetImage();
                img.setImageId(rs.getInt("image_id"));
                img.setAssetId(rs.getInt("asset_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                img.setDescription(rs.getString("description"));
                images.add(img);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    /**
     * Xóa 1 ảnh theo image_id.
     */
    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM asset_images WHERE image_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, imageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy 1 ảnh theo image_id (kiểm tra trước khi xóa).
     */
    public AssetImage getImageById(int imageId) {
        String sql = "SELECT * FROM asset_images WHERE image_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, imageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                AssetImage img = new AssetImage();
                img.setImageId(rs.getInt("image_id"));
                img.setAssetId(rs.getInt("asset_id"));
                img.setImageUrl(rs.getString("image_url"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                img.setDescription(rs.getString("description"));
                return img;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // UC08: Cập nhật thông tin tài sản
    /**
     * Cập nhật thông tin chi tiết tài sản (không đổi mã, trạng thái, ngày tạo).
     */
    public boolean updateAsset(Asset asset) {
        String sql = "UPDATE assets SET asset_name = ?, category_id = ?, supplier_id = ?, "
                + "room_id = ?, price = ?, purchase_date = ?, warranty_expiry_date = ?, "
                + "description = ? WHERE asset_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, asset.getAssetName());
            ps.setInt(2, asset.getCategoryId());
            setNullableInt(ps, 3, asset.getSupplierId());
            setNullableInt(ps, 4, asset.getRoomId());
            ps.setBigDecimal(5, asset.getPrice());
            setNullableDate(ps, 6, asset.getPurchaseDate());
            setNullableDate(ps, 7, asset.getWarrantyExpiryDate());
            ps.setString(8, asset.getDescription());
            ps.setInt(9, asset.getAssetId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // UC09: Cập nhật trạng thái tài sản
    /**
     * Cập nhật trạng thái tài sản: New, In_Use, Maintenance, Broken, Liquidated,
     * Lost.
     */
    public boolean updateStatus(int assetId, String newStatus) {
        String sql = "UPDATE assets SET status = ? WHERE asset_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, assetId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // UC10: Thanh lý tài sản (đánh dấu Liquidated)
    /**
     * Đánh dấu tài sản là đã thanh lý.
     */
    public boolean liquidateAsset(int assetId) {
        return updateStatus(assetId, "Liquidated");
    }

    // Dropdown data: Lấy danh sách Category, Supplier, Room cho form

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_name";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setCategoryName(rs.getString("category_name"));
                c.setPrefixCode(rs.getString("prefix_code"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers ORDER BY supplier_name";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("supplier_id"));
                s.setSupplierName(rs.getString("supplier_name"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_name";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomName(rs.getString("room_name"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Private helper methods
    /**
     * Map 1 dòng ResultSet thành Asset object (kèm Category, Supplier, Room).
     */
    private Asset mapAsset(ResultSet rs) throws Exception {
        Asset a = new Asset();
        a.setAssetId(rs.getInt("asset_id"));
        a.setAssetCode(rs.getString("asset_code"));
        a.setAssetName(rs.getString("asset_name"));
        a.setCategoryId(rs.getInt("category_id"));
        a.setSupplierId(rs.getInt("supplier_id"));
        a.setRoomId(rs.getInt("room_id"));
        a.setPrice(rs.getBigDecimal("price"));
        a.setPurchaseDate(rs.getDate("purchase_date"));
        a.setWarrantyExpiryDate(rs.getDate("warranty_expiry_date"));
        a.setStatus(rs.getString("status"));
        a.setQuantity(rs.getInt("quantity"));
        a.setDescription(rs.getString("description"));
        a.setCreatedAt(rs.getTimestamp("created_at"));

        // Set related objects
        try {
            Category c = new Category();
            c.setCategoryId(a.getCategoryId());
            c.setCategoryName(rs.getString("category_name"));
            c.setPrefixCode(rs.getString("prefix_code"));
            a.setCategory(c);
        } catch (Exception ignored) {
        }

        try {
            Supplier s = new Supplier();
            s.setSupplierId(a.getSupplierId());
            s.setSupplierName(rs.getString("supplier_name"));
            a.setSupplier(s);
        } catch (Exception ignored) {
        }

        try {
            Room r = new Room();
            r.setRoomId(a.getRoomId());
            r.setRoomName(rs.getString("room_name"));
            a.setRoom(r);
        } catch (Exception ignored) {
        }

        return a;
    }

    /**
     * Append WHERE conditions cho keyword, categoryId, status.
     */
    private void appendFilters(StringBuilder sql, List<Object> params,
            String keyword, int categoryId, String status) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (a.asset_code LIKE ? OR a.asset_name LIKE ? OR a.description LIKE ?) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (categoryId > 0) {
            sql.append("AND a.category_id = ? ");
            params.add(categoryId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND a.status = ? ");
            params.add(status.trim());
        }
    }

    /** Set params cho PreparedStatement từ List<Object>. */
    private void setParams(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            Object p = params.get(i);
            if (p instanceof String)
                ps.setString(i + 1, (String) p);
            else if (p instanceof Integer)
                ps.setInt(i + 1, (Integer) p);
        }
    }

    /** Set int hoặc NULL nếu giá trị <= 0. */
    private void setNullableInt(PreparedStatement ps, int index, int value) throws Exception {
        if (value > 0)
            ps.setInt(index, value);
        else
            ps.setNull(index, java.sql.Types.INTEGER);
    }

    /** Set Date hoặc NULL. */
    private void setNullableDate(PreparedStatement ps, int index, java.util.Date value) throws Exception {
        if (value != null)
            ps.setDate(index, new java.sql.Date(value.getTime()));
        else
            ps.setNull(index, java.sql.Types.DATE);
    }
}