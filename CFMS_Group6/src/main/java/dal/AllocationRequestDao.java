package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.AllocationDetail;
import model.AllocationRequest;
import model.Asset;
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
