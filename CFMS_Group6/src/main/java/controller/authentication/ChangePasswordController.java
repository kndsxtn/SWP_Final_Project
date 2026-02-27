package controller.authentication;

import dal.UserDao;
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
@WebServlet(name = "ChangePasswordController", urlPatterns = { "/change-password" })
public class ChangePasswordController extends HttpServlet {

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
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        UserDao dao = new UserDao();

        // Kiểm tra mật khẩu cũ có đúng không
        String currentPass = dao.getPasswordByUserName(currentUser.getUsername());
        if (!oldPass.equals(currentPass)) {
            session.setAttribute("errorMsg", "Mật khẩu hiện tại không đúng!");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Kiểm tra mật khẩu mới và xác nhận có khớp không
        if (!newPass.equals(confirmPass)) {
            session.setAttribute("errorMsg", "Mật khẩu mới và xác nhận không khớp!");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Lưu mật khẩu mới xuống database
        boolean ok = dao.changePassword(currentUser.getUserId(), newPass);

        if (ok) {
            session.setAttribute("successMsg", "Đổi mật khẩu thành công!");
        } else {
            session.setAttribute("errorMsg", "Đổi mật khẩu thất bại, vui lòng thử lại!");
        }

        // Quay lại trang profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
