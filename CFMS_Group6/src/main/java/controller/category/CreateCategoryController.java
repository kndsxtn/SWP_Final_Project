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

/**
 *
 * @author quang
 */
@WebServlet(name = "CreateCategoryController", urlPatterns = {"/category/CreateCategoryController"})
public class CreateCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserDto user = (UserDto) session.getAttribute("user");
        if (user == null || (!user.getRoleName().equals("Asset Staff") && !user.getRoleName().equals("Finance Head"))) {
            request.getSession().setAttribute("status", "Hành động thực hiện không hợp lệ!");
            response.sendRedirect("ViewCategoryController");
            return;
        }
        forwardWithMessage(null, request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status;
        CategoryDAO cDao = new CategoryDAO();
        try {
            String category_name = request.getParameter("category_name");
            if (category_name.isBlank()) {
                status = "Lỗi: Tên danh mục không được để trống";
                forwardWithMessage(status, request, response);
                return;
            }
            String prefix_code = request.getParameter("prefix_code");
            if (prefix_code.isBlank()) {
                status = "Lỗi: Tiền tố danh mục không được để trống";
                forwardWithMessage(status, request, response);
                return;
            }
            String description = request.getParameter("description");
            if (description.isBlank()) {
                status = "Lỗi: Mô tả danh mục không được để trống";
                forwardWithMessage(status, request, response);
                return;
            }
            if (cDao.isHasAttributeCategory("category_name", category_name)) {
                status = "Lỗi: Có danh mục trùng tên";
                forwardWithMessage(status, request, response);
                return;
            }
            if (cDao.isHasAttributeCategory("prefix_code", prefix_code)) {
                status = "Lỗi: Trùng mã tiền tố của danh mục đã tồn tại";
                forwardWithMessage(status, request, response);
                return;
            }
            cDao.createCategory(category_name, prefix_code, description);
            status = "Tạo danh mục mới thành công";
            forwardWithMessage(status, request, response);
        } catch (IOException e) {
            status = "Lỗi khi tạo danh mục: " + e.getMessage();
            forwardWithMessage(status, request, response);
        }
    }

    private void forwardWithMessage(String status, HttpServletRequest request, HttpServletResponse response) throws IOException,ServletException{
        request.setAttribute("status", status);
        request.setAttribute("categoryForm", "create");
        request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
    }
}
