package controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import model.GoogleAccount;
import dal.UserDAO;
import dto.UserDto;
import constant.Message;
/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name = "LoginGoogleServlet", urlPatterns = { "/login-google" })
public class LoginGoogleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String error = request.getParameter("error");
        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String accessToken = GoogleLogin.getToken(code);
        GoogleAccount googleAccount = GoogleLogin.getUserInfo(accessToken);

        UserDAO dao = new UserDAO();
        UserDto account = dao.getUserByEmail(googleAccount.getEmail());

        if (account == null) {
            request.setAttribute("errorMsg", Message.NO_EXITING);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Chặn nếu tài khoản bị khóa
        if (!"Active".equalsIgnoreCase(account.getStatus())) {
            request.setAttribute("errorMsg", "Tài khoản của bạn đã bị khóa hoặc ngừng hoạt động!");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", account);
        session.setAttribute("googleUser", googleAccount);
        session.setMaxInactiveInterval(30 * 60);

        session.removeAttribute("google_oauth_state");

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}