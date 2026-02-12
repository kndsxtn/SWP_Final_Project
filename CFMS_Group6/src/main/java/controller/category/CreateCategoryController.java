
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
@WebServlet(name = "CreateCategoryController", urlPatterns = {"/category/CreateCategoryController"})
public class CreateCategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categoryForm", "create");
        request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
    }

    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status;
        CategoryDao cDao = new CategoryDao();
        try {
            String category_name = request.getParameter("category_name");
            if(category_name.isBlank()){
                status = "Tên danh mục không được để trống";
                request.setAttribute("status", status);
                request.setAttribute("categoryForm", "create");
                request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
                return;
            }
            String prefix_code = request.getParameter("prefix_code");
            if(prefix_code.isBlank()){
                status = "Tiền tố danh mục không được để trống";
                request.setAttribute("status", status);
                request.setAttribute("categoryForm", "create");
                request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
                return;
            }
            String description = request.getParameter("description");
            if(description.isBlank()){
                status = "Mô tả danh mục không được để trống";
                request.setAttribute("status", status);
                request.setAttribute("categoryForm", "create");
                request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
                return;
            }
            cDao.createCategory(category_name, prefix_code, description);
            status = "Tạo danh mục mới thành công";
            request.setAttribute("status", status);
            request.setAttribute("categoryForm", "create");
            request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
        } catch (IOException e) {
            status = "Lỗi khi tạo danh mục.";
            request.setAttribute("status", status);
            request.setAttribute("categoryForm", "create");
            request.getRequestDispatcher("/views/category/category-form.jsp").forward(request, response);
        }
    }

}
