/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.authentication;

import dto.UserDto;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name="ProfileAuthentication", urlPatterns={"/profile"})
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserDto dtoUser = (session != null) ? 
                (UserDto) session.getAttribute("user") : null;
        if(dtoUser == null){
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }
        // Đẩy thông tin user sang trang profile
        request.setAttribute("user", dtoUser);
        request.getRequestDispatcher("/views/auth/profile.jsp").forward(request, response);
    } 

}
