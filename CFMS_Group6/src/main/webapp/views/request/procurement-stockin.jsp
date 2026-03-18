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

                <style>
                    .warning-row {
                        background-color: #fff3cd !important;
                        transition: background-color 0.3s ease;
                    }
                </style>
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
                                                        <th>Tình trạng giao hàng</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${details}" var="d" varStatus="loop">
                                                        <c:set var="receivedQty"
                                                            value="${d.receivedQuantity == null ? 0 : d.receivedQuantity}" />
                                                        <c:set var="remainingQty" value="${d.quantity - receivedQty}" />
                                                        <tr id="row_${d.detailId}">
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
                                                                <!-- Giữ lại ID expected_ để thẻ JS chạy logic bắt lỗi không nhập quá số lượng còn nợ -->
                                                                <span class="d-none"
                                                                    id="expected_${d.detailId}">${remainingQty}</span>

                                                                <c:choose>
                                                                    <c:when test="${remainingQty > 0}">
                                                                        <input type="number"
                                                                            class="form-control text-center fw-bold recv-qty-input border-primary"
                                                                            name="recvQty_${d.detailId}"
                                                                            id="recvQty_${d.detailId}"
                                                                            value="${remainingQty}" min="0"
                                                                            max="${remainingQty}"
                                                                            data-detailid="${d.detailId}" required>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <input type="number"
                                                                            class="form-control text-center fw-bold text-muted bg-light"
                                                                            value="0" disabled>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>

                                                            <td id="status_${d.detailId}">
                                                                <c:choose>
                                                                    <c:when test="${remainingQty > 0}">
                                                                        <span class="text-success fw-bold"><i
                                                                                class="bi bi-check-circle-fill me-1"></i>Đủ
                                                                            số lượng nợ</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-primary fw-bold"><i
                                                                                class="bi bi-check-all me-1"></i>Đã nhập
                                                                            đủ từ trước</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Cảnh báo nếu có hàng thiếu -->
                                        <div id="missingWarning" class="alert alert-warning m-4 d-none">
                                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                            <strong>Cảnh báo:</strong> Bạn đang xác nhận nhập kho với số lượng
                                            <strong>ít hơn</strong> số lượng đã đặt.
                                            Hệ thống sẽ chuyển trạng thái Đơn đặt hàng thành <em>"Nhận một phần"</em> và
                                            ghi nhận số hàng bị thiếu để tiếp tục theo dõi!
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
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const inputs = document.querySelectorAll('.recv-qty-input');
                        const warningBox = document.getElementById('missingWarning');
                        const btnSubmit = document.getElementById('btnSubmit');

                        function checkAllQuantities() {
                            let hasMissing = false;

                            inputs.forEach(input => {
                                const detailId = input.dataset.detailid;
                                const expectedStr = document.getElementById('expected_' + detailId).innerText;
                                const expectedQty = parseInt(expectedStr, 10);
                                let actualQty = parseInt(input.value, 10);

                                if (isNaN(actualQty) || actualQty < 0) {
                                    actualQty = 0;
                                    input.value = 0;
                                }
                                if (actualQty > expectedQty) {
                                    actualQty = expectedQty;
                                    input.value = expectedQty; // Không cho phép nhập vượt quá
                                }

                                const statusTd = document.getElementById('status_' + detailId);
                                const row = document.getElementById('row_' + detailId);

                                if (actualQty < expectedQty) {
                                    hasMissing = true;
                                    const missing = expectedQty - actualQty;
                                    statusTd.innerHTML = '<span class="text-danger fw-bold"><i class="bi bi-exclamation-circle-fill me-1"></i>Giao thiếu ' + missing + '</span>';
                                    row.classList.add('warning-row');
                                } else {
                                    statusTd.innerHTML = '<span class="text-success fw-bold"><i class="bi bi-check-circle-fill me-1"></i>Đủ số lượng</span>';
                                    row.classList.remove('warning-row');
                                }
                            });

                            if (hasMissing) {
                                warningBox.classList.remove('d-none');
                                btnSubmit.innerHTML = '<i class="bi bi-exclamation-triangle-fill me-1"></i> Xác nhận nhập (Giao thiếu)';
                                btnSubmit.classList.replace('btn-success', 'btn-warning');
                                btnSubmit.classList.add('text-dark');
                            } else {
                                warningBox.classList.add('d-none');
                                btnSubmit.innerHTML = '<i class="bi bi-box-arrow-in-down me-1"></i> Xác nhận & Sinh mã cá thể';
                                btnSubmit.classList.replace('btn-warning', 'btn-success');
                                btnSubmit.classList.remove('text-dark');
                            }
                        }

                        // Gắn event listener cho việc nhập liệu
                        inputs.forEach(input => {
                            input.addEventListener('input', checkAllQuantities);
                            input.addEventListener('change', checkAllQuantities);
                        });

                        // Xử lý xác nhận Submit
                        document.getElementById('stockinForm').addEventListener('submit', function (e) {
                            const isWarningVisible = !warningBox.classList.contains('d-none');

                            if (isWarningVisible) {
                                const confirmMsg = "Xác nhận: Bạn đang thao tác NHẬP KHO THIẾU. \n\nBạn có chắc chắn muốn tiến hành nhập kho ngay bây giờ không?";
                                if (!confirm(confirmMsg)) {
                                    e.preventDefault(); // Ngăn submit nếu ấn Cancel
                                }
                            }

                            // Vô hiệu hóa nút sau khi confirm để tránh click double (double submit)
                            setTimeout(() => {
                                btnSubmit.disabled = true;
                            }, 50);
                        });
                    });
                </script>
            </body>

            </html>