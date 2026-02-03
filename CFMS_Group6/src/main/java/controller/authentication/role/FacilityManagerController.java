/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.authentication.role;

import constant.RoleConstant;
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
@WebServlet(name="StaffController", urlPatterns={"/facilityManager"})
public class FacilityManagerController extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         HttpSession session = request.getSession();
        UserDto user = (UserDto) session.getAttribute("user");
        
        //check dieu kien
        if(user == null || user.getRoleId() != RoleConstant.NV_QUAN_LY){
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }
 
        request.getRequestDispatcher("/views/facilityManager.jsp").forward(request, response);
    } 
}
