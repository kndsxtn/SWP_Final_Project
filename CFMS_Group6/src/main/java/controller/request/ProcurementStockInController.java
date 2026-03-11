package controller.request;

import dal.AssetDetailDao;
import dal.DBContext;
import dal.ProcurementRequestDao;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import model.ProcurementDetail;
import model.ProcurementRequest;

/**
 * UC: Nhập kho từ yêu cầu mua sắm đã được duyệt.
 * Nếu procurement có liên kết allocation_request_id, sau khi nhập kho sẽ điều hướng
 * sang màn chọn cá thể cấp phát cho allocation đó.
 */
@WebServlet(name = "ProcurementStockInController", urlPatterns = {"/request/procurement-stockin"})
public class ProcurementStockInController extends HttpServlet {

    private final ProcurementRequestDao procurementDao = new ProcurementRequestDao();
    private final AssetDetailDao assetDetailDao = new AssetDetailDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");
        if (!"Asset Staff".equals(user.getRoleName())) {
            session.setAttribute("errorMsg", "Chỉ nhân viên thiết bị mới được nhập kho từ mua sắm.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        int procurementId;
        try {
            procurementId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu mua sắm không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
        if (proc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu mua sắm PROC-" + procurementId);
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        if (!"Approved".equals(proc.getStatus())) {
            session.setAttribute("errorMsg", "Chỉ có thể nhập kho với yêu cầu đang ở trạng thái 'Đã duyệt'.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
            return;
        }

        if (proc.getAllocationRequestId() == null) {
            session.setAttribute("errorMsg", "Yêu cầu mua sắm này không liên kết với yêu cầu cấp phát nào.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
            return;
        }

        List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);
        if (details == null || details.isEmpty()) {
            session.setAttribute("errorMsg", "Yêu cầu mua sắm không có danh sách chi tiết để nhập kho.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
            return;
        }

        try (Connection con = new DBContext().getConnection()) {
            con.setAutoCommit(false);

            String desc = "Nhập kho từ yêu cầu mua sắm PROC-" + procurementId;
            for (ProcurementDetail d : details) {
                assetDetailDao.stockInInstances(
                        con,
                        d.getAssetId(),
                        (d.getAsset() != null ? d.getAsset().getAssetCode() : null),
                        d.getQuantity(),
                        user.getUserId(),
                        desc
                );
            }

            // Mark procurement as Completed to prevent double stock-in
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE procurement_requests SET status = N'Completed' WHERE procurement_id = ? AND status = N'Approved'")) {
                ps.setInt(1, procurementId);
                ps.executeUpdate();
            }

            con.commit();

            int allocId = proc.getAllocationRequestId();
            session.setAttribute("successMsg",
                    "Đã nhập kho từ PROC-" + procurementId + ". Vui lòng chọn cá thể để cấp phát cho REQ-" + allocId + ".");
            response.sendRedirect(request.getContextPath() + "/request/allocation-assign?id=" + allocId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Không thể nhập kho từ PROC-" + procurementId + ": " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
        }
    }
}

