package filter;

import dto.UserDto;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 * Phân quyền dựa trên tài liệu Quản Lý Tài Sản
 */
@WebFilter({
    // 1. QUẢN LÝ DANH MỤC
    "/category/create", "/category/update", "/category/delete",
    
    // 2. QUẢN LÝ TÀI SẢN
    "/asset/create", "/asset/update", "/asset/status", "/asset/delete",
    
    // 3. YÊU CẦU CẤP PHÁT
    "/request/create", "/request/cancel", "/request/approve", "/request/check-stock",
    
    // 4. MUA SẮM
    "/procurement/create", "/procurement/cancel", "/procurement/approve",
    
    // 5. ĐIỀU CHUYỂN
    "/transfer/create", "/transfer/cancel", "/transfer/approve", 
    "/transfer/confirm-handover", "/transfer/confirm-receive",

    // 6. BÁO CÁO (Chặn việc xuất file nếu cần)
    "/report/export"
})
public class RoleFilter implements Filter {

    // Map route -> allowed roles
    private static final Map<String, List<String>> routeRoles = new HashMap<>();

    // Định nghĩa các Role chuẩn theo tài liệu
    private static final String BOARD = "BOARD";             // Hiệu trưởng/Phó HT
    private static final String ACCOUNTANT = "ACCOUNTANT";   // Trưởng phòng TC-KT
    private static final String ASSET_MANAGER = "ASSET_MANAGER"; // Nhân viên QLTS
    private static final String DEPT_HEAD = "DEPT_HEAD";     // Trưởng bộ môn

    static {
        // --- NHÓM 1: DANH MỤC (UC01-UC03: Chỉ Kế toán) ---
        routeRoles.put("/category/create", Arrays.asList(ACCOUNTANT));
        routeRoles.put("/category/update", Arrays.asList(ACCOUNTANT));
        routeRoles.put("/category/delete", Arrays.asList(ACCOUNTANT));

        // --- NHÓM 2: TÀI SẢN ---
        // UC05, UC08: Thêm, Sửa -> NV QLTS
        routeRoles.put("/asset/create", Arrays.asList(ASSET_MANAGER));
        routeRoles.put("/asset/update", Arrays.asList(ASSET_MANAGER));
        // UC09: Cập nhật trạng thái -> NV QLTS
        routeRoles.put("/asset/status", Arrays.asList(ASSET_MANAGER)); 
        // UC10: Xóa/Thanh lý -> Kế toán
        routeRoles.put("/asset/delete", Arrays.asList(ACCOUNTANT));

        // --- NHÓM 3: YÊU CẦU CẤP PHÁT ---
        // UC11, UC15: Tạo/Hủy yêu cầu -> Trưởng bộ môn
        routeRoles.put("/request/create", Arrays.asList(DEPT_HEAD));
        routeRoles.put("/request/cancel", Arrays.asList(DEPT_HEAD));
        // UC13, UC14: Kiểm tra kho, Duyệt -> NV QLTS
        routeRoles.put("/request/check-stock", Arrays.asList(ASSET_MANAGER));
        routeRoles.put("/request/approve", Arrays.asList(ASSET_MANAGER));

        // --- NHÓM 4: MUA SẮM ---
        // UC16, UC19: Tạo/Hủy đề xuất -> NV QLTS
        routeRoles.put("/procurement/create", Arrays.asList(ASSET_MANAGER));
        routeRoles.put("/procurement/cancel", Arrays.asList(ASSET_MANAGER));
        // UC18: Duyệt mua sắm lớn -> Hiệu trưởng
        routeRoles.put("/procurement/approve", Arrays.asList(BOARD));

        // --- NHÓM 5: ĐIỀU CHUYỂN ---
        // UC20, UC25: Tạo/Hủy phiếu -> NV QLTS
        routeRoles.put("/transfer/create", Arrays.asList(ASSET_MANAGER));
        routeRoles.put("/transfer/cancel", Arrays.asList(ASSET_MANAGER));
        // UC22: Duyệt điều chuyển -> Kế toán
        routeRoles.put("/transfer/approve", Arrays.asList(ACCOUNTANT));
        // UC23, UC24: Xác nhận Bàn giao/Nhận -> Trưởng bộ môn
        routeRoles.put("/transfer/confirm-handover", Arrays.asList(DEPT_HEAD));
        routeRoles.put("/transfer/confirm-receive", Arrays.asList(DEPT_HEAD));
        
        // --- NHÓM 6: BÁO CÁO ---
        // UC27: Xuất báo cáo -> Ai cũng được trừ Trưởng bộ môn (hoặc tùy bạn)
        routeRoles.put("/report/export", Arrays.asList(BOARD, ACCOUNTANT, ASSET_MANAGER));
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath(); // lấy route hiện tại

        try {
            // Nếu route có trong danh sách phân quyền (Map)
            if (routeRoles.containsKey(path)) {
                if (session != null) {
                    // Lấy UserDTO từ session (Code trước đã thống nhất dùng UserDTO)
                    UserDto user = (UserDto) session.getAttribute("user");
                    
                    if (user != null) {
                        // Lấy Role từ DTO (Lưu ý: DTO của bạn dùng getRoleName())
                        String role = user.getRoleName(); 
                        
                        // Kiểm tra: Role này có được phép vào Path này không?
                        if (role != null && routeRoles.get(path).contains(role)) {
                            chain.doFilter(request, response); // Hợp lệ -> Cho qua
                            return;
                        }
                    }
                }
                
                // Nếu: Session null HOẶC User null HOẶC Role không được phép
                // -> Chuyển hướng về trang báo lỗi Access Denied
                res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
                return;
            }
        } catch (Exception e) {
            // Phòng trường hợp có lỗi bất ngờ -> Chặn luôn cho an toàn
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        // Các route không có trong map (VD: Xem danh sách, trang chủ...) -> Cho phép truy cập
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}