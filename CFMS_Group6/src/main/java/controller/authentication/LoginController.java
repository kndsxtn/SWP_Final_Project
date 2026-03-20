/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authentication;

import dal.UserDAO;
import dto.UserDto;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import validation.UserValidator;
import constant.Message;

/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name = "LoginAuthentication", urlPatterns = { "/loginHome" })
public class LoginController extends HttpServlet {

    @Override
    // Chay khi user go link /loginHome hoặc bi Filter da ve hien trang Login
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // kiem tra da dang nhap roi thi ko cho vao login nua
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // UserDto user = (UserDto) session.getAttribute("user");
            // //dieu huong ve login
            // redirectBasedOnRole(request, response, user);
            // return;
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/views/auth/login.jsp")
                .forward(request, response);
    }

    @Override
    // chay khi user bam nut dang nhap trong form
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // lay data tu form
        // khai bao user
        String user = request.getParameter("username");
        // khai bao password
        String password = request.getParameter("password");

        // Use Validator (No Map used)
        String error = UserValidator.validateLogin(user, password);

        if (error != null) {
            // Check if error is related to password or username
            if (error.equals(Message.ERROR_PASS) || error.equals(Message.EMPTY_PASSWORD)) {
                request.setAttribute("errorPass", error);
            } else {
                request.setAttribute("errorMsg", error);
            }
            request.setAttribute("username", user);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Neu khong co loi validation, tuc la user da duoc tim thay va password dung
        UserDAO dao = new UserDAO();
        try {
            // Tim tai khoan theo Username hoac Email
            UserDto account = dao.getUserByUserName(user);
            if (account == null) {
                account = dao.getUserByEmail(user);
            }
            
            // neu dung thi cho dang nhap
            HttpSession session = request.getSession(true);
            session.setAttribute("user", account);
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (Exception e) {
            // neu loi thi quay ra login
            e.printStackTrace();
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }

    }
}
