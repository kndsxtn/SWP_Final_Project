<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử trung chuyển - ${detail.instanceCode}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
</head>
<body class="d-flex flex-column">
    <jsp:include page="../components/header.jsp" />

    <div class="container-fluid flex-grow-1">
        <div class="row h-100">
            <jsp:include page="../components/sidebar.jsp">
                <jsp:param name="page" value="asset_list" />
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">
                <div class="cfms-page-header d-flex justify-content-between align-items-center">
                    <h2><i class="bi bi-clock-history me-2"></i>Lịch sử trung chuyển</h2>
                    <a href="${pageContext.request.contextPath}/asset/detail?id=${detail.assetId}" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại
                    </a>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white py-3">
                        <h5 class="mb-0">Thông tin cá thể: <code>${detail.instanceCode}</code> - <strong>${detail.asset.assetName}</strong></h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty history}">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Thời gian thực hiện</th>
                                                <th>Hành động</th>
                                                <th>Người thực hiện</th>
                                                <th>Mô tả chi tiết</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${history}" var="h">
                                                <tr>
                                                    <td><fmt:formatDate value="${h.actionDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                    <td><span class="badge bg-secondary">${h.action}</span></td>
                                                    <td>${h.performer.fullName}</td>
                                                    <td>${h.description}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="bi bi-info-circle text-muted" style="font-size: 3rem;"></i>
                                    <p class="mt-3 text-muted">Chưa có bản ghi lịch sử trung chuyển nào cho cá thể này.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="../components/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
