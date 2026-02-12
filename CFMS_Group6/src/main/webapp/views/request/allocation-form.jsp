<%--
    Document   : allocation-form
    Created on : Feb 4, 2026, 5:00:09 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo yêu cầu cấp phát - CFMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/form.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/button.css" rel="stylesheet">
    </head>

    <body class="d-flex flex-column">

        <jsp:include page="../components/header.jsp" />

        <div class="container-fluid flex-grow-1">
            <div class="row h-100">

                <jsp:include page="../components/sidebar.jsp">
                    <jsp:param name="page" value="allocation_add"/>
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                    <!-- Page Header -->
                    <div class="cfms-page-header d-flex justify-content-between align-items-center">
                        <h2>
                            <i class="bi bi-plus-square me-2"></i>
                            Tạo yêu cầu cấp phát tài sản
                        </h2>
                        <a href="${pageContext.request.contextPath}/dashboard"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại tổng quan
                        </a>
                    </div>

                    <!-- Messages -->
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

                    <!-- Intro -->
                    <div class="alert alert-info mb-3">
                        <i class="bi bi-info-circle me-2"></i>
                        Chọn mẫu tài sản cần cấp phát (ví dụ: Laptop, Máy chiếu...) và nhập số lượng mong muốn cho bộ môn / phòng học.
                        Nhân viên quản lý tài sản sẽ kiểm tra tồn kho và xử lý yêu cầu của bạn.
                    </div>

                    <!-- Form -->
                    <form method="post" action="${pageContext.request.contextPath}/request/create">

                        <!-- Lý do chung -->
                        <div class="form-card">
                            <h5><i class="bi bi-pencil-square me-2"></i>Lý do yêu cầu</h5>
                            <div class="mb-0">
                                <label for="globalReason" class="form-label">Lý do / Ghi chú chung cho yêu cầu</label>
                                <textarea id="globalReason" name="globalReason" class="form-control" rows="3"
                                          placeholder="VD: Bổ sung thiết bị cho phòng 201 phục vụ lớp K68CNTT..."></textarea>
                                <small class="text-muted">
                                    Lý do này sẽ được tự động gộp vào ghi chú của từng dòng tài sản.
                                </small>
                            </div>
                        </div>

                        <div class="form-card">
                            <h5><i class="bi bi-box-seam me-2"></i>Danh sách tài sản yêu cầu</h5>

                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 55%">Tài sản (mẫu tham chiếu)</th>
                                            <th style="width: 15%">Số lượng</th>
                                            <th style="width: 25%">Ghi chú (VD: Phòng 101)</th>
                                            <th style="width: 5%" class="text-center">Xóa</th>
                                        </tr>
                                    </thead>
                                    <tbody id="allocationItemRows">
                                        <tr>
                                            <td>
                                                <select name="assetId" class="form-select" required>
                                                    <option value="">-- Chọn tài sản --</option>
                                                    <c:forEach items="${categories}" var="cat">
                                                        <optgroup label="${cat.categoryName} (${cat.prefixCode})">
                                                            <c:forEach items="${assets}" var="a">
                                                                <c:if test="${a.category.categoryId == cat.categoryId && a.status == 'New'}">
                                                                    <option value="${a.assetId}">
                                                                        ${a.assetCode} - ${a.assetName}
                                                                        [Khả dụng]
                                                                    </option>
                                                                </c:if>
                                                            </c:forEach>
                                                        </optgroup>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="number" name="quantity" class="form-control"
                                                       min="1" value="1" required>
                                            </td>
                                            <td>
                                                <input type="text" name="note" class="form-control"
                                                       placeholder="VD: Cho phòng 101, lớp K68CNTT">
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-outline-danger btn-sm"
                                                        onclick="removeAllocationRow(this)">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <button type="button" id="btnAddAllocationRow"
                                    class="btn btn-outline-primary">
                                <i class="bi bi-plus-circle me-1"></i>Thêm dòng tài sản
                            </button>
                        </div>

                        <!-- Submit -->
                        <div class="form-card mt-3">
                            <div class="cfms-btn-group-right">
                                <a href="${pageContext.request.contextPath}/dashboard"
                                   class="btn btn-outline-secondary">
                                    Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send-fill me-1"></i>Gửi yêu cầu cấp phát
                                </button>
                            </div>
                        </div>
                    </form>

                </main>
            </div>
        </div>

        <jsp:include page="../components/footer.jsp" />

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var btnAdd = document.getElementById('btnAddAllocationRow');
                var tbody = document.getElementById('allocationItemRows');

                if (btnAdd && tbody) {
                    btnAdd.addEventListener('click', function () {
                        var firstRow = tbody.querySelector('tr');
                        if (!firstRow) {
                            return;
                        }
                        var newRow = firstRow.cloneNode(true);

                        // Reset values in cloned row
                        newRow.querySelectorAll('select, input').forEach(function (el) {
                            if (el.tagName === 'SELECT') {
                                el.selectedIndex = 0;
                            } else if (el.name === 'quantity') {
                                el.value = '1';
                            } else {
                                el.value = '';
                            }
                        });

                        tbody.appendChild(newRow);
                    });
                }
            });

            function removeAllocationRow(btn) {
                var row = btn.closest('tr');
                var tbody = document.getElementById('allocationItemRows');
                if (tbody && row && tbody.rows.length > 1) {
                    tbody.removeChild(row);
                }
            }
        </script>

    </body>
</html>
