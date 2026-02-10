package controller.request;

import dal.AllocationRequestDao;
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

/**
 * UC12 – View allocation request detail.
 *
 * @author Nguyen Dang Khang
 */
@WebServlet(name = "AllocationDetailController", urlPatterns = {"/request/allocation-detail"})
public class AllocationDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        // Parse request ID
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequestDao dao = new AllocationRequestDao();
        AllocationRequest req = dao.getRequestById(id);

        if (req == null) {
            request.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + id);
            request.getRequestDispatcher("/views/request/allocation-list.jsp")
                    .forward(request, response);
            return;
        }

        // Load full details with asset info + images
        List<AllocationDetail> details = dao.getDetailsFullByRequestId(id);
        req.setDetails(details);

        request.setAttribute("req", req);

        request.getRequestDispatcher("/views/request/allocation-detail.jsp")
                .forward(request, response);
    }
}
