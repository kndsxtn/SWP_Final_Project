/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.tranfer;

import dal.AssetHistoryDao;
import dal.TransferDetailDao;
import dal.TransferOrderDAO;
import dto.UserDto;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.TransferDetail;

/**
 *
 * @author Admin
 */
@WebServlet(name = "TransferStatusUpdate", urlPatterns = {"/transfer/update"})
public class TransferStatusUpdate extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TransferStatusUpdate</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TransferStatusUpdate at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int id = Integer.parseInt(request.getParameter("id").trim());
        String status = request.getParameter("status");
        String room = request.getParameter("room");
        TransferOrderDAO tDao = new TransferOrderDAO();
        AssetHistoryDao assetHistoryDao = new AssetHistoryDao();
        tDao.updateStatus(id, status);
        UserDto u = (UserDto) session.getAttribute("user");
        if (status.equals("Ongoing")) {
            TransferDetailDao tdDao = new TransferDetailDao();
            List<TransferDetail> transferDetails = tdDao.getByTransferId(id);
            for (TransferDetail t:transferDetails) {
                assetHistoryDao.create(t.getAsset().getAssetId(), u.getUserId(), "Tài sản được chuyển ra khỏi phòng "+room, "Làm theo đơn chuyển tài sản");
            }
            response.sendRedirect(request.getContextPath() + "/transfer/handover");
        }
        if (status.equals("Approved") || status.equals("Rejected")) {
            tDao.setApproveBy(id, u.getUserId());
            response.sendRedirect(request.getContextPath() + "/transfer/list");
        }
        if (status.equals("Cancelled")) {
            response.sendRedirect(request.getContextPath() + "/transfer/list");
        }
        if (status.equals("Completed")) {
            TransferDetailDao tdDao = new TransferDetailDao();
            List<TransferDetail> transferDetails = tdDao.getByTransferId(id);
            for (TransferDetail t:transferDetails) {
                assetHistoryDao.create(t.getAsset().getAssetId(), u.getUserId(), "Tài sản được chuyển vào phòng "+room, "Làm theo đơn chuyển tài sản");
            }
            response.sendRedirect(request.getContextPath() + "/transfer/receive");
        }
        if (status.equals("Failed")) {
            TransferDetailDao tdDao = new TransferDetailDao();
            List<TransferDetail> transferDetails = tdDao.getByTransferId(id);
            for (TransferDetail t:transferDetails) {
                assetHistoryDao.create(t.getAsset().getAssetId(), u.getUserId(), "Tài sản trả về phòng "+room, "Làm theo đơn chuyển tài sản");
            }
            response.sendRedirect(request.getContextPath() + "/transfer/receive");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
