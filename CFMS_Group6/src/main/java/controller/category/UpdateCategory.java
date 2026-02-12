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
import model.Category;

/**
 *
 * @author quang
 */
@WebServlet(name = "UpdateCategoryController", urlPatterns = {"/category/UpdateCategoryController"})
public class UpdateCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status;
        String idStr = request.getParameter("id");
        int id;
        if (idStr == null || idStr.isBlank()) {
            status = "Id Trống";
            request.getSession().setAttribute("status", status);
            response.sendRedirect("ViewCategoryController");
            return;
        }
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            status = e.getMessage();
            request.getSession().setAttribute("status", status);
            response.sendRedirect("ViewCategoryController");
            return;
        }

        CategoryDao cDao = new CategoryDao();
        Category category = cDao.findCategoryById(id);
        if (category == null) {
            status = "Không tìm thấy danh mục";
            request.getSession().setAttribute("status", status);
            response.sendRedirect("ViewCategoryController");
            return;
        }
        request.setAttribute("category", category);
        request.setAttribute("categoryForm", "update");
        request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status;

        int category_id = Integer.parseInt(request.getParameter("category_id"));
        String category_name = request.getParameter("category_name");
        String description = request.getParameter("description");

        CategoryDao cDao = new CategoryDao();
        try {
            boolean checkUpdate = cDao.updateCategory(category_id, category_name, description);
            if (!checkUpdate) {
                status = "Cập nhật thất bại";
                request.getSession().setAttribute("status", status);
                response.sendRedirect("ViewCategoryController");
                return;
            }
        } catch (IOException e) {
            status = "Cập nhật thất bại: " + e.getMessage();
            request.getSession().setAttribute("status", status);
            response.sendRedirect("ViewCategoryController");
            return;
        }
        status = "Cập nhật thành công";
        request.getSession().setAttribute("status", status);
        response.sendRedirect("ViewCategoryController");
    }
}
