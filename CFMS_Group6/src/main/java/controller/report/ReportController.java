/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.report;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nguyen Dinh Giap
 */
@WebServlet(name="ReportController", urlPatterns={"/report/dashboard"})
public class ReportController extends HttpServlet {

  
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        java.sql.Date startDate = (startDateStr != null && !startDateStr.isEmpty()) ? java.sql.Date.valueOf(startDateStr) : null;
        java.sql.Date endDate = (endDateStr != null && !endDateStr.isEmpty()) ? java.sql.Date.valueOf(endDateStr) : new java.sql.Date(System.currentTimeMillis());

        try {
            dal.ReportDAO reportDAO = new dal.ReportDAO();
            java.util.List<dto.AssetReportDto> reportData = reportDAO.getAssetReport(startDate, endDate);

            request.setAttribute("reportData", reportData);
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Invalid date format");
        }

        request.getRequestDispatcher("/views/report/dashboard-main.jsp").forward(request, response);
    } 


}
