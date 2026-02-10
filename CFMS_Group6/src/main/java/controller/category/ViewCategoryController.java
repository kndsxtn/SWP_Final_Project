package controller.category;

import dal.CategoryDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;

/**
 *
 * @author quang
 */
@WebServlet(name = "ViewCategoryController", urlPatterns = {"/category/ViewCategoryController"})
public class ViewCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        CategoryDao cDao = new CategoryDao();
        List<Category> catList;
        if (keyword != null && !keyword.isBlank()) {
            catList = cDao.searchCategory(keyword);
        } else {
            catList = cDao.loadCategory();
        }
        request.setAttribute("catList", catList);
        request.getRequestDispatcher("/views/category/category-list.jsp").forward(request, response);
    }
}
