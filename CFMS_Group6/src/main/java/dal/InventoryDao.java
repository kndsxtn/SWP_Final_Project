package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Asset;
import model.AssetImage;
import model.Category;
import model.Room;

public class InventoryDao {

    // ─── List assets for inventory with optional search + status filter + paging ───
    public List<Asset> getAssetsForInventory(String statusFilter, String keyword, int page, int pageSize) {
        List<Asset> list = new ArrayList<>();

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT a.*, ")
                .append("c.category_id, c.category_name, c.prefix_code, c.description AS cat_desc, ")
                .append("r.room_id, r.room_name, r.dept_id, r.capacity ")
                .append("FROM assets a ")
                .append("JOIN categories c ON a.category_id = c.category_id ")
                .append("LEFT JOIN rooms r ON a.room_id = r.room_id ");

        boolean hasWhere = false;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sb.append("WHERE a.status = ? ");
            hasWhere = true;
        }
        if (keyword != null && !keyword.isEmpty()) {
            String whereOrAnd = hasWhere ? "AND " : "WHERE ";
            sb.append(whereOrAnd)
                    .append("(")
                    .append("a.asset_code LIKE ? OR ")
                    .append("a.asset_name LIKE ? OR ")
                    .append("a.description LIKE ? OR ")
                    .append("c.category_name LIKE ? OR ")
                    .append("c.prefix_code LIKE ? OR ")
                    .append("r.room_name LIKE ? OR ")
                    .append("a.status LIKE ?")
                    .append(") ");
        }

        sb.append("ORDER BY c.category_name, a.asset_code ");
        sb.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                // asset_code, asset_name, description, category_name, prefix_code, room_name, status
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Asset asset = new Asset();
                    asset.setAssetId(rs.getInt("asset_id"));
                    asset.setAssetCode(rs.getString("asset_code"));
                    asset.setAssetName(rs.getString("asset_name"));
                    asset.setCategoryId(rs.getInt("category_id"));
                    asset.setSupplierId(rs.getInt("supplier_id"));
                    asset.setRoomId(rs.getInt("room_id"));
                    asset.setPrice(rs.getBigDecimal("price"));
                    asset.setPurchaseDate(rs.getDate("purchase_date"));
                    asset.setWarrantyExpiryDate(rs.getDate("warranty_expiry_date"));
                    asset.setStatus(rs.getString("status"));
                    asset.setQuantity(rs.getInt("quantity"));
                    asset.setDescription(rs.getString("description"));
                    asset.setCreatedAt(rs.getTimestamp("created_at"));

                    // Gắn category
                    Category cat = new Category();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setCategoryName(rs.getString("category_name"));
                    cat.setPrefixCode(rs.getString("prefix_code"));
                    cat.setDescription(rs.getString("cat_desc"));
                    asset.setCategory(cat);

                    // Gắn room (nếu có)
                    int roomId = rs.getInt("room_id");
                    if (!rs.wasNull()) {
                        Room room = new Room();
                        room.setRoomId(roomId);
                        room.setRoomName(rs.getString("room_name"));
                        room.setDeptId(rs.getInt("dept_id"));
                        room.setCapacity(rs.getInt("capacity"));
                        asset.setRoom(room);
                    }

                    // Gắn danh sách ảnh
                    asset.setImages(getImagesByAssetId(con, asset.getAssetId()));

                    list.add(asset);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Map<String, Integer> getInventoryCountByStatus() {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM assets GROUP BY status";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int cnt = rs.getInt("cnt");
                counts.put(status != null ? status : "Unknown", cnt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    // ─── Count for paging ───
    public int countAssetsForInventory(String statusFilter, String keyword) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT COUNT(*) ")
                .append("FROM assets a ")
                .append("JOIN categories c ON a.category_id = c.category_id ")
                .append("LEFT JOIN rooms r ON a.room_id = r.room_id ");

        boolean hasWhere = false;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sb.append("WHERE a.status = ? ");
            hasWhere = true;
        }
        if (keyword != null && !keyword.isEmpty()) {
            String whereOrAnd = hasWhere ? "AND " : "WHERE ";
            sb.append(whereOrAnd)
                    .append("(")
                    .append("a.asset_code LIKE ? OR ")
                    .append("a.asset_name LIKE ? OR ")
                    .append("a.description LIKE ? OR ")
                    .append("c.category_name LIKE ? OR ")
                    .append("c.prefix_code LIKE ? OR ")
                    .append("r.room_name LIKE ? OR ")
                    .append("a.status LIKE ?")
                    .append(") ");
        }

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
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

    // ─── Load images for an asset ───
    private List<AssetImage> getImagesByAssetId(Connection con, int assetId) throws Exception {
        List<AssetImage> images = new ArrayList<>();
        String sql = "SELECT * FROM asset_images WHERE asset_id = ? ORDER BY image_id";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, assetId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssetImage img = new AssetImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setAssetId(rs.getInt("asset_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    img.setDescription(rs.getString("description"));
                    images.add(img);
                }
            }
        }
        return images;
    }
}

