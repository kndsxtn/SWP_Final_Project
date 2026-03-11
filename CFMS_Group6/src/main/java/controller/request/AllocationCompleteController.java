package controller.request;

import dal.AllocationRequestDAO;
import dto.UserDto;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AllocationRequest;

/**
 * Hoàn thành cấp phát tài sản cho các yêu cầu đã được duyệt
 * và kho hiện tại đủ số lượng (status -> Completed).
 */
@WebServlet(name = "AllocationCompleteController", urlPatterns = {"/request/complete"})
public class AllocationCompleteController extends HttpServlet {

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

        AllocationRequestDAO dao = new AllocationRequestDAO();
        AllocationRequest req = dao.getRequestById(requestId);

        if (req == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Chỉ nhân viên thiết bị (Asset Staff) mới được hoàn thành cấp phát
        if (!"Asset Staff".equals(user.getRoleName())) {
            session.setAttribute("errorMsg", "Bạn không có quyền hoàn thành cấp phát cho yêu cầu này.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        String status = req.getStatus();
        boolean isApprovedStatus = "Approved_By_Staff".equals(status)
                || "Approved_By_VP".equals(status)
                || "Approved_By_Principal".equals(status);

        if (!isApprovedStatus) {
            session.setAttribute("errorMsg",
                    "Chỉ có thể hoàn thành cấp phát cho các yêu cầu đã được duyệt.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Kiểm tra lại tồn kho một lần nữa để đảm bảo đủ số lượng cho toàn bộ yêu cầu
        Map<Integer, Integer> missing = dao.getMissingQuantitiesByAsset(requestId);
        if (missing != null && !missing.isEmpty()) {
            session.setAttribute("errorMsg",
                    "Kho hiện tại chưa đủ số lượng để hoàn thành cấp phát cho REQ-" + requestId
                            + ". Vui lòng kiểm tra lại tồn kho / yêu cầu mua sắm.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        boolean ok = dao.markCompleted(requestId);
        if (ok) {
            session.setAttribute("successMsg",
                    "Đã đánh dấu hoàn thành cấp phát cho yêu cầu REQ-" + requestId + ".");
        } else {
            session.setAttribute("errorMsg",
                    "Không thể hoàn thành cấp phát cho yêu cầu REQ-" + requestId + ". Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/request/allocation-list");
    }
}

