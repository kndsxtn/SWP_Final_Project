package controller.userMgt;

import constant.Message;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Role;

/**
 *
 * @author Nguyen Dinh Giap
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
            
            String deptIdStr = request.getParameter("deptId");
            int deptId = 0;
            if (deptIdStr != null && !deptIdStr.trim().isEmpty()) {
                deptId = Integer.parseInt(deptIdStr);
            }
            
            UserDAO dao = new UserDAO();

            dto.UserDto user = dao.getUserByid(userId);
            if (user == null) {
                request.getSession().setAttribute("errorMsg", "Người dùng không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
                return;
            }

            // Kiem tra: khong cho phep sua tai khoan Admin
            String currentRole = dao.getRoleNameByUserId(userId);
            if (Message.ADMIN.equals(currentRole)) {
                request.getSession().setAttribute("errorMsg", "Không thể chỉnh sửa tài khoản Admin!");
                response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
                return;
            }

            // Kiem tra: khong cho phep doi role thanh Admin
            if (roleId == getRoleIdByName(dao, Message.ADMIN)) {
                request.getSession().setAttribute("errorMsg", "Không thể cấp quyền Admin cho người dùng!");
                response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
                return;
            }

            // Kiem tra bat buoc chon department neu user chua co department_id
            if (user.getDeptId() <= 0 && deptId <= 0) {
                request.getSession().setAttribute("errorMsg", "Cập nhật thất bại: Phải chọn bộ phận (Department) cho người dùng chưa có bộ phận!");
                response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
                return;
            }

            boolean roleUpdated = false;
            // Cap nhat role va ca deptId neu co chon hoac giu nguyen dept_id cu
            int finalDeptId = (deptId > 0) ? deptId : user.getDeptId();
            if (finalDeptId > 0) {
                roleUpdated = dao.updateUserRoleAndDept(userId, roleId, finalDeptId);
            } else {
                roleUpdated = dao.updateUserRole(userId, roleId);
            }
            
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

    // lay role_id tu role_name (de kiem tra xem roleId moi co phai Admin khong
    private int getRoleIdByName(UserDAO dao, String roleName) {
        List<Role> roles = dao.getAllRoles();
        for (model.Role r : roles) {
            if (roleName.equals(r.getRoleName())) {
                return r.getRoleId();
            }
        }
        return -1;
    }
}
