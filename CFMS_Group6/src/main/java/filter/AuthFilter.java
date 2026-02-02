package filter;

import dto.UserDto;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

 

@WebFilter({
    // --- KHU VỰC CHUNG ---
    "/dashboard",
    "/profile",
    "/profile/update",
    "/change-password",

    // --- 1. QUẢN LÝ TÀI SẢN (ASSET) ---
    "/asset/list",
    "/asset/create",
    "/asset/update",
    "/asset/delete",
    "/asset/status", // Cập nhật trạng thái hỏng/mất/thanh lý

    // --- 2. QUẢN LÝ DANH MỤC (CATEGORY) ---
    "/category/list",
    "/category/create",
    "/category/update",
    "/category/delete",

    // --- 3. QUẢN LÝ YÊU CẦU & MUA SẮM (REQUEST & PROCUREMENT) ---
    "/request/list",
    "/request/create",
    "/request/approve", // Duyệt yêu cầu cấp phát
    "/request/cancel",
    "/procurement/list",
    "/procurement/create",
    "/procurement/approve", // Duyệt phiếu mua sắm
    "/procurement/cancel",

    // --- 4. QUẢN LÝ ĐIỀU CHUYỂN (TRANSFER) ---
    "/transfer/list",
    "/transfer/create",
    "/transfer/approve",
    "/transfer/confirm", // Xác nhận đã nhận bàn giao
    "/transfer/cancel",

    // --- 5. BÁO CÁO (REPORT) ---
    "/report/view",
    "/report/export"
}) 
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter (thường để trống)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 2. Lấy session hiện tại (false: không tạo mới nếu chưa có)
        HttpSession session = req.getSession(false);

        // 3. Kiểm tra đăng nhập
        // Lấy object "user" từ session và ép kiểu về UserDTO
        UserDto user = (session != null) ? (UserDto) session.getAttribute("user") : null;

        if (user == null) {
            // TRƯỜNG HỢP: Chưa đăng nhập hoặc Session hết hạn
            // -> Chuyển hướng về trang Login
            // Lưu ý: Đảm bảo đường dẫn "/auth/login" đúng với project của bạn
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return; // Dừng, không cho đi tiếp
        }

        // TRƯỜNG HỢP: Đã đăng nhập
        // -> Cho phép đi tiếp vào Controller/Servlet đích
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}