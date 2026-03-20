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
import validation.UserValidator;

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

        UserDAO dao = new UserDAO();
        String currentPassDB = dao.getPasswordByUserName(currentUser.getUsername());

        // Use Validator
        String error = UserValidator.validateChangePassword(oldPass, currentPassDB, newPass, confirmPass);

        if (error != null) {
            session.setAttribute("errorMsg", error);
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        // Lưu mật khẩu mới xuống database
        boolean ok = dao.changePassword(currentUser.getUserId(), newPass);

        if (ok) {
            currentUser.setForceChange(false); // Quan trong: xoa co bat buoc doi de Filter khong chan nua
            session.setAttribute("user", currentUser);
            session.setAttribute("successMsg", "Đổi mật khẩu thành công!");
        } else {
            session.setAttribute("errorMsg", "Đổi mật khẩu thất bại, vui lòng thử lại!");
        }

        // Quay lại trang profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
