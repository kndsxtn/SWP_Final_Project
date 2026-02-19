<%--
    Document   : procurement-list
    Description: Danh sách yêu cầu mua sắm (tương tự allocation-list)
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu mua sắm - CFMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

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
                <jsp:param name="page" value="procurement_list"/>
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                <!-- ===== Page Header ===== -->
                <div class="cfms-page-header d-flex justify-content-between align-items-center">
                    <h2><i class="bi bi-cart-plus me-2"></i>Yêu cầu mua sắm</h2>
                    <c:if test="${sessionScope.user.roleName == 'Asset Staff'}">
                        <a href="${pageContext.request.contextPath}/request/procurement-add"
                           class="btn btn-primary">
                            <i class="bi bi-plus-circle me-1"></i>Tạo mới
                        </a>
                    </c:if>
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
                      action="${pageContext.request.contextPath}/request/procurement-list">

                    <div class="filter-search">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="bi bi-search text-muted"></i>
                            </span>
                            <input type="text" name="keyword" class="form-control border-start-0"
                                   placeholder="Tìm theo mã yêu cầu, người tạo, tài sản, lý do..."
                                   value="${keyword}">
                        </div>
                    </div>

                    <div class="filter-select">
                        <select name="status" class="form-select">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                            <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Đã duyệt</option>
                            <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            <option value="Cancelled" ${statusFilter == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                            <option value="Completed" ${statusFilter == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                        </select>
                    </div>

                    <div class="filter-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/request/procurement-list"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa lọc
                        </a>
                    </div>
                </form>

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
                                <th class="text-center">Tổng số lượng</th>
                                <th>Tài sản & Số lượng</th>
                                <th>Loại tài sản</th>
                                <th>Liên kết cấp phát</th>
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
                                                <i class="bi bi-cart-x"></i>
                                                <c:choose>
                                                    <c:when test="${not empty keyword || not empty statusFilter}">
                                                        Không tìm thấy yêu cầu mua sắm phù hợp.
                                                    </c:when>
                                                    <c:otherwise>
                                                        Không có yêu cầu mua sắm nào.
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${list}" var="proc" varStatus="loop">
                                        <tr>
                                            <td class="col-no">
                                                ${(currentPage - 1) * pageSize + loop.count}
                                            </td>

                                            <td>
                                                <strong>PROC-${proc.procurementId}</strong>
                                            </td>

                                            <td>${proc.creator.fullName}</td>

                                            <td>
                                                <fmt:formatDate value="${proc.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>

                                            <td class="text-center">
                                                <c:set var="totalQty" value="0" />
                                                <c:forEach items="${proc.details}" var="d">
                                                    <c:set var="totalQty" value="${totalQty + d.quantity}" />
                                                </c:forEach>
                                                <span class="badge bg-primary" style="font-size: 0.85rem; padding: 0.35rem 0.6rem;">
                                                    <i class="bi bi-box-seam me-1"></i>${totalQty}
                                                </span>
                                            </td>

                                            <td>
                                                <c:forEach items="${proc.details}" var="d">
                                                    <div class="d-flex align-items-center mb-1" style="gap: 0.5rem;">
                                                        <span class="small flex-grow-1">
                                                            <strong>${d.asset.assetCode}</strong> – ${d.asset.assetName}
                                                        </span>
                                                        <span class="badge bg-secondary" style="font-size: 0.7rem; padding: 0.25rem 0.5rem; min-width: 2.5rem;">
                                                            <i class="bi bi-hash me-1"></i>${d.quantity}
                                                        </span>
                                                    </div>
                                                </c:forEach>
                                            </td>

                                            <td>
                                                <c:forEach items="${proc.details}" var="d">
                                                    <span class="d-block small">${d.asset.category.categoryName}</span>
                                                </c:forEach>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${proc.allocationRequestId != null}">
                                                        <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${proc.allocationRequestId}"
                                                           class="badge bg-info text-decoration-none" style="font-size: 0.75rem;">
                                                            REQ-${proc.allocationRequestId}
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted small">–</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${proc.status == 'Pending'}">
                                                        <span class="cfms-badge cfms-badge-pending">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${proc.status == 'Approved'}">
                                                        <span class="cfms-badge cfms-badge-approved">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${proc.status == 'Rejected'}">
                                                        <span class="d-inline-flex align-items-center">
                                                            <span class="cfms-badge cfms-badge-rejected">Từ chối</span>
                                                            <c:if test="${not empty proc.reasonReject}">
                                                                <i class="bi bi-info-circle text-danger ms-1" data-bs-toggle="tooltip" title="${proc.reasonReject}"></i>
                                                            </c:if>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${proc.status == 'Cancelled'}">
                                                        <span class="cfms-badge cfms-badge-rejected">Đã hủy</span>
                                                    </c:when>
                                                    <c:when test="${proc.status == 'Completed'}">
                                                        <span class="cfms-badge cfms-badge-completed">Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="cfms-badge">${proc.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="col-action">
                                                <a href="${pageContext.request.contextPath}/request/procurement-detail?id=${proc.procurementId}"
                                                   class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <%-- Asset Staff: Edit + Cancel (chỉ khi Pending và là người tạo) --%>
                                                <c:if test="${proc.status == 'Pending' && sessionScope.user.roleName == 'Asset Staff' && proc.createdBy == sessionScope.user.userId}">
                                                    <a href="${pageContext.request.contextPath}/request/procurement-edit?id=${proc.procurementId}"
                                                       class="btn btn-sm btn-outline-warning ms-1" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <form method="post" action="${pageContext.request.contextPath}/request/procurement-cancel" class="d-inline ms-1">
                                                        <input type="hidden" name="id" value="${proc.procurementId}">
                                                        <button type="button" class="btn btn-sm btn-outline-danger" title="Hủy yêu cầu"
                                                                onclick="(function(f){ CFMS_CONFIRM({ title: 'Xác nhận hủy', message: 'Bạn có chắc muốn hủy yêu cầu mua sắm PROC-${proc.procurementId}?', danger: true, onConfirm: function() { f.submit(); } }); })(this.closest('form'));">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <%-- Hiệu trưởng / Trưởng phòng TC-KT: Approve + Reject (khi Pending) --%>
                                                <c:if test="${proc.status == 'Pending' && (sessionScope.user.roleName == 'Principal' || sessionScope.user.roleName == 'Finance Head')}">
                                                    <form method="post" action="${pageContext.request.contextPath}/request/procurement-approve" class="d-inline ms-1">
                                                        <input type="hidden" name="id" value="${proc.procurementId}">
                                                        <button type="button" class="btn btn-sm btn-outline-success" title="Phê duyệt"
                                                                onclick="(function(f){ CFMS_CONFIRM({ title: 'Xác nhận phê duyệt', message: 'Bạn có chắc muốn phê duyệt yêu cầu mua sắm PROC-${proc.procurementId}?', danger: false, onConfirm: function() { f.submit(); } }); })(this.closest('form'));">
                                                            <i class="bi bi-check-circle"></i>
                                                        </button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/request/procurement-reject" class="d-inline ms-1">
                                                        <input type="hidden" name="id" value="${proc.procurementId}">
                                                        <input type="hidden" name="reason" value="">
                                                        <button type="button" class="btn btn-sm btn-outline-danger" title="Từ chối"
                                                                onclick="(function(f){ CFMS_CONFIRM({ title: 'Từ chối yêu cầu', message: 'Nhập lý do từ chối cho yêu cầu mua sắm PROC-${proc.procurementId}:', danger: true, requireReason: true, reasonLabel: 'Lý do từ chối', reasonPlaceholder: 'Nhập lý do từ chối...', onConfirm: function(reasonText) { f.querySelector('input[name=reason]').value = reasonText; f.submit(); } }); })(this.closest('form'));">
                                                            <i class="bi bi-x-circle"></i>
                                                        </button>
                                                    </form>
                                                </c:if>
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
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/request/procurement-list?page=${currentPage - 1}${queryParams}">
                                            &laquo;
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/request/procurement-list?page=${i}${queryParams}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/request/procurement-list?page=${currentPage + 1}${queryParams}">
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
    <jsp:include page="../components/confirm-modal.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (el) {
                new bootstrap.Tooltip(el);
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>

</body>
</html>
