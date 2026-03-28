<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thu hồi tài sản cho REQ-${alloc.requestId} - CFMS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/form.css" rel="stylesheet">
</head>

<body class="d-flex flex-column">

    <jsp:include page="../components/header.jsp" />

    <div class="container-fluid flex-grow-1">
        <div class="row h-100">

            <jsp:include page="../components/sidebar.jsp">
                <jsp:param name="page" value="allocation_list"/>
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                <div class="cfms-page-header d-flex justify-content-between align-items-center">
                    <h2>
                        <i class="bi bi-arrow-return-left me-2"></i>
                        Thu hồi tài sản cho REQ-${alloc.requestId}
                    </h2>
                    <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${alloc.requestId}"
                       class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại chi tiết
                    </a>
                </div>

                <c:if test="${not empty errorMsg}">
                    <div class="cfms-msg cfms-msg-error">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
                    </div>
                </c:if>
                <c:if test="${not empty successMsg}">
                    <div class="cfms-msg cfms-msg-success">
                        <i class="bi bi-check-circle-fill"></i> ${successMsg}
                    </div>
                </c:if>

                <div class="alert alert-info mb-3 small">
                    <i class="bi bi-info-circle me-2"></i>
                    Chọn các cá thể đang được sử dụng tại các phòng để thu hồi về kho.
                    Sau khi thu hồi, trạng thái cá thể sẽ chuyển thành <strong>In_Stock</strong>
                    và bạn có thể tiến hành cấp phát cho yêu cầu này.
                    Bạn có thể thu hồi <strong>từng phần</strong> – không cần lấy đủ tất cả cùng lúc.
                </div>

                <form method="post" action="${pageContext.request.contextPath}/asset/retrieval-list">
                    <input type="hidden" name="allocationId" value="${alloc.requestId}">

                    <c:choose>
                        <c:when test="${empty details}">
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle me-1"></i>
                                Yêu cầu này đã được cấp phát đủ số lượng.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:set var="hasAnyInUse" value="false"/>
                            <c:forEach items="${details}" var="d">
                                <c:set var="remaining" value="${d.quantity - d.allocatedQuantity}"/>
                                <c:if test="${remaining > 0}">
                                    <c:set var="instances" value="${inUseByAsset[d.assetId]}"/>
                                    <div class="form-card mb-3">
                                        <div class="d-flex align-items-center justify-content-between mb-3">
                                            <h6 class="mb-0">
                                                <i class="bi bi-box-seam me-2"></i>
                                                <strong>${d.asset.assetCode}</strong> – ${d.asset.assetName}
                                            </h6>
                                            <span class="badge bg-warning text-dark">
                                                Còn thiếu: ${remaining}
                                            </span>
                                        </div>

                                        <c:choose>
                                            <c:when test="${empty instances}">
                                                <p class="text-muted small mb-0">
                                                    <i class="bi bi-dash-circle me-1"></i>
                                                    Không có cá thể nào đang sử dụng tại các phòng để thu hồi.
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="hasAnyInUse" value="true"/>
                                                <p class="text-muted small mb-2">
                                                    Chọn cá thể cần thu hồi (tối đa ${remaining} để đủ số lượng, hoặc ít hơn nếu muốn thu hồi từng phần):
                                                </p>
                                                <div class="table-responsive">
                                                    <table class="table table-sm align-middle mb-0">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th style="width: 40px;">
                                                                    <input type="checkbox" class="form-check-input select-all"
                                                                           data-asset="${d.assetId}" title="Chọn tất cả">
                                                                </th>
                                                                <th>Mã cá thể</th>
                                                                <th>Phòng hiện tại</th>
                                                                <th>Trạng thái</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${instances}" var="inst">
                                                                <tr>
                                                                    <td>
                                                                        <input type="checkbox"
                                                                               class="form-check-input instance-cb cb-asset-${d.assetId}"
                                                                               name="instanceIds"
                                                                               value="${inst.instanceId}"
                                                                               data-asset-id="${d.assetId}"
                                                                               data-max="${remaining}">
                                                                    </td>
                                                                    <td><strong>${inst.instanceCode}</strong></td>
                                                                    <td>
                                                                        <i class="bi bi-geo-alt text-muted me-1"></i>
                                                                        ${inst.room.roomName}
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge bg-primary">In_Use</span>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <div class="form-card mt-3">
                                <div class="cfms-btn-group-right">
                                    <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${alloc.requestId}"
                                       class="btn btn-outline-secondary">Hủy</a>
                                    <button type="submit" class="btn btn-secondary" id="btnSubmitRetrieval">
                                        <i class="bi bi-arrow-return-left me-1"></i>Xác nhận thu hồi
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </form>

            </main>
        </div>
    </div>

    <jsp:include page="../components/footer.jsp" />
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>
    <script>
        // Select-all checkbox per asset group
        document.querySelectorAll('.select-all').forEach(function (chk) {
            chk.addEventListener('change', function () {
                var assetId = chk.getAttribute('data-asset');
                document.querySelectorAll('.cb-asset-' + assetId).forEach(function (c) {
                    c.checked = chk.checked;
                });
            });
        });

        // Disable submit if nothing selected
        document.getElementById('btnSubmitRetrieval')?.addEventListener('click', function (e) {
            var anyChecked = document.querySelectorAll('input[name="instanceIds"]:checked').length > 0;
            if (!anyChecked) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất một cá thể để thu hồi.');
            }
        });
    </script>
</body>
</html>
