package controller.category;

import tool.PagingTool;
import dal.CategoryDAO;
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
        String status = (String) request.getSession().getAttribute("status");
        if (status != null) {
            request.setAttribute("status", status);
            request.getSession().removeAttribute("status");
        }
        
        String keyword = request.getParameter("keyword");
        CategoryDAO cDao = new CategoryDAO();
        List<Category> catList;
        if (keyword != null && !keyword.isBlank()) {
            catList = cDao.searchCategory(keyword);
        } else {
            catList = cDao.loadCategory();
        }
        int size = catList.size();
        int nrpp = Integer.parseInt(request.getServletContext().getInitParameter("nrpp"));
        int index = -1;
        try{
            index = Integer.parseInt(request.getParameter("index"));
        }catch(Exception e){
            index = -1;
        }
        PagingTool tool = new PagingTool(size, nrpp, index);
        tool.caclPaging();
        request.setAttribute("tool", tool);
        request.setAttribute("catList", catList);
        request.getRequestDispatcher("/views/category/category-list.jsp").forward(request, response);
    }
}
