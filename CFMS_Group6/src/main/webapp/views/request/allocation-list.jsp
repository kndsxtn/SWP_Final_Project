<%--
    Document   : allocation-list.jsp
    Description: UC12 - View list of asset allocation requests
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu cấp phát - CFMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Global + component CSS -->
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
                <jsp:param name="page" value="allocation_list"/>
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                <!-- ===== Page Header ===== -->
                <div class="cfms-page-header">
                    <h2><i class="bi bi-inbox me-2"></i>Yêu cầu cấp phát tài sản</h2>
                </div>

                <!-- ===== Success / Error messages ===== -->
                <c:if test="${not empty successMsg}">
                    <div class="cfms-msg cfms-msg-success">
                        <i class="bi bi-check-circle-fill"></i> ${successMsg}
                    </div>
                </c:if>
                <c:if test="${not empty errorMsg}">
                    <div class="cfms-msg cfms-msg-error">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
                    </div>
                </c:if>

                <!-- ===== Filter & Search Bar ===== -->
                <form class="cfms-filter" method="get"
                      action="${pageContext.request.contextPath}/request/allocation-list">

                    <!-- Search input -->
                    <div class="filter-search">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="bi bi-search text-muted"></i>
                            </span>
                            <input type="text" name="keyword" class="form-control border-start-0"
                                   placeholder="Tìm theo mã yêu cầu, người tạo, tài sản, loại tài sản, ghi chú..."
                                   value="${keyword}">
                        </div>
                    </div>

                    <!-- Status dropdown -->
                    <div class="filter-select">
                        <select name="status" class="form-select">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="Pending"
                                ${statusFilter == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                            <option value="Approved_By_Staff"
                                ${statusFilter == 'Approved_By_Staff' ? 'selected' : ''}>Đã duyệt (NV Thiết bị)</option>
                            <option value="Approved_By_VP"
                                ${statusFilter == 'Approved_By_VP' ? 'selected' : ''}>Đã duyệt (Phó HT)</option>
                            <option value="Approved_By_Principal"
                                ${statusFilter == 'Approved_By_Principal' ? 'selected' : ''}>Đã duyệt (Hiệu trưởng)</option>
                            <option value="Rejected"
                                ${statusFilter == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            <option value="Completed"
                                ${statusFilter == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        </select>
                    </div>

                    <!-- Action buttons -->
                    <div class="filter-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/request/allocation-list"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa lọc
                        </a>
                    </div>
                </form>

                <!-- Build query string for pagination links (preserves search + filter) -->
                <c:set var="queryParams" value="" />
                <c:if test="${not empty statusFilter}">
                    <c:set var="queryParams" value="${queryParams}&status=${statusFilter}" />
                </c:if>
                <c:if test="${not empty keyword}">
                    <c:set var="queryParams" value="${queryParams}&keyword=${keyword}" />
                </c:if>

                <!-- ===== Data Table ===== -->
                <div class="cfms-table-wrap">
                    <table class="cfms-table table table-hover mb-0">
                        <thead>
                            <tr>
                                <th class="col-no">#</th>
                                <th>Mã yêu cầu</th>
                                <th>Người tạo</th>
                                <th>Ngày tạo</th>
                                <th>Số lượng</th>
                                <th>Tài sản</th>
                                <th>Loại tài sản</th>
                                <th>Ghi chú</th>
                                <th>Trạng thái</th>
                                <th class="col-action">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="10">
                                            <div class="cfms-table-empty">
                                                <i class="bi bi-inbox"></i>
                                                <c:choose>
                                                    <c:when test="${not empty keyword || not empty statusFilter}">
                                                        Không tìm thấy yêu cầu phù hợp.
                                                    </c:when>
                                                    <c:otherwise>
                                                        Không có yêu cầu cấp phát nào.
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${list}" var="req" varStatus="loop">
                                        <tr>
                                            <!-- Row number -->
                                            <td class="col-no">
                                                ${(currentPage - 1) * pageSize + loop.count}
                                            </td>

                                            <!-- Request ID -->
                                            <td>
                                                <strong>REQ-${req.requestId}</strong>
                                            </td>

                                            <!-- Creator -->
                                            <td>${req.creator.fullName}</td>

                                            <!-- Date -->
                                            <td>
                                                <fmt:formatDate value="${req.createdDate}"
                                                                pattern="dd/MM/yyyy HH:mm"/>
                                            </td>

                                            <!-- Quantity (number of assets in this request) -->
                                            <td class="text-center">
                                                <strong>${req.details.size()}</strong>
                                            </td>

                                            <!-- Assets -->
                                            <td>
                                                <c:forEach items="${req.details}" var="d">
                                                    <span class="d-block small">
                                                        <strong>${d.asset.assetCode}</strong> – ${d.asset.assetName}
                                                    </span>
                                                </c:forEach>
                                            </td>

                                            <!-- Categories -->
                                            <td>
                                                <c:forEach items="${req.details}" var="d">
                                                    <span class="d-block small">${d.asset.category.categoryName}</span>
                                                </c:forEach>
                                            </td>

                                            <!-- Notes -->
                                            <td>
                                                <c:forEach items="${req.details}" var="d">
                                                    <span class="d-block small text-muted">
                                                        <c:choose>
                                                            <c:when test="${not empty d.note}">${d.note}</c:when>
                                                            <c:otherwise>–</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </c:forEach>
                                            </td>

                                            <!-- Status badge -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${req.status == 'Pending'}">
                                                        <span class="cfms-badge cfms-badge-pending">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Approved_By_Staff'}">
                                                        <span class="cfms-badge cfms-badge-in-progress">Đã duyệt (NV TB)</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Approved_By_VP'}">
                                                        <span class="cfms-badge cfms-badge-approved">Đã duyệt (Phó HT)</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Approved_By_Principal'}">
                                                        <span class="cfms-badge cfms-badge-approved">Đã duyệt (HT)</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Rejected'}">
                                                        <span class="cfms-badge cfms-badge-rejected">Từ chối</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Completed'}">
                                                        <span class="cfms-badge cfms-badge-completed">Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="cfms-badge">${req.status}</span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Rejection reason tooltip -->
                                                <c:if test="${req.status == 'Rejected' && not empty req.reasonReject}">
                                                    <i class="bi bi-info-circle text-danger ms-1"
                                                       data-bs-toggle="tooltip"
                                                       title="${req.reasonReject}"></i>
                                                </c:if>
                                            </td>

                                            <!-- Actions -->
                                            <td class="col-action">
                                                <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${req.requestId}"
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
                            (${totalRecords} yêu cầu)
                        </span>

                        <c:if test="${totalPages > 1}">
                            <nav>
                                <ul class="pagination">
                                    <!-- Previous -->
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/request/allocation-list?page=${currentPage - 1}${queryParams}">
                                            &laquo;
                                        </a>
                                    </li>

                                    <!-- Page numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/request/allocation-list?page=${i}${queryParams}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <!-- Next -->
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/request/allocation-list?page=${currentPage + 1}${queryParams}">
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

    <!-- Tooltip init -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var tooltipTriggerList = [].slice.call(
                document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (el) {
                new bootstrap.Tooltip(el);
            });
        });
    </script>

</body>
</html>
