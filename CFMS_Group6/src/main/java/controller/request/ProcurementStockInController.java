package controller.request;

import dal.AssetDetailDAO;
import dal.DBContext;
import dal.ProcurementRequestDAO;
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
 * Nếu procurement có liên kết allocation_request_id, sau khi nhập kho sẽ hiển thị nút
 * để chuyển sang màn chọn cá thể cấp phát.
 */
@WebServlet(name = "ProcurementStockInController", urlPatterns = {"/request/procurement-stockin"})
public class ProcurementStockInController extends HttpServlet {

    private final ProcurementRequestDAO procurementDao = new ProcurementRequestDAO();
    private final AssetDetailDAO assetDetailDAO = new AssetDetailDAO();

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

            // Prevent double stock-in: if any Stock_In history already exists for this PROC, stop.
            try (PreparedStatement psCheck = con.prepareStatement(
                    "SELECT TOP 1 1 FROM asset_history WHERE action = N'Stock_In' AND description LIKE ?")) {
                psCheck.setString(1, "%PROC-" + procurementId + "%");
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        con.rollback();
                        session.setAttribute("errorMsg", "PROC-" + procurementId + " đã được nhập kho trước đó.");
                        response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
                        return;
                    }
                }
            }

            String desc = "Nhập kho từ yêu cầu mua sắm PROC-" + procurementId;
            for (ProcurementDetail d : details) {
                assetDetailDAO.stockInInstances(
                        con,
                        d.getAssetId(),
                        (d.getAsset() != null ? d.getAsset().getAssetCode() : null),
                        d.getQuantity(),
                        user.getUserId(),
                        desc
                );
            }

            // Do NOT mark procurement Completed here.
            // Procurement will be marked Completed only after allocation (instance selection) is done.

            con.commit();

            session.setAttribute("successMsg",
                    "Đã nhập kho từ PROC-" + procurementId + ". Bạn có thể chuyển sang màn chọn cá thể để cấp phát.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Không thể nhập kho từ PROC-" + procurementId + ": " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
        }
    }
}

