/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.category;

import dal.CategoryDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author quang
 */
@WebServlet(name = "CreateCategory", urlPatterns = {"/category/CreateCategory"})
public class CreateCategory extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categoryForm", "create");
        request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    CategoryDao cDao = new CategoryDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = "";
        try {
            String category_name = request.getParameter("category_name");
            if(category_name.isBlank()){
                status = "Tên danh mục không được để trống";
                request.setAttribute("status", status);
                response.sendRedirect("CreateCategory");
                return;
            }
            String prefix_code = request.getParameter("prefix_code");
            if(prefix_code.isBlank()){
                status = "Tiền tố danh mục không được để trống";
                request.setAttribute("status", status);
                response.sendRedirect("CreateCategory");
                return;
            }
            String description = request.getParameter("description");
            if(description.isBlank()){
                status = "Mô tả danh mục không được để trống";
                request.setAttribute("status", status);
                response.sendRedirect("CreateCategory");
                return;
            }
            cDao.createCategory(category_name, prefix_code, description);
            status = "Tạo danh mục mới thành công";
            request.setAttribute("status", status);
        } catch (IOException e) {
            status = "Lỗi khi tạo danh mục.";
            request.setAttribute("status", status);
        }
        response.sendRedirect("ViewCategory");

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
