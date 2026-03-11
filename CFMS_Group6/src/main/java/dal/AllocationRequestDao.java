package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
                    + "OR ar.reason LIKE ? "
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
                ps.setString(idx++, kw); // ar.reason
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
                    + "OR ar.reason LIKE ? "
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
                ps.setString(idx++, kw); // ar.reason
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

    // ─── List requests of a specific creator (\"Yêu cầu của tôi\") ───
    public List<AllocationRequest> getRequestsByCreator(int creatorUserId, String statusFilter,
                                                        String keyword, int page, int pageSize) {
        List<AllocationRequest> list = new ArrayList<>();

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT ar.*, u.full_name AS creator_name ");
        sb.append("FROM allocation_requests ar ");
        sb.append("JOIN users u ON ar.created_by = u.user_id ");

        List<String> conditions = new ArrayList<>();
        conditions.add("ar.created_by = ?");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            conditions.add("ar.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            conditions.add("(CAST(ar.request_id AS VARCHAR) LIKE ? "
                    + "OR ('REQ-' + CAST(ar.request_id AS VARCHAR)) LIKE ? "
                    + "OR ar.reason LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM allocation_details ad "
                    + "JOIN assets a ON ad.asset_id = a.asset_id "
                    + "JOIN categories c ON a.category_id = c.category_id "
                    + "WHERE ad.request_id = ar.request_id "
                    + "AND (a.asset_name LIKE ? OR a.asset_code LIKE ? "
                    + "OR c.category_name LIKE ? OR ad.note LIKE ?)))");
        }

        sb.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        sb.append("ORDER BY ar.created_date DESC ");
        sb.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            ps.setInt(idx++, creatorUserId);

            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw); // request_id (numeric)
                ps.setString(idx++, kw); // REQ-request_id (formatted)
                ps.setString(idx++, kw); // ar.reason
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

    // ─── Count requests of a specific creator (for paging \"Yêu cầu của tôi\") ───
    public int countRequestsByCreator(int creatorUserId, String statusFilter, String keyword) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT COUNT(*) FROM allocation_requests ar ");
        sb.append("JOIN users u ON ar.created_by = u.user_id ");

        List<String> conditions = new ArrayList<>();
        conditions.add("ar.created_by = ?");

        if (statusFilter != null && !statusFilter.isEmpty()) {
            conditions.add("ar.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            conditions.add("(CAST(ar.request_id AS VARCHAR) LIKE ? "
                    + "OR ('REQ-' + CAST(ar.request_id AS VARCHAR)) LIKE ? "
                    + "OR ar.reason LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM allocation_details ad "
                    + "JOIN assets a ON ad.asset_id = a.asset_id "
                    + "JOIN categories c ON a.category_id = c.category_id "
                    + "WHERE ad.request_id = ar.request_id "
                    + "AND (a.asset_name LIKE ? OR a.asset_code LIKE ? "
                    + "OR c.category_name LIKE ? OR ad.note LIKE ?)))");
        }

        sb.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            int idx = 1;
            ps.setInt(idx++, creatorUserId);

            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(idx++, statusFilter);
            }
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw); // request_id (numeric)
                ps.setString(idx++, kw); // REQ-request_id (formatted)
                ps.setString(idx++, kw); // ar.reason
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

    // ─── Delete a pending request created by specific user (for UC15) ───
    public boolean deletePendingRequest(int requestId, int creatorUserId) {
        String sql = "DELETE FROM allocation_requests "
                + "WHERE request_id = ? AND created_by = ? AND status = 'Pending' "
                + "AND NOT EXISTS (SELECT 1 FROM procurement_requests pr "
                + "WHERE pr.allocation_request_id = allocation_requests.request_id)";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ps.setInt(2, creatorUserId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
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

        String sqlRequested = "SELECT ad.asset_id, ad.quantity "
                + "FROM allocation_details ad "
                + "WHERE ad.request_id = ? "
                + "ORDER BY ad.detail_id";

        String sqlAvailable = "SELECT COUNT(*) AS ok "
                + "FROM asset_details ad "
                + "WHERE ad.asset_id = ? "
                + "AND ad.status = N'In_Stock' "
                + "AND ad.room_id IS NULL";

        int totalRequested = 0;
        int totalAvailable = 0;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement psReq = con.prepareStatement(sqlRequested);
             PreparedStatement psAvail = con.prepareStatement(sqlAvailable)) {

            psReq.setInt(1, requestId);
            try (ResultSet rsReq = psReq.executeQuery()) {
                while (rsReq.next()) {
                    int assetId = rsReq.getInt("asset_id");
                    int qty = rsReq.getInt("quantity");
                    totalRequested += qty;

                    psAvail.setInt(1, assetId);
                    try (ResultSet rsAvail = psAvail.executeQuery()) {
                        int availableQty = 0;
                        if (rsAvail.next()) {
                            availableQty = Math.max(0, rsAvail.getInt("ok"));
                        }
                        totalAvailable += Math.min(qty, availableQty);
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

    /**
     * Điền số lượng tồn kho hiện có (availableInStock) cho từng detail.
     * Dùng để hiển thị cột Tồn kho theo từng tài sản trong list.
     */
    public void populateDetailsStockInfo(List<AllocationDetail> details) {
        if (details == null || details.isEmpty()) {
            return;
        }

        List<Integer> assetIds = new ArrayList<>();
        for (AllocationDetail d : details) {
            if (d.getAssetId() > 0 && !assetIds.contains(d.getAssetId())) {
                assetIds.add(d.getAssetId());
            }
        }
        if (assetIds.isEmpty()) {
            return;
        }

        Map<Integer, Integer> assetIdToAvailable = new HashMap<>();
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < assetIds.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }
        String sql = "SELECT ad.asset_id, COUNT(*) AS qty "
                + "FROM asset_details ad "
                + "WHERE ad.asset_id IN (" + placeholders + ") "
                + "AND ad.status = N'In_Stock' "
                + "AND ad.room_id IS NULL "
                + "GROUP BY ad.asset_id";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < assetIds.size(); i++) {
                ps.setInt(i + 1, assetIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int avail = Math.max(0, rs.getInt("qty"));
                    assetIdToAvailable.put(rs.getInt("asset_id"), avail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }

        for (AllocationDetail d : details) {
            int available = assetIdToAvailable.getOrDefault(d.getAssetId(), 0);
            d.setAvailableInStock(available);
        }
    }

    public Map<Integer, Integer> getMissingQuantitiesByAsset(int requestId) {
        Map<Integer, Integer> missing = new HashMap<>();

        String sqlRequestedAssets = "SELECT ad.asset_id, SUM(ad.quantity) AS requested_qty "
                + "FROM allocation_details ad "
                + "WHERE ad.request_id = ? "
                + "GROUP BY ad.asset_id";

        String sqlIsAvailable = "SELECT COUNT(*) AS ok "
                + "FROM asset_details ad "
                + "WHERE ad.asset_id = ? "
                + "AND ad.status = N'In_Stock' "
                + "AND ad.room_id IS NULL";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement psReq = con.prepareStatement(sqlRequestedAssets);
             PreparedStatement psAvail = con.prepareStatement(sqlIsAvailable)) {

            psReq.setInt(1, requestId);
            try (ResultSet rs = psReq.executeQuery()) {
                while (rs.next()) {
                    int assetId = rs.getInt("asset_id");
                    int requestedQty = rs.getInt("requested_qty");

                    psAvail.setInt(1, assetId);
                    int availableQty = 0;
                    try (ResultSet rsAvail = psAvail.executeQuery()) {
                        if (rsAvail.next()) {
                            availableQty = Math.max(0, rsAvail.getInt("ok"));
                        }
                    }

                    int shortage = requestedQty - availableQty;
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

    public int createRequest(int createdByUserId, int targetRoomId, String reason, int[] assetIds, int[] quantities, String[] notes) {
        if (assetIds == null || quantities == null || assetIds.length == 0 || assetIds.length != quantities.length) {
            return -1;
        }

        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);

            // 1) Insert master row into allocation_requests
            String insertReqSql = "INSERT INTO allocation_requests "
                    + "(created_by, target_room_id, created_date, status, reason, reason_reject) "
                    + "VALUES (?, ?, GETDATE(), N'Pending', ?, NULL)";

            int requestId = -1;
            try (PreparedStatement psReq = con.prepareStatement(insertReqSql, Statement.RETURN_GENERATED_KEYS)) {
                psReq.setInt(1, createdByUserId);
                psReq.setInt(2, targetRoomId);
                if (reason != null && !reason.trim().isEmpty()) {
                    psReq.setString(3, reason.trim());
                } else {
                    psReq.setNull(3, java.sql.Types.NVARCHAR);
                }
                psReq.executeUpdate();

                try (ResultSet rs = psReq.getGeneratedKeys()) {
                    if (rs.next()) {
                        requestId = rs.getInt(1);
                    }
                }
            }

            if (requestId <= 0) {
                con.rollback();
                return -1;
            }

            // 2) Insert detail rows (one row per asset with quantity)
            String insertDetailSql = "INSERT INTO allocation_details (request_id, asset_id, quantity, note) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement psDet = con.prepareStatement(insertDetailSql)) {

                for (int i = 0; i < assetIds.length; i++) {
                    int assetId = assetIds[i];
                    int qty = quantities[i];

                    if (assetId <= 0 || qty <= 0) {
                        continue;
                    }

                    String note = (notes != null && i < notes.length) ? notes[i] : null;
                    String trimmedNote = (note != null) ? note.trim() : null;

                    psDet.setInt(1, requestId);
                    psDet.setInt(2, assetId);
                    psDet.setInt(3, qty);
                    if (trimmedNote == null || trimmedNote.isEmpty()) {
                        psDet.setNull(4, java.sql.Types.NVARCHAR);
                    } else {
                        psDet.setString(4, trimmedNote);
                    }
                    psDet.addBatch();
                }

                psDet.executeBatch();
            }

            con.commit();
            return requestId;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return -1;
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
                + "a.price, a.description AS asset_desc, "
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

                    Asset asset = d.getAsset();
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

    /**
     * Lấy danh sách cá thể (instance) đã được cấp phát cho một yêu cầu REQ-x.
     * Dựa trên asset_history được ghi khi cấp phát (action = 'Allocated').
     */
    public java.util.Map<Integer, java.util.List<model.AssetDetail>> getAllocatedInstancesByRequestId(int requestId) {
        java.util.Map<Integer, java.util.List<model.AssetDetail>> map = new java.util.HashMap<>();

        String sql = "SELECT ad.instance_id, ad.asset_id, ad.instance_code, ad.room_id, ad.status "
                + "FROM asset_history ah "
                + "JOIN asset_details ad ON ah.instance_id = ad.instance_id "
                + "WHERE ah.action = N'Allocated' AND ah.description LIKE ? "
                + "ORDER BY ad.asset_id, ad.instance_code";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%REQ-" + requestId + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.AssetDetail d = new model.AssetDetail();
                    d.setInstanceId(rs.getInt("instance_id"));
                    d.setAssetId(rs.getInt("asset_id"));
                    d.setInstanceCode(rs.getString("instance_code"));
                    int roomId = rs.getInt("room_id");
                    d.setRoomId(rs.wasNull() ? null : roomId);
                    d.setStatus(rs.getString("status"));

                    map.computeIfAbsent(d.getAssetId(), k -> new java.util.ArrayList<>()).add(d);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
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

    /**
     * Đánh dấu yêu cầu cấp phát là đã hoàn thành (Completed).
     * Chỉ áp dụng cho các yêu cầu đã được duyệt (Approved_By_Staff / Approved_By_VP / Approved_By_Principal).
     *
     * Schema mới quản lý tồn kho theo bảng asset_details (cá thể). Vì vậy KHÔNG trừ assets.quantity ở đây.
     */
    public boolean markCompleted(int requestId) {
        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);

            // 1) Cập nhật trạng thái yêu cầu
            String sqlStatus = "UPDATE allocation_requests "
                    + "SET status = N'Completed', completed_date = GETDATE() "
                    + "WHERE request_id = ? "
                    + "AND status IN (N'Approved_By_Staff', N'Approved_By_VP', N'Approved_By_Principal')";
            try (PreparedStatement psReq = con.prepareStatement(sqlStatus)) {
                psReq.setInt(1, requestId);
                if (psReq.executeUpdate() <= 0) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    // ─── Update request (only allowed when status is Pending) ───
    public boolean updateRequest(int requestId, int createdByUserId, int targetRoomId, String reason,
                                 int[] assetIds, int[] quantities, String[] notes) {
        if (assetIds == null || quantities == null || assetIds.length == 0 || assetIds.length != quantities.length) {
            return false;
        }

        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);

            // 1) Verify request exists, is Pending, and belongs to the user
            String checkSql = "SELECT status, created_by FROM allocation_requests WHERE request_id = ?";
            try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                psCheck.setInt(1, requestId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false; // Request not found
                    }
                    String status = rs.getString("status");
                    int createdBy = rs.getInt("created_by");
                    
                    if (!"Pending".equals(status)) {
                        con.rollback();
                        return false; // Can only edit Pending requests
                    }
                    if (createdBy != createdByUserId) {
                        con.rollback();
                        return false; // User must be the creator
                    }
                }
            }

            // 2) Update target room + reason
            String updateReasonSql = "UPDATE allocation_requests SET target_room_id = ?, reason = ? WHERE request_id = ?";
            try (PreparedStatement psReason = con.prepareStatement(updateReasonSql)) {
                psReason.setInt(1, targetRoomId);
                if (reason != null && !reason.trim().isEmpty()) {
                    psReason.setString(2, reason.trim());
                } else {
                    psReason.setNull(2, java.sql.Types.NVARCHAR);
                }
                psReason.setInt(3, requestId);
                psReason.executeUpdate();
            }

            // 3) Delete existing details
            String deleteDetailsSql = "DELETE FROM allocation_details WHERE request_id = ?";
            try (PreparedStatement psDelete = con.prepareStatement(deleteDetailsSql)) {
                psDelete.setInt(1, requestId);
                psDelete.executeUpdate();
            }

            // 4) Insert new details
            String insertDetailSql = "INSERT INTO allocation_details (request_id, asset_id, quantity, note) "
                    + "VALUES (?, ?, ?, ?)";

            try (PreparedStatement psDet = con.prepareStatement(insertDetailSql)) {
                for (int i = 0; i < assetIds.length; i++) {
                    int assetId = assetIds[i];
                    int qty = quantities[i];

                    if (assetId <= 0 || qty <= 0) {
                        continue;
                    }

                    String note = (notes != null && i < notes.length) ? notes[i] : null;
                    String trimmedNote = (note != null) ? note.trim() : null;

                    psDet.setInt(1, requestId);
                    psDet.setInt(2, assetId);
                    psDet.setInt(3, qty);
                    if (trimmedNote == null || trimmedNote.isEmpty()) {
                        psDet.setNull(4, java.sql.Types.NVARCHAR);
                    } else {
                        psDet.setString(4, trimmedNote);
                    }
                    psDet.addBatch();
                }

                psDet.executeBatch();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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
        req.setTargetRoomId(rs.getInt("target_room_id"));
        req.setCreatedDate(rs.getTimestamp("created_date"));
        req.setStatus(rs.getString("status"));
        req.setReason(rs.getString("reason"));
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
        d.setQuantity(rs.getInt("quantity"));
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
