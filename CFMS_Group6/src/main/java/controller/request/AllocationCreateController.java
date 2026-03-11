package controller.request;

import dal.AllocationRequestDAO;
import dal.AssetDAO;
import dal.RoomDAO;
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
import model.Asset;
import model.Category;
import model.Room;

/**
 *
 * @author Nguyen Dang Khang
 */
@WebServlet(name = "AllocationCreateController", urlPatterns = {
    "/request/allocation-add",
    "/request/create"
})
public class AllocationCreateController extends HttpServlet {

    private final AssetDAO assetDao = new AssetDAO();
    private final AllocationRequestDAO allocationDao = new AllocationRequestDAO();
    private final RoomDAO roomDao = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        UserDto user = (UserDto) session.getAttribute("user");
        String path = request.getServletPath();
        if ("/request/allocation-add".equals(path)) {
            loadFormData(request, user.getDeptId());
            request.getRequestDispatcher("/views/request/allocation-form.jsp")
                    .forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/allocation-add");
        }
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

        String path = request.getServletPath();
        if ("/request/create".equals(path)) {
            handleCreate(request, response, session, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/allocation-add");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, UserDto user)
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
            request.setAttribute("reason", request.getParameter("reason"));
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
            request.setAttribute("reason", reason);
            loadFormData(request, user.getDeptId());
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

            // Nếu user chọn phòng và note dòng đang trống, tự điền để lưu mục đích cấp phát
            if (roomId != null && (note == null || note.trim().isEmpty())) {
                note = "Phòng " + roomId;
            }

            assetIdList.add(assetId);
            qtyList.add(qty);
            noteList.add(note);
        }

        if (assetIdList.isEmpty()) {
            request.setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại danh sách tài sản.");
            request.setAttribute("reason", reason);
            request.setAttribute("roomId", roomId);
            loadFormData(request, user.getDeptId());
            request.getRequestDispatcher("/views/request/allocation-form.jsp")
                    .forward(request, response);
            return;
        }

        int[] assetIds = assetIdList.stream().mapToInt(Integer::intValue).toArray();
        int[] quantities = qtyList.stream().mapToInt(Integer::intValue).toArray();
        String[] noteArr = noteList.toArray(new String[0]);

        int requestId = allocationDao.createRequest(user.getUserId(), roomId, reason, assetIds, quantities, noteArr);
        if (requestId > 0) {
            session.setAttribute("successMsg", "Đã tạo yêu cầu cấp phát REQ-" + requestId + " thành công.");
            response.sendRedirect(request.getContextPath() + "/request/allocation-list");
        } else {
            request.setAttribute("errorMsg", "Không thể tạo yêu cầu cấp phát. Vui lòng thử lại.");
            request.setAttribute("reason", reason);
            request.setAttribute("roomId", roomId);
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

