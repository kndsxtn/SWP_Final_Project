package controller.report;

import dal.ReportDAO;
import dto.ProcurementReportDto;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProcurementReportController", urlPatterns = {"/report/procedure"})
public class ProcurementReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        if (startDateStr != null && !startDateStr.isEmpty() && endDateStr != null && !endDateStr.isEmpty()) {
            try {
                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);

                ReportDAO reportDAO = new ReportDAO();
                List<ProcurementReportDto> reportData = reportDAO.getProcurementReport(startDate, endDate);

                request.setAttribute("reportData", reportData);
                request.setAttribute("startDate", startDateStr);
                request.setAttribute("endDate", endDateStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Invalid date format");
            }
        }

        request.getRequestDispatcher("/views/report/procurement-report.jsp").forward(request, response);
    }
}
