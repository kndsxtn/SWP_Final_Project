package controller.authentication;

import constant.Iconstant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name = "GoogleOAuthServlet", urlPatterns = {"/google-login"})
public class GoogleOAuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("google_oauth_state", state);

        String googleURL = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?scope=" + URLEncoder.encode("email profile openid", StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(Iconstant.GOOGLE_REDIRECT_URI, StandardCharsets.UTF_8)
                + "&response_type=code"
                + "&client_id=" + URLEncoder.encode(Iconstant.GOOGLE_CLIENT_ID, StandardCharsets.UTF_8)
                + "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8)
                + "&prompt=select_account";

        response.sendRedirect(googleURL);
    }
}