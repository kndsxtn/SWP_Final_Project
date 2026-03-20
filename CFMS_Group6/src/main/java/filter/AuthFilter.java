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
        "/user-mgt/*"
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

        // --- KIỂM TRA BẮT BUỘC ĐỔI MẬT KHẨU ---
        String uri = req.getRequestURI();
        // Cho phep tiep tuc neu: (1) uri la trang doi mat khau, (2) uri la logout, hoac (3) uri dang o trang profile
        if (user.isForceChange() && !uri.endsWith("/change-password") && !uri.endsWith("/logout") && !uri.contains("/profile")) {
            session.setAttribute("errorMsg", "Bạn phải đổi mật khẩu mới để tiếp tục sử dụng hệ thống!");
            resp.sendRedirect(req.getContextPath() + "/profile"); 
            return;
        }

        // --- ĐĂNG XUẤT XONG KHÔNG CHO ẤN NÚT BACK QUAY LẠI ---
        // Thiết lập các header chống cache (lưu bộ nhớ tạm trên trình duyệt)
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        resp.setHeader("Pragma", "no-cache"); // HTTP 1.0
        resp.setHeader("Expires", "0"); // Proxy servers

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
