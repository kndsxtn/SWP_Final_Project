package controller.request;

import dal.AssetDetailDAO;
import dal.DBContext;
import dal.ProcurementRequestDAO;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.AssetDetail;
import model.ProcurementDetail;
import model.ProcurementRequest;

@WebServlet(name = "ProcurementStockInController", urlPatterns = { "/request/procurement-stockin" })
public class ProcurementStockInController extends HttpServlet {
    private final ProcurementRequestDAO procurementDao = new ProcurementRequestDAO();
    private final AssetDetailDAO assetDetailDAO = new AssetDetailDAO();

    // GET: Hiển thị trang nhập kho
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);

        int procurementId;
        try {
            procurementId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
        if (proc == null || (!"Approved".equals(proc.getStatus()) && !"Partially_Received".equals(proc.getStatus()))) {
            session.setAttribute("errorMsg", "Yêu cầu mua sắm không tồn tại hoặc chưa được duyệt.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);

        request.setAttribute("proc", proc);
        request.setAttribute("details", details);
        request.getRequestDispatcher("/views/request/procurement-stockin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserDto user = (UserDto) session.getAttribute("user");

        int procurementId;
        try {
            procurementId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
        if (proc == null || (!"Approved".equals(proc.getStatus()) && !"Partially_Received".equals(proc.getStatus()))) {
            session.setAttribute("errorMsg", "Mã phiếu không thể nhập kho (có thể đã nhập đủ hoặc bị hủy).");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);
        if (details == null || details.isEmpty()) {
            session.setAttribute("errorMsg", "Phiếu mua sắm không có chi tiết tài sản.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        boolean hasMissing = false;
        Connection con = null;

        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false); // Bắt đầu Transaction

            // Lấy thông tin chi tiết tài sản
            String desc = "Nhập kho từ PO: PROC-" + procurementId;
            List<Integer> newlyGeneratedIds = new ArrayList<>();

            // Lặp qua từng chi tiết tài sản
            for (ProcurementDetail d : details) {
                String paramName = "recvQty_" + d.getDetailId();
                String valStr = request.getParameter(paramName);

                int recvQty = 0;
                if (valStr != null && !valStr.trim().isEmpty()) {
                    try {
                        recvQty = Integer.parseInt(valStr.trim());
                    } catch (NumberFormatException ignored) {
                    }
                }

                // Kiểm tra số lượng nhập kho
                if (recvQty < 0) {
                    // Nếu số lượng nhập kho nhỏ hơn 0 thì set bằng 0
                    recvQty = 0;
                }

                // Lấy số lượng đã nhập kho
                int currentReceived = (d.getReceivedQuantity() == null) ? 0 : d.getReceivedQuantity();

                // Số lượng còn thiếu trước khi nhập lần này
                int remainingToReceive = d.getQuantity() - currentReceived;

                if (recvQty > remainingToReceive) {
                    recvQty = remainingToReceive; // Không cho phép nhập vượt quá số lượng còn lại
                }

                // Tính toán số lượng mới và số lượng còn thiếu
                int newTotalReceived = currentReceived + recvQty;
                int missingQty = d.getQuantity() - newTotalReceived;

                // Kiểm tra xem còn thiếu hay không
                if (missingQty > 0) {
                    // Nếu còn thiếu thì set hasMissing = true
                    hasMissing = true;
                }

                // 1. Cập nhật số lượng nhập kho vào bảng procurement_details
                procurementDao.updateReceivedQuantity(con, d.getDetailId(), newTotalReceived, missingQty);

                // 2. Sinh tài sản: Gọi AssetDetailDAO để sinh mã cá thể tự cộng dồn
                if (recvQty > 0) {
                    List<Integer> batchIds = assetDetailDAO.stockInInstances(
                            con,
                            d.getAssetId(),
                            d.getAsset() != null ? d.getAsset().getAssetCode() : null,
                            recvQty, // Số lượng nhập TRONG LẦN NÀY
                            user.getUserId(),
                            desc);
                    if (batchIds != null) {
                        newlyGeneratedIds.addAll(batchIds);
                    }
                }
            }

            // 3. Cập nhật trạng thái tổng của PO này (Đủ -> Completed, Thiếu ->
            // Partially_Received)
            String newStatus = hasMissing ? "Partially_Received" : "Completed";
            procurementDao.updateProcurementStatus(con, procurementId, newStatus);

            con.commit(); // Thành công tất cả

            // Query ArrayList các bản ghi đầy đủ thông tin để in ấn
            List<AssetDetail> newlyGeneratedInstances = assetDetailDAO.getInstancesByIds(newlyGeneratedIds);
            session.setAttribute("newlyGeneratedInstances", newlyGeneratedInstances);

            session.setAttribute("successMsg", "Nhập kho thành công! Vui lòng in tem nhãn tài sản.");
            // Chuyển hướng sang trang hiển thị mã cá thể vừa sinh để In mã (Bước 5)
            response.sendRedirect(request.getContextPath() + "/request/procurement-print-codes?id=" + procurementId);

        } catch (Exception e) {
            // Rollback transaction khi có lỗi để đảm bảo tính toàn vẹn dữ liệu
            if (con != null) {
                try { con.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi nhập kho: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/request/procurement-stockin?id=" + procurementId);
        } finally {
            // Đóng connection thủ công
            if (con != null) {
                try { con.close(); } catch (Exception ignored) {}
            }
        }
    }
}
