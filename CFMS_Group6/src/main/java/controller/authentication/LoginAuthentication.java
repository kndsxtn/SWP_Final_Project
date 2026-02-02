/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authentication;

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

        //call DAO check 
        UserDao dao = new UserDao();

        //check login ben dao
        UserDto account = dao.checkLogin(user, password);

        //Xu ly ket qua
        if (account != null) {
            //tao session moi
            HttpSession session = request.getSession();

            //luu user vao session
            //phan quyen ben filter user khop ben AuthFilter va RoleFilter
            session.setAttribute("user", account);

            //thiet lap thoi gian session
            session.setMaxInactiveInterval(30 * 60);
            
            //goi dieu huong
            redirectBasedOnRole(request, response, account);

        } else {
            //truong hop sai pass
            //gan thong tin loi de hien thi ben JSP
            request.setAttribute("errorMessage", "Incorrect username or password!");

            //giu lai usename khi go sai pass hoac ten
            request.setAttribute("username", user);

            //quay lai trang login jsp
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }

    }

    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response, UserDto user)
            throws IOException {

        //dieu huong theo role
        int role = user.getRoleId();

        //su dung switch case
        switch (role) {
            //case Admin = 1
            case constant.RoleConstant.Admin:
                //chuyen ve trang chu cua Admin
                response.sendRedirect(request.getContextPath() + "/admin");
                break;

            //case Hieu_Truong = 2
            case constant.RoleConstant.Hieu_Truong:
                //chuyen ve trang chu cua Hieu_Truong
                response.sendRedirect(request.getContextPath() + "/principal");
                break;

            //case TP_TAI_CHINH = 3
            case constant.RoleConstant.TP_TAI_CHINH:
                //chuyen ve trang chu cua TP_TAI_CHINH
                response.sendRedirect(request.getContextPath() + "/finance");
                break;

            //case NV_QUAN_LY = 4
            case constant.RoleConstant.NV_QUAN_LY:
                //chuyen ve trang chu cua NV_QUAN_LY
                response.sendRedirect(request.getContextPath() + "/staff");
                break;

            //case TRUONG_BO_MON = 5
            case constant.RoleConstant.TRUONG_BO_MON:
                //chuyen ve trang chu cua TRUONG_BO_MON
                response.sendRedirect(request.getContextPath() + "/teacher");
                break;
            default:
                //neu loi thi huy session
                request.getSession().invalidate();
                //ve lai login
                response.sendRedirect(request.getContextPath() + "/loginHome?error=invalidRole");
                break;
        }

    }
}
