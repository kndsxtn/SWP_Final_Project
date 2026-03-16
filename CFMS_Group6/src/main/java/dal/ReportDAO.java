package dal;

import dto.AssetReportDto;
import dto.ProcurementReportDto;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public List<ProcurementReportDto> getProcurementReport(Date startDate, Date endDate) {
        List<ProcurementReportDto> list = new ArrayList<>();
        String sql = "SELECT u.full_name AS approver_name, c.category_name, pd.quantity "
                + "FROM procurement_requests pr "
                + "JOIN procurement_details pd ON pr.procurement_id = pd.procurement_id "
                + "JOIN assets a ON pd.asset_id = a.asset_id "
                + "JOIN categories c ON a.category_id = c.category_id "
                + "LEFT JOIN users u ON pr.approved_by = u.user_id "
                + "WHERE pr.status IN ('Approved', 'Completed') "
                + "AND CAST(pr.approved_date AS DATE) >= ? "
                + "AND CAST(pr.approved_date AS DATE) <= ? "
                + "ORDER BY pr.approved_date DESC";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, startDate);
            ps.setDate(2, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                int stt = 1;
                while (rs.next()) {
                    ProcurementReportDto dto = new ProcurementReportDto();
                    dto.setStt(stt++);
                    dto.setApproverName(rs.getString("approver_name") != null ? rs.getString("approver_name") : "N/A");
                    dto.setCategoryName(rs.getString("category_name"));
                    dto.setQuantity(rs.getInt("quantity"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<AssetReportDto> getAssetReport(Date startDate, Date endDate, String status) {
        List<AssetReportDto> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.asset_code, a.asset_name, c.category_name, a.purchase_date, ad.status " +
                "FROM asset_details ad " +
                "JOIN assets a ON ad.asset_id = a.asset_id " +
                "JOIN categories c ON a.category_id = c.category_id " +
                "WHERE 1=1 ");

        if (startDate != null && endDate != null) {
            sql.append("AND a.purchase_date >= ? AND a.purchase_date <= ? ");
        }
        if (status != null && !status.isEmpty() && !status.equals("All")) {
            sql.append("AND ad.status = ? ");
        }
        sql.append("ORDER BY a.purchase_date DESC");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (startDate != null && endDate != null) {
                ps.setDate(paramIndex++, startDate);
                ps.setDate(paramIndex++, endDate);
            }
            if (status != null && !status.isEmpty() && !status.equals("All")) {
                ps.setString(paramIndex++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                int stt = 1;
                while (rs.next()) {
                    AssetReportDto dto = new AssetReportDto();
                    dto.setStt(stt++);
                    dto.setAssetCode(rs.getString("asset_code"));
                    dto.setAssetName(rs.getString("asset_name"));
                    dto.setCategoryName(rs.getString("category_name"));
                    dto.setPurchaseDate(rs.getDate("purchase_date"));
                    dto.setStatus(rs.getString("status"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
