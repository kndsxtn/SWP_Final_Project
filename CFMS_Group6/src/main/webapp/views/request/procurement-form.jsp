<%--
    Document   : procurement-form
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width:device-width, initial-scale=1.0">
        <title><c:choose><c:when test="${isEdit}">Chỉnh sửa yêu cầu mua sắm</c:when><c:otherwise>Tạo yêu cầu mua sắm</c:otherwise></c:choose> - CFMS</title>

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
                    <jsp:param name="page" value="procurement_add"/>
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                    <!-- Page Header -->
                    <div class="cfms-page-header d-flex justify-content-between align-items-center">
                        <h2>
                            <i class="bi ${isEdit ? 'bi-pencil-square' : 'bi-plus-square'} me-2"></i>
                            <c:choose>
                                <c:when test="${isEdit}">
                                    Chỉnh sửa yêu cầu mua sắm PROC-${proc.procurementId}
                                </c:when>
                                <c:otherwise>
                                    Tạo yêu cầu mua sắm
                                </c:otherwise>
                            </c:choose>
                        </h2>
                        <a href="${pageContext.request.contextPath}<c:choose><c:when test="${isEdit}">/request/procurement-detail?id=${proc.procurementId}</c:when><c:otherwise>/request/procurement-list</c:otherwise></c:choose>"
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
                        Nhập lý do đề xuất mua sắm và chọn mẫu tài sản cần mua cùng số lượng. Yêu cầu sẽ được gửi Hiệu trưởng duyệt.
                    </div>

                    <!-- Form -->
                    <form method="post" action="${pageContext.request.contextPath}<c:choose><c:when test="${isEdit}">/request/procurement-update</c:when><c:otherwise>/request/procurement-create</c:otherwise></c:choose>">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="procurementId" value="${proc.procurementId}">
                        </c:if>

                        <!-- Lý do -->
                        <div class="form-card mb-3">
                            <h5><i class="bi bi-chat-text me-2"></i>Lý do đề xuất mua sắm</h5>
                            <textarea name="reason" class="form-control" rows="3" placeholder="VD: Bổ sung thiết bị cho phòng lab, thiếu tồn kho so với nhu cầu..."><c:out value="${isEdit ? proc.reason : reason}" /></textarea>
                        </div>

                        <div class="form-card">
                            <h5><i class="bi bi-box-seam me-2"></i>Danh sách tài sản đề xuất mua</h5>

                            <div class="table-responsive">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 55%">Tài sản (mẫu tham chiếu)</th>
                                            <th style="width: 15%">Số lượng</th>
                                            <th style="width: 25%">Ghi chú</th>
                                            <th style="width: 5%" class="text-center">Xóa</th>
                                        </tr>
                                    </thead>
                                    <tbody id="procurementItemRows">
                                        <c:choose>
                                            <c:when test="${isEdit && not empty proc.details}">
                                                <c:forEach items="${proc.details}" var="d">
                                                    <tr>
                                                        <td>
                                                            <select name="assetId" class="form-select" required>
                                                                <option value="">-- Chọn tài sản --</option>
                                                                <c:forEach items="${categories}" var="cat">
                                                                    <optgroup label="${cat.categoryName} (${cat.prefixCode})">
                                                                        <c:forEach items="${assets}" var="a">
                                                                            <c:if test="${a.category.categoryId == cat.categoryId}">
                                                                                <option value="${a.assetId}" ${a.assetId == d.assetId ? 'selected' : ''}>
                                                                                    ${a.assetCode} - ${a.assetName}
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
                                                                   value="${d.note}" placeholder="Ghi chú (tùy chọn)">
                                                        </td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-outline-danger btn-sm"
                                                                    onclick="removeProcurementRow(this)">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td>
                                                        <select name="assetId" class="form-select" required>
                                                            <option value="">-- Chọn tài sản --</option>
                                                            <c:forEach items="${categories}" var="cat">
                                                                <optgroup label="${cat.categoryName} (${cat.prefixCode})">
                                                                    <c:forEach items="${assets}" var="a">
                                                                        <c:if test="${a.category.categoryId == cat.categoryId}">
                                                                            <option value="${a.assetId}">
                                                                                ${a.assetCode} - ${a.assetName}
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
                                                               placeholder="Ghi chú (tùy chọn)">
                                                    </td>
                                                    <td class="text-center">
                                                        <button type="button" class="btn btn-outline-danger btn-sm"
                                                                onclick="removeProcurementRow(this)">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <button type="button" id="btnAddProcurementRow"
                                    class="btn btn-outline-primary">
                                <i class="bi bi-plus-circle me-1"></i>Thêm dòng tài sản
                            </button>
                        </div>

                        <!-- Submit -->
                        <div class="form-card mt-3">
                            <div class="cfms-btn-group-right">
                                <a href="${pageContext.request.contextPath}<c:choose><c:when test="${isEdit}">/request/procurement-detail?id=${proc.procurementId}</c:when><c:otherwise>/request/procurement-list</c:otherwise></c:choose>"
                                   class="btn btn-outline-secondary">
                                    Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi ${isEdit ? 'bi-check-circle' : 'bi-send-fill'} me-1"></i>
                                    <c:choose>
                                        <c:when test="${isEdit}">Cập nhật yêu cầu</c:when>
                                        <c:otherwise>Gửi yêu cầu mua sắm</c:otherwise>
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
                var btnAdd = document.getElementById('btnAddProcurementRow');
                var tbody = document.getElementById('procurementItemRows');

                if (btnAdd && tbody) {
                    btnAdd.addEventListener('click', function () {
                        var firstRow = tbody.querySelector('tr');
                        if (!firstRow) return;
                        var newRow = firstRow.cloneNode(true);
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

            function removeProcurementRow(btn) {
                var row = btn.closest('tr');
                var tbody = document.getElementById('procurementItemRows');
                if (tbody && row && tbody.rows.length > 1) {
                    tbody.removeChild(row);
                }
            }
        </script>
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>

    </body>
</html>
