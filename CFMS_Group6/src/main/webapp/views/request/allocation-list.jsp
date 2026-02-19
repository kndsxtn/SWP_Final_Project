<%--
    Document   : allocation-list.jsp
    Description: UC12 - View list of asset allocation requests
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

                <c:set var="isHeadOfDept" value="${sessionScope.user.roleName == 'Head of Dept'}"/>

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
                                <th class="text-center">Tổng số lượng</th>
                                <th>Tài sản & Số lượng</th>
                                <th>Loại tài sản</th>
                                <c:if test="${!isHeadOfDept}">
                                    <th>Tồn kho</th>
                                </c:if>
                                <th>Trạng thái</th>
                                <th class="col-action">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="${isHeadOfDept ? 9 : 10}">
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

                                            <!-- Total Quantity (sum of all assets in this request) -->
                                            <td class="text-center">
                                                <c:set var="totalQty" value="0" />
                                                <c:forEach items="${req.details}" var="d">
                                                    <c:set var="totalQty" value="${totalQty + d.quantity}" />
                                                </c:forEach>
                                                <span class="badge bg-primary" style="font-size: 0.85rem; padding: 0.35rem 0.6rem;">
                                                    <i class="bi bi-box-seam me-1"></i>${totalQty}
                                                </span>
                                            </td>

                                            <!-- Assets with Quantity -->
                                            <td>
                                                <c:forEach items="${req.details}" var="d">
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

                                            <!-- Categories -->
                                            <td>
                                                <c:forEach items="${req.details}" var="d">
                                                    <span class="d-block small">${d.asset.category.categoryName}</span>
                                                </c:forEach>
                                            </td>

                                            <!-- Stock status (UC13) - hiển thị theo từng tài sản: tên + (có sẵn/yêu cầu) -->
                                            <c:if test="${!isHeadOfDept}">
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${req.status == 'Pending'}">
                                                            <c:forEach items="${req.details}" var="d">
                                                                <div class="d-flex align-items-center mb-1" style="gap: 0.35rem;">
                                                                    <span class="small flex-grow-1 text-nowrap" style="max-width: 120px; overflow: hidden; text-overflow: ellipsis;" title="${d.asset.assetCode} – ${d.asset.assetName}">
                                                                        <strong>${d.asset.assetCode}</strong> – ${d.asset.assetName}
                                                                    </span>
                                                                    <c:choose>
                                                                        <c:when test="${d.availableInStock >= d.quantity}">
                                                                            <span class="badge bg-success" style="font-size: 0.7rem; padding: 0.2rem 0.4rem;" title="Đủ: ${d.availableInStock}/${d.quantity}">${d.availableInStock}/${d.quantity}</span>
                                                                        </c:when>
                                                                        <c:when test="${d.availableInStock > 0}">
                                                                            <span class="badge bg-warning text-dark" style="font-size: 0.7rem; padding: 0.2rem 0.4rem;" title="Thiếu: ${d.availableInStock}/${d.quantity}">${d.availableInStock}/${d.quantity}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-danger" style="font-size: 0.7rem; padding: 0.2rem 0.4rem;" title="Hết: 0/${d.quantity}">0/${d.quantity}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted small">Không áp dụng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </c:if>

                                            <!-- Status badge -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${req.status == 'Pending'}">
                                                        <span class="cfms-badge cfms-badge-pending">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Approved_By_Staff' || req.status == 'Approved_By_VP' || req.status == 'Approved_By_Principal'}">
                                                        <span class="cfms-badge cfms-badge-approved">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Rejected'}">
                                                        <span class="d-inline-flex align-items-center">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(req.reasonReject, '[CANCELLED]')}">
                                                                    <span class="cfms-badge cfms-badge-rejected">Đã hủy</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="cfms-badge cfms-badge-rejected">Từ chối</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <c:if test="${not empty req.reasonReject}">
                                                                <i class="bi bi-info-circle text-danger ms-1"
                                                                   data-bs-toggle="tooltip"
                                                                   title="${req.reasonReject}"></i>
                                                            </c:if>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${req.status == 'Completed'}">
                                                        <span class="cfms-badge cfms-badge-completed">Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="cfms-badge">${req.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <!-- Actions -->
                                            <td class="col-action">
                                                <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${req.requestId}"
                                                   class="btn btn-sm btn-outline-primary"
                                                   title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>

                                                <!-- Approve / Reject for Asset Staff -->
                                                <c:if test="${req.status == 'Pending' && sessionScope.user.roleName == 'Asset Staff'}">
                                                    <button type="button"
                                                            class="btn btn-sm btn-success ms-1 btn-alloc-approve"
                                                            data-req-id="${req.requestId}"
                                                            data-stock-status="${req.stockStatus}"
                                                            data-total="${req.totalRequestedAssets}"
                                                            data-available="${req.totalAvailableInStock}"
                                                            title="Phê duyệt yêu cầu">
                                                        <i class="bi bi-check2-circle"></i>
                                                    </button>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-danger ms-1 btn-alloc-reject"
                                                            data-req-id="${req.requestId}"
                                                            title="Từ chối yêu cầu">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </c:if>

                                                <!-- Edit and Cancel for Head of Dept (creator) when Pending -->
                                                <c:if test="${req.status == 'Pending' && sessionScope.user.roleName == 'Head of Dept' && req.createdBy == sessionScope.user.userId}">
                                                    <a href="${pageContext.request.contextPath}/request/allocation-edit?id=${req.requestId}"
                                                       class="btn btn-sm btn-outline-warning ms-1"
                                                       title="Chỉnh sửa yêu cầu">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-danger ms-1 btn-alloc-cancel"
                                                            data-req-id="${req.requestId}"
                                                            title="Hủy yêu cầu này">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Hidden form for approve/reject actions from list -->
                <form id="allocationListActionForm" method="post"
                      action="${pageContext.request.contextPath}/request/approve" class="d-none">
                    <input type="hidden" name="id" id="listActionRequestId">
                    <input type="hidden" name="action" id="listActionType">
                    <input type="hidden" name="reasonReject" id="listActionReason">
                </form>

                <!-- Hidden form for cancel (Head of Dept) -->
                <form id="allocationCancelForm" method="post"
                      action="${pageContext.request.contextPath}/request/cancel" class="d-none">
                    <input type="hidden" name="id" id="cancelRequestId">
                </form>

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

    <!-- Reusable confirmation modal for list actions -->
    <jsp:include page="../components/confirm-modal.jsp" />

    <!-- Tooltip + Approve/Reject from list -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Tooltip init
            var tooltipTriggerList = [].slice.call(
                    document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (el) {
                new bootstrap.Tooltip(el);
            });

            // // Auto-hide flash messages after 3s
            // setTimeout(function () {
            //     document.querySelectorAll('.cfms-msg').forEach(function (el) {
            //         el.style.transition = 'opacity 0.3s';
            //         el.style.opacity = '0';
            //         setTimeout(function () {
            //             el.style.display = 'none';
            //         }, 300);
            //     });
            // }, 3000);

            // Approve / Reject from list
            (function () {
                var form = document.getElementById('allocationListActionForm');
                if (!form) {
                    return;
                }

                var idInput = document.getElementById('listActionRequestId');
                var actionInput = document.getElementById('listActionType');
                var reasonInput = document.getElementById('listActionReason');

                // Approve buttons
                document.querySelectorAll('.btn-alloc-approve').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        var reqId = btn.getAttribute('data-req-id');
                        var stockStatus = btn.getAttribute('data-stock-status') || '';
                        var totalReq = parseInt(btn.getAttribute('data-total') || '0', 10);
                        var totalAvail = parseInt(btn.getAttribute('data-available') || '0', 10);
                        var shortage = totalReq - totalAvail;

                        var message = 'Bạn có chắc chắn muốn duyệt yêu cầu REQ-' + reqId + ' ?';
                        var extraHtml = '';
                        if (stockStatus === 'PARTIAL' || stockStatus === 'NONE') {
                            extraHtml = '<div class="alert alert-warning p-2 mb-0 small">'
                                    + 'Tồn kho hiện tại chỉ đáp ứng <strong>' + totalAvail + '/' + totalReq + '</strong> tài sản.<br>'
                                    + 'Hệ thống sẽ tự động tạo <strong>đề xuất mua sắm</strong> cho '
                                    + '<strong>' + (shortage > 0 ? shortage : 0) + '</strong> tài sản còn thiếu.'
                                    + '</div>';
                        }

                        if (window.CFMS_CONFIRM) {
                            CFMS_CONFIRM({
                                title: 'Xác nhận duyệt yêu cầu',
                                message: message,
                                extraHtml: extraHtml,
                                danger: false,
                                requireReason: false,
                                onConfirm: function () {
                                    idInput.value = reqId;
                                    actionInput.value = 'approve';
                                    reasonInput.value = '';
                                    form.submit();
                                }
                            });
                        } else {
                            if (confirm(message)) {
                                idInput.value = reqId;
                                actionInput.value = 'approve';
                                reasonInput.value = '';
                                form.submit();
                            }
                        }
                    });
                });

                // Reject buttons
                document.querySelectorAll('.btn-alloc-reject').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        var reqId = btn.getAttribute('data-req-id');
                        if (window.CFMS_CONFIRM) {
                            CFMS_CONFIRM({
                                title: 'Xác nhận từ chối yêu cầu',
                                message: 'Bạn có chắc chắn muốn từ chối yêu cầu REQ-' + reqId + ' ?',
                                danger: true,
                                requireReason: true,
                                reasonLabel: 'Lý do từ chối',
                                reasonPlaceholder: 'Nhập lý do từ chối...',
                                onConfirm: function (reasonText) {
                                    idInput.value = reqId;
                                    actionInput.value = 'reject';
                                    reasonInput.value = reasonText;
                                    form.submit();
                                }
                            });
                        } else {
                            var reason = prompt('Nhập lý do từ chối cho REQ-' + reqId + ':');
                            if (reason && reason.trim().length > 0) {
                                idInput.value = reqId;
                                actionInput.value = 'reject';
                                reasonInput.value = reason.trim();
                                form.submit();
                            }
                        }
                    });
                });

                // Cancel buttons (Head of Dept)
                var cancelForm = document.getElementById('allocationCancelForm');
                var cancelIdInput = document.getElementById('cancelRequestId');
                if (cancelForm && cancelIdInput) {
                    document.querySelectorAll('.btn-alloc-cancel').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            var reqId = btn.getAttribute('data-req-id');
                            var message = 'Bạn có chắc chắn muốn hủy yêu cầu REQ-' + reqId + ' ?';

                            if (window.CFMS_CONFIRM) {
                                CFMS_CONFIRM({
                                    title: 'Xác nhận hủy yêu cầu',
                                    message: message,
                                    danger: true,
                                    requireReason: false,
                                    onConfirm: function () {
                                        cancelIdInput.value = reqId;
                                        cancelForm.submit();
                                    }
                                });
                            } else {
                                if (confirm(message)) {
                                    cancelIdInput.value = reqId;
                                    cancelForm.submit();
                                }
                            }
                        });
                    });
                }
            })();
        });
    </script>
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>

</body>
</html>
