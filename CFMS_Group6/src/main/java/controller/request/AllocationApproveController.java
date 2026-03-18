package controller.request;

import dal.AllocationRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AllocationDetail;
import model.AllocationRequest;
@WebServlet(name = "AllocationApproveController", urlPatterns = {"/request/approve"})
public class AllocationApproveController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        String reasonReject = request.getParameter("reasonReject");

        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequestDAO allocDao = new AllocationRequestDAO();
        AllocationRequest alloc = allocDao.getRequestById(requestId);
        if (alloc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Load details & stock info for safety checks
        List<AllocationDetail> details = allocDao.getDetailsByRequestId(requestId);
        alloc.setDetails(details);
        allocDao.populateStockInfo(alloc);

        if ("reject".equalsIgnoreCase(action)) {
            if (reasonReject == null || reasonReject.trim().isEmpty()) {
                reasonReject = "Không có lý do.";
            }
            boolean ok = allocDao.updateStatus(requestId, "Rejected", reasonReject);
            if (ok) {
                session.setAttribute("successMsg",
                        "Đã từ chối yêu cầu REQ-" + requestId + " với lý do: " + reasonReject);
            } else {
                session.setAttribute("errorMsg", "Không thể cập nhật trạng thái yêu cầu REQ-" + requestId);
            }
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        if (!"approve".equalsIgnoreCase(action)) {
            session.setAttribute("errorMsg", "Thao tác không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Approve by Asset Management Staff
        String newStatus = "Approved_By_Staff";

        boolean ok = allocDao.updateStatus(requestId, newStatus, null);
        if (!ok) {
            session.setAttribute("errorMsg", "Không thể cập nhật trạng thái yêu cầu REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        String msg = "Đã duyệt yêu cầu REQ-" + requestId + ".";
        if (!"FULL".equals(alloc.getStockStatus())) {
            msg += " Kho chưa đủ tài sản – vui lòng chọn phương án xử lý trong trang chi tiết.";
        }
        session.setAttribute("successMsg", msg);
        response.sendRedirect(request.getContextPath() + "/request/allocation-detail?id=" + requestId);
    }
}

