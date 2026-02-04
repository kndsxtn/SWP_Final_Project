package filter;

import dto.UserDto;
import constant.Message; // Import class Constant của bạn
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 *
 * @author Nguyen Dinh Giap
 */
@WebFilter({
    // Danh sách các URL cần bảo vệ quyền hạn
    "/category/create", "/category/update", "/category/delete",
    "/asset/create", "/asset/update", "/asset/status", "/asset/delete",
    "/request/create", "/request/cancel", "/request/approve", "/request/check-stock",
    "/procurement/create", "/procurement/cancel", "/procurement/approve",
    "/transfer/create", "/transfer/cancel", "/transfer/approve",
    "/transfer/confirm-handover", "/transfer/confirm-receive",
    "/report/export"
})
public class RoleFilter implements Filter {

    private static final Map<String, List<String>> routeRoles = new HashMap<>();

    static {
        // --- NHÓM 1: QUẢN LÝ DANH MỤC (UC01-UC03) ---
        // Nhân viên QLTS quản lý danh mục
        routeRoles.put("/category/create", Arrays.asList(Message.NV_QUAN_LY));
        routeRoles.put("/category/update", Arrays.asList(Message.NV_QUAN_LY));
        routeRoles.put("/category/delete", Arrays.asList(Message.NV_QUAN_LY));

        // --- NHÓM 2: QUẢN LÝ TÀI SẢN (UC05-UC10) ---
        routeRoles.put("/asset/create", Arrays.asList(Message.NV_QUAN_LY)); // UC05
        routeRoles.put("/asset/update", Arrays.asList(Message.NV_QUAN_LY)); // UC08
        routeRoles.put("/asset/status", Arrays.asList(Message.NV_QUAN_LY)); // UC09
        routeRoles.put("/asset/delete", Arrays.asList(Message.TP_TAI_CHINH)); // UC10: Chỉ TP Tài chính

        // --- NHÓM 3: YÊU CẦU CẤP PHÁT (UC11-UC15) ---
        routeRoles.put("/request/create", Arrays.asList(Message.TRUONG_BAN)); // UC11
        routeRoles.put("/request/cancel", Arrays.asList(Message.TRUONG_BAN)); // UC15
        routeRoles.put("/request/check-stock", Arrays.asList(Message.NV_QUAN_LY)); // UC13
        routeRoles.put("/request/approve", Arrays.asList(Message.NV_QUAN_LY)); // UC14

        // --- NHÓM 3: MUA SẮM (UC16-UC19) ---
        routeRoles.put("/procurement/create", Arrays.asList(Message.NV_QUAN_LY)); // UC16
        routeRoles.put("/procurement/cancel", Arrays.asList(Message.NV_QUAN_LY)); // UC19
        routeRoles.put("/procurement/approve", Arrays.asList(Message.HIEU_TRUONG)); // UC18: Hiệu trưởng duyệt

        // --- NHÓM 4: ĐIỀU CHUYỂN (UC20-UC25) ---
        routeRoles.put("/transfer/create", Arrays.asList(Message.NV_QUAN_LY)); // UC20
        routeRoles.put("/transfer/cancel", Arrays.asList(Message.NV_QUAN_LY, Message.TP_TAI_CHINH)); // UC25
        routeRoles.put("/transfer/approve", Arrays.asList(Message.TP_TAI_CHINH)); // UC22: TP Tài chính duyệt
        routeRoles.put("/transfer/confirm-handover", Arrays.asList(Message.TRUONG_BAN)); // UC23
        routeRoles.put("/transfer/confirm-receive", Arrays.asList(Message.TRUONG_BAN)); // UC24

        // --- NHÓM 5: BÁO CÁO (UC27) ---
        // Cho phép các cấp quản lý xuất báo cáo
        routeRoles.put("/report/export", Arrays.asList(Message.HIEU_TRUONG, Message.TP_TAI_CHINH, Message.NV_QUAN_LY));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();

        try {
            if (routeRoles.containsKey(path)) {
                if (session != null && session.getAttribute("user") != null) {
                    UserDto user = (UserDto) session.getAttribute("user");
                    String role = user.getRoleName();

                    if (role != null && routeRoles.get(path).contains(role)) {
                        chain.doFilter(request, response);
                        return;
                    }
                }
                // Nếu không có quyền hoặc chưa đăng nhập
                res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
