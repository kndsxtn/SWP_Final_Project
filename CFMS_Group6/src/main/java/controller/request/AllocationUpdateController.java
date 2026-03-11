package controller.request;

import dal.AllocationRequestDao;
import dal.AssetDAO;
import dal.RoomDao;
import dto.UserDto;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AllocationDetail;
import model.AllocationRequest;
import model.Asset;
import model.Category;
import model.Room;

/**
 * Controller for updating allocation requests (only when status is Pending)
 * 
 * @author Nguyen Dang Khang
 */
@WebServlet(name = "AllocationUpdateController", urlPatterns = {
    "/request/allocation-edit",
    "/request/update"
})
public class AllocationUpdateController extends HttpServlet {

    private final AssetDAO assetDao = new AssetDAO();
    private final AllocationRequestDao allocationDao = new AllocationRequestDao();
    private final RoomDao roomDao = new RoomDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");

        // Parse request ID
        String idParam = request.getParameter("id");
        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Get the request
        AllocationRequest req = allocationDao.getRequestById(requestId);
        if (req == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu cấp phát REQ-" + requestId);
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Check if user is the creator
        if (req.getCreatedBy() != user.getUserId()) {
            session.setAttribute("errorMsg", "Bạn không có quyền chỉnh sửa yêu cầu này.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        // Check if status is Pending
        if (!"Pending".equals(req.getStatus())) {
            session.setAttribute("errorMsg", "Chỉ có thể chỉnh sửa yêu cầu đang ở trạng thái 'Chờ duyệt'.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-detail?id=" + requestId);
            return;
        }

        // Load details
        List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
        req.setDetails(details);

        // Load form data (assets and categories)
        loadFormData(request, user.getDeptId());

        // Set request for form
        request.setAttribute("req", req);
        request.setAttribute("roomId", req.getTargetRoomId());
        request.setAttribute("isEdit", true);

        request.getRequestDispatcher("/views/request/allocation-form.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }
        UserDto user = (UserDto) session.getAttribute("user");

        // Parse request ID
        String idParam = request.getParameter("requestId");
        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
            return;
        }

        String path = request.getServletPath();
        if ("/request/update".equals(path)) {
            handleUpdate(request, response, session, user, requestId);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, UserDto user, int requestId)
            throws IOException, ServletException {

        String roomIdParam = request.getParameter("roomId");
        Integer roomId = null;
        if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
            try {
                roomId = Integer.parseInt(roomIdParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }
        if (roomId == null || roomId <= 0 || roomDao.getById(roomId) == null) {
            request.setAttribute("errorMsg", "Vui lòng chọn phòng cấp phát.");
            request.setAttribute("roomId", roomId);
            AllocationRequest req = allocationDao.getRequestById(requestId);
            if (req != null) {
                req.setReason(request.getParameter("reason"));
                List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
                req.setDetails(details);
                request.setAttribute("req", req);
            }
            request.setAttribute("isEdit", true);
            loadFormData(request, user.getDeptId());
            request.getRequestDispatcher("/views/request/allocation-form.jsp")
                    .forward(request, response);
            return;
        }

        String reason = request.getParameter("reason");
        String[] assetIdsStr = request.getParameterValues("assetId");
        String[] qtyStrs = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("note");

        if (assetIdsStr == null || qtyStrs == null || assetIdsStr.length == 0) {
            request.setAttribute("errorMsg", "Vui lòng chọn ít nhất một dòng tài sản cần cấp phát.");
            AllocationRequest req = allocationDao.getRequestById(requestId);
            if (req != null) {
                req.setReason(reason);
                List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
                req.setDetails(details);
                request.setAttribute("req", req);
            }
            request.setAttribute("isEdit", true);
            loadFormData(request);
            request.getRequestDispatcher("/views/request/allocation-form.jsp")
                    .forward(request, response);
            return;
        }

        List<Integer> assetIdList = new ArrayList<>();
        List<Integer> qtyList = new ArrayList<>();
        List<String> noteList = new ArrayList<>();

        for (int i = 0; i < assetIdsStr.length; i++) {
            String aStr = assetIdsStr[i];
            String qStr = (i < qtyStrs.length) ? qtyStrs[i] : "1";
            String note = (notes != null && i < notes.length) ? notes[i] : null;

            int assetId;
            int qty;
            try {
                assetId = Integer.parseInt(aStr);
            } catch (NumberFormatException e) {
                continue;
            }
            try {
                qty = Integer.parseInt(qStr);
            } catch (NumberFormatException e) {
                qty = 1;
            }

            if (assetId <= 0 || qty <= 0) {
                continue;
            }

            if (roomId != null && (note == null || note.trim().isEmpty())) {
                note = "Phòng " + roomId;
            }

            assetIdList.add(assetId);
            qtyList.add(qty);
            noteList.add(note);
        }

        if (assetIdList.isEmpty()) {
            request.setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại danh sách tài sản.");
            AllocationRequest req = allocationDao.getRequestById(requestId);
            if (req != null) {
                req.setReason(reason);
                List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
                req.setDetails(details);
                request.setAttribute("req", req);
            }
            request.setAttribute("roomId", roomId);
            request.setAttribute("isEdit", true);
            loadFormData(request, user.getDeptId());
            request.getRequestDispatcher("/views/request/allocation-form.jsp")
                    .forward(request, response);
            return;
        }

        int[] assetIds = assetIdList.stream().mapToInt(Integer::intValue).toArray();
        int[] quantities = qtyList.stream().mapToInt(Integer::intValue).toArray();
        String[] noteArr = noteList.toArray(new String[0]);

        boolean success = allocationDao.updateRequest(requestId, user.getUserId(), roomId, reason, assetIds, quantities, noteArr);
        if (success) {
            session.setAttribute("successMsg", "Đã cập nhật yêu cầu cấp phát REQ-" + requestId + " thành công.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-detail?id=" + requestId);
        } else {
            request.setAttribute("errorMsg", "Không thể cập nhật yêu cầu cấp phát. Vui lòng kiểm tra lại quyền truy cập hoặc trạng thái yêu cầu.");
            AllocationRequest req = allocationDao.getRequestById(requestId);
            if (req != null) {
                req.setReason(reason);
                List<AllocationDetail> details = allocationDao.getDetailsByRequestId(requestId);
                req.setDetails(details);
                request.setAttribute("req", req);
            }
            request.setAttribute("roomId", roomId);
            request.setAttribute("isEdit", true);
            loadFormData(request, user.getDeptId());
            request.getRequestDispatcher("/views/request/allocation-form.jsp")
                    .forward(request, response);
        }
    }

    private void loadFormData(HttpServletRequest request, int deptId) {
        List<Asset> assets = assetDao.getAll();
        List<Category> categories = assetDao.getAllCategories();
        List<Room> rooms = roomDao.getByDeptId(deptId);
        request.setAttribute("assets", assets);
        request.setAttribute("categories", categories);
        request.setAttribute("rooms", rooms);
    }
}
