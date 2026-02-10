package filter;

import dto.UserDto;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author Nguyen Dinh Giap
 */

@WebFilter({
        // --- 1. KHU VỰC CHUNG & DASHBOARD ---
        "/dashboard",
        "/report/dashboard", // Landing Page của Hiệu trưởng
        "/profile",
        "/profile/update",
        "/change-password",

        // --- 2. QUẢN LÝ TÀI SẢN & DANH MỤC ---
        "/asset/*", // Dùng wildcard bao quát hết list/create/update...
        "/category/*",

        // --- 3. QUẢN LÝ YÊU CẦU & MUA SẮM ---
        "/request/allocation-list", // Landing Page của NV QLTS
        "/request/my-requests", // Landing Page của Trưởng ban
        "/request/*",
        "/procurement/*",

        // --- 4. QUẢN LÝ ĐIỀU CHUYỂN ---
        "/transfer/*",

        // --- 5. BÁO CÁO & ADMIN ---
        "/report/*",
        "/admin/*"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // Lấy thông tin user từ session
        UserDto user = (session != null) ? (UserDto) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/loginHome");
            return;
        }

        // Đã đăng nhập -> Cho phép đi tiếp (thường là sẽ gặp RoleFilter tiếp theo)
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
