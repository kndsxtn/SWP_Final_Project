/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.userMgt;

import dal.UserDao;
import dto.UserDto;
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
@WebServlet(name="AdminController", urlPatterns={"/admin/user-list"})
public class UserManagementController extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //goi dao de lay danh sach nguoi dung
        UserDao dao = new UserDao();
        List<UserDto> list = dao.getAllUser();
        
        //day danh sach vao attribute
        request.setAttribute("list", list);
        
        //forward sang trang jsp
        request.getRequestDispatcher("/views/admin/user-list.jsp").forward(request, response);
    } 

}
