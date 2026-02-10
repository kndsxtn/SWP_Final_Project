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
                                                <div class="detail-label">Vị trí hiện tại</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${asset.room != null}">
                                                            <i
                                                                class="bi bi-geo-alt me-1 text-primary"></i>${asset.room.roomName}
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">Trong kho</span>
                                                        </c:otherwise>
                                                    </c:choose>
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

                                        <!-- Trạng thái -->
                                        <div class="detail-card">
                                            <h5><i class="bi bi-flag me-2"></i>Trạng thái</h5>

                                            <div class="text-center mb-3">
                                                <c:choose>
                                                    <c:when test="${asset.status == 'New'}">
                                                        <span
                                                            class="cfms-badge cfms-badge-pending fs-6 px-4 py-2">Mới</span>
                                                    </c:when>
                                                    <c:when test="${asset.status == 'In_Use'}">
                                                        <span class="cfms-badge cfms-badge-approved fs-6 px-4 py-2">Đang
                                                            sử dụng</span>
                                                    </c:when>
                                                    <c:when test="${asset.status == 'Maintenance'}">
                                                        <span
                                                            class="cfms-badge cfms-badge-in-progress fs-6 px-4 py-2">Bảo
                                                            trì</span>
                                                    </c:when>
                                                    <c:when test="${asset.status == 'Broken'}">
                                                        <span
                                                            class="cfms-badge cfms-badge-rejected fs-6 px-4 py-2">Hỏng</span>
                                                    </c:when>
                                                    <c:when test="${asset.status == 'Liquidated'}">
                                                        <span
                                                            class="cfms-badge cfms-badge-completed fs-6 px-4 py-2">Thanh
                                                            lý</span>
                                                    </c:when>
                                                    <c:when test="${asset.status == 'Lost'}">
                                                        <span class="cfms-badge cfms-badge-rejected fs-6 px-4 py-2">Thất
                                                            lạc</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>

                                            <!-- Nút đổi trạng thái (UC09 - chỉ Asset Staff) -->
                                            <c:if
                                                test="${sessionScope.user.roleName == 'Asset Staff' && asset.status != 'Liquidated'}">
                                                <div class="status-actions justify-content-center">
                                                    <c:if test="${asset.status == 'New'}">
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/asset/status"
                                                            class="d-inline">
                                                            <input type="hidden" name="assetId"
                                                                value="${asset.assetId}">
                                                            <input type="hidden" name="status" value="In_Use">
                                                            <button class="btn btn-sm btn-outline-success">
                                                                <i class="bi bi-play-circle me-1"></i>Đưa vào sử dụng
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${asset.status == 'In_Use'}">
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/asset/status"
                                                            class="d-inline">
                                                            <input type="hidden" name="assetId"
                                                                value="${asset.assetId}">
                                                            <input type="hidden" name="status" value="Maintenance">
                                                            <button class="btn btn-sm btn-outline-warning">
                                                                <i class="bi bi-tools me-1"></i>Bảo trì
                                                            </button>
                                                        </form>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/asset/status"
                                                            class="d-inline">
                                                            <input type="hidden" name="assetId"
                                                                value="${asset.assetId}">
                                                            <input type="hidden" name="status" value="Broken">
                                                            <button class="btn btn-sm btn-outline-danger">
                                                                <i class="bi bi-x-circle me-1"></i>Hỏng
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${asset.status == 'Maintenance'}">
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/asset/status"
                                                            class="d-inline">
                                                            <input type="hidden" name="assetId"
                                                                value="${asset.assetId}">
                                                            <input type="hidden" name="status" value="In_Use">
                                                            <button class="btn btn-sm btn-outline-success">
                                                                <i class="bi bi-check-lg me-1"></i>Hoàn thành sửa
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${asset.status == 'Broken'}">
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/asset/delete"
                                                            class="d-inline"
                                                            onsubmit="return confirm('Bạn chắc chắn muốn thanh lý tài sản này?');">
                                                            <input type="hidden" name="assetId"
                                                                value="${asset.assetId}">
                                                            <button class="btn btn-sm btn-outline-dark">
                                                                <i class="bi bi-trash me-1"></i>Thanh lý
                                                            </button>
                                                        </form>
                                                    </c:if>
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