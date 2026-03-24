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
        String sql = "SELECT COALESCE(u.full_name, 'N/A') AS approver_name, c.category_name, SUM(pd.quantity) AS total_quantity "
                + "FROM procurement_requests pr "
                + "JOIN procurement_details pd ON pr.procurement_id = pd.procurement_id "
                + "JOIN assets a ON pd.asset_id = a.asset_id "
                + "JOIN categories c ON a.category_id = c.category_id "
                + "LEFT JOIN users u ON pr.approved_by = u.user_id "
                + "WHERE pr.status IN ('Approved', 'Completed') "
                + "AND CAST(pr.approved_date AS DATE) >= ? "
                + "AND CAST(pr.approved_date AS DATE) <= ? "
                + "GROUP BY COALESCE(u.full_name, 'N/A'), c.category_name "
                + "ORDER BY approver_name, c.category_name";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, startDate);
            ps.setDate(2, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                int stt = 1;
                ProcurementReportDto currentDto = null;
                while (rs.next()) {
                    String approverName = rs.getString("approver_name");
                    String categoryName = rs.getString("category_name");
                    int quantity = rs.getInt("total_quantity");

                    if (currentDto == null || !currentDto.getApproverName().equals(approverName)) {
                        currentDto = new ProcurementReportDto();
                        currentDto.setStt(stt++);
                        currentDto.setApproverName(approverName);
                        currentDto.setDetails(new ArrayList<>());
                        list.add(currentDto);
                    }
                    currentDto.getDetails().add(new dto.CategoryQuantityDto(categoryName, quantity));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<AssetReportDto> getAssetReport(Date startDate, Date endDate) {
        List<AssetReportDto> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.category_name, a.asset_name, " +
                "SUM(CASE WHEN ad.status = 'In_Stock' THEN 1 ELSE 0 END) AS in_stock, " +
                "SUM(CASE WHEN ad.status = 'In_Use' THEN 1 ELSE 0 END) AS in_use, " +
                "SUM(CASE WHEN ad.status = 'Maintenance' THEN 1 ELSE 0 END) AS maintenance, " +
                "SUM(CASE WHEN ad.status = 'Broken' THEN 1 ELSE 0 END) AS broken, " +
                "SUM(CASE WHEN ad.status = 'Liquidated' THEN 1 ELSE 0 END) AS liquidated, " +
                "SUM(CASE WHEN ad.status = 'Lost' THEN 1 ELSE 0 END) AS lost, " +
                "COUNT(ad.instance_id) AS total " +
                "FROM assets a " +
                "JOIN categories c ON a.category_id = c.category_id " +
                "LEFT JOIN asset_details ad ON a.asset_id = ad.asset_id " +
                "WHERE 1=1 ");

        if (startDate != null && endDate != null) {
            sql.append("AND a.purchase_date >= ? AND a.purchase_date <= ? ");
        } else if (endDate != null) {
            sql.append("AND a.purchase_date <= ? ");
        }
        
        sql.append("GROUP BY c.category_name, a.asset_name ");
        sql.append("ORDER BY c.category_name, a.asset_name");

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (startDate != null && endDate != null) {
                ps.setDate(paramIndex++, startDate);
                ps.setDate(paramIndex++, endDate);
            } else if (endDate != null) {
                ps.setDate(paramIndex++, endDate);
            }

            try (ResultSet rs = ps.executeQuery()) {
                int stt = 1;
                while (rs.next()) {
                    AssetReportDto dto = new AssetReportDto();
                    dto.setStt(stt++);
                    dto.setCategoryName(rs.getString("category_name"));
                    dto.setAssetName(rs.getString("asset_name"));
                    dto.setInStockCount(rs.getInt("in_stock"));
                    dto.setInUseCount(rs.getInt("in_use"));
                    dto.setMaintenanceCount(rs.getInt("maintenance"));
                    dto.setBrokenCount(rs.getInt("broken"));
                    dto.setLiquidatedCount(rs.getInt("liquidated"));
                    dto.setLostCount(rs.getInt("lost"));
                    dto.setTotalCount(rs.getInt("total"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
