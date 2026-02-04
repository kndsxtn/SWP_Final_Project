/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authentication;

import constant.Message;
import dao.user.UserDao;
import dto.UserDto;
import java.io.IOException;
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
@WebServlet(name = "LoginAuthentication", urlPatterns = {"/loginHome"})
public class LoginAuthentication extends HttpServlet {

    @Override
    //Chay khi user go link /loginHome hoặc bi Filter da ve hien trang Login
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //kiem tra da dang nhap roi thi ko cho vao login nua
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            UserDto user = (UserDto) session.getAttribute("user");
            //dieu huong ve login
            redirectBasedOnRole(request, response, user);
            return;
        }
        request.getRequestDispatcher("/views/auth/login.jsp")
                .forward(request, response);
    }

    @Override
    //chay khi user bam nut dang nhap trong form
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //lay data tu form
        //khai bao user
        String user = request.getParameter("username");
        //khai bao password
        String password = request.getParameter("password");

        //call DAO 
        UserDao dao = new UserDao();

        try {
            UserDto account = dao.getUserByUserName(user);
            //kiem tra account co trong database ko
            if (account == null) {
                request.setAttribute("errorMsg", Message.NO_EXITING);
                request.setAttribute("username", user);
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }
            String passwordDB = dao.getPasswordByUserName(user);

            //kiem tra mat khau
            if (passwordDB != null && passwordDB.trim().equals(password)) {

                //neu dung thi cho dang nhap
                HttpSession session = request.getSession(true);
                session.setAttribute("user", account);
                session.setMaxInactiveInterval(30 * 60);
                redirectBasedOnRole(request, response, account);
                return;
            } else {
                //neu sai thi view ra thong bao
                request.setAttribute("errorPass", Message.ERROR_PASS);
                request.setAttribute("username", user);
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            //neu loi thi quay ra login
            e.printStackTrace();
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }

    }

    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response, UserDto user)
            throws IOException {
        //lay role name
        String roleName = user.getRoleName();
        String redirect = request.getContextPath();

        //dieu huong dua vao vai tro
        switch (roleName) {
            case Message.ADMIN:
                //quan ly nguoi dung
                response.sendRedirect(redirect + "/admin/user-list");
                break;
            case Message.HIEU_TRUONG:
                //xem bao cao
                response.sendRedirect(redirect + "/report/dashboard");
                break;
            case Message.NV_QUAN_LY:
                //xu ly yeu cau
                response.sendRedirect(redirect + "/request/allocation-list");
                break;
            case Message.TP_TAI_CHINH:
                //quan ly tai san va thanh ly
                response.sendRedirect(redirect + "/asset/list");
                break;
            case Message.TRUONG_BAN:
                //theo doi lich su yeu cau
                response.sendRedirect(redirect + "/request/my-requests");
                break;
            default:
                request.getSession().invalidate();
                response.sendRedirect(redirect + "/loginHome?error=invalidRole");
                break;
        }

    }
}
