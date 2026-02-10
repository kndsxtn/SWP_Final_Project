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

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id;
        if(idStr == null || idStr.isBlank()) {
            response.sendRedirect("ViewCategoryController");
            return;
        }
        try{
            id = Integer.parseInt(idStr);
        }catch(NumberFormatException e){
            response.sendRedirect("ViewCategoryController");
            return;
        }
        
        CategoryDao cDao = new CategoryDao();
        Category category = cDao.findCategoryById(id);
        if(category == null){
            response.sendRedirect("ViewCategoryController");
            return;
        }
        request.setAttribute("category",category );
        request.setAttribute("categoryForm", "update");
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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = "";
        int category_id = Integer.parseInt(request.getParameter("category_id"));
        String category_name = request.getParameter("category_name");
        String description = request.getParameter("description");

        CategoryDao cDao = new CategoryDao();
        boolean checkUpdate = cDao.updateCategory(category_id, category_name, description);
        if (!checkUpdate) {
            return;
        }
        response.sendRedirect("ViewCategoryController");
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
