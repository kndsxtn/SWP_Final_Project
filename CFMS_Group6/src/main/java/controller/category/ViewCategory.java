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
@WebServlet(name = "ViewCategory", urlPatterns = {"/category/ViewCategory"})
public class ViewCategory extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = (String) request.getSession().getAttribute("status");
        if (status != null) {
            request.setAttribute("status", status);
            request.getSession().removeAttribute("status");
        }
        
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
