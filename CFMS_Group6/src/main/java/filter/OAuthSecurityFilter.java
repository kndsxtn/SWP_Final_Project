package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;
/**
 *
 * @author Nguyen Dinh Giap
 */
@WebFilter("/login-google")
public class OAuthSecurityFilter implements Filter {

    private final Logger LOGGER = Logger.getLogger(OAuthSecurityFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String code = req.getParameter("code");
        String state = req.getParameter("state");
        String savedState = (String) req.getSession().getAttribute("google_oauth_state");

        if (code == null || code.isEmpty()
                || state == null || state.isEmpty()
                || savedState == null
                || !savedState.equals(state)) {

            LOGGER.warning("Phát hiện truy cập không hợp lệ vào OAuth Callback.");
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}