package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * DAO phục vụ Dashboard - Lấy dữ liệu thống kê tổng quan.
 * Trả về các con số tổng hợp để hiển thị trên trang chủ theo từng role.
 *
 * @author Vũ Quang Hiếu
 */
public class DashboardDAO {

    // ─── Thống kê tổng số tài sản ───
    public int countTotalAssets() {
        return countSingle("SELECT COUNT(*) FROM assets");
    }

    public Map<String, Integer> countAssetsByStatus() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM asset_details GROUP BY status ORDER BY status";

        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // ─── Đếm cá thể tài sản đang sử dụng (schema mới: asset_details) ───
    public int countAssetsInUse() {
        return countSingle("SELECT COUNT(*) FROM asset_details WHERE status = N'In_Use'");
    }

    // ─── Đếm cá thể tài sản đang ở kho ───
    public int countAssetsNew() {
        return countSingle("SELECT COUNT(*) FROM asset_details WHERE status = N'In_Stock' AND room_id IS NULL");
    }

    // ─── Đếm cá thể tài sản đang bảo trì ───
    public int countAssetsMaintenance() {
        return countSingle("SELECT COUNT(*) FROM asset_details WHERE status = N'Maintenance'");
    }

    // ─── Đếm cá thể tài sản hỏng ───
    public int countAssetsBroken() {
        return countSingle("SELECT COUNT(*) FROM asset_details WHERE status = N'Broken'");
    }

    // ─── Đếm cá thể tài sản thất lạc ───
    public int countAssetsLost() {
        return countSingle("SELECT COUNT(*) FROM asset_details WHERE status = N'Lost'");
    }

    // ─── Đếm cá thể tài sản đã thanh lý ───
    public int countAssetsLiquidated() {
        return countSingle("SELECT COUNT(*) FROM asset_details WHERE status = N'Liquidated'");
    }

    // ─── Đếm tổng danh mục tài sản ───
    public int countCategories() {
        return countSingle("SELECT COUNT(*) FROM categories");
    }

    // ─── Đếm tổng phòng ───
    public int countRooms() {
        return countSingle("SELECT COUNT(*) FROM rooms");
    }

    // ─── Đếm yêu cầu cấp phát đang chờ duyệt ───
    public int countPendingAllocations() {
        return countSingle("SELECT COUNT(*) FROM allocation_requests WHERE status = N'Pending'");
    }

    // ─── Đếm phiếu điều chuyển đang chờ duyệt ───
    public int countPendingTransfers() {
        return countSingle("SELECT COUNT(*) FROM transfer_orders WHERE status = N'Pending'");
    }

    // ─── Đếm yêu cầu bảo trì đang chờ xử lý ───
    public int countPendingMaintenance() {
        return countSingle("SELECT COUNT(*) FROM maintenance_requests WHERE status = N'Reported'");
    }

    // ─── Đếm yêu cầu cấp phát của 1 user cụ thể ───
    public int countAllocationsByUser(int userId) {
        return countSingle(
                "SELECT COUNT(*) FROM allocation_requests WHERE created_by = ?",
                userId);
    }

    public int countAssetsByDept(int deptId) {
        return countSingle(
                "SELECT COUNT(*) FROM asset_details ad "
                        + "JOIN rooms r ON ad.room_id = r.room_id "
                        + "WHERE r.dept_id = ?",
                deptId);
    }

    // ═══════ Helper methods ═══════

    /**
     * Đếm đơn giản với câu SQL không có tham số.
     */
    private int countSingle(String sql) {
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm với câu SQL có 1 tham số int.
     */
    private int countSingle(String sql, int param) {
        try (Connection con = new DBContext().getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, param);
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
}
