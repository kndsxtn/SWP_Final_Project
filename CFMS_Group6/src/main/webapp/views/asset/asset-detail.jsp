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
                                                                onclick="openLightbox(${idx.index})">
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
                                                <c:if test="${not empty assetDetails}">
                                                    <span class="badge bg-primary ms-2">${assetDetails.size()}</span>
                                                </c:if>
                                            </h5>

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
                                                                    <c:if test="${sessionScope.user.roleName == 'Asset Staff'}">
                                                                        <th>Thao tác</th>
                                                                    </c:if>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${assetDetails}" var="detail" varStatus="loop">
                                                                    <tr>
                                                                        <td>${loop.count}</td>
                                                                        <td><code>${detail.instanceCode}</code></td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when test="${not empty detail.room.roomName}">
                                                                                    <i class="bi bi-geo-alt me-1 text-primary"></i>${detail.room.roomName}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="text-muted">Trong kho</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when test="${detail.status == 'In_Stock'}">
                                                                                    <span class="cfms-badge cfms-badge-pending">Trong kho</span>
                                                                                </c:when>
                                                                                <c:when test="${detail.status == 'In_Use'}">
                                                                                    <span class="cfms-badge cfms-badge-approved">Đang sử dụng</span>
                                                                                </c:when>
                                                                                <c:when test="${detail.status == 'Maintenance'}">
                                                                                    <span class="cfms-badge cfms-badge-in-progress">Bảo trì</span>
                                                                                </c:when>
                                                                                <c:when test="${detail.status == 'Broken'}">
                                                                                    <span class="cfms-badge cfms-badge-rejected">Hỏng</span>
                                                                                </c:when>
                                                                                <c:when test="${detail.status == 'Liquidated'}">
                                                                                    <span class="cfms-badge cfms-badge-completed">Thanh lý</span>
                                                                                </c:when>
                                                                                <c:when test="${detail.status == 'Lost'}">
                                                                                    <span class="cfms-badge cfms-badge-rejected">Thất lạc</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="cfms-badge">${detail.status}</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <!-- UC09: Nút đổi trạng thái (chỉ Asset Staff) -->
                                                                        <c:if test="${sessionScope.user.roleName == 'Asset Staff'}">
                                                                            <td>
                                                                                <c:if test="${detail.status != 'Liquidated' && detail.status != 'Lost'}">
                                                                                    <form method="post" action="${pageContext.request.contextPath}/asset/status" class="d-flex gap-1 align-items-center">
                                                                                        <input type="hidden" name="instanceId" value="${detail.instanceId}">
                                                                                        <input type="hidden" name="assetId" value="${asset.assetId}">
                                                                                        <select name="status" class="form-select form-select-sm" style="width: auto; min-width: 140px;">
                                                                                            <c:if test="${detail.status == 'In_Stock'}">
                                                                                                <option value="In_Use">Đưa vào sử dụng</option>
                                                                                            </c:if>
                                                                                            <c:if test="${detail.status == 'In_Use'}">
                                                                                                <option value="Maintenance">Bảo trì</option>
                                                                                                <option value="Broken">Hỏng</option>
                                                                                            </c:if>
                                                                                            <c:if test="${detail.status == 'Maintenance'}">
                                                                                                <option value="In_Use">Hoàn thành sửa</option>
                                                                                                <option value="Broken">Không sửa được</option>
                                                                                            </c:if>
                                                                                            <c:if test="${detail.status == 'Broken'}">
                                                                                                <option value="Maintenance">Thử sửa lại</option>
                                                                                                <option value="Liquidated">Thanh lý</option>
                                                                                            </c:if>
                                                                                        </select>
                                                                                        <button type="submit" class="btn btn-sm btn-outline-primary" title="Cập nhật">
                                                                                            <i class="bi bi-check-lg"></i>
                                                                                        </button>
                                                                                    </form>
                                                                                </c:if>
                                                                                <c:if test="${detail.status == 'Liquidated' || detail.status == 'Lost'}">
                                                                                    <span class="text-muted">–</span>
                                                                                </c:if>
                                                                            </td>
                                                                        </c:if>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-center text-muted py-3">
                                                        <i class="bi bi-inbox" style="font-size: 2rem;"></i>
                                                        <p class="mt-2 mb-0">Chưa có cá thể nào.</p>
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
                                                    <div class="detail-value"><strong>${asset.countAvailableInStock}</strong></div>
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
                                                    <div class="detail-value"><strong>${asset.countMaintenance}</strong></div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countBroken > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-rejected">Hỏng</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countBroken}</strong></div>
                                                </div>
                                            </c:if>
                                            <c:if test="${asset.countLiquidated > 0}">
                                                <div class="detail-row">
                                                    <div class="detail-label">
                                                        <span class="cfms-badge cfms-badge-completed">Thanh lý</span>
                                                    </div>
                                                    <div class="detail-value"><strong>${asset.countLiquidated}</strong></div>
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