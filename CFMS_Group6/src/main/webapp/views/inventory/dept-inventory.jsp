<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Tài sản phòng ban - CFMS</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

            <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
        </head>

        <body class="d-flex flex-column">

            <jsp:include page="../components/header.jsp" />

            <div class="container-fluid flex-grow-1">
                <div class="row h-100">

                    <jsp:include page="../components/sidebar.jsp">
                        <jsp:param name="page" value="dept_inventory" />
                    </jsp:include>

                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                        <!-- Page Header -->
                        <div class="cfms-page-header d-flex justify-content-between align-items-center">
                            <h2><i class="bi bi-building me-2"></i>Tài sản phòng ban</h2>

                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty errorMsg}">
                            <div class="cfms-msg cfms-msg-error">
                                <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
                            </div>
                        </c:if>

                        <!-- Bộ lọc -->
                        <div class="card mb-4 shadow-sm">
                            <div class="card-body bg-light">
                                <form method="get" action="${pageContext.request.contextPath}/inventory/dept"
                                    class="row gx-3 gy-2 align-items-center">

                                    <%-- Dropdown lọc phòng ban (chỉ hiển thị cho Staff / Principal / Finance) --%>
                                        <c:if test="${not isHod}">
                                            <div class="col-sm-4 col-md-3">
                                                <label class="visually-hidden" for="deptId">Phòng ban</label>
                                                <select class="form-select" id="deptId" name="deptId"
                                                    onchange="this.form.submit()">
                                                    <option value="">-- Tất cả phòng ban --</option>
                                                    <c:forEach items="${departments}" var="dept">
                                                        <option value="${dept.deptId}" ${selectedDeptId==dept.deptId
                                                            ? 'selected' : '' }>
                                                            ${dept.deptName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:if>

                                        <%-- Dropdown lọc theo phòng --%>
                                            <div class="col-sm-4 col-md-3">
                                                <label class="visually-hidden" for="roomId">Lọc theo phòng</label>
                                                <select class="form-select" id="roomId" name="roomId">
                                                    <option value="" ${empty selectedRoomId ? 'selected' : '' }>-- Tất
                                                        cả phòng
                                                        --</option>
                                                    <c:forEach items="${rooms}" var="room">
                                                        <option value="${room.roomId}" ${selectedRoomId==room.roomId
                                                            ? 'selected' : '' }>
                                                            ${room.roomName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="col-auto">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-funnel me-1"></i>Lọc
                                                </button>
                                            </div>
                                </form>
                            </div>
                        </div>

                        <!-- Bảng danh sách tài sản -->
                        <div class="card shadow-sm">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                                <h5 class="mb-0 text-primary">
                                    <i class="bi bi-list-ul me-2"></i>
                                    <c:choose>
                                        <c:when test="${not empty selectedRoomId}">
                                            Tài sản tại phòng đã chọn
                                        </c:when>
                                        <c:when test="${not empty selectedDeptId}">
                                            Tài sản theo phòng ban đã chọn
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${isHod}">Toàn bộ tài sản phòng ban</c:when>
                                                <c:otherwise>Toàn bộ tài sản trong hệ thống</c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </h5>
                                <span class="badge bg-secondary">Tổng cộng: ${assetDetails.size()} thiết bị</span>
                            </div>

                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${not empty assetDetails}">
                                        <div class="table-responsive">
                                            <table class="table table-hover table-striped mb-0 align-middle">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th class="px-4">#</th>
                                                        <th>Mã cá thể</th>
                                                        <th>Loại tài sản</th>
                                                        <th>Tên thiết bị</th>
                                                        <th>Phòng</th>
                                                        <th>Tình trạng</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${assetDetails}" var="detail" varStatus="loop">
                                                        <tr>
                                                            <td class="px-4">${loop.count}</td>
                                                            <td><code>${detail.instanceCode}</code></td>
                                                            <td>
                                                                ${detail.asset != null && detail.asset.category !=
                                                                null ? detail.asset.category.categoryName : 'Khác'}
                                                            </td>
                                                            <td>
                                                                <strong>${detail.asset != null ?
                                                                    detail.asset.assetName : 'N/A'}</strong>
                                                            </td>
                                                            <td>
                                                                ${detail.room != null ? detail.room.roomName : 'Chưa
                                                                gán'}
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${detail.status == 'In_Use'}">
                                                                        <span class="badge bg-success">Đang sử
                                                                            dụng</span>
                                                                    </c:when>
                                                                    <c:when test="${detail.status == 'In_Stock'}">
                                                                        <span class="badge bg-secondary">Trong
                                                                            kho</span>
                                                                    </c:when>
                                                                    <c:when test="${detail.status == 'Maintenance'}">
                                                                        <span class="badge bg-warning text-dark">Bảo
                                                                            trì</span>
                                                                    </c:when>
                                                                    <c:when test="${detail.status == 'Broken'}">
                                                                        <span class="badge bg-danger">Hỏng</span>
                                                                    </c:when>
                                                                    <c:when test="${detail.status == 'Lost'}">
                                                                        <span class="badge bg-dark">Thất lạc</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="badge bg-light text-dark border">Thanh
                                                                            lí</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5 text-muted">
                                            <i class="bi bi-box-seam fs-1 d-block mb-3"></i>
                                            <p class="fs-5">Chưa có tài sản nào.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </main>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>