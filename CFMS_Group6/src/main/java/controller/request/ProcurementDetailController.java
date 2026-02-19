package controller.request;

import dal.ProcurementRequestDao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProcurementDetail;
import model.ProcurementRequest;

/**
 * Controller for procurement detail page.
 */
@WebServlet(name = "ProcurementDetailController", urlPatterns = {"/request/procurement-detail"})
public class ProcurementDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        ProcurementRequestDao dao = new ProcurementRequestDao();
        ProcurementRequest proc = dao.getProcurementById(id);

        if (proc == null) {
            request.setAttribute("errorMsg", "Không tìm thấy yêu cầu mua sắm PROC-" + id);
            request.getRequestDispatcher("/views/request/procurement-list.jsp").forward(request, response);
            return;
        }

        List<ProcurementDetail> details = dao.getDetailsByProcurementId(id);
        proc.setDetails(details);

        request.setAttribute("proc", proc);
        request.getRequestDispatcher("/views/request/procurement-detail.jsp").forward(request, response);
    }
}
