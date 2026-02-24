<%-- Document : asset-list.jsp Description: UC06 - Xem và tìm kiếm danh sách tài sản Author : Vũ Quang Hiếu --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Danh sách tài sản - CFMS</title>

                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

                    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/filter.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/badge.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/paging.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
                </head>

                <body class="d-flex flex-column">

                    <jsp:include page="../components/header.jsp" />

                    <div class="container-fluid flex-grow-1">
                        <div class="row h-100">

                            <jsp:include page="../components/sidebar.jsp">
                                <jsp:param name="page" value="asset_list" />
                            </jsp:include>

                            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                                <!-- ===== Page Header ===== -->
                                <div class="cfms-page-header d-flex justify-content-between align-items-center">
                                    <h2><i class="bi bi-pc-display-horizontal me-2"></i>Danh sách tài sản</h2>
                                    <c:if test="${sessionScope.user.roleName == 'Asset Staff'}">
                                        <a href="${pageContext.request.contextPath}/asset/create"
                                            class="btn btn-primary">
                                            <i class="bi bi-plus-lg me-1"></i>Thêm tài sản
                                        </a>
                                    </c:if>
                                </div>

                                <!-- ===== Success / Error messages ===== -->
                                <c:if test="${not empty sessionScope.successMsg}">
                                    <div class="cfms-msg cfms-msg-success">
                                        <i class="bi bi-check-circle-fill"></i> ${sessionScope.successMsg}
                                    </div>
                                    <c:remove var="successMsg" scope="session" />
                                </c:if>
                                <c:if test="${not empty errorMsg}">
                                    <div class="cfms-msg cfms-msg-error">
                                        <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
                                    </div>
                                </c:if>

                                <!-- ===== Filter & Search Bar ===== -->
                                <form class="cfms-filter" method="get"
                                    action="${pageContext.request.contextPath}/asset/list">

                                    <!-- Search -->
                                    <div class="filter-search">
                                        <div class="input-group">
                                            <span class="input-group-text bg-white border-end-0">
                                                <i class="bi bi-search text-muted"></i>
                                            </span>
                                            <input type="text" name="keyword" class="form-control border-start-0"
                                                placeholder="Tìm theo mã, tên, mô tả tài sản..." value="${keyword}">
                                        </div>
                                    </div>

                                    <!-- Category filter -->
                                    <div class="filter-select">
                                        <select name="category" class="form-select">
                                            <option value="">-- Tất cả danh mục --</option>
                                            <c:forEach items="${categories}" var="cat">
                                                <option value="${cat.categoryId}" ${categoryFilter==cat.categoryId
                                                    ? 'selected' : '' }>
                                                    ${cat.categoryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <!-- Status filter -->
                                    <div class="filter-select">
                                        <select name="status" class="form-select">
                                            <option value="">-- Tất cả trạng thái --</option>
                                            <option value="New" ${statusFilter=='New' ? 'selected' : '' }>Mới</option>
                                            <option value="In_Use" ${statusFilter=='In_Use' ? 'selected' : '' }>Đang sử
                                                dụng</option>
                                            <option value="Maintenance" ${statusFilter=='Maintenance' ? 'selected' : ''
                                                }>Bảo trì</option>
                                            <option value="Broken" ${statusFilter=='Broken' ? 'selected' : '' }>Hỏng
                                            </option>
                                            <option value="Liquidated" ${statusFilter=='Liquidated' ? 'selected' : '' }>
                                                Thanh lý</option>
                                            <option value="Lost" ${statusFilter=='Lost' ? 'selected' : '' }>Thất lạc
                                            </option>
                                        </select>
                                    </div>

                                    <!-- Action buttons -->
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-search me-1"></i>Tìm kiếm
                                        </button>
                                        <a href="${pageContext.request.contextPath}/asset/list"
                                            class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa lọc
                                        </a>
                                    </div>
                                </form>

                                <!-- Build query string cho pagination -->
                                <c:set var="queryParams" value="" />
                                <c:if test="${not empty keyword}">
                                    <c:set var="queryParams" value="${queryParams}&keyword=${keyword}" />
                                </c:if>
                                <c:if test="${categoryFilter > 0}">
                                    <c:set var="queryParams" value="${queryParams}&category=${categoryFilter}" />
                                </c:if>
                                <c:if test="${not empty statusFilter}">
                                    <c:set var="queryParams" value="${queryParams}&status=${statusFilter}" />
                                </c:if>

                                <!-- ===== Data Table ===== -->
                                <div class="cfms-table-wrap">
                                    <table class="cfms-table table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th class="col-no">#</th>
                                                <th>Mã tài sản</th>
                                                <th>Tên tài sản</th>
                                                <th>Danh mục</th>
                                                <th>Vị trí</th>
                                                <th>Giá trị</th>
                                                <th>Trạng thái</th>
                                                <th class="col-action">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty assets}">
                                                    <tr>
                                                        <td colspan="8">
                                                            <div class="cfms-table-empty">
                                                                <i class="bi bi-inbox"></i>
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty keyword || categoryFilter > 0 || not empty statusFilter}">
                                                                        Không tìm thấy tài sản phù hợp.
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Chưa có tài sản nào trong hệ thống.
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach items="${assets}" var="a" varStatus="loop">
                                                        <tr>
                                                            <td class="col-no">
                                                                ${(currentPage - 1) * pageSize + loop.count}
                                                            </td>
                                                            <td><strong>${a.assetCode}</strong></td>
                                                            <td>${a.assetName}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${a.category != null}">
                                                                        ${a.category.categoryName}</c:when>
                                                                    <c:otherwise>–</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${a.room != null}">${a.room.roomName}
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">Kho</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatNumber value="${a.price}" type="number"
                                                                    groupingUsed="true" />₫
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${a.status == 'New'}">
                                                                        <span
                                                                            class="cfms-badge cfms-badge-pending">Mới</span>
                                                                    </c:when>
                                                                    <c:when test="${a.status == 'In_Use'}">
                                                                        <span
                                                                            class="cfms-badge cfms-badge-approved">Đang
                                                                            sử dụng</span>
                                                                    </c:when>
                                                                    <c:when test="${a.status == 'Maintenance'}">
                                                                        <span
                                                                            class="cfms-badge cfms-badge-in-progress">Bảo
                                                                            trì</span>
                                                                    </c:when>
                                                                    <c:when test="${a.status == 'Broken'}">
                                                                        <span
                                                                            class="cfms-badge cfms-badge-rejected">Hỏng</span>
                                                                    </c:when>
                                                                    <c:when test="${a.status == 'Liquidated'}">
                                                                        <span
                                                                            class="cfms-badge cfms-badge-completed">Thanh
                                                                            lý</span>
                                                                    </c:when>
                                                                    <c:when test="${a.status == 'Lost'}">
                                                                        <span
                                                                            class="cfms-badge cfms-badge-rejected">Thất
                                                                            lạc</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="cfms-badge">${a.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="col-action">
                                                                <a href="${pageContext.request.contextPath}/asset/detail?id=${a.assetId}"
                                                                    class="btn btn-sm btn-outline-primary"
                                                                    title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
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
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/asset/list?page=${currentPage - 1}${queryParams}">
                                                            &laquo;
                                                        </a>
                                                    </li>

                                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/asset/list?page=${i}${queryParams}">
                                                                ${i}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <li
                                                        class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="${pageContext.request.contextPath}/asset/list?page=${currentPage + 1}${queryParams}">
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