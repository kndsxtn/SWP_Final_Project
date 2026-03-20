package controller.userMgt;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Role;
import validation.UserValidator;

/**
 *
 * @author Nguyen Dinh Giap
 */

@WebServlet(name = "UserCreateController", urlPatterns = { "/user-mgt/user-create" })
public class UserCreateController extends HttpServlet {

    // GET: load form, truyen danh sach role xuong jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        List<Role> roles = dao.getAllRoles();
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/views/user-mgt/user-form.jsp").forward(request, response);
    }

    // POST: lay du lieu tu form, goi dao tao user, redirect ve danh sach
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lay du lieu tu form
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        UserDAO dao = new UserDAO();

        // Use Validator
        String error = UserValidator.validateCreateUser(username, password, fullName, email, phone);

        if (error != null) {
            request.getSession().setAttribute("errorMsg", error);
            List<Role> roles = dao.getAllRoles();
            request.setAttribute("roles", roles);
            // giu lai du lieu cu de user khoi phai nhap lai
            request.setAttribute("oldUsername", username);
            request.setAttribute("oldFullName", fullName);
            request.setAttribute("oldEmail", email);
            request.setAttribute("oldPhone", phone);
            request.setAttribute("oldRoleId", roleId);
            request.getRequestDispatcher("/views/user-mgt/user-form.jsp").forward(request, response);
            return;
        }

        boolean success = dao.createUser(username, password, fullName, email, phone, roleId);

        if (success) {
            // Them thanh cong -> quay ve danh sach voi thong bao
            request.getSession().setAttribute("successMsg", "Thêm người dùng thành công!");
        } else {
            // That bai -> giu lai form + thong bao loi
            request.getSession().setAttribute("errorMsg", "Thêm thất bại! Có lỗi xảy ra trong hệ thống.");
            List<Role> roles = dao.getAllRoles();
            request.setAttribute("roles", roles);
            // giu lai du lieu cu de user khoi phai nhap lai
            request.setAttribute("oldUsername", username);
            request.setAttribute("oldFullName", fullName);
            request.setAttribute("oldEmail", email);
            request.setAttribute("oldPhone", phone);
            request.setAttribute("oldRoleId", roleId);
            request.getRequestDispatcher("/views/user-mgt/user-form.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/user-mgt/user-list");
    }
}
