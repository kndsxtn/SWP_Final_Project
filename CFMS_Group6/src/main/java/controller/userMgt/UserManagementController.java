/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.userMgt;

import dal.UserDao;
import dto.UserDto;
import model.Role;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name = "AdminController", urlPatterns = { "/user-mgt/user-list" })
public class UserManagementController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDao dao = new UserDao();

        // lay so trang tu parameter, mac dinh la 1
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // dem tong so user va tinh tong so trang
        int totalUsers = dao.countAllUser();
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        // lay danh sach user theo trang
        List<UserDto> list = dao.getUsersByPage(page, PAGE_SIZE);
        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);

        // lay danh sach role de hien thi trong modal
        List<Role> roles = dao.getAllRoles();
        request.setAttribute("roles", roles);

        request.getRequestDispatcher("/views/user-mgt/user-list.jsp").forward(request, response);
    }

}
