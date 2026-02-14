package controller.request;

import dal.AllocationRequestDao;
import dto.UserDto;
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
 *
 * @author Nguyen Dang Khang
 */
@WebServlet(name = "AllocationListController", urlPatterns = {"/request/allocation-list"})
public class AllocationListController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");

        // --- Filter param ---
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && statusFilter.isEmpty()) {
            statusFilter = null;
        }

        // --- Search param ---
        String keyword = request.getParameter("keyword");
        if (keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }
        if (keyword != null) {
            keyword = keyword.trim();
        }

        // --- Page param ---
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException ignored) {
        }

        // --- Query data ---
        AllocationRequestDao dao = new AllocationRequestDao();
        List<AllocationRequest> list;
        int totalRecords;

        // Asset Staff, Finance Head, Principal, Admin... xem tất cả
        // Trưởng bộ môn (Head of Dept) chỉ xem các yêu cầu do chính mình tạo
        String roleName = user.getRoleName();
        boolean isHeadOfDept = "Head of Dept".equals(roleName);

        if (isHeadOfDept) {
            list = dao.getRequestsByCreator(user.getUserId(), statusFilter, keyword, page, PAGE_SIZE);
            totalRecords = dao.countRequestsByCreator(user.getUserId(), statusFilter, keyword);
        } else {
            list = dao.getRequests(statusFilter, keyword, page, PAGE_SIZE);
            totalRecords = dao.countRequests(statusFilter, keyword);
        }

        for (AllocationRequest req : list) {
            List<AllocationDetail> details = dao.getDetailsByRequestId(req.getRequestId());
            req.setDetails(details);
            dao.populateStockInfo(req);
            dao.populateDetailsStockInfo(req.getDetails());
        }
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        // --- Set attributes ---
        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/views/request/allocation-list.jsp")
                .forward(request, response);
    }
}
