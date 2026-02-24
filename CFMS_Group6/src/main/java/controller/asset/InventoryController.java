package controller.asset;

import dal.InventoryDao;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Asset;

@WebServlet(name = "InventoryController", urlPatterns = {"/asset/inventory-check"})
public class InventoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InventoryDao dao = new InventoryDao();
        final int PAGE_SIZE = 10;

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
            if (page < 1) {
                page = 1;
            }
        } catch (NumberFormatException ignored) {
        }

        // --- Query data ---
        List<Asset> inventoryList = dao.getAssetsForInventory(statusFilter, keyword, page, PAGE_SIZE);
        int totalRecords = dao.countAssetsForInventory(statusFilter, keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        Map<String, Integer> statusCounts = dao.getInventoryCountByStatus();

        request.setAttribute("inventoryList", inventoryList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusCounts", statusCounts);

        request.getRequestDispatcher("/views/asset/inventory-list.jsp")
                .forward(request, response);
    }
}

