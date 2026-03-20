/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.room;

import dal.AssetDetailDAO;
import dal.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
 *
 * @author vuhieu
 */
@WebServlet(name = "RoomInventoryController", urlPatterns = {
        "/inventory/room"
})
public class RoomInventoryController extends HttpServlet {

    private final RoomDAO roomDao = new RoomDAO();
    private final AssetDetailDAO assetDetailDao = new AssetDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/inventory/room":
                doInventory(request, response);
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    public void doInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDto user = (UserDto) request.getSession().getAttribute("user");
        List<Room> rooms;
        // Role 4: Trưởng bộ môn / Giáo viên quản lý -> Chỉ xem phòng của bộ môn mình
        if (user.getRoleName().equals(Message.TRUONG_BAN)) {
            rooms = roomDao.getByDeptId(user.getDeptId());
        } else {
            // Các role khác (QLTS, Hiệu trưởng...) -> Xem tất cả
            rooms = roomDao.getAll();
        }
        request.setAttribute("rooms", rooms);
        // Nếu người dùng có chọn 1 phòng trên giao diện (dropdown)
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr != null && !roomIdStr.isEmpty()) {
            try {
                int roomId = Integer.parseInt(roomIdStr);

                // BẢO MẬT: Kiểm tra xem user có quyền xem phòng này không
                boolean isAllowed = rooms.stream().anyMatch(r -> r.getRoomId() == roomId);

                if (isAllowed) {
                    // Gọi hàm DAO bạn vừa viết
                    List<AssetDetail> assetDetails = assetDetailDao.getAssetDetailByRoomId(roomId);
                    request.setAttribute("assetDetails", assetDetails);
                    request.setAttribute("selectedRoomId", roomId);

                    // Truyền thêm tên phòng để hiển thị Header trên UI
                    Room selectedRoom = roomDao.getById(roomId);
                    if (selectedRoom != null) {
                        request.setAttribute("selectedRoomName", selectedRoom.getRoomName());
                    }
                } else {
                    request.setAttribute("errorMsg", "Bạn không có quyền truy cập dữ liệu của phòng này.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "Mã phòng không hợp lệ.");
            }
        }
        // Forward tới file JSP
        request.getRequestDispatcher("/views/inventory/room-inventory.jsp").forward(request, response);
    }

}
