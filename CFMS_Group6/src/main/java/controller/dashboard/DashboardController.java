package controller.dashboard;

import dal.DashboardDAO;
import dto.UserDto;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller Dashboard chung.
 * Sau khi đăng nhập, tất cả role đều vào đây.
 * Dựa vào role sẽ load dữ liệu thống kê phù hợp và hiển thị trên dashboard.
 *
 * @author Nguyen Dang Khang, Vũ Quang Hiếu
 */
@WebServlet(name = "DashboardController", urlPatterns = { "/dashboard" })
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Chưa đăng nhập → redirect về login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        // Lấy thông tin user từ session
        UserDto user = (UserDto) session.getAttribute("user");
        String role = user.getRoleName();
        System.out.println("User " + user.getUsername() + " truy cập Dashboard với quyền: " + role);

        // Gọi DAO lấy thống kê
        DashboardDAO dao = new DashboardDAO();

        // ─── Thống kê chung (mọi role đều thấy) ───
        request.setAttribute("totalAssets", dao.countTotalAssets());
        request.setAttribute("totalCategories", dao.countCategories());
        request.setAttribute("totalRooms", dao.countRooms());

        // ─── Thống kê tài sản theo trạng thái ───
        Map<String, Integer> assetByStatus = dao.countAssetsByStatus();
        request.setAttribute("assetByStatus", assetByStatus);

        request.setAttribute("assetsNew", dao.countAssetsNew());
        request.setAttribute("assetsInUse", dao.countAssetsInUse());
        request.setAttribute("assetsMaintenance", dao.countAssetsMaintenance());
        request.setAttribute("assetsBroken", dao.countAssetsBroken());

        // ─── Thống kê theo role ───
        request.setAttribute("pendingAllocations", dao.countPendingAllocations());
        request.setAttribute("pendingTransfers", dao.countPendingTransfers());
        request.setAttribute("pendingMaintenance", dao.countPendingMaintenance());

        // Dữ liệu riêng cho Head of Dept
        if ("Head of Dept".equals(role)) {
            request.setAttribute("myAllocations", dao.countAllocationsByUser(user.getUserId()));
            if (user.getDeptId() > 0) {
                request.setAttribute("deptAssets", dao.countAssetsByDept(user.getDeptId()));
            }
        }

        // Forward sang trang JSP
        request.getRequestDispatcher("/views/components/dashboard.jsp").forward(request, response);
    }
}
