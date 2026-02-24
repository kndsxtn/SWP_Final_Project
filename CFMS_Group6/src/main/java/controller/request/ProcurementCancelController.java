package controller.request;

import dal.ProcurementRequestDao;
import dto.UserDto;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProcurementRequest;

@WebServlet(name = "ProcurementCancelController", urlPatterns = {"/request/procurement-cancel"})
public class ProcurementCancelController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }
        UserDto user = (UserDto) session.getAttribute("user");

        String idParam = request.getParameter("id");
        int procurementId;
        try {
            procurementId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu mua sắm không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        ProcurementRequestDao dao = new ProcurementRequestDao();
        ProcurementRequest proc = dao.getProcurementById(procurementId);

        if (proc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu mua sắm PROC-" + procurementId);
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        if (proc.getCreatedBy() != user.getUserId()) {
            session.setAttribute("errorMsg", "Bạn không có quyền hủy yêu cầu này (không phải người tạo).");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        if (!"Pending".equals(proc.getStatus())) {
            session.setAttribute("errorMsg", "Chỉ có thể hủy yêu cầu đang ở trạng thái 'Chờ duyệt'.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
            return;
        }

        boolean ok = dao.cancelProcurement(procurementId, user.getUserId());
        if (ok) {
            session.setAttribute("successMsg", "Đã hủy yêu cầu mua sắm PROC-" + procurementId + " thành công.");
        } else {
            session.setAttribute("errorMsg", "Không thể hủy yêu cầu PROC-" + procurementId + ". Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/request/procurement-list");
    }
}
