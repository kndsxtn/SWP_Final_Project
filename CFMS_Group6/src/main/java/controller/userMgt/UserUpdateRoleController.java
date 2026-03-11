package controller.userMgt;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * POST /user-mgt/update-role
 * Cap nhat role va status cho user, sau do redirect ve danh sach
 */
@WebServlet(name = "UserUpdateRoleController", urlPatterns = { "/user-mgt/update-role" })
public class UserUpdateRoleController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userIdStr = request.getParameter("userId");
        String roleIdStr = request.getParameter("roleId");
        String status = request.getParameter("status");

        if (userIdStr == null || roleIdStr == null) {
            request.getSession().setAttribute("errorMsg", "Thiếu thông tin cập nhật!");
            response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            int roleId = Integer.parseInt(roleIdStr);
            UserDAO dao = new UserDAO();

            boolean roleUpdated = dao.updateUserRole(userId, roleId);
            boolean statusUpdated = true;
            if (status != null && !status.isEmpty()) {
                statusUpdated = dao.updateUserStatus(userId, status);
            }

            if (roleUpdated && statusUpdated) {
                request.getSession().setAttribute("successMsg", "Cập nhật thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Cập nhật thất bại!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
    }
}
