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

public class InventoryDAO {

    // ─── List assets for inventory with optional search + status filter + paging ───
    public List<Asset> getAssetsForInventory(String statusFilter, String keyword, int page, int pageSize) {
        List<Asset> list = new ArrayList<>();

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ")
                .append(" a.asset_id, a.asset_code, a.asset_name, a.category_id, a.supplier_id, ")
                .append(" a.price, a.purchase_date, a.warranty_expiry_date, a.quantity, a.description, a.created_at, ")
                .append(" c.category_name, c.prefix_code, c.description AS cat_desc, ")
                .append(" COUNT(ad.instance_id) AS instance_total, ")
                .append(" SUM(CASE WHEN ad.status = N'In_Stock' THEN 1 ELSE 0 END) AS cnt_new_total, ")
                .append(" SUM(CASE WHEN ad.status = N'In_Stock' AND ad.room_id IS NULL THEN 1 ELSE 0 END) AS cnt_available, ")
                .append(" SUM(CASE WHEN ad.status = N'In_Use' THEN 1 ELSE 0 END) AS cnt_in_use, ")
                .append(" SUM(CASE WHEN ad.status = N'Maintenance' THEN 1 ELSE 0 END) AS cnt_maintenance, ")
                .append(" SUM(CASE WHEN ad.status = N'Broken' THEN 1 ELSE 0 END) AS cnt_broken, ")
                .append(" SUM(CASE WHEN ad.status = N'Lost' THEN 1 ELSE 0 END) AS cnt_lost, ")
                .append(" SUM(CASE WHEN ad.status = N'Liquidated' THEN 1 ELSE 0 END) AS cnt_liquidated ")
                .append("FROM assets a ")
                .append("JOIN categories c ON a.category_id = c.category_id ")
                .append("LEFT JOIN asset_details ad ON ad.asset_id = a.asset_id ")
                .append("LEFT JOIN rooms r ON ad.room_id = r.room_id ");

        // WHERE only for keyword (non-aggregate)
        if (keyword != null && !keyword.isEmpty()) {
            sb.append("WHERE (a.asset_code LIKE ? OR a.asset_name LIKE ? OR a.description LIKE ? ")
                    .append("OR c.category_name LIKE ? OR c.prefix_code LIKE ?) ");
        }

        sb.append("GROUP BY ")
                .append(" a.asset_id, a.asset_code, a.asset_name, a.category_id, a.supplier_id, ")
                .append(" a.price, a.purchase_date, a.warranty_expiry_date, a.quantity, a.description, a.created_at, ")
                .append(" c.category_name, c.prefix_code, c.description ");

        // HAVING for statusFilter (aggregate)
        if (statusFilter != null && !statusFilter.isEmpty()) {
            if ("In_Stock".equals(statusFilter)) {
                sb.append("HAVING SUM(CASE WHEN ad.status = N'In_Stock' AND ad.room_id IS NULL THEN 1 ELSE 0 END) > 0 ");
            } else {
                sb.append("HAVING SUM(CASE WHEN ad.status = ? THEN 1 ELSE 0 END) > 0 ");
            }
        }

        sb.append("ORDER BY c.category_name, a.asset_code ");
        sb.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (statusFilter != null && !statusFilter.isEmpty() && !"In_Stock".equals(statusFilter)) {
                ps.setString(idx++, statusFilter);
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
                    asset.setPrice(rs.getBigDecimal("price"));
                    asset.setPurchaseDate(rs.getDate("purchase_date"));
                    asset.setWarrantyExpiryDate(rs.getDate("warranty_expiry_date"));
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

                    // Gắn aggregate counts từ asset_details
                    asset.setInstanceTotal(rs.getInt("instance_total"));
                    asset.setCountNewTotal(rs.getInt("cnt_new_total"));
                    asset.setCountAvailableInStock(rs.getInt("cnt_available"));
                    asset.setCountInUse(rs.getInt("cnt_in_use"));
                    asset.setCountMaintenance(rs.getInt("cnt_maintenance"));
                    asset.setCountBroken(rs.getInt("cnt_broken"));
                    asset.setCountLost(rs.getInt("cnt_lost"));
                    asset.setCountLiquidated(rs.getInt("cnt_liquidated"));

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
        String sqlAvailable = "SELECT COUNT(*) AS cnt "
                + "FROM asset_details ad "
                + "WHERE ad.status = N'In_Stock' AND ad.room_id IS NULL";

        String sqlOther = "SELECT status, COUNT(*) AS cnt FROM asset_details "
                + "WHERE status <> N'In_Stock' GROUP BY status";

        try (Connection con = new DBContext().getConnection()) {
            try (PreparedStatement psA = con.prepareStatement(sqlAvailable);
                 ResultSet rsA = psA.executeQuery()) {
                if (rsA.next()) {
                    counts.put("In_Stock", rsA.getInt("cnt"));
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlOther);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    counts.put(status != null ? status : "Unknown", cnt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return counts;
    }

    // ─── Count for paging ───
    public int countAssetsForInventory(String statusFilter, String keyword) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT COUNT(*) FROM (");
        sb.append("SELECT a.asset_id ")
                .append("FROM assets a ")
                .append("JOIN categories c ON a.category_id = c.category_id ")
                .append("LEFT JOIN asset_details ad ON ad.asset_id = a.asset_id ")
                .append("LEFT JOIN rooms r ON ad.room_id = r.room_id ");

        if (keyword != null && !keyword.isEmpty()) {
            sb.append("WHERE (a.asset_code LIKE ? OR a.asset_name LIKE ? OR a.description LIKE ? ")
                    .append("OR c.category_name LIKE ? OR c.prefix_code LIKE ?) ");
        }

        sb.append("GROUP BY a.asset_id, a.asset_code, a.asset_name, a.category_id, a.supplier_id, ")
                .append("a.price, a.purchase_date, a.warranty_expiry_date, a.quantity, a.description, a.created_at, ")
                .append("c.category_name, c.prefix_code, c.description ");

            if (statusFilter != null && !statusFilter.isEmpty()) {
            if ("In_Stock".equals(statusFilter)) {
                sb.append("HAVING SUM(CASE WHEN ad.status = N'In_Stock' AND ad.room_id IS NULL THEN 1 ELSE 0 END) > 0 ");
            } else {
                sb.append("HAVING SUM(CASE WHEN ad.status = ? THEN 1 ELSE 0 END) > 0 ");
            }
        }

        sb.append(") t");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (statusFilter != null && !statusFilter.isEmpty() && !"In_Stock".equals(statusFilter)) {
                ps.setString(idx++, statusFilter);
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

