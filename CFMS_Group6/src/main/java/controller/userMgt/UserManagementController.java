/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.userMgt;

import dal.UserDAO;
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
        UserDAO dao = new UserDAO();

        // 1. Lay tham so tim kiem
        String searchQuery = request.getParameter("searchQuery");
        String roleIdStr = request.getParameter("roleId");
        Integer roleId = null;
        if (roleIdStr != null && !roleIdStr.isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdStr);
            } catch (NumberFormatException e) {
                roleId = 0;
            }
        }

        // 2. Phan trang
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 3. Lay du lieu da qua filter
        int totalUsers = dao.countSearchUsers(searchQuery, roleId);
        int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<UserDto> list = dao.searchUsers(searchQuery, roleId, page, PAGE_SIZE);

        // 4. Day du lieu sang JSP
        request.setAttribute("list", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        
        // Luu lai cac input tim kiem de hien thi tren form
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("selectedRoleId", roleId);

        // Lay danh sach role de hien thi trong dropdown filter va modal
        List<Role> roles = dao.getAllRoles();
        request.setAttribute("roles", roles);

        // Lay danh sach department de hien thi modal
        List<model.Department> depts = dao.getAllDepartments();
        request.setAttribute("depts", depts);

        request.getRequestDispatcher("/views/user-mgt/user-list.jsp").forward(request, response);
    }

}
