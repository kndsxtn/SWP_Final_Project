package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.AllocationDetail;
import model.AllocationRequest;
import model.Asset;
import model.AssetImage;
import model.Category;
import model.User;

/**
 * Data Access Object for allocation_requests & allocation_details.
 *
 * @author Nguyen Dang Khang
 */
public class AllocationRequestDao {

    // ─── List requests with optional status filter, search keyword + paging ───
    public List<AllocationRequest> getRequests(String statusFilter, String keyword, int page, int pageSize) {
        List<AllocationRequest> list = new ArrayList<>();

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ar.*, u.full_name AS creator_name ");
        sb.append("FROM allocation_requests ar ");
        sb.append("JOIN users u ON ar.created_by = u.user_id ");

        // Build WHERE clauses
        List<String> conditions = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isEmpty()) {
            conditions.add("ar.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            conditions.add("(u.full_name LIKE ? OR CAST(ar.request_id AS VARCHAR) LIKE ? "
                    + "OR ('REQ-' + CAST(ar.request_id AS VARCHAR)) LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM allocation_details ad "
                    + "JOIN assets a ON ad.asset_id = a.asset_id "
                    + "JOIN categories c ON a.category_id = c.category_id "
                    + "WHERE ad.request_id = ar.request_id "
                    + "AND (a.asset_name LIKE ? OR a.asset_code LIKE ? "
                    + "OR c.category_name LIKE ? OR ad.note LIKE ?)))");
        }
        if (!conditions.isEmpty()) {
            sb.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        }

        sb.append("ORDER BY ar.created_date DESC ");
        sb.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw); // full_name
                ps.setString(idx++, kw); // request_id (numeric)
                ps.setString(idx++, kw); // REQ-request_id (formatted)
                ps.setString(idx++, kw); // asset_name
                ps.setString(idx++, kw); // asset_code
                ps.setString(idx++, kw); // category_name
                ps.setString(idx++, kw); // note
            }
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRequest(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Count total (for paging) ───
    public int countRequests(String statusFilter, String keyword) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT COUNT(*) FROM allocation_requests ar ");
        sb.append("JOIN users u ON ar.created_by = u.user_id ");

        List<String> conditions = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isEmpty()) {
            conditions.add("ar.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            conditions.add("(u.full_name LIKE ? OR CAST(ar.request_id AS VARCHAR) LIKE ? "
                    + "OR ('REQ-' + CAST(ar.request_id AS VARCHAR)) LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM allocation_details ad "
                    + "JOIN assets a ON ad.asset_id = a.asset_id "
                    + "JOIN categories c ON a.category_id = c.category_id "
                    + "WHERE ad.request_id = ar.request_id "
                    + "AND (a.asset_name LIKE ? OR a.asset_code LIKE ? "
                    + "OR c.category_name LIKE ? OR ad.note LIKE ?)))");
        }
        if (!conditions.isEmpty()) {
            sb.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        }

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw); // full_name
                ps.setString(idx++, kw); // request_id (numeric)
                ps.setString(idx++, kw); // REQ-request_id (formatted)
                ps.setString(idx++, kw); // asset_name
                ps.setString(idx++, kw); // asset_code
                ps.setString(idx++, kw); // category_name
                ps.setString(idx, kw);   // note
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

    // ─── Get details for a specific request ───
    public List<AllocationDetail> getDetailsByRequestId(int requestId) {
        List<AllocationDetail> list = new ArrayList<>();
        String sql = "SELECT ad.*, a.asset_code, a.asset_name, a.category_id, "
                + "c.category_name, c.prefix_code "
                + "FROM allocation_details ad "
                + "JOIN assets a ON ad.asset_id = a.asset_id "
                + "JOIN categories c ON a.category_id = c.category_id "
                + "WHERE ad.request_id = ? "
                + "ORDER BY ad.detail_id";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDetail(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void populateStockInfo(AllocationRequest req) {
        if (req == null) {
            return;
        }

        int requestId = req.getRequestId();

        String sqlRequested = "SELECT ad.asset_id "
                + "FROM allocation_details ad "
                + "WHERE ad.request_id = ? "
                + "ORDER BY ad.detail_id";

        // Asset is considered "available in stock" only when it is New and not assigned to any room yet.
        // (Seed data uses room_id = NULL for assets in stock.)
        String sqlAvailable = "SELECT COUNT(*) AS ok "
                + "FROM assets "
                + "WHERE asset_id = ? AND status = 'New' AND room_id IS NULL";

        int totalRequested = 0;
        int totalAvailable = 0;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement psReq = con.prepareStatement(sqlRequested);
             PreparedStatement psAvail = con.prepareStatement(sqlAvailable)) {

            psReq.setInt(1, requestId);
            try (ResultSet rsReq = psReq.executeQuery()) {
                while (rsReq.next()) {
                    totalRequested++;
                    int assetId = rsReq.getInt("asset_id");

                    psAvail.setInt(1, assetId);
                    try (ResultSet rsAvail = psAvail.executeQuery()) {
                        if (rsAvail.next() && rsAvail.getInt("ok") > 0) {
                            totalAvailable++;
                        }
                    }
                }
            }

            req.setTotalRequestedAssets(totalRequested);
            req.setTotalAvailableInStock(totalAvailable);

            String stockStatus;
            if (totalRequested == 0) {
                stockStatus = "NONE";
            } else if (totalAvailable == totalRequested) {
                stockStatus = "FULL";
            } else if (totalAvailable == 0) {
                stockStatus = "NONE";
            } else {
                stockStatus = "PARTIAL";
            }

            req.setStockStatus(stockStatus);

        } catch (Exception e) {
            e.printStackTrace();
            req.setStockStatus("NONE");
        }
    }

    public Map<Integer, Integer> getMissingQuantitiesByAsset(int requestId) {
        Map<Integer, Integer> missing = new HashMap<>();

        String sqlRequestedAssets = "SELECT ad.asset_id, COUNT(*) AS requested_qty "
                + "FROM allocation_details ad "
                + "WHERE ad.request_id = ? "
                + "GROUP BY ad.asset_id";

        String sqlIsAvailable = "SELECT COUNT(*) AS ok "
                + "FROM assets "
                + "WHERE asset_id = ? AND status = 'New' AND room_id IS NULL";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement psReq = con.prepareStatement(sqlRequestedAssets);
             PreparedStatement psAvail = con.prepareStatement(sqlIsAvailable)) {

            psReq.setInt(1, requestId);
            try (ResultSet rs = psReq.executeQuery()) {
                while (rs.next()) {
                    int assetId = rs.getInt("asset_id");
                    int requestedQty = rs.getInt("requested_qty");

                    psAvail.setInt(1, assetId);
                    int ok = 0;
                    try (ResultSet rsAvail = psAvail.executeQuery()) {
                        if (rsAvail.next()) {
                            ok = rsAvail.getInt("ok"); // 0 or 1
                        }
                    }

                    int shortage = requestedQty - ok;
                    if (shortage > 0) {
                        missing.put(assetId, shortage);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return missing;
    }

    // ─── Get single request by ID (for detail page) ───
    public AllocationRequest getRequestById(int requestId) {
        String sql = "SELECT ar.*, u.full_name AS creator_name "
                + "FROM allocation_requests ar "
                + "JOIN users u ON ar.created_by = u.user_id "
                + "WHERE ar.request_id = ?";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRequest(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── Get full details with asset info + images (for detail page) ───
    public List<AllocationDetail> getDetailsFullByRequestId(int requestId) {
        List<AllocationDetail> list = new ArrayList<>();
        String sql = "SELECT ad.*, a.asset_id AS a_id, a.asset_code, a.asset_name, "
                + "a.status AS asset_status, a.price, a.description AS asset_desc, "
                + "a.category_id, c.category_name, c.prefix_code "
                + "FROM allocation_details ad "
                + "JOIN assets a ON ad.asset_id = a.asset_id "
                + "JOIN categories c ON a.category_id = c.category_id "
                + "WHERE ad.request_id = ? "
                + "ORDER BY ad.detail_id";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AllocationDetail d = mapDetail(rs);

                    // Enrich asset with extra fields
                    Asset asset = d.getAsset();
                    asset.setStatus(rs.getString("asset_status"));
                    asset.setPrice(rs.getBigDecimal("price"));
                    asset.setDescription(rs.getString("asset_desc"));

                    // Load images for this asset
                    asset.setImages(getImagesByAssetId(con, asset.getAssetId()));

                    list.add(d);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int requestId, String newStatus, String reasonReject) {
        String sql = "UPDATE allocation_requests "
                + "SET status = ?, reason_reject = ? "
                + "WHERE request_id = ?";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);

            if (reasonReject == null || reasonReject.trim().isEmpty()) {
                ps.setNull(2, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(2, reasonReject.trim());
            }

            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ─── Get images for an asset (reuses existing connection) ───
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

    // ─── Mapping helpers ───

    private AllocationRequest mapRequest(ResultSet rs) throws Exception {
        AllocationRequest req = new AllocationRequest();
        req.setRequestId(rs.getInt("request_id"));
        req.setCreatedBy(rs.getInt("created_by"));
        req.setCreatedDate(rs.getTimestamp("created_date"));
        req.setStatus(rs.getString("status"));
        req.setReasonReject(rs.getString("reason_reject"));

        // Attach creator (lightweight – only full_name needed for the list)
        User creator = new User();
        creator.setUserId(rs.getInt("created_by"));
        creator.setFullName(rs.getString("creator_name"));
        req.setCreator(creator);

        return req;
    }

    private AllocationDetail mapDetail(ResultSet rs) throws Exception {
        AllocationDetail d = new AllocationDetail();
        d.setDetailId(rs.getInt("detail_id"));
        d.setRequestId(rs.getInt("request_id"));
        d.setAssetId(rs.getInt("asset_id"));
        d.setNote(rs.getString("note"));

        // Attach asset with its category
        Asset asset = new Asset();
        asset.setAssetId(rs.getInt("asset_id"));
        asset.setAssetCode(rs.getString("asset_code"));
        asset.setAssetName(rs.getString("asset_name"));

        Category cat = new Category();
        cat.setCategoryId(rs.getInt("category_id"));
        cat.setCategoryName(rs.getString("category_name"));
        cat.setPrefixCode(rs.getString("prefix_code"));
        asset.setCategory(cat);

        d.setAsset(asset);

        return d;
    }
}
