package controller.request;

import dal.AllocationRequestDao;
import dal.AssetDetailDAO;
import dal.DBContext;
import dto.UserDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.AllocationDetail;
import model.AllocationRequest;
import model.AssetDetail;

/**
 * Cho phép nhân viên thiết bị chọn cụ thể từng cá thể (instance)
 * để cấp phát cho một yêu cầu đã được duyệt.
 *
 * Flow:
 * - GET: hiển thị danh sách các dòng yêu cầu + các instance khả dụng để chọn.
 * - POST: nhận danh sách instance_id được chọn, gán phòng cho chúng (nếu có),
 *   đổi trạng thái instance sang In_Use và đánh dấu yêu cầu Completed.
 */
@WebServlet(name = "AllocationAssignInstanceController", urlPatterns = {"/request/allocation-assign"})
public class AllocationAssignInstanceController extends HttpServlet {

    private final AllocationRequestDao allocationDao = new AllocationRequestDao();
    private final AssetDetailDAO assetDetailDao = new AssetDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");
        if (!"Asset Staff".equals(user.getRoleName())) {
            session.setAttribute("errorMsg", "Chỉ nhân viên thiết bị mới được chọn cá thể cấp phát.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequest reqAlloc = allocationDao.getRequestById(requestId);
        if (reqAlloc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Chỉ cho phép chọn instance khi yêu cầu đã được duyệt
        String status = reqAlloc.getStatus();
        boolean isApproved = "Approved_By_Staff".equals(status)
                || "Approved_By_VP".equals(status)
                || "Approved_By_Principal".equals(status);
        if (!isApproved) {
            session.setAttribute("errorMsg", "Chỉ có thể chọn cá thể cho các yêu cầu đã được duyệt.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-detail?id=" + requestId);
            return;
        }

        List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
        Map<Integer, List<AssetDetail>> instancesByAsset = new HashMap<>();
        for (AllocationDetail d : details) {
            instancesByAsset.put(d.getAssetId(),
                    assetDetailDao.getAvailableInstancesByAsset(d.getAssetId()));
        }

        reqAlloc.setDetails(details);
        request.setAttribute("req", reqAlloc);
        request.setAttribute("details", details);
        request.setAttribute("instancesByAsset", instancesByAsset);
        request.setAttribute("targetRoomId", reqAlloc.getTargetRoomId());

        request.getRequestDispatcher("/views/request/allocation-assign.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");
        if (!"Asset Staff".equals(user.getRoleName())) {
            session.setAttribute("errorMsg", "Chỉ nhân viên thiết bị mới được chọn cá thể cấp phát.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(request.getParameter("requestId"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequest reqAlloc = allocationDao.getRequestById(requestId);
        if (reqAlloc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }
        int targetRoomId = reqAlloc.getTargetRoomId();

        List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
        Map<Integer, List<Integer>> selectedInstancesByDetail = new HashMap<>();

        // Đọc danh sách instance đã chọn cho từng detail
        for (AllocationDetail d : details) {
            String paramName = "instance_" + d.getDetailId();
            String[] values = request.getParameterValues(paramName);
            List<Integer> ids = new ArrayList<>();
            if (values != null) {
                for (String v : values) {
                    try {
                        ids.add(Integer.parseInt(v));
                    } catch (NumberFormatException ignored) {
                    }
                }
            }
            selectedInstancesByDetail.put(d.getDetailId(), ids);
        }

        // Validate: mỗi dòng phải chọn đúng số lượng cá thể = quantity
        for (AllocationDetail d : details) {
            List<Integer> ids = selectedInstancesByDetail.get(d.getDetailId());
            int picked = (ids != null) ? ids.size() : 0;
            if (picked != d.getQuantity()) {
                session.setAttribute("errorMsg",
                        "Dòng tài sản " + d.getAsset().getAssetCode()
                                + " – " + d.getAsset().getAssetName()
                                + " yêu cầu " + d.getQuantity()
                                + " cá thể, nhưng bạn đã chọn " + picked + ".");
                response.sendRedirect(request.getContextPath()
                        + "/request/allocation-assign?id=" + requestId);
                return;
            }
        }

        // Gom tất cả instanceId được chọn vào một list chung để cập nhật
        List<Integer> allInstanceIds = new ArrayList<>();
        for (List<Integer> ids : selectedInstancesByDetail.values()) {
            allInstanceIds.addAll(ids);
        }

        if (allInstanceIds.isEmpty()) {
            session.setAttribute("errorMsg", "Bạn chưa chọn cá thể nào để cấp phát.");
            response.sendRedirect(request.getContextPath()
                    + "/request/allocation-assign?id=" + requestId);
            return;
        }

        // Transaction: cập nhật asset_details + asset_history + đánh dấu Completed
        try (Connection con = new DBContext().getConnection()) {
            con.setAutoCommit(false);

            // 1) Update asset_details: gán room_id (nếu có) và status = 'In_Use'
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < allInstanceIds.size(); i++) {
                if (i > 0) {
                    placeholders.append(",");
                }
                placeholders.append("?");
            }

            String sqlUpdateInstance = "UPDATE asset_details "
                    + "SET status = N'In_Use' "
                    + (targetRoomId > 0 ? ", room_id = ?" : "")
                    + " WHERE instance_id IN (" + placeholders + ")";

            try (PreparedStatement ps = con.prepareStatement(sqlUpdateInstance)) {
                int idx = 1;
                if (targetRoomId > 0) {
                    ps.setInt(idx++, targetRoomId);
                }
                for (Integer id : allInstanceIds) {
                    ps.setInt(idx++, id);
                }
                ps.executeUpdate();
            }

            // 2) Ghi lịch sử cho từng instance
            String sqlHistory = "INSERT INTO asset_history "
                    + "(instance_id, action, performed_by, description, action_date) "
                    + "VALUES (?, N'Allocated', ?, ?, GETDATE())";
            try (PreparedStatement ps = con.prepareStatement(sqlHistory)) {
                String desc = "Cấp phát từ yêu cầu REQ-" + requestId;
                for (Integer id : allInstanceIds) {
                    ps.setInt(1, id);
                    ps.setInt(2, user.getUserId());
                    ps.setString(3, desc);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // 3) Đánh dấu yêu cầu Completed (tận dụng hàm có sẵn)
            boolean updated = allocationDao.markCompleted(requestId);
            if (!updated) {
                con.rollback();
                session.setAttribute("errorMsg", "Không thể đánh dấu yêu cầu REQ-" + requestId + " là hoàn thành.");
                response.sendRedirect(request.getContextPath()
                        + "/request/allocation-assign?id=" + requestId);
                return;
            }

            con.commit();
            session.setAttribute("successMsg",
                    "Đã chọn cá thể và hoàn thành cấp phát cho yêu cầu REQ-" + requestId + ".");
            response.sendRedirect(request.getContextPath()
                    + "/request/allocation-detail?id=" + requestId);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi khi cập nhật cá thể tài sản: " + e.getMessage());
            response.sendRedirect(request.getContextPath()
                    + "/request/allocation-assign?id=" + requestId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi hệ thống khi cập nhật cá thể tài sản.");
            response.sendRedirect(request.getContextPath()
                    + "/request/allocation-assign?id=" + requestId);
        }
    }
}

