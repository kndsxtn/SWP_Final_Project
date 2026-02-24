/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.tranfer;

import dal.AssetDao;
import dal.RoomDao;
import dal.TransferDao;
import dto.UserDto;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Asset;
import model.Room;
import model.TransferOrder;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "TransferAdd2", urlPatterns = {"/transfer/addstep2"})
public class TransferAdd2 extends HttpServlet {

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
            out.println("<title>Servlet TransferAdd2</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TransferAdd2 at " + request.getContextPath() + "</h1>");
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

        Integer srcRoomId = null;
        Integer destRoomId = null;

        String srcParam = request.getParameter("sourceRoom");
        String destParam = request.getParameter("destinationRoom");

        if (srcParam != null && !srcParam.isEmpty()) {
            srcRoomId = Integer.parseInt(srcParam);
            session.setAttribute("srcRoomId", srcRoomId);
        }

        if (destParam != null && !destParam.isEmpty()) {
            destRoomId = Integer.parseInt(destParam);
            session.setAttribute("destRoomId", destRoomId);
        }
        RoomDao rDao = new RoomDao();
        List<Room> rooms = rDao.getAll();
        request.setAttribute("rooms", rooms);
        if (srcRoomId != null) {
            AssetDao aDao = new AssetDao();
            List<Asset> assets = aDao.getByRoomId(srcRoomId);
            request.setAttribute("assets", assets);
        }
        request.getRequestDispatcher("/views/tranfer/transfer-add-step1.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        String[] assetIds = request.getParameterValues("assetIds");
        List<Integer> selectedAssetIds = new ArrayList<>();
        if (assetIds != null) {
            for (String id : assetIds) {
                selectedAssetIds.add(Integer.parseInt(id));
            }
        }
        TransferDao tDao = new TransferDao();
        AssetDao aDao = new AssetDao();
        TransferOrder t = new TransferOrder();

        System.out.println("Selected assets: " + selectedAssetIds);

        UserDto u = (UserDto) session.getAttribute("user");

        Integer src = (Integer) session.getAttribute("srcRoomId");
        Integer dest = (Integer) session.getAttribute("destRoomId");
        String note = request.getParameter("note");

        if (u == null || src == null || dest == null || selectedAssetIds.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/transfer/add");
            return;
        }

        List<Asset> selectedAssetList = new ArrayList<>();
        for (int id : selectedAssetIds) {
            Asset a = aDao.getById(id);
            selectedAssetList.add(a);
        }
        t.setCreatedBy(u.getUserId());
        t.setDestRoomId(dest);
        t.setSourceRoomId(src);
        t.setNote(note);
        try {
            int i = tDao.createTransfer(t, selectedAssetList);
        } catch (Exception ex) {
            Logger.getLogger(TransferAdd2.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect(request.getContextPath() + "/transfer/list");
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
