package controller.category;

import dal.CategoryDAO;
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
            status = "Bạn không có quyền thực hiện hành động này!";
            request.setAttribute("status", status);
            request.getRequestDispatcher("/category/ViewCategoryController").forward(request, response);
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        CategoryDAO cDao = new CategoryDAO();
        try {
            if (cDao.isAssetInCategoryEmpty(id)) {
                String oldCategory = cDao.findCategoryById(id).getCategoryName();
                cDao.deleteCategory(id);
                status = "Xóa thành công danh mục " + oldCategory;
                request.getSession().setAttribute("FLASH_MSG", status);
            } else {
                status = "Lỗi: Danh mục đang chứa các tài sản khác.";
                request.getSession().setAttribute("FLASH_MSG", status);
            }
        } catch (ClassNotFoundException | SQLException e) {
               status = "Lỗi: Không xác định: "+ e.getMessage();
               request.getSession().setAttribute("FLASH_MSG", status);
        }
        response.sendRedirect("ViewCategoryController?status");
    }

}
