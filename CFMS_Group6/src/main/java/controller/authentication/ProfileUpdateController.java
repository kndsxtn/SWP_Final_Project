package controller.authentication;

import dal.UserDAO;
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
 * @author Nguyen Dinh Giap
 */

@WebServlet(name = "ProfileUpdateController", urlPatterns = { "/profile/update" })
public class ProfileUpdateController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy session
        HttpSession session = request.getSession(false);
        UserDto currentUser = (session != null) ? (UserDto) session.getAttribute("user") : null;

        // Chưa đăng nhập thì về trang login
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Cập nhật vào object
        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        currentUser.setPhone(phone);

        // Lưu xuống database
        UserDAO dao = new UserDAO();
        boolean ok = dao.updateProfile(currentUser);

        if (ok) {
            // Cập nhật lại session
            session.setAttribute("user", currentUser);
            session.setAttribute("successMsg", "Cập nhật thông tin thành công!");
        } else {
            session.setAttribute("errorMsg", "Cập nhật thất bại, vui lòng thử lại!");
        }

        // Quay lại trang profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
