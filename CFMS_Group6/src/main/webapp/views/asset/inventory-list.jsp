<%--
    Document   : inventory-list.jsp
    Description: UC13 - Inventory list by individual asset (Option 2)
    Author     : GPT (based on CFMS layout)

    Expected request attribute:
      - inventoryList: List<Asset> (model.Asset) or DTO with fields
            assetCode
            assetName
            category.categoryName
            room.roomName (nullable)
            status
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tồn kho tài sản - CFMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Global + component CSS -->
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/filter.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/badge.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/paging.css" rel="stylesheet">
    </head>

    <body class="d-flex flex-column">

        <jsp:include page="../components/header.jsp" />

        <div class="container-fluid flex-grow-1">
            <div class="row h-100">

                <jsp:include page="../components/sidebar.jsp">
                    <jsp:param name="page" value="inventory_check"/>
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                    <!-- ===== Page Header ===== -->
                    <div class="cfms-page-header">
                        <h2><i class="bi bi-box-seam me-2"></i>Danh sách tồn kho tài sản</h2>
                        <p class="text-muted small mb-0">
                            Mỗi dòng là một tài sản trong hệ thống, kèm trạng thái và vị trí hiện tại.
                        </p>
                    </div>

                    <!-- ===== Filter & Search Bar ===== -->
                    <form class="cfms-filter mb-3" method="get"
                          action="${pageContext.request.contextPath}/asset/inventory-check">

                        <!-- Search input -->
                        <div class="filter-search">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0">
                                    <i class="bi bi-search text-muted"></i>
                                </span>
                                <input type="text" name="keyword" class="form-control border-start-0"
                                       placeholder="Tìm theo mã, tên tài sản, loại, phòng, trạng thái..."
                                       value="${keyword}">
                            </div>
                        </div>

                        <!-- Status dropdown -->
                        <div class="filter-select">
                            <select name="status" class="form-select">
                                <option value="">-- Tất cả trạng thái --</option>
                                <option value="New" ${statusFilter == 'New' ? 'selected' : ''}>Mới (Trong kho)</option>
                                <option value="In_Use" ${statusFilter == 'In_Use' ? 'selected' : ''}>Đang sử dụng</option>
                                <option value="Maintenance" ${statusFilter == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                                <option value="Broken" ${statusFilter == 'Broken' ? 'selected' : ''}>Hỏng</option>
                                <option value="Lost" ${statusFilter == 'Lost' ? 'selected' : ''}>Thất lạc</option>
                                <option value="Liquidated" ${statusFilter == 'Liquidated' ? 'selected' : ''}>Thanh lý</option>
                            </select>
                        </div>

                        <!-- Action buttons -->
                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search me-1"></i>Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/asset/inventory-check"
                               class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa lọc
                            </a>
                        </div>
                    </form>

                    <!-- ===== Inventory Table (1 row = 1 asset) ===== -->
                    <div class="cfms-table-wrap">
                        <table class="cfms-table table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th class="col-no">#</th>
                                    <th>Hình ảnh</th>
                                    <th>Mã tài sản</th>
                                    <th>Tên tài sản</th>
                                    <th>Loại tài sản</th>
                                    <th>Vị trí hiện tại</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty inventoryList}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="cfms-table-empty">
                                                    <i class="bi bi-inbox"></i>
                                                    Chưa có tài sản nào trong hệ thống để hiển thị tồn kho.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${inventoryList}" var="inv" varStatus="loop">
                                            <tr>
                                                <td class="col-no">
                                                    ${loop.count}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty inv.images}">
                                                            <c:set var="firstImg" value="${inv.images[0]}"/>
                                                            <img src="${pageContext.request.contextPath}${firstImg.imageUrl}"
                                                                 alt="${firstImg.description}"
                                                                 class="img-thumbnail"
                                                                 style="width: 60px; height: 60px; object-fit: cover;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">
                                                                <i class="bi bi-image"></i> Không có ảnh
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <strong>${inv.assetCode}</strong>
                                                </td>
                                                <td>
                                                    ${inv.assetName}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty inv.category}">
                                                            ${inv.category.categoryName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">Không xác định</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty inv.room}">
                                                            ${inv.room.roomName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="cfms-badge cfms-badge-new"
                                                                  title="Tài sản đang ở kho trung tâm / chưa gán phòng">
                                                                Kho thiết bị / Chưa gán
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inv.status == 'New'}">
                                                            <span class="cfms-badge cfms-badge-new">Mới (Trong kho)</span>
                                                        </c:when>
                                                        <c:when test="${inv.status == 'In_Use'}">
                                                            <span class="cfms-badge cfms-badge-in-use">Đang sử dụng</span>
                                                        </c:when>
                                                        <c:when test="${inv.status == 'Maintenance'}">
                                                            <span class="cfms-badge cfms-badge-maintenance">Bảo trì</span>
                                                        </c:when>
                                                        <c:when test="${inv.status == 'Broken'}">
                                                            <span class="cfms-badge cfms-badge-broken">Hỏng</span>
                                                        </c:when>
                                                        <c:when test="${inv.status == 'Lost'}">
                                                            <span class="cfms-badge cfms-badge-lost">Thất lạc</span>
                                                        </c:when>
                                                        <c:when test="${inv.status == 'Liquidated'}">
                                                            <span class="cfms-badge cfms-badge-liquidated">Thanh lý</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="cfms-badge">${inv.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- ===== Pagination ===== -->
                    <c:if test="${totalPages > 0}">
                        <div class="cfms-paging">
                            <span class="paging-info">
                                Hiển thị trang <strong>${currentPage}</strong> / ${totalPages}
                                (${totalRecords} tài sản)
                            </span>

                            <c:if test="${totalPages > 1}">
                                <nav>
                                    <ul class="pagination">
                                        <!-- Previous -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/asset/inventory-check?page=${currentPage - 1}&status=${statusFilter}&keyword=${keyword}">
                                                &laquo;
                                            </a>
                                        </li>

                                        <!-- Page numbers -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                   href="${pageContext.request.contextPath}/asset/inventory-check?page=${i}&status=${statusFilter}&keyword=${keyword}">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:forEach>

                                        <!-- Next -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/asset/inventory-check?page=${currentPage + 1}&status=${statusFilter}&keyword=${keyword}">
                                                &raquo;
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </c:if>

                </main>

            </div>
        </div>

        <jsp:include page="../components/footer.jsp" />

    </body>
</html>

