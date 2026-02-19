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
        <title><c:choose><c:when test="${isEdit}">Chỉnh sửa yêu cầu cấp phát</c:when><c:otherwise>Tạo yêu cầu cấp phát</c:otherwise></c:choose> - CFMS</title>

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
                            <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-square'} me-2"></i>
                            <c:choose>
                                <c:when test="${isEdit}">
                                    Chỉnh sửa yêu cầu cấp phát REQ-${req.requestId}
                                </c:when>
                                <c:otherwise>
                                    Tạo yêu cầu cấp phát tài sản
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <a href="${pageContext.request.contextPath}<c:choose><c:when test="${isEdit}">/request/allocation-detail?id=${req.requestId}</c:when><c:otherwise>/dashboard</c:otherwise></c:choose>"
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại
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
                    <form method="post" action="${pageContext.request.contextPath}<c:choose><c:when test="${isEdit}">/request/update</c:when><c:otherwise>/request/create</c:otherwise></c:choose>">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="requestId" value="${req.requestId}">
                        </c:if>

                        <!-- Lý do yêu cầu -->
                        <div class="form-card mb-3">
                            <h5><i class="bi bi-chat-text me-2"></i>Lý do yêu cầu cấp phát</h5>
                            <textarea name="reason" class="form-control" rows="3" placeholder="VD: Bổ sung thiết bị cho phòng lab, nhu cầu giảng dạy bộ môn..."><c:out value="${isEdit ? req.reason : reason}" /></textarea>
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
                                        <c:choose>
                                            <c:when test="${isEdit && not empty req.details}">
                                                <!-- Edit mode: populate with existing data -->
                                                <c:forEach items="${req.details}" var="d">
                                                    <tr>
                                                        <td>
                                                            <select name="assetId" class="form-select" required>
                                                                <option value="">-- Chọn tài sản --</option>
                                                                <c:forEach items="${categories}" var="cat">
                                                                    <optgroup label="${cat.categoryName} (${cat.prefixCode})">
                                                                        <c:forEach items="${assets}" var="a">
                                                                            <c:if test="${a.category.categoryId == cat.categoryId && a.status == 'New'}">
                                                                                <option value="${a.assetId}" ${a.assetId == d.assetId ? 'selected' : ''}>
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
                                                                   min="1" value="${d.quantity}" required>
                                                        </td>
                                                        <td>
                                                            <input type="text" name="note" class="form-control"
                                                                   value="${d.note}" placeholder="VD: Cho phòng 101, lớp K68CNTT">
                                                        </td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-outline-danger btn-sm"
                                                                    onclick="removeAllocationRow(this)">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Create mode: empty row -->
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
                                            </c:otherwise>
                                        </c:choose>
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
                                <a href="${pageContext.request.contextPath}<c:choose><c:when test="${isEdit}">/request/allocation-detail?id=${req.requestId}</c:when><c:otherwise>/dashboard</c:otherwise></c:choose>"
                                   class="btn btn-outline-secondary">
                                    Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi ${isEdit ? 'bi-check-circle' : 'bi-send-fill'} me-1"></i>
                                    <c:choose>
                                        <c:when test="${isEdit}">Cập nhật yêu cầu</c:when>
                                        <c:otherwise>Gửi yêu cầu cấp phát</c:otherwise>
                                    </c:choose>
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
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>

    </body>
</html>
