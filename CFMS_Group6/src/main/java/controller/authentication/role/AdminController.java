/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authentication.role;

import constant.RoleConstant;
import dao.user.UserDao;
import dto.UserDto;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDto user = (UserDto) session.getAttribute("user");

        //check dieu kien
        if (user == null || user.getRoleId() != RoleConstant.Admin) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }
        
        //lay du lieu tu database
        UserDao dao = new UserDao();
        List<UserDto> list = dao.getAllUser();
        
        //gui sang cho jsp
        request.setAttribute("listUser", list);
        
        //Admin vao tcn quan ly 
        request.getRequestDispatcher("/views/admin.jsp").forward(request, response);
    }    
    
}
