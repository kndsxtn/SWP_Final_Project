<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chọn cá thể cho REQ-${req.requestId} - CFMS</title>

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
                            <i class="bi bi-list-check me-2"></i>
                            Chọn cá thể cấp phát cho REQ-${req.requestId}
                        </h2>
                        <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${req.requestId}"
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

                    <div class="alert alert-info mb-3">
                        <i class="bi bi-info-circle me-2"></i>
                        Chọn đúng số lượng cá thể (instance) tương ứng với mỗi dòng tài sản bên dưới.
                        Sau khi xác nhận, hệ thống sẽ cập nhật trạng thái cá thể thành <strong>In_Use</strong>
                        và đánh dấu yêu cầu là <strong>Hoàn thành</strong>.
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/request/allocation-assign">
                        <input type="hidden" name="requestId" value="${req.requestId}">

                        <div class="form-card mb-3">
                            <h5><i class="bi bi-geo-alt me-2"></i>Thông tin chung</h5>
                            <div class="row g-3 align-items-center">
                                <div class="col-sm-6">
                                    <label class="form-label mb-1">Mã yêu cầu</label>
                                    <div><strong>REQ-${req.requestId}</strong></div>
                                </div>
                                <div class="col-sm-6">
                                    <label for="roomId" class="form-label mb-1">Phòng đích (tùy chọn)</label>
                                    <input type="number" class="form-control" id="roomId" name="roomId"
                                           placeholder="Nhập room_id nếu muốn gán trực tiếp phòng cho cá thể">
                                </div>
                            </div>
                        </div>

                        <div class="form-card">
                            <h5><i class="bi bi-box-seam me-2"></i>Chọn cá thể cho từng dòng tài sản</h5>

                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Tài sản</th>
                                            <th>Số lượng yêu cầu</th>
                                            <th>Các cá thể khả dụng (instance_code)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${details}" var="d" varStatus="loop">
                                            <tr>
                                                <td>${loop.count}</td>
                                                <td>
                                                    <strong>${d.asset.assetCode}</strong> – ${d.asset.assetName}
                                                </td>
                                                <td>
                                                    <span class="badge bg-info">
                                                        <i class="bi bi-hash me-1"></i>${d.quantity}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:set var="instances" value="${instancesByAsset[d.assetId]}"/>
                                                    <c:choose>
                                                        <c:when test="${empty instances}">
                                                            <span class="text-danger small">
                                                                Không còn cá thể khả dụng cho tài sản này.
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-2">
                                                                <c:forEach items="${instances}" var="inst">
                                                                    <div class="col">
                                                                        <div class="form-check">
                                                                            <input class="form-check-input"
                                                                                   type="checkbox"
                                                                                   name="instance_${d.detailId}"
                                                                                   value="${inst.instanceId}"
                                                                                   id="inst_${d.detailId}_${inst.instanceId}">
                                                                            <label class="form-check-label small"
                                                                                   for="inst_${d.detailId}_${inst.instanceId}">
                                                                                ${inst.instanceCode}
                                                                            </label>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                            <small class="text-muted d-block mt-1">
                                                                Hãy chọn đúng <strong>${d.quantity}</strong> cá thể.
                                                            </small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="form-card mt-3">
                            <div class="cfms-btn-group-right">
                                <a href="${pageContext.request.contextPath}/request/allocation-detail?id=${req.requestId}"
                                   class="btn btn-outline-secondary">
                                    Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check2-square me-1"></i>Xác nhận chọn cá thể và hoàn thành cấp phát
                                </button>
                            </div>
                        </div>
                    </form>

                </main>
            </div>
        </div>

        <jsp:include page="../components/footer.jsp" />
        <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>
    </body>
</html>

