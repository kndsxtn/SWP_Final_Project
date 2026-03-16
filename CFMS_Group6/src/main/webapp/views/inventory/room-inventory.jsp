<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Kiểm kê tài sản theo phòng - CFMS</title>

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
                        <jsp:param name="page" value="room_inventory" />
                    </jsp:include>

                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                        <!-- Page Header -->
                        <div class="cfms-page-header d-flex justify-content-between align-items-center">
                            <h2><i class="bi bi-box-seam me-2"></i>Tài sản theo phòng</h2>

                            <c:if test="${not empty selectedRoomId && not empty assetDetails}">
                                <button class="btn btn-outline-primary" onclick="window.print()">
                                    <i class="bi bi-printer me-1"></i>In báo cáo
                                </button>
                            </c:if>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty errorMsg}">
                            <div class="cfms-msg cfms-msg-error">
                                <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
                            </div>
                        </c:if>

                        <!-- Box Chọn Phòng -->
                        <div class="card mb-4 shadow-sm">
                            <div class="card-body bg-light">
                                <form method="get" action="${pageContext.request.contextPath}/inventory/room"
                                    class="row gx-3 gy-2 align-items-center">
                                    <div class="col-sm-5 col-md-4">
                                        <label class="visually-hidden" for="roomId">Chọn phòng</label>
                                        <select class="form-select" id="roomId" name="roomId" required>
                                            <option value="" disabled ${empty selectedRoomId ? 'selected' : '' }>-- Chọn
                                                vị trí / phòng --</option>
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
                                            <i class="bi bi-search me-1"></i>Kiểm kê
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Kết quả tìm kiếm (Danh sách tài sản) -->
                        <c:if test="${not empty selectedRoomId}">
                            <div class="card shadow-sm">
                                <div
                                    class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                                    <h5 class="mb-0 text-primary">
                                        <i class="bi bi-geo-alt-fill me-2"></i>
                                        Danh sách tài sản tại: <strong>${selectedRoomName}</strong>
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
                                                            <th>Tình trạng</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${assetDetails}" var="detail"
                                                            varStatus="loop">
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
                                                                    <c:choose>
                                                                        <c:when test="${detail.status == 'In_Use'}">
                                                                            <span class="badge bg-success">Đang sử
                                                                                dụng</span>
                                                                        </c:when>
                                                                        <c:when test="${detail.status == 'In_Stock'}">
                                                                            <span class="badge bg-secondary">Trong
                                                                                kho</span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${detail.status == 'Maintenance'}">
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
                                                <p class="fs-5">Chưa có tài sản nào được phân bổ hoặc gắn với phòng này.
                                                </p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>

                    </main>
                </div>
            </div>

            <!-- Cho phép in ấn (ẩn header/sidebar khi in) -->
            <style>
                @media print {

                    .cfms-page-header,
                    form,
                    nav,
                    .sidebar {
                        display: none !important;
                    }

                    main {
                        width: 100% !important;
                        margin: 0 !important;
                        padding: 0 !important;
                    }

                    .card {
                        border: none !important;
                        box-shadow: none !important;
                    }
                }
            </style>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>