package controller.asset;

import dal.AssetDAO;
import model.Asset;
import model.AssetImage;
import model.Category;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * Controller xử lý các nghiệp vụ liên quan đến Tài sản (Asset).
 * UC05: Thêm mới → GET /asset/create, POST /asset/create
 * UC06: Danh sách → GET /asset/list
 * UC07: Chi tiết → GET /asset/detail
 * UC08: Cập nhật → GET /asset/update, POST /asset/update
 * UC09: Cập nhật trạng thái → POST /asset/status
 * UC10: Thanh lý → POST /asset/delete
 * Ảnh: Xóa ảnh → POST /asset/deleteImage
 *
 * @author Vũ Quang Hiếu
 */
@WebServlet(name = "AssetController", urlPatterns = {
        "/asset/list",
        "/asset/detail",
        "/asset/create",
        "/asset/update",
        "/asset/status",
        "/asset/delete",
        "/asset/deleteImage"
})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024, // 5 MB / file
        maxRequestSize = 25 * 1024 * 1024 // 25 MB tổng
)
public class AssetController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    /** Thư mục lưu ảnh tài sản (tương đối so với webapp) */
    private static final String UPLOAD_DIR = "images" + File.separator + "assets";
    private final AssetDAO assetDao = new AssetDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/asset/list":
                doList(request, response);
                break;
            case "/asset/detail":
                doDetail(request, response);
                break;
            case "/asset/create":
                doCreateForm(request, response);
                break;
            case "/asset/update":
                doUpdateForm(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/asset/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        switch (path) {
            case "/asset/create":
                doCreate(request, response);
                break;
            case "/asset/update":
                doUpdate(request, response);
                break;
            case "/asset/status":
                doUpdateStatus(request, response);
                break;
            case "/asset/delete":
                doLiquidate(request, response);
                break;
            case "/asset/deleteImage":
                doDeleteImage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/asset/list");
        }
    }

    // UC06: Xem & tìm kiếm danh sách tài sản
    private void doList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy params filter
        String keyword = request.getParameter("keyword");
        if (keyword != null && keyword.trim().isEmpty())
            keyword = null;

        int categoryId = parseIntParam(request.getParameter("category"), 0);

        String status = request.getParameter("status");
        if (status != null && status.isEmpty())
            status = null;

        // Paging
        int page = parseIntParam(request.getParameter("page"), 1);
        if (page < 1)
            page = 1;

        // Query
        List<Asset> assets = assetDao.search(keyword, categoryId, status, page, PAGE_SIZE);
        int totalRecords = assetDao.countAssets(keyword, categoryId, status);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        // Dropdown data cho filter
        List<Category> categories = assetDao.getAllCategories();

        // Set attributes
        request.setAttribute("assets", assets);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("keyword", keyword);
        request.setAttribute("categoryFilter", categoryId);
        request.setAttribute("statusFilter", status);

        request.getRequestDispatcher("/views/asset/asset-list.jsp").forward(request, response);
    }

    // UC07: Xem chi tiết tài sản
    private void doDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseIntParam(request.getParameter("id"), 0);
        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/asset/list");
            return;
        }

        Asset asset = assetDao.getById(id);
        if (asset == null) {
            request.setAttribute("errorMsg", "Không tìm thấy tài sản có ID: " + id);
            doList(request, response);
            return;
        }

        // Lấy danh sách ảnh của tài sản
        List<AssetImage> images = assetDao.getImagesByAssetId(id);

        request.setAttribute("asset", asset);
        request.setAttribute("assetImages", images);
        request.getRequestDispatcher("/views/asset/asset-detail.jsp").forward(request, response);
    }

    // UC05: Hiển thị form thêm mới
    private void doCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        loadFormData(request);
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/views/asset/asset-form.jsp").forward(request, response);
    }

    // UC05: Xử lý POST thêm mới (bao gồm upload ảnh)
    private void doCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Asset asset = parseAssetFromRequest(request);

        int newId = assetDao.insertAsset(asset);
        if (newId > 0) {
            // Upload ảnh (nếu có)
            saveUploadedImages(request, newId);
            request.getSession().setAttribute("successMsg",
                    "Thêm tài sản thành công! Mã: " + asset.getAssetCode());
            response.sendRedirect(request.getContextPath() + "/asset/detail?id=" + newId);
        } else {
            request.setAttribute("errorMsg", "Thêm tài sản thất bại. Vui lòng thử lại.");
            loadFormData(request);
            request.setAttribute("asset", asset);
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/views/asset/asset-form.jsp").forward(request, response);
        }
    }

    // UC08: Hiển thị form cập nhật
    private void doUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseIntParam(request.getParameter("id"), 0);
        Asset asset = assetDao.getById(id);

        if (asset == null) {
            response.sendRedirect(request.getContextPath() + "/asset/list");
            return;
        }

        loadFormData(request);
        request.setAttribute("asset", asset);
        request.setAttribute("formAction", "update");

        // Lấy ảnh hiện tại để hiển thị trên form
        request.setAttribute("assetImages", assetDao.getImagesByAssetId(id));

        request.getRequestDispatcher("/views/asset/asset-form.jsp").forward(request, response);
    }

    // UC08: Xử lý POST cập nhật (bao gồm upload ảnh mới)
    private void doUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Asset asset = parseAssetFromRequest(request);
        asset.setAssetId(parseIntParam(request.getParameter("assetId"), 0));

        if (assetDao.updateAsset(asset)) {
            // Upload ảnh mới (nếu có)
            saveUploadedImages(request, asset.getAssetId());
            request.getSession().setAttribute("successMsg", "Cập nhật tài sản thành công!");
            response.sendRedirect(request.getContextPath() + "/asset/detail?id=" + asset.getAssetId());
        } else {
            request.setAttribute("errorMsg", "Cập nhật thất bại. Vui lòng thử lại.");
            loadFormData(request);
            request.setAttribute("asset", asset);
            request.setAttribute("formAction", "update");
            request.setAttribute("assetImages", assetDao.getImagesByAssetId(asset.getAssetId()));
            request.getRequestDispatcher("/views/asset/asset-form.jsp").forward(request, response);
        }
    }

    // UC09: Cập nhật trạng thái tài sản
    private void doUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseIntParam(request.getParameter("assetId"), 0);
        String newStatus = request.getParameter("status");

        if (id <= 0 || newStatus == null || newStatus.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/asset/list");
            return;
        }

        if (assetDao.updateStatus(id, newStatus)) {
            request.getSession().setAttribute("successMsg", "Cập nhật trạng thái thành công!");
        } else {
            request.getSession().setAttribute("errorMsg", "Cập nhật trạng thái thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/asset/detail?id=" + id);
    }

    // UC10: Thanh lý tài sản
    private void doLiquidate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseIntParam(request.getParameter("assetId"), 0);

        if (id > 0 && assetDao.liquidateAsset(id)) {
            request.getSession().setAttribute("successMsg", "Tài sản đã được đánh dấu thanh lý!");
        } else {
            request.getSession().setAttribute("errorMsg", "Thanh lý thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/asset/list");
    }

    // Xóa ảnh tài sản
    private void doDeleteImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int imageId = parseIntParam(request.getParameter("imageId"), 0);
        int assetId = parseIntParam(request.getParameter("assetId"), 0);

        if (imageId > 0) {
            // Lấy thông tin ảnh để xóa file vật lý
            AssetImage img = assetDao.getImageById(imageId);
            if (img != null) {
                // Xóa file trên server
                String uploadPath = getServletContext().getRealPath("") + File.separator + img.getImageUrl();
                File file = new File(uploadPath);
                if (file.exists())
                    file.delete();

                // Xóa record trong DB
                assetDao.deleteImage(imageId);
                request.getSession().setAttribute("successMsg", "Đã xóa ảnh thành công!");
            }
        }

        // Quay lại trang phù hợp
        if (assetId > 0) {
            response.sendRedirect(request.getContextPath() + "/asset/update?id=" + assetId);
        } else {
            response.sendRedirect(request.getContextPath() + "/asset/list");
        }
    }

    // Helper methods
    /** Load danh sách categories, suppliers, rooms cho form dropdown */
    private void loadFormData(HttpServletRequest request) {
        request.setAttribute("categories", assetDao.getAllCategories());
        request.setAttribute("suppliers", assetDao.getAllSuppliers());
        request.setAttribute("rooms", assetDao.getAllRooms());
    }

    /**
     * Xử lý upload nhiều file ảnh từ input name="assetImages".
     * Lưu file vào thư mục images/assets/ và insert record vào DB.
     */
    private void saveUploadedImages(HttpServletRequest request, int assetId) {
        try {
            // Đường dẫn thực tế trên server
            String realPath = getServletContext().getRealPath("")
                    + File.separator + UPLOAD_DIR;

            // Tạo thư mục nếu chưa có
            File uploadDir = new File(realPath);
            if (!uploadDir.exists())
                uploadDir.mkdirs();

            // Lấy tất cả Part có tên "assetImages"
            Collection<Part> fileParts = request.getParts();
            for (Part part : fileParts) {
                if (!"assetImages".equals(part.getName()))
                    continue;

                String fileName = getFileName(part);
                if (fileName == null || fileName.isEmpty())
                    continue;

                // Chỉ chấp nhận file ảnh
                String contentType = part.getContentType();
                if (contentType == null || !contentType.startsWith("image/"))
                    continue;

                // Tạo tên file unique: UUID + extension gốc
                String ext = fileName.substring(fileName.lastIndexOf("."));
                String uniqueName = UUID.randomUUID().toString() + ext;

                // Ghi file ra ổ đĩa
                String filePath = realPath + File.separator + uniqueName;
                part.write(filePath);

                // Lưu đường dẫn tương đối vào DB (dùng "/" cho URL web)
                String relativeUrl = UPLOAD_DIR.replace(File.separator, "/") + "/" + uniqueName;
                assetDao.insertImage(assetId, relativeUrl, null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** Lấy tên file gốc từ Part header */
    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null)
            return null;

        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // Lấy phần tên file cuối cùng (bỏ path nếu có)
                return Paths.get(name).getFileName().toString();
            }
        }
        return null;
    }

    /** Parse form data thành Asset object */
    private Asset parseAssetFromRequest(HttpServletRequest request) {
        Asset asset = new Asset();
        asset.setAssetName(request.getParameter("assetName"));
        asset.setCategoryId(parseIntParam(request.getParameter("categoryId"), 0));
        asset.setSupplierId(parseIntParam(request.getParameter("supplierId"), 0));
        asset.setRoomId(parseIntParam(request.getParameter("roomId"), 0));

        String priceStr = request.getParameter("price");
        if (priceStr != null && !priceStr.isEmpty()) {
            asset.setPrice(new BigDecimal(priceStr));
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            String pd = request.getParameter("purchaseDate");
            if (pd != null && !pd.isEmpty())
                asset.setPurchaseDate(sdf.parse(pd));

            String wd = request.getParameter("warrantyExpiryDate");
            if (wd != null && !wd.isEmpty())
                asset.setWarrantyExpiryDate(sdf.parse(wd));
        } catch (Exception e) {
            e.printStackTrace();
        }

        asset.setDescription(request.getParameter("description"));
        return asset;
    }

    /** Parse int an toàn, trả defaultValue nếu lỗi */
    private int parseIntParam(String param, int defaultValue) {
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
