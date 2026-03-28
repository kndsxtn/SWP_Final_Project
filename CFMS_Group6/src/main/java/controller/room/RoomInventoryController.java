package controller.room;

import dal.AssetDetailDAO;
import dal.RoomDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

import constant.Message;
import model.AssetDetail;
import model.Room;
import dto.UserDto;

/**
 * Controller xử lý kiểm kê tài sản theo phòng ban / phòng.
 * - HOD: chỉ xem phòng ban của mình.
 * - Asset Staff / Principal / Finance Head: xem tất cả phòng ban.
 *
 * @author vuhieu
 */
@WebServlet(name = "RoomInventoryController", urlPatterns = {
        "/inventory/dept"
})
public class RoomInventoryController extends HttpServlet {

    private final RoomDAO roomDao = new RoomDAO();
    private final AssetDetailDAO assetDetailDao = new AssetDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/inventory/dept":
                doDeptInventory(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    /**
     * Xem tài sản theo phòng ban.
     * - HOD: tự động lọc theo dept_id của user, có thể lọc thêm theo phòng.
     * - Asset Staff / Principal / Finance Head: xem toàn bộ, lọc theo phòng ban và
     * phòng.
     */
    private void doDeptInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // RoleFilter đã kiểm tra quyền truy cập, ở đây chỉ cần lấy user từ session
        UserDto user = (UserDto) request.getSession().getAttribute("user");

        String role = user.getRoleName();
        boolean isHod = Message.TRUONG_BAN.equals(role);

        List<AssetDetail> assetDetails;
        List<Room> rooms;

        if (isHod) {
            // HOD: chỉ xem phòng ban của mình
            int deptId = user.getDeptId();
            assetDetails = assetDetailDao.getAllAssetDetailByDeptId(deptId);
            rooms = roomDao.getByDeptId(deptId);
        } else {
            // Staff / Principal / Finance: xem toàn bộ
            // Hỗ trợ lọc theo phòng ban
            String deptIdStr = request.getParameter("deptId");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                int deptId = Integer.parseInt(deptIdStr);
                assetDetails = assetDetailDao.getAllAssetDetailByDeptId(deptId);
                rooms = roomDao.getByDeptId(deptId);
                request.setAttribute("selectedDeptId", deptId);
            } else {
                assetDetails = assetDetailDao.getAllAssetDetails();
                rooms = roomDao.getAll();
            }

            // Truyền danh sách phòng ban cho dropdown lọc
            request.setAttribute("departments", roomDao.getAllDepartments());
        }

        request.setAttribute("assetDetails", assetDetails);
        request.setAttribute("rooms", rooms);
        request.setAttribute("isHod", isHod);

        // Lọc theo phòng cụ thể (nếu user chọn)
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr != null && !roomIdStr.isEmpty()) {
            try {
                int roomId = Integer.parseInt(roomIdStr);
                // Kiểm tra phòng có thuộc danh sách được phép không
                boolean isAllowed = false;
                for (Room r : rooms) {
                    if (r.getRoomId() == roomId) {
                        isAllowed = true;
                        break;
                    }
                }
                if (isAllowed) {
                    assetDetails = assetDetailDao.getAssetDetailByRoomId(roomId);
                    request.setAttribute("assetDetails", assetDetails);
                    request.setAttribute("selectedRoomId", roomId);
                } else {
                    request.setAttribute("errorMsg", "Bạn không có quyền truy cập dữ liệu của phòng này!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "Định dạng mã phòng không hợp lệ!");
            }
        }

        request.getRequestDispatcher("/views/inventory/dept-inventory.jsp").forward(request, response);
    }

}
