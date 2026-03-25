<%-- Document : asset-detail.jsp Description: UC07 - Xem chi tiết tài sản (có gallery ảnh) Author : Vũ Quang Hiếu --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết tài sản - CFMS</title>

                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

                    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/badge.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">

                    <link href="${pageContext.request.contextPath}/css/detail.css" rel="stylesheet">
                </head>

                <body class="d-flex flex-column">

                    <jsp:include page="../components/header.jsp" />

                    <div class="container-fluid flex-grow-1">
                        <div class="row h-100">

                            <jsp:include page="../components/sidebar.jsp">
                                <jsp:param name="page" value="asset_list" />
                            </jsp:include>

                            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                                <!-- Page Header -->
                                <div class="cfms-page-header d-flex justify-content-between align-items-center">
                                    <h2><i class="bi bi-info-circle me-2"></i>Chi tiết tài sản</h2>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/asset/list"
                                            class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left me-1"></i>Quay lại
                                        </a>
                                        <c:if test="${sessionScope.user.roleName == 'Asset Staff'}">
                                            <a href="${pageContext.request.contextPath}/asset/update?id=${asset.assetId}"
                                                class="btn btn-warning">
                                                <i class="bi bi-pencil me-1"></i>Sửa
                                            </a>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Messages -->
                                <c:if test="${not empty sessionScope.successMsg}">
                                    <div class="cfms-msg cfms-msg-success">
                                        <i class="bi bi-check-circle-fill"></i> ${sessionScope.successMsg}
                                    </div>
                                    <c:remove var="successMsg" scope="session" />
                                </c:if>
                                <c:if test="${not empty sessionScope.errorMsg}">
                                    <div class="cfms-msg cfms-msg-error">
                                        <i class="bi bi-exclamation-triangle-fill"></i> ${sessionScope.errorMsg}
                                    </div>
                                    <c:remove var="errorMsg" scope="session" />
                                </c:if>

                                <div class="row">
                                    <!-- ========== CỘT TRÁI: Thông tin cơ bản + Gallery ========== -->
                                    <div class="col-lg-8">
                                        <div class="detail-card">
                                            <h5><i class="bi bi-card-list me-2"></i>Thông tin cơ bản</h5>

                                            <div class="detail-row">
                                                <div class="detail-label">Mã tài sản</div>
                                                <div class="detail-value"><strong>${asset.assetCode}</strong></div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Tên tài sản</div>
                                                <div class="detail-value">${asset.assetName}</div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Số lượng</div>
                                                <div class="detail-value">${asset.quantity}</div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Danh mục</div>
                                                <div class="detail-value">
                                                    ${asset.category != null ? asset.category.categoryName : '–'}
                                                </div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Nhà cung cấp</div>
                                                <div class="detail-value">
                                                    ${asset.supplier != null ? asset.supplier.supplierName : '–'}
                                                </div>
                                            </div>

                                            <div class="detail-row">
                                                <div class="detail-label">Mô tả</div>
                                                <div class="detail-value">
                                                    ${not empty asset.description ? asset.description : '–'}
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ===== Gallery ảnh ===== -->
                                        <div class="detail-card">
                                            <h5>
                                                <i class="bi bi-images me-2"></i>Hình ảnh
                                                <c:if test="${not empty assetImages}">
                                                    <span class="badge bg-primary ms-2">${assetImages.size()}</span>
                                                </c:if>
                                            </h5>

                                            <c:choose>
                                                <c:when test="${not empty assetImages}">
                                                    <div class="gallery-grid">
                                                        <c:forEach items="${assetImages}" var="img" varStatus="idx">
                                                            <div class="gallery-item"
                                                                onclick="openLightbox(${idx.index});">
                                                                <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                                    alt="${asset.assetName}">
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="gallery-empty">
                                                        <i class="bi bi-image"></i>
                                                        <p>Chưa có hình ảnh nào cho tài sản này.</p>
                                                        <c:if test="${sessionScope.user.roleName == 'Asset Staff'}">
                                                            <a href="${pageContext.request.contextPath}/asset/update?id=${asset.assetId}"
                                                                class="btn btn-sm btn-outline-primary mt-2">
                                                                <i class="bi bi-upload me-1"></i>Thêm ảnh
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- ===== Danh sách cá thể (Instances) ===== -->
                                        <div class="detail-card">
                                            <h5>
                                                <i class="bi bi-collection me-2"></i>Danh sách cá thể
                                                <span class="badge bg-primary ms-2">${instanceTotal}</span>
                                            </h5>

                                            <!-- Search + Filter cá thể -->
                                            <form class="row g-2 mb-3" method="get"
                                                action="${pageContext.request.contextPath}/asset/detail">
                                                <input type="hidden" name="id" value="${asset.assetId}">
                                                <div class="col-sm-5">
                                                    <div class="input-group input-group-sm">
                                                        <span class="input-group-text bg-white"><i class="bi bi-search text-muted"></i></span>
                                                        <input type="text" name="instanceKeyword" class="form-control"
                                                            placeholder="Tìm mã cá thể"
                                                            value="${instanceKeyword}">
                                                    </div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <select name="instanceStatus" class="form-select form-select-sm">
                                                        <option value="">-- Tất cả trạng thái --</option>
                                                        <option value="In_Stock" ${instanceStatus == 'In_Stock' ? 'selected' : ''}>Trong kho</option>
                                                        <option value="In_Use" ${instanceStatus == 'In_Use' ? 'selected' : ''}>Đang sử dụng</option>
                                                        <option value="Maintenance" ${instanceStatus == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                                                        <option value="Broken" ${instanceStatus == 'Broken' ? 'selected' : ''}>Hỏng</option>
                                                        <option value="Liquidated" ${instanceStatus == 'Liquidated' ? 'selected' : ''}>Thanh lý</option>
                                                        <option value="Lost" ${instanceStatus == 'Lost' ? 'selected' : ''}>Thất lạc</option>
                                                    </select>
                                                </div>
                                                <div class="col-sm-3 d-flex gap-1">
                                                    <button type="submit" class="btn btn-sm btn-primary">
                                                        <i class="bi bi-search me-1"></i>Lọc
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/asset/detail?id=${asset.assetId}"
                                                        class="btn btn-sm btn-outline-secondary">
                                                        <i class="bi bi-arrow-counterclockwise"></i>
                                                    </a>
                                                </div>
                                            </form>

                                            <c:choose>
                                                <c:when test="${not empty assetDetails}">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover mb-0">
                                                            <thead>
                                                                <tr>
                                                                    <th>#</th>
                                                                    <th>Mã cá thể</th>
                                                                    <th>Vị trí</th>
                                                                    <th>Trạng thái</th>
                                                                    <c:if
                                                                        test="${sessionScope.user.roleName == 'Asset Staff'}">
                                                                        <th>Thao tác</th>
                                                                    </c:if>
                                                                    <th>Lịch sử</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${assetDetails}" var="detail"
                                                                    varStatus="loop">
                                                                    <tr>
                                                                        <td>${(instancePage - 1) * 10 + loop.count}</td>
                                                                        <td><code>${detail.instanceCode}</code></td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty detail.room.roomName}">
                                                                                    <i
                                                                                        class="bi bi-geo-alt me-1 text-primary"></i>${detail.room.roomName}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="text-muted">Trong
                                                                                        kho</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${detail.status == 'In_Stock'}">
                                                                                    <span
                                                                                        class="cfms-badge cfms-badge-pending">Trong
                                                                                        kho</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${detail.status == 'In_Use'}">
                                                                                    <span
                                                                                        class="cfms-badge cfms-badge-approved">Đang
                                                                                        sử dụng</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${detail.status == 'Maintenance'}">
                                                                                    <span
                                                                                        class="cfms-badge cfms-badge-in-progress">Bảo
                                                                                        trì</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${detail.status == 'Broken'}">
                                                                                    <span
                                                                                        class="cfms-badge cfms-badge-rejected">Hỏng</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${detail.status == 'Liquidated'}">
                                                                                    <span
                                                                                        class="cfms-badge cfms-badge-completed">Thanh
                                                                                        lý</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${detail.status == 'Lost'}">
                                                                                    <span
                                                                                        class="cfms-badge cfms-badge-rejected">Thất
                                                                                        lạc</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span
                                                                                        class="cfms-badge">${detail.status}</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <!-- UC09: Nút đổi trạng thái (chỉ Asset Staff) -->
                                                                        <c:if
                                                                            test="${sessionScope.user.roleName == 'Asset Staff'}">
                                                                            <td>
                                                                                <c:if
                                                                                    test="${detail.status != 'Liquidated'}">
                                                                                    <form method="post"
                                                                                        action="${pageContext.request.contextPath}/asset/status"
                                                                                        class="d-flex gap-1 align-items-center">
                                                                                        <input type="hidden"
                                                                                            name="instanceId"
                                                                                            value="${detail.instanceId}">
                                                                                        <input type="hidden"
                                                                                            name="assetId"
                                                                                            value="${asset.assetId}">
                                                                                        <select name="status"
                                                                                            class="form-select form-select-sm"
                                                                                            style="width: auto; min-width: 140px;">
                                                                                            <c:if
                                                                                                test="${detail.status == 'In_Stock'}">
                                                                                                <option value="In_Use">
                                                                                                    Đưa vào sử dụng
                                                                                                </option>
                                                                                                <option value="Lost">
                                                                                                    Thất lạc / Mất
                                                                                                </option>
                                                                                            </c:if>
                                                                                            <c:if
                                                                                                test="${detail.status == 'In_Use'}">
                                                                                                <option
                                                                                                    value="Maintenance">
                                                                                                    Bảo trì</option>
                                                                                                <option value="Broken">
                                                                                                    Hỏng</option>
                                                                                                <option value="Lost">Báo
                                                                                                    mất</option>
                                                                                            </c:if>
                                                                                            <c:if
                                                                                                test="${detail.status == 'Maintenance'}">
                                                                                                <option value="In_Use">
                                                                                                    Hoàn thành sửa
                                                                                                </option>
                                                                                                <option value="Broken">
                                                                                                    Không sửa được
                                                                                                </option>
                                                                                                <option value="Lost">Báo
                                                                                                    mất</option>
                                                                                            </c:if>
                                                                                            <c:if
                                                                                                test="${detail.status == 'Broken'}">
                                                                                                <option
                                                                                                    value="Maintenance">
                                                                                                    Thử sửa lại</option>
                                                                                                <option value="Lost">Báo
                                                                                                    mất</option>
                                                                                            </c:if>
                                                                                            <c:if
                                                                                                test="${detail.status == 'Lost'}">
                                                                                                <option
                                                                                                    value="In_Stock">Đã
                                                                                                    tìm thấy (Nhập lại
                                                                                                    kho)</option>
                                                                                                <option value="Broken">
                                                                                                    Tìm thấy (Bị hỏng)
                                                                                                </option>
                                                                                                <option value="In_Use">
                                                                                                    Tìm thấy (Đưa lại
                                                                                                    phòng hiện tại)
                                                                                                </option>
                                                                                            </c:if>
                                                                                        </select>
                                                                                        <button type="submit"
                                                                                            class="btn btn-sm btn-outline-primary"
                                                                                            title="Cập nhật">
                                                                                            <i
                                                                                                class="bi bi-check-lg"></i>
                                                                                        </button>
                                                                                    </form>
                                                                                    <%-- UC10: Nút Thanh lý riêng (có
                                                                                        confirm) cho trạng thái Broken
                                                                                        --%>
                                                                                        <c:if
                                                                                            test="${detail.status == 'Broken'}">
                                                                                            <form method="post"
                                                                                                action="${pageContext.request.contextPath}/asset/delete"
                                                                                                class="d-inline ms-1"
                                                                                                onsubmit="return confirm('Bạn chắc chắn muốn THANH LÝ cá thể ${detail.instanceCode}? Hành động này không thể hoàn tác!');">
                                                                                                <input type="hidden"
                                                                                                    name="instanceId"
                                                                                                    value="${detail.instanceId}">
                                                                                                <input type="hidden"
                                                                                                    name="assetId"
                                                                                                    value="${asset.assetId}">
                                                                                                <button type="submit"
                                                                                                    class="btn btn-sm btn-outline-danger"
                                                                                                    title="Thanh lý">
                                                                                                    <i
                                                                                                        class="bi bi-trash me-1"></i>Thanh
                                                                                                    lý
                                                                                                </button>
                                                                                            </form>
                                                                                        </c:if>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${detail.status == 'Liquidated'}">
                                                                                    <span class="text-muted">–</span>
                                                                                </c:if>
                                                                            </td>
                                                                        </c:if>
                                                                        <td>
                                                                            <a href="${pageContext.request.contextPath}/asset/instance/history?instanceId=${detail.instanceId}" 
                                                                                class="btn btn-sm btn-outline-info" 
                                                                                title="Xem lịch sử trung chuyển">
                                                                                <i class="bi bi-clock-history"></i>
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <!-- Phân trang cá thể -->
                                                    <c:if test="${instanceTotalPages > 1}">
                                                        <%-- Xây dựng query string giữ lại filter --%>
                                                        <c:set var="instParams" value="" />
                                                        <c:if test="${not empty instanceKeyword}">
                                                            <c:set var="instParams" value="${instParams}&instanceKeyword=${instanceKeyword}" />
                                                        </c:if>
                                                        <c:if test="${not empty instanceStatus}">
                                                            <c:set var="instParams" value="${instParams}&instanceStatus=${instanceStatus}" />
                                                        </c:if>

                                                        <div class="d-flex justify-content-between align-items-center mt-3">
                                                            <small class="text-muted">
                                                                Trang <strong>${instancePage}</strong> / ${instanceTotalPages}
                                                                (${instanceTotal} cá thể)
                                                            </small>
                                                            <nav>
                                                                <ul class="pagination pagination-sm mb-0">
                                                                    <li class="page-item ${instancePage == 1 ? 'disabled' : ''}">
                                                                        <a class="page-link"
                                                                            href="${pageContext.request.contextPath}/asset/detail?id=${asset.assetId}&instancePage=${instancePage - 1}${instParams}">
                                                                            &laquo;
                                                                        </a>
                                                                    </li>
                                                                    <c:forEach begin="1" end="${instanceTotalPages}" var="i">
                                                                        <li class="page-item ${i == instancePage ? 'active' : ''}">
                                                                            <a class="page-link"
                                                                                href="${pageContext.request.contextPath}/asset/detail?id=${asset.assetId}&instancePage=${i}${instParams}">
                                                                                ${i}
                                                                            </a>
                                                                        </li>
                                                                    </c:forEach>
                                                                    <li class="page-item ${instancePage == instanceTotalPages ? 'disabled' : ''}">
                                                                        <a class="page-link"
                                                                            href="${pageContext.request.contextPath}/asset/detail?id=${asset.assetId}&instancePage=${instancePage + 1}${instParams}">
                                                                            &raquo;
                                                                        </a>
                                                                    </li>
                                                                </ul>
                                                            </nav>
                                                        </div>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-center text-muted py-3">
                                                        <i class="bi bi-inbox" style="font-size: 2rem;"></i>
                                                        <c:choose>
                                                            <c:when test="${not empty instanceKeyword || not empty instanceStatus}">
                                                                <p class="mt-2 mb-0">Không tìm thấy cá thể phù hợp.</p>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <p class="mt-2 mb-0">Chưa có cá thể nào.</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- ========== CỘT PHẢI: Giá trị + Trạng thái ========== -->
                                    <div class="col-lg-4">
                                        <div class="detail-card">
                                            <h5><i class="bi bi-currency-dollar me-2"></i>Giá trị & bảo hành</h5>

                                            <div class="detail-row">
                                                <div class="detail-label">Giá trị</div>
                                                <div class="detail-value">
                                                    <strong class="text-primary">
                                                        <fmt:formatNumber value="${asset.price}" type="number"
                                                            groupingUsed="true" />₫
                                                    </strong>
                                                </div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Ngày mua</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${asset.purchaseDate != null}">
                                                            <fmt:formatDate value="${asset.purchaseDate}"
                                                                pattern="dd/MM/yyyy" />
                                                        </c:when>
                                                        <c:otherwise>–</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Hết bảo hành</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${asset.warrantyExpiryDate != null}">
                                                            <fmt:formatDate value="${asset.warrantyExpiryDate}"
                                                                pattern="dd/MM/yyyy" />
                                                        </c:when>
                                                        <c:otherwise>–</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="detail-row">
                                                <div class="detail-label">Ngày tạo</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${asset.createdAt != null}">
                                                            <fmt:formatDate value="${asset.createdAt}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </c:when>
                                                        <c:otherwise>–</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Phân bổ trạng thái -->
                                        <div class="detail-card">
                                            <h5><i class="bi bi-pie-chart me-2"></i>Phân bổ trạng thái</h5>

                                            <div class="detail-row">
                                                <div class="detail-label">Tổng cá thể</div>
                                                <div class="detail-value"><strong>${asset.instanceTotal}</strong></div>
                                            </div>
                                            <c:if test="${asset.countAvailableInStock > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-pending">Trong kho</span>
                                                    </div>
                                                    <div class="detail-value">
                                                        <strong>${asset.countAvailableInStock}</strong></div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countInUse > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-approved">Đang sử dụng</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countInUse}</strong></div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countMaintenance > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-in-progress">Bảo trì</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countMaintenance}</strong>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countBroken > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-rejected">Hỏng</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countBroken}</strong>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countLiquidated > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-completed">Thanh lý</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countLiquidated}</strong>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countLost > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-rejected">Thất lạc</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countLost}</strong></div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                            </main>
                        </div>
                    </div>

                    <!-- ===== Lightbox (Xem ảnh phóng to) ===== -->
                    <div class="lightbox-overlay" id="lightbox">
                        <button class="lightbox-close" onclick="closeLightbox()">&times;</button>
                        <button class="lightbox-nav lightbox-prev" onclick="navLightbox(-1)">
                            <i class="bi bi-chevron-left"></i>
                        </button>
                        <img id="lightboxImg" src="" alt="Preview">
                        <button class="lightbox-nav lightbox-next" onclick="navLightbox(1)">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>

                    <jsp:include page="../components/footer.jsp" />

                    <!-- ===== JavaScript: Lightbox ===== -->
                    <script>
                        // Thu thập tất cả URL ảnh từ gallery
                        const imageUrls = [];
                        <c:forEach items="${assetImages}" var="img">
                            imageUrls.push('${pageContext.request.contextPath}/${img.imageUrl}');
                        </c:forEach>

                        let currentIndex = 0;
                        const lightbox = document.getElementById('lightbox');
                        const lightboxImg = document.getElementById('lightboxImg');

                        function openLightbox(index) {
                            currentIndex = index;
                            lightboxImg.src = imageUrls[currentIndex];
                            lightbox.classList.add('active');
                            document.body.style.overflow = 'hidden';
                        }

                        function closeLightbox() {
                            lightbox.classList.remove('active');
                            document.body.style.overflow = '';
                        }

                        function navLightbox(direction) {
                            currentIndex += direction;
                            if (currentIndex < 0) currentIndex = imageUrls.length - 1;
                            if (currentIndex >= imageUrls.length) currentIndex = 0;
                            lightboxImg.src = imageUrls[currentIndex];
                        }

                        // Đóng lightbox khi nhấn ESC hoặc click overlay
                        document.addEventListener('keydown', function (e) {
                            if (!lightbox.classList.contains('active')) return;
                            if (e.key === 'Escape') closeLightbox();
                            if (e.key === 'ArrowLeft') navLightbox(-1);
                            if (e.key === 'ArrowRight') navLightbox(1);
                        });

                        lightbox.addEventListener('click', function (e) {
                            if (e.target === lightbox) closeLightbox();
                        });
                    </script>

                </body>

                </html>