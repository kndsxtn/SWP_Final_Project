/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.authentication;

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
@WebServlet(name="LogoutAuthentication", urlPatterns={"/logout"})
public class LogoutAuthentication extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //lay session hien tai
        HttpSession session = request.getSession(false);
        
        //neu session ton tai thi huy het session
        if(session != null){
            session.invalidate();
        }
        
        //chuyen huong ve trang login
        response.sendRedirect("loginHome");
    } 
}
