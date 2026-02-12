package controller.request;

import dal.AllocationRequestDao;
import dto.UserDto;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AllocationRequest;

/**
 * 
 * @author Nguyen Dang Khang
 */
@WebServlet(name = "AllocationCancelController", urlPatterns = {"/request/cancel"})
public class AllocationCancelController extends HttpServlet {

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
        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequestDao dao = new AllocationRequestDao();
        AllocationRequest req = dao.getRequestById(requestId);

        if (req == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        if (req.getCreatedBy() != user.getUserId()) {
            session.setAttribute("errorMsg",
                    "Bạn không có quyền hủy yêu cầu REQ-" + requestId + " (không phải người tạo).");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        if (!"Pending".equals(req.getStatus())) {
            session.setAttribute("errorMsg",
                    "Chỉ có thể hủy yêu cầu ở trạng thái 'Chờ duyệt'.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        String reason = "[CANCELLED] Yêu cầu đã được hủy bởi người tạo.";
        boolean ok = dao.updateStatus(requestId, "Rejected", reason);
        if (ok) {
            session.setAttribute("successMsg", "Đã hủy yêu cầu cấp phát REQ-" + requestId + " thành công.");
        } else {
            session.setAttribute("errorMsg", "Không thể hủy yêu cầu REQ-" + requestId
                    + ". Có thể yêu cầu đã được xử lý hoặc thay đổi trạng thái.");
        }

        response.sendRedirect(request.getContextPath() + "/request/allocation-list");
    }
}

