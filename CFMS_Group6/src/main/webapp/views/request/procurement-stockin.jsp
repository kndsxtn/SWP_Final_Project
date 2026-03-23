<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đối chiếu Nhập kho từ PO - CFMS</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
                <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">


            </head>

            <body class="d-flex flex-column">

                <jsp:include page="../components/header.jsp" />

                <div class="container-fluid flex-grow-1">
                    <div class="row h-100">

                        <jsp:include page="../components/sidebar.jsp">
                            <jsp:param name="page" value="procurement_list" />
                        </jsp:include>

                        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                            <!-- Page Header -->
                            <div class="cfms-page-header d-flex justify-content-between align-items-center">
                                <h2><i class="bi bi-box-arrow-in-down me-2"></i>Kiểm đếm & Nhập kho từ Đơn mua sắm</h2>
                                <a href="${pageContext.request.contextPath}/request/procurement-list"
                                    class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại
                                </a>
                            </div>

                            <!-- Messages -->
                            <c:if test="${not empty errorMsg}">
                                <div class="cfms-msg cfms-msg-error">
                                    <i class="bi bi-exclamation-triangle-fill mt-1 me-2"></i> ${errorMsg}
                                </div>
                                <% session.removeAttribute("errorMsg"); %>
                            </c:if>

                            <div class="card shadow-sm mb-4">
                                <div class="card-header bg-light py-3 border-bottom">
                                    <h5 class="mb-0 text-primary">Thông tin Đơn mua sắm (PO)</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6 mb-2">
                                            <strong>Mã yêu cầu:</strong> PROC-${proc.procurementId}
                                        </div>
                                        <div class="col-md-6 mb-2">
                                            <strong>Tạo bởi:</strong> ${proc.creator != null ? proc.creator.fullName :
                                            proc.createdBy}
                                        </div>
                                        <div class="col-md-6 mb-2">
                                            <strong>Ngày tạo:</strong>
                                            <fmt:formatDate value="${proc.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                        <div class="col-md-6 mb-2">
                                            <strong>Lý do mua sắm:</strong> ${proc.reason}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card shadow-sm">
                                <div
                                    class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">Đối chiếu danh sách tài sản</h5>
                                    <span class="badge bg-info text-dark">Vui lòng nhập số lượng thực tế nhận được từ
                                        nhà cung cấp</span>
                                </div>

                                <div class="card-body p-0">
                                    <form id="stockinForm"
                                        action="${pageContext.request.contextPath}/request/procurement-stockin"
                                        method="post">
                                        <input type="hidden" name="id" value="${proc.procurementId}">

                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle mb-0" id="assetsTable">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th class="px-4">#</th>
                                                        <th>Tên tài sản</th>
                                                        <th>Phân loại</th>
                                                        <th class="text-center">Số lượng đặt mua</th>
                                                        <th class="text-center text-primary">Đã nhận</th>
                                                        <th class="text-center" style="width: 200px;">Thực nhận đợt này
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${details}" var="d" varStatus="loop">
                                                        <c:set var="receivedQty"
                                                            value="${d.receivedQuantity == null ? 0 : d.receivedQuantity}" />
                                                        <c:set var="remainingQty" value="${d.quantity - receivedQty}" />
                                                        <tr>
                                                            <td class="px-4">${loop.count}</td>
                                                            <td><strong>${d.asset != null ? d.asset.assetName :
                                                                    'N/A'}</strong></td>
                                                            <td>${d.asset != null && d.asset.category != null ?
                                                                d.asset.category.categoryName : ''}</td>

                                                            <td class="text-center">
                                                                <span
                                                                    class="badge bg-secondary fs-6">${d.quantity}</span>
                                                            </td>

                                                            <td class="text-center text-primary fw-bold">
                                                                ${receivedQty}
                                                            </td>

                                                            <td class="text-center">


                                                                <c:choose>
                                                                    <c:when test="${remainingQty > 0}">
                                                                        <input type="number"
                                                                            class="form-control text-center fw-bold border-primary"
                                                                            name="recvQty_${d.detailId}"
                                                                            value="${remainingQty}" min="0"
                                                                            max="${remainingQty}" required>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <input type="number"
                                                                            class="form-control text-center fw-bold text-muted bg-light"
                                                                            value="0" disabled>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="card-footer bg-light p-3 text-end">
                                            <button type="button" class="btn btn-secondary me-2"
                                                onclick="window.history.back()">Hủy bỏ</button>
                                            <button type="submit" class="btn btn-success" id="btnSubmit">
                                                <i class="bi bi-box-arrow-in-down me-1"></i> Xác nhận & Sinh mã cá thể
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                        </main>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>