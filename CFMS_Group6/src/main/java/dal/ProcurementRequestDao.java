package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

public class ProcurementRequestDao {

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

