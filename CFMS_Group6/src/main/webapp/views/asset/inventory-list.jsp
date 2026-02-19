<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kiểm tra tồn kho tài sản - CFMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Global + component CSS -->
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/filter.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/badge.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/paging.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/inventory.css" rel="stylesheet">
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
                        <h2><i class="bi bi-box-seam me-2"></i>Kiểm tra tồn kho tài sản</h2>
                        <p class="text-muted small mb-0">
                            Xem tài sản nào đang có sẵn trong kho để đáp ứng yêu cầu cấp phát. Dùng bộ lọc bên dưới để nhanh chóng xem <strong>tài sản khả dụng</strong> (có thể cấp phát).
                        </p>
                    </div>

                    <div class="inventory-summary">
                        <c:set var="totalAll" value="0"/>
                        <c:forEach items="${statusCounts}" var="entry">
                            <c:set var="totalAll" value="${totalAll + entry.value}"/>
                        </c:forEach>
                        <a href="${pageContext.request.contextPath}/asset/inventory-check" class="inv-card text-decoration-none text-dark">
                            <span class="inv-num">${totalAll}</span>
                            <span class="inv-label">Tổng tài sản</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/asset/inventory-check?status=New" class="inv-card available text-decoration-none text-dark">
                            <span class="inv-num">${statusCounts['New'] != null ? statusCounts['New'] : 0}</span>
                            <span class="inv-label">Khả dụng (có thể cấp phát)</span>
                        </a>
                        <span class="inv-card">
                            <span class="inv-num">${statusCounts['In_Use'] != null ? statusCounts['In_Use'] : 0}</span>
                            <span class="inv-label">Đang sử dụng</span>
                        </span>
                        <span class="inv-card">
                            <span class="inv-num">${statusCounts['Maintenance'] != null ? statusCounts['Maintenance'] : 0}</span>
                            <span class="inv-label">Bảo trì</span>
                        </span>
                        <span class="inv-card">
                            <span class="inv-num">${statusCounts['Broken'] != null ? statusCounts['Broken'] : 0}</span>
                            <span class="inv-label">Hỏng</span>
                        </span>
                        <span class="inv-card">
                            <span class="inv-num">${statusCounts['Lost'] != null ? statusCounts['Lost'] : 0}</span>
                            <span class="inv-label">Thất lạc</span>
                        </span>
                        <span class="inv-card">
                            <span class="inv-num">${statusCounts['Liquidated'] != null ? statusCounts['Liquidated'] : 0}</span>
                            <span class="inv-label">Thanh lý</span>
                        </span>
                    </div>

                    <!-- Quick filter: show only available -->
                    <div class="inv-quick-filter">
                        <c:if test="${statusFilter != 'New'}">
                            <a href="${pageContext.request.contextPath}/asset/inventory-check?status=New" class="btn btn-sm btn-outline-success">
                                <i class="bi bi-check-circle me-1"></i>Chỉ xem tài sản khả dụng (có thể cấp phát)
                            </a>
                        </c:if>
                        <c:if test="${statusFilter == 'New'}">
                            <span class="badge bg-success">Đang lọc: Chỉ tài sản khả dụng</span>
                            <a href="${pageContext.request.contextPath}/asset/inventory-check" class="btn btn-sm btn-link">Xem tất cả</a>
                        </c:if>
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
                                <option value="New" ${statusFilter == 'New' ? 'selected' : ''}>Khả dụng</option>
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
                                    <th>Số lượng</th>
                                    <th>Trạng thái</th>
                                    <th>Có thể cấp phát?</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty inventoryList}">
                                        <tr>
                                            <td colspan="9">
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
                                                            <img src="${pageContext.request.contextPath}/${firstImg.imageUrl}"
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
                                                <td class="text-center">
                                                    <strong>${inv.quantity}</strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inv.status == 'New'}">
                                                            <span class="cfms-badge cfms-badge-new">Khả dụng</span>
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
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inv.status == 'New'}">
                                                            <span class="cfms-badge cfms-badge-stock-full" title="Tài sản có sẵn trong kho, có thể cấp phát">
                                                                <i class="bi bi-check-circle me-1"></i>Có thể cấp phát
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="cfms-badge cfms-badge-stock-none" title="Đang sử dụng / bảo trì / hỏng / thất lạc / thanh lý">
                                                                Không thể cấp phát
                                                            </span>
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

