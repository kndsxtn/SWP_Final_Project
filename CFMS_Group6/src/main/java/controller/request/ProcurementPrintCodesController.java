package controller.request;

import dal.AssetDetailDAO;
import dal.ProcurementRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AssetDetail;
import model.ProcurementRequest;

@WebServlet(name = "ProcurementPrintCodesController", urlPatterns = {"/request/procurement-print-codes"})
public class ProcurementPrintCodesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        try {
            int procurementId = Integer.parseInt(idParam);
            
            // Lấy ra thông tin PO
            ProcurementRequestDAO procDao = new ProcurementRequestDAO();
            ProcurementRequest proc = procDao.getProcurementById(procurementId);
            if (proc == null) {
                response.sendRedirect(request.getContextPath() + "/request/procurement-list");
                return;
            }
            
            // Lấy danh sách cá thể vừa được nhập kho từ PO này
            AssetDetailDAO adDao = new AssetDetailDAO();
            List<AssetDetail> instances = adDao.getInstancesStockedInForProcurement(procurementId);
            
            request.setAttribute("proc", proc);
            request.setAttribute("instances", instances);
            
            request.getRequestDispatcher("/views/request/procurement-print-codes.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/request/procurement-list");
        }
    }
}
