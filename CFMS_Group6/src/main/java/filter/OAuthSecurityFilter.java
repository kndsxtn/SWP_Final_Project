package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Filter này dùng để bảo vệ đường dẫn nhận kết quả trả về từ Google.
 * Nó đảm bảo request có chứa tham số 'code' và 'state' hợp lệ.
 */
// Đường dẫn này phải KHỚP với cấu hình trong Google Cloud Console
@WebFilter("/oauth2callback") 
public class OAuthSecurityFilter implements Filter {

    // Tạo Logger để ghi lại nhật ký lỗi nếu có ai đó cố tình truy cập trái phép
    private final Logger LOGGER = Logger.getLogger(OAuthSecurityFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo (thường để trống)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 1. Lấy 2 tham số quan trọng mà Google trả về
        String code = req.getParameter("code");   // Mã xác thực (dùng đổi lấy Token)
        String state = req.getParameter("state"); // Mã bảo mật chống giả mạo

        // 2. Kiểm tra tính hợp lệ
        if (code == null || state == null || code.isEmpty() || state.isEmpty()) {
            // TRƯỜNG HỢP: Truy cập trực tiếp vào link này mà không qua Google
            // -> Chặn lại và báo lỗi 403 (Forbidden)
            LOGGER.warning("Phát hiện truy cập không hợp lệ vào OAuth Callback: Thiếu code hoặc state.");
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Truy cập bị từ chối. Thiếu tham số xác thực.");
            return; // Dừng, không cho đi tiếp
        }

        // 3. Nếu hợp lệ -> Cho phép đi tiếp vào Servlet xử lý đăng nhập
        // (Ví dụ: LoginGoogleServlet sẽ chạy ngay sau Filter này)
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}
