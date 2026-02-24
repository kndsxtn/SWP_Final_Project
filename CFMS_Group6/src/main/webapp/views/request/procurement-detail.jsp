<%--
    Document   : procurement-detail
    Description: Chi tiết yêu cầu mua sắm (format theo allocation-detail)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width:device-width, initial-scale=1.0">
    <title>Chi tiết yêu cầu PROC-${proc.procurementId} - CFMS</title>

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
                <jsp:param name="page" value="procurement_list"/>
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                <!-- ===== Page Header ===== -->
                <div class="cfms-page-header">
                    <h2><i class="bi bi-cart-check me-2"></i>Chi tiết yêu cầu PROC-${proc.procurementId}</h2>
                    <div class="page-header-actions">
                        <%-- Asset Staff: Edit + Cancel (chỉ khi Pending và là người tạo) --%>
                        <c:if test="${proc.status == 'Pending' && sessionScope.user.roleName == 'Asset Staff' && proc.createdBy == sessionScope.user.userId}">
                            <a href="${pageContext.request.contextPath}/request/procurement-edit?id=${proc.procurementId}"
                               class="btn btn-warning me-2">
                                <i class="bi bi-pencil me-1"></i>Chỉnh sửa
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/request/procurement-cancel" class="d-inline me-2">
                                <input type="hidden" name="id" value="${proc.procurementId}">
                                <button type="button" class="btn btn-danger"
                                        onclick="(function(f){ CFMS_CONFIRM({ title: 'Xác nhận hủy', message: 'Bạn có chắc muốn hủy yêu cầu mua sắm PROC-${proc.procurementId}?', danger: true, onConfirm: function() { f.submit(); } }); })(this.closest('form'));">
                                    <i class="bi bi-x-circle me-1"></i>Hủy yêu cầu
                                </button>
                            </form>
                        </c:if>
                        <%-- Hiệu trưởng / Trưởng phòng TC-KT: Approve + Reject (khi Pending) --%>
                        <c:if test="${proc.status == 'Pending' && (sessionScope.user.roleName == 'Principal' || sessionScope.user.roleName == 'Finance Head')}">
                            <form method="post" action="${pageContext.request.contextPath}/request/procurement-approve" class="d-inline me-2">
                                <input type="hidden" name="id" value="${proc.procurementId}">
                                <button type="button" class="btn btn-success"
                                        onclick="(function(f){ CFMS_CONFIRM({ title: 'Xác nhận phê duyệt', message: 'Bạn có chắc muốn phê duyệt yêu cầu mua sắm PROC-${proc.procurementId}?', danger: false, onConfirm: function() { f.submit(); } }); })(this.closest('form'));">
                                    <i class="bi bi-check-circle me-1"></i>Phê duyệt
                                </button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/request/procurement-reject" class="d-inline me-2">
                                <input type="hidden" name="id" value="${proc.procurementId}">
                                <input type="hidden" name="reason" value="">
                                <button type="button" class="btn btn-danger"
                                        onclick="(function(f){ CFMS_CONFIRM({ title: 'Từ chối yêu cầu', message: 'Nhập lý do từ chối cho yêu cầu mua sắm PROC-${proc.procurementId}:', danger: true, requireReason: true, reasonLabel: 'Lý do từ chối', reasonPlaceholder: 'Nhập lý do từ chối...', onConfirm: function(reasonText) { f.querySelector('input[name=reason]').value = reasonText; f.submit(); } }); })(this.closest('form'));">
                                    <i class="bi bi-x-circle me-1"></i>Từ chối
                                </button>
                            </form>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/request/procurement-list"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
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

                <!-- ===== Request Info Card ===== -->
                <div class="detail-card">
                    <h5><i class="bi bi-info-circle me-2"></i>Thông tin yêu cầu</h5>

                    <div class="detail-row">
                        <span class="detail-label">Mã yêu cầu:</span>
                        <span class="detail-value"><strong>PROC-${proc.procurementId}</strong></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Người tạo:</span>
                        <span class="detail-value">${proc.creator.fullName}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Ngày tạo:</span>
                        <span class="detail-value">
                            <fmt:formatDate value="${proc.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Lý do:</span>
                        <span class="detail-value">${not empty proc.reason ? proc.reason : '–'}</span>
                    </div>
                    <c:if test="${proc.allocationRequestId != null}">
                        <div class="detail-row">
                            <span class="detail-label">Liên kết cấp phát:</span>
                            <span class="detail-value">
                                <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${proc.allocationRequestId}">REQ-${proc.allocationRequestId}</a>
                            </span>
                        </div>
                    </c:if>
                    <div class="detail-row">
                        <span class="detail-label">Trạng thái:</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${proc.status == 'Pending'}">
                                    <span class="cfms-badge cfms-badge-pending">Chờ duyệt</span>
                                </c:when>
                                <c:when test="${proc.status == 'Approved'}">
                                    <span class="cfms-badge cfms-badge-approved">Đã duyệt</span>
                                </c:when>
                                <c:when test="${proc.status == 'Rejected'}">
                                    <span class="cfms-badge cfms-badge-rejected">Từ chối</span>
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
                        </span>
                    </div>

                    <c:if test="${proc.status == 'Rejected' && not empty proc.reasonReject}">
                        <div class="detail-row">
                            <span class="detail-label">Lý do từ chối:</span>
                            <span class="detail-value text-danger">${proc.reasonReject}</span>
                        </div>
                    </c:if>
                </div>

                <!-- ===== Asset Details (card layout like allocation-detail) ===== -->
                <div class="detail-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0"><i class="bi bi-box-seam me-2"></i>Danh sách tài sản yêu cầu mua</h5>
                        <c:set var="totalQty" value="0" />
                        <c:forEach items="${proc.details}" var="d">
                            <c:set var="totalQty" value="${totalQty + d.quantity}" />
                        </c:forEach>
                        <span class="badge bg-primary" style="font-size: 0.9rem; padding: 0.4rem 0.8rem;">
                            <i class="bi bi-calculator me-1"></i>Tổng: <strong>${totalQty}</strong> tài sản
                        </span>
                    </div>

                    <c:forEach items="${proc.details}" var="d" varStatus="loop">
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
                            </div>

                            <div class="asset-info-grid">
                                <div>
                                    <span class="info-label">Loại tài sản: </span>
                                    <span class="info-value">${d.asset.category.categoryName}</span>
                                </div>
                                <c:if test="${d.asset.price != null}">
                                    <div>
                                        <span class="info-label">Giá trị: </span>
                                        <span class="info-value">
                                            <fmt:formatNumber value="${d.asset.price}" type="number"
                                                              groupingUsed="true" maxFractionDigits="0"/> VNĐ
                                        </span>
                                    </div>
                                </c:if>
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

                            <c:choose>
                                <c:when test="${not empty d.asset.images}">
                                    <div class="asset-images">
                                        <c:forEach items="${d.asset.images}" var="img">
                                            <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                 alt="${img.description}"
                                                 class="img-thumb"
                                                 data-bs-toggle="modal"
                                                 data-bs-target="#imageModal"
                                                 data-img-src="${pageContext.request.contextPath}/${img.imageUrl}"
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
    </script>
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>

</body>
</html>
