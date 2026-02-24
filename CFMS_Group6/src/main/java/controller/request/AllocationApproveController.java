package controller.request;

import dal.AllocationRequestDao;
import dal.ProcurementRequestDao;
import dto.UserDto;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AllocationDetail;
import model.AllocationRequest;

/**
 * UC14 – Approve / Reject asset allocation requests.
 * <p>
 * When approving, this controller will:
 *  - Re-check stock (UC13)
 *  - If stock is insufficient, auto-create a procurement request (UC16)
 *
 * @author GPT
 */
@WebServlet(name = "AllocationApproveController", urlPatterns = {"/request/approve"})
public class AllocationApproveController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");

        String idParam = request.getParameter("id");
        String action = request.getParameter("action");
        String reasonReject = request.getParameter("reasonReject");

        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequestDao allocDao = new AllocationRequestDao();
        AllocationRequest alloc = allocDao.getRequestById(requestId);
        if (alloc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Load details & stock info for safety checks
        List<AllocationDetail> details = allocDao.getDetailsByRequestId(requestId);
        alloc.setDetails(details);
        allocDao.populateStockInfo(alloc);

        if ("reject".equalsIgnoreCase(action)) {
            if (reasonReject == null || reasonReject.trim().isEmpty()) {
                reasonReject = "Không có lý do.";
            }
            boolean ok = allocDao.updateStatus(requestId, "Rejected", reasonReject);
            if (ok) {
                session.setAttribute("successMsg",
                        "Đã từ chối yêu cầu REQ-" + requestId + " với lý do: " + reasonReject);
            } else {
                session.setAttribute("errorMsg", "Không thể cập nhật trạng thái yêu cầu REQ-" + requestId);
            }
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        if (!"approve".equalsIgnoreCase(action)) {
            session.setAttribute("errorMsg", "Thao tác không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Approve by Asset Management Staff
        String newStatus = "Approved_By_Staff";

        // UC16 – If stock is insufficient, auto create procurement request
        boolean stockInsufficient = !"FULL".equals(alloc.getStockStatus());
        Integer createdProcurementId = null;
        if (stockInsufficient) {
            Map<Integer, Integer> missingByAsset = allocDao.getMissingQuantitiesByAsset(requestId);
            if (!missingByAsset.isEmpty()) {
                ProcurementRequestDao procDao = new ProcurementRequestDao();
                String reason = "Tự động tạo do kho không đủ tài sản cho yêu cầu REQ-" + requestId;
                int pid = procDao.createProcurementForShortage(
                        requestId,
                        user.getUserId(),
                        missingByAsset,
                        reason
                );
                if (pid > 0) {
                    createdProcurementId = pid;
                }
            }
        }

        boolean ok = allocDao.updateStatus(requestId, newStatus, null);
        if (!ok) {
            session.setAttribute("errorMsg", "Không thể cập nhật trạng thái yêu cầu REQ-" + requestId);
        } else {
            StringBuilder msg = new StringBuilder();
            msg.append("Đã duyệt yêu cầu REQ-").append(requestId).append(".");
            if (createdProcurementId != null) {
                msg.append(" Hệ thống đã tự động tạo đề xuất mua sắm (ID: ").append(createdProcurementId)
                        .append(") do tồn kho không đủ.");
            } else if (stockInsufficient) {
                msg.append(" Kho không đủ tài sản, nhưng không thể tạo đề xuất mua sắm tự động.");
            }
            session.setAttribute("successMsg", msg.toString());
        }

        response.sendRedirect(request.getContextPath() + "/request/allocation-list");
    }
}

