package controller.asset;

import dal.AllocationRequestDAO;
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

@WebServlet(name = "RetrievalController", urlPatterns = {"/asset/retrieval-list"})
public class RetrievalController extends HttpServlet {

    private final AllocationRequestDAO allocationDao = new AllocationRequestDAO();
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
            session.setAttribute("errorMsg", "Chỉ nhân viên thiết bị mới được thực hiện thu hồi tài sản.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        int allocationId;
        try {
            allocationId = Integer.parseInt(request.getParameter("allocationId"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        AllocationRequest alloc = allocationDao.getRequestById(allocationId);
        if (alloc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + allocationId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        String status = alloc.getStatus();
        boolean canRetrieve = "Approved_By_Staff".equals(status)
                || "Approved_By_VP".equals(status)
                || "Approved_By_Principal".equals(status)
                || "Partially_Completed".equals(status);
        if (!canRetrieve) {
            session.setAttribute("errorMsg", "Chỉ có thể thu hồi tài sản cho các yêu cầu đã được duyệt.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-detail?id=" + allocationId);
            return;
        }

        // Lấy danh sách asset còn thiếu trong yêu cầu
        List<AllocationDetail> details = allocationDao.getDetailsByRequestId(allocationId);

        // Với mỗi asset còn thiếu, lấy danh sách instance đang In_Use ở các phòng
        Map<Integer, List<AssetDetail>> inUseByAsset = new HashMap<>();
        for (AllocationDetail d : details) {
            int remaining = d.getQuantity() - d.getAllocatedQuantity();
            if (remaining > 0) {
                inUseByAsset.put(d.getAssetId(),
                        assetDetailDao.getInUseInstancesByAsset(d.getAssetId()));
            }
        }

        alloc.setDetails(details);
        request.setAttribute("alloc", alloc);
        request.setAttribute("details", details);
        request.setAttribute("inUseByAsset", inUseByAsset);

        request.getRequestDispatcher("/views/asset/retrieval-list.jsp")
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
            session.setAttribute("errorMsg", "Chỉ nhân viên thiết bị mới được thực hiện thu hồi tài sản.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        int allocationId;
        try {
            allocationId = Integer.parseInt(request.getParameter("allocationId"));
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Đọc danh sách instance được chọn để thu hồi
        String[] selectedValues = request.getParameterValues("instanceIds");
        if (selectedValues == null || selectedValues.length == 0) {
            session.setAttribute("errorMsg", "Bạn chưa chọn cá thể nào để thu hồi.");
            response.sendRedirect(request.getContextPath()
                    + "/asset/retrieval-list?allocationId=" + allocationId);
            return;
        }

        List<Integer> instanceIds = new ArrayList<>();
        for (String v : selectedValues) {
            try {
                instanceIds.add(Integer.parseInt(v));
            } catch (NumberFormatException ignored) {
            }
        }

        if (instanceIds.isEmpty()) {
            session.setAttribute("errorMsg", "Bạn chưa chọn cá thể nào để thu hồi.");
            response.sendRedirect(request.getContextPath()
                    + "/asset/retrieval-list?allocationId=" + allocationId);
            return;
        }

        // --- BỔ SUNG VALIDATION SERVER-SIDE ---
        // 1. Lấy thông tin số lượng còn thiếu của từng asset trong yêu cầu
        List<AllocationDetail> details = allocationDao.getDetailsByRequestId(allocationId);
        Map<Integer, Integer> remainingMap = new HashMap<>();
        for (AllocationDetail d : details) {
            remainingMap.put(d.getAssetId(), d.getQuantity() - d.getAllocatedQuantity());
        }

        // 2. Kiểm tra xem các instanceIds gửi lên thuộc về asset nào và đếm số lượng
        Map<Integer, Integer> pickedCounts = new HashMap<>();
        try (Connection con = new DBContext().getConnection()) {
            StringBuilder sb = new StringBuilder("SELECT instance_id, asset_id FROM asset_details WHERE instance_id IN (");
            for (int i = 0; i < instanceIds.size(); i++) {
                sb.append(i > 0 ? "," : "").append("?");
            }
            sb.append(")");

            try (PreparedStatement ps = con.prepareStatement(sb.toString())) {
                for (int i = 0; i < instanceIds.size(); i++) {
                    ps.setInt(i + 1, instanceIds.get(i));
                }
                try (var rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int assetId = rs.getInt("asset_id");
                        pickedCounts.put(assetId, pickedCounts.getOrDefault(assetId, 0) + 1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 3. So sánh số lượng chọn với số lượng còn thiếu
        for (Map.Entry<Integer, Integer> entry : pickedCounts.entrySet()) {
            int assetId = entry.getKey();
            int picked = entry.getValue();
            int remaining = remainingMap.getOrDefault(assetId, 0);

            if (picked > remaining) {
                session.setAttribute("errorMsg", "Số lượng thu hồi vượt quá nhu cầu còn thiếu của yêu cầu.");
                response.sendRedirect(request.getContextPath()
                        + "/asset/retrieval-list?allocationId=" + allocationId);
                return;
            }
        }
        // --- KẾT THÚC VALIDATION ---

        // Build placeholders
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < instanceIds.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }

        try (Connection con = new DBContext().getConnection()) {
            con.setAutoCommit(false);

            // 1) Cập nhật instance: status = In_Stock, room_id = NULL
            String sqlUpdate = "UPDATE asset_details SET status = N'In_Stock', room_id = NULL "
                    + "WHERE instance_id IN (" + placeholders + ")";
            try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
                for (int i = 0; i < instanceIds.size(); i++) {
                    ps.setInt(i + 1, instanceIds.get(i));
                }
                ps.executeUpdate();
            }

            // 2) Ghi lịch sử thu hồi
            String sqlHistory = "INSERT INTO asset_history "
                    + "(instance_id, action, performed_by, description, action_date) "
                    + "VALUES (?, N'Retrieved', ?, ?, GETDATE())";
            try (PreparedStatement ps = con.prepareStatement(sqlHistory)) {
                String desc = "Thu hồi về kho để cấp phát cho yêu cầu REQ-" + allocationId;
                for (Integer id : instanceIds) {
                    ps.setInt(1, id);
                    ps.setInt(2, user.getUserId());
                    ps.setString(3, desc);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();

            session.setAttribute("successMsg",
                    "Đã thu hồi " + instanceIds.size() + " cá thể về kho. "
                    + "Bạn có thể tiến hành cấp phát cho yêu cầu REQ-" + allocationId + ".");
            response.sendRedirect(request.getContextPath()
                    + "/request/allocation-detail?id=" + allocationId);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi khi thu hồi tài sản: " + e.getMessage());
            response.sendRedirect(request.getContextPath()
                    + "/asset/retrieval-list?allocationId=" + allocationId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi hệ thống khi thu hồi tài sản.");
            response.sendRedirect(request.getContextPath()
                    + "/asset/retrieval-list?allocationId=" + allocationId);
        }
    }
}
