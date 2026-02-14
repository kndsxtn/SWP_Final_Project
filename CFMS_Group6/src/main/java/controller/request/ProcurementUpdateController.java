package controller.request;

import dal.AssetDAO;
import dal.ProcurementRequestDao;
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
import model.ProcurementDetail;
import model.ProcurementRequest;

@WebServlet(name = "ProcurementUpdateController", urlPatterns = {
    "/request/procurement-edit",
    "/request/procurement-update"
})
public class ProcurementUpdateController extends HttpServlet {

    private final AssetDAO assetDao = new AssetDAO();
    private final ProcurementRequestDao procurementDao = new ProcurementRequestDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginHome");
            return;
        }
        UserDto user = (UserDto) session.getAttribute("user");

        String idParam = request.getParameter("id");
        int procurementId;
        try {
            procurementId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu mua sắm không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
        if (proc == null) {
            session.setAttribute("errorMsg", "Không tìm thấy yêu cầu mua sắm PROC-" + procurementId);
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        if (proc.getCreatedBy() != user.getUserId()) {
            session.setAttribute("errorMsg", "Bạn không có quyền chỉnh sửa yêu cầu này.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        if (!"Pending".equals(proc.getStatus())) {
            session.setAttribute("errorMsg", "Chỉ có thể chỉnh sửa yêu cầu đang ở trạng thái 'Chờ duyệt'.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
            return;
        }

        List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);
        proc.setDetails(details);

        loadFormData(request);
        request.setAttribute("proc", proc);
        request.setAttribute("isEdit", true);

        request.getRequestDispatcher("/views/request/procurement-form.jsp")
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

        String idParam = request.getParameter("procurementId");
        int procurementId;
        try {
            procurementId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Mã yêu cầu mua sắm không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
            return;
        }

        String path = request.getServletPath();
        if ("/request/procurement-update".equals(path)) {
            handleUpdate(request, response, session, user, procurementId);
        } else {
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response,
                              HttpSession session, UserDto user, int procurementId)
            throws IOException, ServletException {

        String reason = request.getParameter("reason");
        String[] assetIdsStr = request.getParameterValues("assetId");
        String[] qtyStrs = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("note");

        if (assetIdsStr == null || qtyStrs == null || assetIdsStr.length == 0) {
            request.setAttribute("errorMsg", "Vui lòng chọn ít nhất một dòng tài sản.");
            ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
            if (proc != null) {
                List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);
                proc.setDetails(details);
                request.setAttribute("proc", proc);
            }
            request.setAttribute("isEdit", true);
            loadFormData(request);
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
            ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
            if (proc != null) {
                List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);
                proc.setDetails(details);
                request.setAttribute("proc", proc);
            }
            request.setAttribute("isEdit", true);
            loadFormData(request);
            request.getRequestDispatcher("/views/request/procurement-form.jsp")
                    .forward(request, response);
            return;
        }

        int[] assetIds = assetIdList.stream().mapToInt(Integer::intValue).toArray();
        int[] quantities = qtyList.stream().mapToInt(Integer::intValue).toArray();
        String[] noteArr = noteList.toArray(new String[0]);

        boolean success = procurementDao.updateProcurement(
                procurementId, user.getUserId(), reason, assetIds, quantities, noteArr);
        if (success) {
            session.setAttribute("successMsg", "Đã cập nhật yêu cầu mua sắm PROC-" + procurementId + " thành công.");
            response.sendRedirect(request.getContextPath() + "/request/procurement-detail?id=" + procurementId);
        } else {
            request.setAttribute("errorMsg", "Không thể cập nhật. Kiểm tra quyền truy cập hoặc trạng thái yêu cầu.");
            ProcurementRequest proc = procurementDao.getProcurementById(procurementId);
            if (proc != null) {
                List<ProcurementDetail> details = procurementDao.getDetailsByProcurementId(procurementId);
                proc.setDetails(details);
                request.setAttribute("proc", proc);
            }
            request.setAttribute("isEdit", true);
            loadFormData(request);
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
