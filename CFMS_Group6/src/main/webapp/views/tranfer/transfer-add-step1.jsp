<%-- Document : transfer-add Created on : Feb 10, 2026, 8:56:19 PM Author : Pham Van Tung --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>JSP Page</title>
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            </head>

            <body class="d-flex flex-column">

                <jsp:include page="../components/header.jsp"></jsp:include>

                <div class="container-fluid flex-grow-1">
                    <div class="row h-100">

                        <jsp:include page="../components/sidebar.jsp">
                            <jsp:param name="page" value="transfer_add" />
                        </jsp:include>

                        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                            <div
                                class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                <h1 class="h2 text-secondary" style="font-weight: 500;">Tạo Phiếu Điều Chuyển</h1>
                            </div>

                            <c:if test="${not empty msg}">
                                <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                                    ${msg}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                            </c:if>

                            <div class="card shadow-sm border-0 mb-4">
                                <div class="card-header bg-light border-bottom border-light">
                                    <h5 class="card-title mb-0 text-secondary" style="font-weight: 500;">1. Chọn phòng
                                        nguồn và phòng đích</h5>
                                </div>
                                <div class="card-body p-4">
                                    <form action="${pageContext.request.contextPath}/transfer/addstep2" method="get">
                                        <div class="row g-4">
                                            <div class="col-md-6">
                                                <label class="form-label fw-semibold text-muted">Phòng Đích</label>
                                                <select name="destinationRoom" class="form-select shadow-sm" required
                                                    onchange="this.form.submit()">
                                                    <option value="">-- Chọn phòng đích --</option>
                                                    <c:forEach items="${rooms}" var="r">
                                                        <c:if test="${r.roomId != param.sourceRoom}">
                                                            <option value="${r.roomId}"
                                                                ${r.roomId==param.destinationRoom ? "selected" : "" }>
                                                                ${r.roomName}
                                                            </option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="col-md-6">
                                                <label class="form-label fw-semibold text-muted">Phòng Nguồn</label>
                                                <select name="sourceRoom" class="form-select shadow-sm" required
                                                    onchange="this.form.submit()">
                                                    <option value="">-- Chọn phòng nguồn --</option>
                                                    <c:forEach items="${rooms}" var="r">
                                                        <c:if test="${r.roomId != param.destinationRoom}">
                                                            <option value="${r.roomId}" ${r.roomId==param.sourceRoom
                                                                ? "selected" : "" }>
                                                                ${r.roomName}
                                                            </option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <c:if test="${not empty assetDetailList}">
                                <div class="card shadow-sm border-0">
                                    <div class="card-header bg-light border-bottom border-light pb-0">
                                        <h5 class="card-title mb-3 text-secondary" style="font-weight: 500;">2. Chọn tài
                                            sản cần điều chuyển</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <form action="${pageContext.request.contextPath}/transfer/addstep2"
                                            method="post">
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle mb-0"
                                                    style="color: #495057;">
                                                    <thead class="table-light text-muted"
                                                        style="border-bottom: 2px solid #dee2e6;">
                                                        <tr>
                                                            <th class="fw-semibold px-4 text-center"
                                                                style="width: 50px;">
                                                                <i class="bi bi-check2-square border-0 bg-transparent p-0 text-muted"
                                                                    style="font-size: 1.2rem;"></i>
                                                            </th>
                                                            <th class="fw-semibold">Mã Tài Sản</th>
                                                            <th class="fw-semibold">Tên Tài Sản</th>
                                                            <th class="fw-semibold">Trạng Thái</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody style="border-top: none;">
                                                        <c:forEach items="${assetDetailList}" var="a">
                                                            <tr>
                                                                <td class="text-center px-4">
                                                                    <div
                                                                        class="form-check d-flex justify-content-center">
                                                                        <input class="form-check-input" type="checkbox"
                                                                            name="assetIds" value="${a.instanceId}"
                                                                            id="assetDetail_${a.instanceId}">
                                                                    </div>
                                                                </td>
                                                                <td class="text-secondary fw-semibold">
                                                                    <label class="form-check-label w-100"
                                                                        for="assetDetail_${a.instanceId}">${a.instanceCode}</label>
                                                                </td>
                                                                <td class="fw-medium">
                                                                    <label class="form-check-label w-100"
                                                                        for="assetDetail_${a.instanceId}">${a.assetName}</label>
                                                                </td>
                                                                <td>
                                                                    <label class="form-check-label w-100"
                                                                        for="assetDetail_${a.instanceId}">
                                                                        <span
                                                                            class="badge bg-light text-dark border border-secondary-subtle px-2 py-1 fw-normal">${a.status}</span>
                                                                    </label>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div class="p-4 bg-light border-top">
                                                <div class="mb-4">
                                                    <label class="form-label fw-semibold text-muted">Ghi Chú</label>
                                                    <textarea name="note" class="form-control shadow-sm" rows="3"
                                                        placeholder="Nhập lý do hoặc thông tin thêm...">${param.note}</textarea>
                                                </div>
                                                <div class="d-flex justify-content-end gap-2">
                                                    <a href="${pageContext.request.contextPath}/transfer/list"
                                                        class="btn btn-outline-secondary px-4 shadow-sm">
                                                        Hủy bỏ
                                                    </a>
                                                    <button type="submit" class="btn btn-primary px-4 shadow-sm">
                                                        <i class="bi bi-send me-1"></i> Tạo Đơn
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                    </div>


                </div>
                </div>

                <jsp:include page="../components/footer.jsp"></jsp:include>

            </body>

            </html>