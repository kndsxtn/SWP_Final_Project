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

@WebServlet(name = "ProcurementApproveController", urlPatterns = {
    "/request/procurement-approve",
    "/request/procurement-reject"
})
public class ProcurementApproveController extends HttpServlet {

    private final ProcurementRequestDao dao = new ProcurementRequestDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
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

        ProcurementRequest proc = dao.getProcurementById(procurementId);
        if (proc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu mua sắm PROC-" + procurementId);
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }
        if (!"Pending".equals(proc.getStatus())) {
            session.setAttribute("errorMsg", "Chỉ có thể phê duyệt/từ chối yêu cầu đang ở trạng thái 'Chờ duyệt'.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
            return;
        }

        String path = request.getServletPath();
        if ("/request/procurement-approve".equals(path)) {
            handleApprove(request, response, session, user.getUserId(), procurementId);
        } else if ("/request/procurement-reject".equals(path)) {
            handleReject(request, response, session, user.getUserId(), procurementId);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response,
                               HttpSession session, int userId, int procurementId) throws IOException {
        boolean ok = dao.approveProcurement(procurementId, userId);
        if (ok) {
            session.setAttribute("successMsg", "Đã phê duyệt yêu cầu mua sắm PROC-" + procurementId + ".");
        } else {
            session.setAttribute("errorMsg", "Không thể phê duyệt yêu cầu PROC-" + procurementId + ". Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/request/procurement-list");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, int userId, int procurementId) throws IOException {
        String reason = request.getParameter("reason");
        boolean ok = dao.rejectProcurement(procurementId, userId, reason);
        if (ok) {
            session.setAttribute("successMsg", "Đã từ chối yêu cầu mua sắm PROC-" + procurementId + ".");
        } else {
            session.setAttribute("errorMsg", "Không thể từ chối yêu cầu PROC-" + procurementId + ". Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/request/procurement-list");
    }
}
