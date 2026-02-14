package controller.category;

import dal.CategoryDao;
import dto.UserDto;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        HttpSession session = request.getSession(false);
        UserDto user = (UserDto) session.getAttribute("user");
        if (user == null || (!user.getRoleName().equals("Asset Staff") && !user.getRoleName().equals("Finance Head"))) {
            request.setAttribute("status", "Bạn không có quyền thực hiện hành động này!");
            request.getRequestDispatcher("/category/ViewCategoryController").forward(request, response);
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        CategoryDao cDao = new CategoryDao();
        try {
            if (cDao.isAssetInCategoryEmpty(id)) {
                cDao.deleteCategory(id);
            } else {
                status = "Lỗi: Danh mục đang chứa các tài sản khác.";
                request.setAttribute("status", status);
            }
        } catch (ClassNotFoundException | SQLException e) {

        }
        response.sendRedirect("ViewCategoryController");
    }

}
