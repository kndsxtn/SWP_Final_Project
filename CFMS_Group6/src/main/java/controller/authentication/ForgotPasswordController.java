package controller.authentication;

import dal.UserDAO;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;
import validation.EmailValidation;
/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = { "/forgot-password" })
public class ForgotPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final EmailValidation emailService = new EmailValidation();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hien thi form quen mat khau
        request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        // 1. Kiem tra xem email co ton tai trong DB khong
        UserDto user = userDAO.getUserByEmail(email);

        if (user == null) {
            session.setAttribute("errorMsg", "Email này không tồn tại trong hệ thống!");
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        // 2. Tao mat khau moi ngau nhien
        String newPassword = generateRandomPassword(8);

        // 3. Cap nhat mat khau moi vao Database va bat co Bat buoc doi mat khau
        boolean isUpdated = userDAO.resetPassword(user.getUserId(), newPassword);

        if (isUpdated) {
            try {
                // 4. Gui email cho nguoi dung
                emailService.sendNewPasswordEmail(user.getEmail(), user.getUsername(), newPassword);
                session.setAttribute("successMsg", "Mật khẩu 3 số đã được gửi vào Email của bạn! Hãy dùng nó để đăng nhập.");
                response.sendRedirect(request.getContextPath() + "/loginHome");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Có lỗi khi gửi email. Vui lòng thử lại sau!");
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            }
        } else {
            session.setAttribute("errorMsg", "Lỗi khi cập nhật mật khẩu!");
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }

    // Ham tao mat khau ngau nhien (Rut gon thanh 3 chu so)
    private String generateRandomPassword(int length) {
        String chars = "0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
