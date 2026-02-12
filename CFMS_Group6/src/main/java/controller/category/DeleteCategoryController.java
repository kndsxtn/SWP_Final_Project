
package controller.category;

import dal.CategoryDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

/**
 *
 * @author quang
 */
@WebServlet(name = "DeleteCategoryController", urlPatterns = {"/category/DeleteCategoryController"})
public class DeleteCategoryController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status;
        int id = Integer.parseInt(request.getParameter("id"));
        CategoryDao cDao = new CategoryDao();
        try {
            if (cDao.isAssetInCategoryEmpty(id)) {
                cDao.deleteCategory(id);
            }
            else{
                status = "Lỗi: Danh mục đang chứa các tài sản khác.";
                request.setAttribute("status", status);
            }
        } catch (ClassNotFoundException | SQLException e) {
            
        }
        response.sendRedirect("ViewCategoryController");
    }

}
