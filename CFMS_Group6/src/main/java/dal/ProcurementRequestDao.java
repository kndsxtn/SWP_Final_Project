package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Asset;
import model.Category;
import model.ProcurementDetail;
import model.ProcurementRequest;
import model.User;

public class ProcurementRequestDao {

    private static final String PROC_BASE = "SELECT pr.*, u.full_name AS creator_name FROM procurement_requests pr "
            + "JOIN users u ON pr.created_by = u.user_id ";

    public List<ProcurementRequest> getRequests(String statusFilter, String keyword, int page, int pageSize) {
        List<ProcurementRequest> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append(PROC_BASE);
        List<String> conditions = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isEmpty()) {
            conditions.add("pr.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            conditions.add("(u.full_name LIKE ? OR CAST(pr.procurement_id AS VARCHAR) LIKE ? "
                    + "OR ('PROC-' + CAST(pr.procurement_id AS VARCHAR)) LIKE ? "
                    + "OR pr.reason LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM procurement_details pd "
                    + "JOIN assets a ON pd.asset_id = a.asset_id "
                    + "JOIN categories c ON a.category_id = c.category_id "
                    + "WHERE pd.procurement_id = pr.procurement_id "
                    + "AND (a.asset_name LIKE ? OR a.asset_code LIKE ? OR c.category_name LIKE ? OR pd.note LIKE ?)))");
        }
        if (!conditions.isEmpty()) {
            sb.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        }
        sb.append("ORDER BY pr.created_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

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
                ps.setString(idx++, kw);
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

    public int countRequests(String statusFilter, String keyword) {
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT COUNT(*) FROM procurement_requests pr JOIN users u ON pr.created_by = u.user_id ");
        List<String> conditions = new ArrayList<>();
        if (statusFilter != null && !statusFilter.isEmpty()) {
            conditions.add("pr.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            conditions.add("(u.full_name LIKE ? OR CAST(pr.procurement_id AS VARCHAR) LIKE ? "
                    + "OR ('PROC-' + CAST(pr.procurement_id AS VARCHAR)) LIKE ? OR pr.reason LIKE ? "
                    + "OR EXISTS (SELECT 1 FROM procurement_details pd JOIN assets a ON pd.asset_id = a.asset_id "
                    + "JOIN categories c ON a.category_id = c.category_id WHERE pd.procurement_id = pr.procurement_id "
                    + "AND (a.asset_name LIKE ? OR a.asset_code LIKE ? OR c.category_name LIKE ? OR pd.note LIKE ?)))");
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
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx, kw);
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

    public ProcurementRequest getProcurementById(int procurementId) {
        String sql = PROC_BASE + "WHERE pr.procurement_id = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, procurementId);
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

    public List<ProcurementDetail> getDetailsByProcurementId(int procurementId) {
        List<ProcurementDetail> list = new ArrayList<>();
        String sql = "SELECT pd.*, a.asset_code, a.asset_name, a.category_id, "
                + "c.category_name, c.prefix_code "
                + "FROM procurement_details pd "
                + "JOIN assets a ON pd.asset_id = a.asset_id "
                + "JOIN categories c ON a.category_id = c.category_id "
                + "WHERE pd.procurement_id = ? ORDER BY pd.detail_id";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, procurementId);
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

    private ProcurementRequest mapRequest(ResultSet rs) throws Exception {
        ProcurementRequest req = new ProcurementRequest();
        req.setProcurementId(rs.getInt("procurement_id"));
        req.setCreatedBy(rs.getInt("created_by"));
        req.setCreatedDate(rs.getTimestamp("created_date"));
        req.setStatus(rs.getString("status"));
        req.setReasonReject(rs.getString("reason_reject"));
        req.setReason(rs.getString("reason"));
        int allocId = rs.getInt("allocation_request_id");
        req.setAllocationRequestId(rs.wasNull() ? null : allocId);
        User creator = new User();
        creator.setUserId(rs.getInt("created_by"));
        creator.setFullName(rs.getString("creator_name"));
        req.setCreator(creator);
        return req;
    }

    private ProcurementDetail mapDetail(ResultSet rs) throws Exception {
        ProcurementDetail d = new ProcurementDetail();
        d.setDetailId(rs.getInt("detail_id"));
        d.setProcurementId(rs.getInt("procurement_id"));
        d.setAssetId(rs.getInt("asset_id"));
        d.setQuantity(rs.getInt("quantity"));
        d.setNote(rs.getString("note"));
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

    public int createProcurementStandalone(int createdByUserId, String reason,
                                           int[] assetIds, int[] quantities, String[] notes) {
        if (assetIds == null || quantities == null || assetIds.length == 0 || assetIds.length != quantities.length) {
            return -1;
        }
        String insertReqSql = "INSERT INTO procurement_requests "
                + "(created_by, created_date, status, reason, allocation_request_id) "
                + "VALUES (?, GETDATE(), N'Pending', ?, NULL); "
                + "SELECT SCOPE_IDENTITY() AS new_id";
        String insertDetailSql = "INSERT INTO procurement_details (procurement_id, asset_id, quantity, note) VALUES (?, ?, ?, ?)";
        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);
            int procurementId = -1;
            try (PreparedStatement psReq = con.prepareStatement(insertReqSql)) {
                psReq.setInt(1, createdByUserId);
                psReq.setString(2, reason != null ? reason.trim() : null);
                try (ResultSet rs = psReq.executeQuery()) {
                    if (rs.next()) {
                        procurementId = rs.getInt("new_id");
                    }
                }
            }
            if (procurementId <= 0) {
                con.rollback();
                return -1;
            }
            try (PreparedStatement psDet = con.prepareStatement(insertDetailSql)) {
                for (int i = 0; i < assetIds.length; i++) {
                    int assetId = assetIds[i];
                    int qty = quantities[i];
                    if (assetId <= 0 || qty <= 0) continue;
                    String note = (notes != null && i < notes.length) ? notes[i] : null;
                    String trimmedNote = (note != null) ? note.trim() : null;
                    psDet.setInt(1, procurementId);
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
            return procurementId;
        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return -1;
    }

    public boolean updateProcurement(int procurementId, int createdByUserId, String reason,
                                     int[] assetIds, int[] quantities, String[] notes) {
        if (assetIds == null || quantities == null || assetIds.length == 0 || assetIds.length != quantities.length) {
            return false;
        }
        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);
            String checkSql = "SELECT status, created_by FROM procurement_requests WHERE procurement_id = ?";
            try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {
                psCheck.setInt(1, procurementId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                    if (!"Pending".equals(rs.getString("status")) || rs.getInt("created_by") != createdByUserId) {
                        con.rollback();
                        return false;
                    }
                }
            }
            String updateReasonSql = "UPDATE procurement_requests SET reason = ? WHERE procurement_id = ?";
            try (PreparedStatement psReason = con.prepareStatement(updateReasonSql)) {
                psReason.setString(1, reason != null ? reason.trim() : null);
                psReason.setInt(2, procurementId);
                psReason.executeUpdate();
            }
            try (PreparedStatement psDel = con.prepareStatement("DELETE FROM procurement_details WHERE procurement_id = ?")) {
                psDel.setInt(1, procurementId);
                psDel.executeUpdate();
            }
            String insertDetailSql = "INSERT INTO procurement_details (procurement_id, asset_id, quantity, note) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psDet = con.prepareStatement(insertDetailSql)) {
                for (int i = 0; i < assetIds.length; i++) {
                    int assetId = assetIds[i];
                    int qty = quantities[i];
                    if (assetId <= 0 || qty <= 0) continue;
                    String note = (notes != null && i < notes.length) ? notes[i] : null;
                    String trimmedNote = (note != null) ? note.trim() : null;
                    psDet.setInt(1, procurementId);
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
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public boolean cancelProcurement(int procurementId, int userId) {
        String sql = "UPDATE procurement_requests SET status = N'Cancelled' "
                + "WHERE procurement_id = ? AND status = N'Pending' AND created_by = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, procurementId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean approveProcurement(int procurementId, int approvedByUserId) {
        String sql = "UPDATE procurement_requests SET status = N'Approved', "
                + "approved_by = ?, approved_date = GETDATE(), rejected_by = NULL, rejected_date = NULL, reason_reject = NULL "
                + "WHERE procurement_id = ? AND status = N'Pending'";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, approvedByUserId);
            ps.setInt(2, procurementId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectProcurement(int procurementId, int rejectedByUserId, String reasonReject) {
        String sql = "UPDATE procurement_requests SET status = N'Rejected', "
                + "rejected_by = ?, rejected_date = GETDATE(), reason_reject = ?, approved_by = NULL, approved_date = NULL "
                + "WHERE procurement_id = ? AND status = N'Pending'";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rejectedByUserId);
            ps.setString(2, reasonReject != null ? reasonReject.trim() : null);
            ps.setInt(3, procurementId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int createProcurementForShortage(int allocationRequestId,
                                            int createdByUserId,
                                            Map<Integer, Integer> missingByCategory,
                                            String reason) {
        if (missingByCategory == null || missingByCategory.isEmpty()) {
            return -1;
        }

        String insertReqSql = "INSERT INTO procurement_requests "
                + "(created_by, created_date, status, reason, allocation_request_id) "
                + "VALUES (?, GETDATE(), N'Pending', ?, ?); "
                + "SELECT SCOPE_IDENTITY() AS new_id";

        String insertDetailSql = "INSERT INTO procurement_details "
                + "(procurement_id, asset_id, quantity, note) "
                + "VALUES (?, ?, ?, ?)";

        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);

            int procurementId = -1;
            try (PreparedStatement psReq = con.prepareStatement(insertReqSql)) {
                psReq.setInt(1, createdByUserId);
                psReq.setString(2, reason);
                psReq.setInt(3, allocationRequestId);

                try (ResultSet rs = psReq.executeQuery()) {
                    if (rs.next()) {
                        procurementId = rs.getInt("new_id");
                    }
                }
            }

            if (procurementId <= 0) {
                con.rollback();
                return -1;
            }

            try (PreparedStatement psDet = con.prepareStatement(insertDetailSql)) {

                for (Map.Entry<Integer, Integer> entry : missingByCategory.entrySet()) {
                    int assetId = entry.getKey();
                    int qty = entry.getValue();
                    if (qty <= 0) {
                        continue;
                    }

                    psDet.setInt(1, procurementId);
                    psDet.setInt(2, assetId);
                    psDet.setInt(3, qty);
                    psDet.setString(4, "Tự động tạo từ yêu cầu cấp phát REQ-" + allocationRequestId
                            + " do tồn kho không đủ");
                    psDet.addBatch();
                }
                psDet.executeBatch();
            }

            con.commit();
            return procurementId;

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
}

