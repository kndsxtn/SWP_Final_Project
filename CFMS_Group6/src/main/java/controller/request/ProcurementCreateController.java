package controller.request;

import dal.AllocationRequestDAO;
import dal.AssetDAO;
import dal.ProcurementRequestDAO;
import dto.UserDto;
import java.io.IOException;
import java.util.ArrayList;
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
import model.Asset;
import model.Category;

@WebServlet(name = "ProcurementCreateController", urlPatterns = {
    "/request/procurement-add",
    "/request/procurement-create"
})
public class ProcurementCreateController extends HttpServlet {
    private final AssetDAO assetDao = new AssetDAO();
    private final ProcurementRequestDAO procurementDao = new ProcurementRequestDAO();
    private final AllocationRequestDAO allocationDao = new AllocationRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }

        String path = request.getServletPath();
        if ("/request/procurement-add".equals(path)) {
            // Check if coming from allocation detail (pre-fill mode)
            String allocationIdStr = request.getParameter("allocationId");
            String assetIdStr = request.getParameter("assetId");
            if (allocationIdStr != null && assetIdStr != null) {
                try {
                    int allocationId = Integer.parseInt(allocationIdStr);
                    int assetId = Integer.parseInt(assetIdStr);
                    AllocationRequest alloc = allocationDao.getRequestById(allocationId);
                    if (alloc != null) {
                        // Find remaining quantity for this asset
                        int remaining = 0;
                        AllocationDetail matchedDetail = null;
                        List<AllocationDetail> details = allocationDao.getDetailsByRequestId(allocationId);
                        for (AllocationDetail d : details) {
                            if (d.getAssetId() == assetId) {
                                remaining = d.getQuantity() - d.getAllocatedQuantity();
                                matchedDetail = d;
                                break;
                            }
                        }
                        // Trừ thêm số lượng đã có procurement đang pending/approved
                        Map<Integer, Integer> procuredMap = procurementDao.getProcuredQuantityByAllocation(allocationId);
                        int alreadyProcured = procuredMap.getOrDefault(assetId, 0);
                        int suggestQty = remaining - alreadyProcured;
                        request.setAttribute("prefillAllocationId", allocationId);
                        request.setAttribute("prefillAssetId", assetId);
                        request.setAttribute("prefillQuantity", suggestQty > 0 ? suggestQty : 1);
                        request.setAttribute("prefillReason", "Bổ sung tài sản còn thiếu cho yêu cầu cấp phát REQ-" + allocationId
                                + (alloc.getReason() != null && !alloc.getReason().isEmpty()
                                   ? ": " + alloc.getReason() : ""));
                        request.setAttribute("prefillDetail", matchedDetail);
                        // Thông tin để hiển thị context trong form
                        if (matchedDetail != null) {
                            request.setAttribute("prefillTotalQty", matchedDetail.getQuantity());
                            request.setAttribute("prefillAllocated", matchedDetail.getAllocatedQuantity());
                        }
                        request.setAttribute("prefillAlreadyProcured", alreadyProcured);
                        request.setAttribute("prefillRemaining", remaining);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
            loadFormData(request);
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/request/procurement-form.jsp")
                    .forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/procurement-add");
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
        if ("/request/procurement-create".equals(path)) {
            handleCreate(request, response, session, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/procurement-add");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, UserDto user)
            throws IOException, ServletException {

        String reason = request.getParameter("reason");
        String[] assetIdsStr = request.getParameterValues("assetId");
        String[] qtyStrs = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("note");
        String allocationIdStr = request.getParameter("allocationId");

        if (assetIdsStr == null || qtyStrs == null || assetIdsStr.length == 0) {
            request.setAttribute("errorMsg", "Vui lòng chọn ít nhất một dòng tài sản cần mua sắm.");
            request.setAttribute("reason", reason);
            loadFormData(request);
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/request/procurement-form.jsp")
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

            assetIdList.add(assetId);
            qtyList.add(qty);
            noteList.add(note);
        }

        if (assetIdList.isEmpty()) {
            request.setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại danh sách tài sản.");
            request.setAttribute("reason", reason);
            loadFormData(request);
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/request/procurement-form.jsp")
                    .forward(request, response);
            return;
        }

        int[] assetIds = assetIdList.stream().mapToInt(Integer::intValue).toArray();
        int[] quantities = qtyList.stream().mapToInt(Integer::intValue).toArray();
        String[] noteArr = noteList.toArray(new String[0]);

        int allocationId = -1;
        try {
            if (allocationIdStr != null && !allocationIdStr.isBlank()) {
                allocationId = Integer.parseInt(allocationIdStr);
            }
        } catch (NumberFormatException ignored) {
        }

        int procurementId;
        if (allocationId > 0) {
            procurementId = procurementDao.createProcurementLinked(
                    allocationId, user.getUserId(), reason, assetIds, quantities, noteArr);
        } else {
            procurementId = procurementDao.createProcurementStandalone(
                    user.getUserId(), reason, assetIds, quantities, noteArr);
        }

        if (procurementId > 0) {
            session.setAttribute("successMsg", "Đã tạo yêu cầu mua sắm PROC-" + procurementId + " thành công.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
        } else {
            request.setAttribute("errorMsg", "Không thể tạo yêu cầu mua sắm. Vui lòng thử lại.");
            request.setAttribute("reason", reason);
            loadFormData(request);
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/request/procurement-form.jsp")
                    .forward(request, response);
        }
    }

    private void loadFormData(HttpServletRequest request) {
        List<Asset> assets = assetDao.getAll();
        List<Category> categories = assetDao.getAllCategories();
        request.setAttribute("assets", assets);
        request.setAttribute("categories", categories);
    }
}
