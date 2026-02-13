<%--
    Document   : allocation-detail.jsp
    Description: UC12 - View allocation request detail with asset images
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
    <title>Chi tiết yêu cầu REQ-${req.requestId} - CFMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <!-- Global + component CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/badge.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/detail.css" rel="stylesheet">
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
                    <h2><i class="bi bi-file-earmark-text me-2"></i>Chi tiết yêu cầu REQ-${req.requestId}</h2>
                    <div class="page-header-actions">
                        <!-- Edit button for creator when status is Pending -->
                        <c:if test="${req.status == 'Pending' && sessionScope.user.userId == req.createdBy}">
                            <a href="${pageContext.request.contextPath}/request/allocation-edit?id=${req.requestId}"
                               class="btn btn-warning me-2">
                                <i class="bi bi-pencil me-1"></i>Chỉnh sửa
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/request/allocation-list"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- ===== Request Info Card ===== -->
                <div class="detail-card">
                    <h5><i class="bi bi-info-circle me-2"></i>Thông tin yêu cầu</h5>

                    <div class="detail-row">
                        <span class="detail-label">Mã yêu cầu:</span>
                        <span class="detail-value"><strong>REQ-${req.requestId}</strong></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Người tạo:</span>
                        <span class="detail-value">${req.creator.fullName}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Ngày tạo:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${req.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Số lượng tài sản:</span>
                        <span class="detail-value"><strong>${req.details.size()}</strong></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Trạng thái:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${req.status == 'Pending'}">
                                    <span class="cfms-badge cfms-badge-pending">Chờ duyệt</span>
                                </c:when>
                                <c:when test="${req.status == 'Approved_By_Staff' || req.status == 'Approved_By_VP' || req.status == 'Approved_By_Principal'}">
                                    <span class="cfms-badge cfms-badge-approved">Đã duyệt</span>
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
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Tồn kho (hiện tại):</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${req.status == 'Pending'}">
                                    <%-- Chỉ hiển thị chi tiết khi yêu cầu đang ở trạng thái Pending --%>
                                    <c:choose>
                                        <c:when test="${req.stockStatus == 'FULL'}">
                                            <span class="cfms-badge cfms-badge-stock-full">
                                                Đủ hàng (${req.totalAvailableInStock}/${req.totalRequestedAssets})
                                            </span>
                                        </c:when>
                                        <c:when test="${req.stockStatus == 'PARTIAL'}">
                                            <span class="cfms-badge cfms-badge-stock-partial">
                                                Thiếu hàng (${req.totalAvailableInStock}/${req.totalRequestedAssets})
                                            </span>
                                        </c:when>
                                        <c:when test="${req.stockStatus == 'NONE'}">
                                            <span class="cfms-badge cfms-badge-stock-none">
                                                Hết hàng (0/${req.totalRequestedAssets})
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">–</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted small">
                                        Không áp dụng (yêu cầu đã được xử lý trước đó)
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <c:if test="${req.status == 'Rejected' && not empty req.reasonReject}">
                        <div class="detail-row">
                            <span class="detail-label">Lý do từ chối:</span>
                            <span class="detail-value text-danger">${req.reasonReject}</span>
                        </div>
                    </c:if>
                </div>

                <!-- ===== Approve / Reject Actions (UC14) ===== -->
                <c:if test="${req.status == 'Pending' && sessionScope.user.roleName == 'Asset Staff'}">
                    <div class="detail-card">
                        <h5><i class="bi bi-check2-square me-2"></i>Phê duyệt yêu cầu</h5>
                        <p class="mb-3 text-muted small">
                            Kiểm tra tồn kho trước khi phê duyệt. Nếu kho không đủ, hệ thống sẽ tự động tạo
                            đề xuất mua sắm tương ứng (UC16).
                        </p>

                        <form id="allocationApproveForm" method="post"
                              action="${pageContext.request.contextPath}/request/approve">
                            <input type="hidden" name="id" value="${req.requestId}">
                            <input type="hidden" name="action" id="approveActionInput" value="">
                            <input type="hidden" name="reasonReject" id="rejectReasonInput" value="">

                            <div class="d-flex flex-wrap gap-2">
                                <button type="button" class="btn btn-success"
                                        id="btnApproveRequest">
                                    <i class="bi bi-check2-circle me-1"></i>Duyệt cấp phát
                                </button>
                                <button type="button" class="btn btn-outline-danger"
                                        id="btnRejectRequest">
                                    <i class="bi bi-x-circle me-1"></i>Từ chối yêu cầu
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <!-- ===== Asset Details ===== -->
                <div class="detail-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0"><i class="bi bi-box-seam me-2"></i>Danh sách tài sản yêu cầu</h5>
                        <c:set var="totalQty" value="0" />
                        <c:forEach items="${req.details}" var="d">
                            <c:set var="totalQty" value="${totalQty + d.quantity}" />
                        </c:forEach>
                        <span class="badge bg-primary" style="font-size: 0.9rem; padding: 0.4rem 0.8rem;">
                            <i class="bi bi-calculator me-1"></i>Tổng: <strong>${totalQty}</strong> tài sản
                        </span>
                    </div>

                    <c:forEach items="${req.details}" var="d" varStatus="loop">
                        <div class="asset-card">
                            <div class="asset-card-header">
                                <div class="d-flex align-items-center" style="gap: 0.75rem;">
                                    <span class="badge bg-light text-dark" style="font-size: 0.75rem; padding: 0.3rem 0.5rem; min-width: 2rem;">
                                        ${loop.count}
                                    </span>
                                    <h6 class="mb-0 flex-grow-1">${d.asset.assetCode} – ${d.asset.assetName}</h6>
                                    <span class="badge bg-info text-dark" style="font-size: 0.85rem; padding: 0.4rem 0.7rem;">
                                        <i class="bi bi-hash me-1"></i>Số lượng: <strong>${d.quantity}</strong>
                                    </span>
                                </div>
                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${d.asset.status == 'New'}">
                                            <span class="cfms-badge cfms-badge-new">${d.asset.status}</span>
                                        </c:when>
                                        <c:when test="${d.asset.status == 'In_Use'}">
                                            <span class="cfms-badge cfms-badge-in-use">Đang dùng</span>
                                        </c:when>
                                        <c:when test="${d.asset.status == 'Maintenance'}">
                                            <span class="cfms-badge cfms-badge-maintenance">Bảo trì</span>
                                        </c:when>
                                        <c:when test="${d.asset.status == 'Broken'}">
                                            <span class="cfms-badge cfms-badge-broken">Hỏng</span>
                                        </c:when>
                                        <c:when test="${d.asset.status == 'Lost'}">
                                            <span class="cfms-badge cfms-badge-lost">Thất lạc</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="cfms-badge">${d.asset.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="asset-info-grid">
                                <div>
                                    <span class="info-label">Loại tài sản: </span>
                                    <span class="info-value">${d.asset.category.categoryName}</span>
                                </div>
                                <div>
                                    <span class="info-label">Giá trị: </span>
                                    <span class="info-value">
                                        <fmt:formatNumber value="${d.asset.price}" type="number"
                                                          groupingUsed="true" maxFractionDigits="0"/> VNĐ
                                    </span>
                                </div>
                                <c:if test="${not empty d.asset.description}">
                                    <div>
                                        <span class="info-label">Mô tả: </span>
                                        <span class="info-value">${d.asset.description}</span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty d.note}">
                                    <div>
                                        <span class="info-label">Ghi chú: </span>
                                        <span class="info-value">${d.note}</span>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Asset Images -->
                            <c:choose>
                                <c:when test="${not empty d.asset.images}">
                                    <div class="asset-images">
                                        <c:forEach items="${d.asset.images}" var="img">
                                            <img src="${pageContext.request.contextPath}${img.imageUrl}"
                                                 alt="${img.description}"
                                                 class="img-thumb"
                                                 data-bs-toggle="modal"
                                                 data-bs-target="#imageModal"
                                                 data-img-src="${pageContext.request.contextPath}${img.imageUrl}"
                                                 data-img-desc="${img.description}"
                                                 title="${img.description}">
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-images">
                                        <i class="bi bi-image me-1"></i>Chưa có hình ảnh
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>

            </main>

        </div>
    </div>

    <jsp:include page="../components/footer.jsp" />

    <jsp:include page="../components/confirm-modal.jsp" />

    <!-- ===== Image Preview Modal ===== -->
    <div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="imageModalLabel">Hình ảnh tài sản</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="" class="img-fluid rounded">
                </div>
            </div>
        </div>
    </div>

    <script>
        // Image modal preview
        document.getElementById('imageModal').addEventListener('show.bs.modal', function (event) {
            var thumb = event.relatedTarget;
            var imgSrc = thumb.getAttribute('data-img-src');
            var imgDesc = thumb.getAttribute('data-img-desc');
            document.getElementById('modalImage').src = imgSrc;
            document.getElementById('modalImage').alt = imgDesc;
            document.getElementById('imageModalLabel').textContent = imgDesc || 'Hình ảnh tài sản';
        });

        (function () {
            var approveBtn = document.getElementById('btnApproveRequest');
            var rejectBtn = document.getElementById('btnRejectRequest');
            var form = document.getElementById('allocationApproveForm');
            if (!form) {
                return;
            }

            var actionInput = document.getElementById('approveActionInput');
            var reasonInput = document.getElementById('rejectReasonInput');
            var reqId = '${req.requestId}';

            if (approveBtn) {
                approveBtn.addEventListener('click', function () {
                    var stockStatus = '${req.stockStatus}';
                    var totalReq = ${req.totalRequestedAssets};
                    var totalAvail = ${req.totalAvailableInStock};
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
                                actionInput.value = 'approve';
                                form.submit();
                            }
                        });
                    } else {
                        if (confirm(message)) {
                            actionInput.value = 'approve';
                            form.submit();
                        }
                    }
                });
            }

            if (rejectBtn) {
                rejectBtn.addEventListener('click', function () {
                    if (window.CFMS_CONFIRM) {
                        CFMS_CONFIRM({
                            title: 'Xác nhận từ chối yêu cầu',
                            message: 'Bạn có chắc chắn muốn từ chối yêu cầu REQ-' + reqId + ' ?',
                            danger: true,
                            requireReason: true,
                            reasonLabel: 'Lý do từ chối',
                            reasonPlaceholder: 'Nhập lý do từ chối...',
                            onConfirm: function (reasonText) {
                                actionInput.value = 'reject';
                                reasonInput.value = reasonText;
                                form.submit();
                            }
                        });
                    } else {
                        var reason = prompt('Nhập lý do từ chối:');
                        if (reason && reason.trim().length > 0) {
                            actionInput.value = 'reject';
                            reasonInput.value = reason.trim();
                            form.submit();
                        }
                    }
                });
            }
        })();
    </script>

</body>
</html>
