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
 * Controller for procurement list page.
 */
@WebServlet(name = "ProcurementListController", urlPatterns = {"/request/procurement-list"})
public class ProcurementListController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.isEmpty()) {
            statusFilter = null;
        }

        String keyword = request.getParameter("keyword");
        if (keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }
        if (keyword != null) {
            keyword = keyword.trim();
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {
        }

        ProcurementRequestDao dao = new ProcurementRequestDao();
        List<ProcurementRequest> list = dao.getRequests(statusFilter, keyword, page, PAGE_SIZE);
        int totalRecords = dao.countRequests(statusFilter, keyword);

        for (ProcurementRequest req : list) {
            List<ProcurementDetail> details = dao.getDetailsByProcurementId(req.getProcurementId());
            req.setDetails(details);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/views/request/procurement-list.jsp")
                .forward(request, response);
    }
}
