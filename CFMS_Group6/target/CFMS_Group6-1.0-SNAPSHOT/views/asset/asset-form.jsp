<%-- Document : asset-form.jsp Description: UC05 (Thêm mới) & UC08 (Cập nhật) tài sản - hỗ trợ upload ảnh Author : Vũ
    Quang Hiếu --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        ${formAction == 'update' ? 'Cập nhật' : 'Thêm mới'} tài sản - CFMS
                    </title>

                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

                    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">

                    <link href="${pageContext.request.contextPath}/css/form.css" rel="stylesheet">
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
                                    <h2>
                                        <i
                                            class="bi bi-${formAction == 'update' ? 'pencil-square' : 'plus-circle'} me-2"></i>
                                        ${formAction == 'update' ? 'Cập nhật' : 'Thêm mới'} tài sản
                                    </h2>
                                    <a href="${pageContext.request.contextPath}/asset/list"
                                        class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>Quay lại
                                    </a>
                                </div>

                                <!-- Error message -->
                                <c:if test="${not empty errorMsg}">
                                    <div class="cfms-msg cfms-msg-error">
                                        <i class="bi bi-exclamation-triangle-fill"></i> ${errorMsg}
                                    </div>
                                </c:if>

                                <!-- ===== Form (multipart/form-data để upload ảnh) ===== -->
                                <form method="post" enctype="multipart/form-data"
                                    action="${pageContext.request.contextPath}/asset/${formAction}">

                                    <!-- Hidden ID khi update -->
                                    <c:if test="${formAction == 'update'}">
                                        <input type="hidden" name="assetId" value="${asset.assetId}">
                                    </c:if>

                                    <div class="row">
                                        <!-- ========== CỘT TRÁI: Thông tin cơ bản ========== -->
                                        <div class="col-lg-8">
                                            <div class="form-card">
                                                <h5><i class="bi bi-card-list me-2"></i>Thông tin cơ bản</h5>

                                                <!-- Mã tài sản (chỉ hiện khi update) -->
                                                <c:if test="${formAction == 'update'}">
                                                    <div class="mb-3">
                                                        <label class="form-label">Mã tài sản</label>
                                                        <input type="text" class="form-control"
                                                            value="${asset.assetCode}" readonly disabled>
                                                        <small class="text-muted">Mã tài sản không thể thay đổi.</small>
                                                    </div>
                                                </c:if>

                                                <div class="mb-3">
                                                    <label for="assetName" class="form-label required">Tên tài
                                                        sản</label>
                                                    <input type="text" id="assetName" name="assetName"
                                                        class="form-control" required
                                                        placeholder="VD: Dell Latitude 5540"
                                                        value="${asset != null ? asset.assetName : ''}">
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label for="categoryId" class="form-label required">Danh
                                                            mục</label>
                                                        <select id="categoryId" name="categoryId" class="form-select"
                                                            required>
                                                            <option value="">-- Chọn danh mục --</option>
                                                            <c:forEach items="${categories}" var="cat">
                                                                <option value="${cat.categoryId}" ${asset !=null &&
                                                                    asset.categoryId==cat.categoryId ? 'selected' : ''
                                                                    }>
                                                                    ${cat.categoryName} (${cat.prefixCode})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <c:if test="${formAction == 'create'}">
                                                            <small class="text-muted">
                                                                Mã tài sản sẽ được tự động sinh theo danh mục.
                                                            </small>
                                                        </c:if>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label for="supplierId" class="form-label">Nhà cung cấp</label>
                                                        <select id="supplierId" name="supplierId" class="form-select">
                                                            <option value="0">-- Không chọn --</option>
                                                            <c:forEach items="${suppliers}" var="sup">
                                                                <option value="${sup.supplierId}" ${asset !=null &&
                                                                    asset.supplierId==sup.supplierId ? 'selected' : ''
                                                                    }>
                                                                    ${sup.supplierName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="roomId" class="form-label">Vị trí (Phòng)</label>
                                                    <select id="roomId" name="roomId" class="form-select">
                                                        <option value="0">-- Trong kho (chưa cấp phát) --</option>
                                                        <c:forEach items="${rooms}" var="room">
                                                            <option value="${room.roomId}" ${asset !=null &&
                                                                asset.roomId==room.roomId ? 'selected' : '' }>
                                                                ${room.roomName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="mb-3">
                                                    <label for="description" class="form-label">Mô tả</label>
                                                    <textarea id="description" name="description" class="form-control"
                                                        rows="3"
                                                        placeholder="Ghi chú thêm về tài sản...">${asset != null ? asset.description : ''}</textarea>
                                                </div>
                                            </div>

                                            <!-- ========== UPLOAD ẢNH ========== -->
                                            <div class="form-card">
                                                <h5><i class="bi bi-images me-2"></i>Hình ảnh tài sản</h5>

                                                <!-- Ảnh đã có (chỉ hiện khi update) -->
                                                <c:if test="${formAction == 'update' && not empty assetImages}">
                                                    <p class="text-muted mb-2">
                                                        <i class="bi bi-check-circle text-success me-1"></i>
                                                        Ảnh hiện tại (${assetImages.size()})
                                                    </p>
                                                    <div class="current-images">
                                                        <c:forEach items="${assetImages}" var="img">
                                                            <div class="current-img-item">
                                                                <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                                    alt="Asset image">
                                                                <div class="delete-overlay">
                                                                    <form method="post"
                                                                        action="${pageContext.request.contextPath}/asset/deleteImage"
                                                                        onsubmit="return confirm('Xóa ảnh này?');">
                                                                        <input type="hidden" name="imageId"
                                                                            value="${img.imageId}">
                                                                        <input type="hidden" name="assetId"
                                                                            value="${asset.assetId}">
                                                                        <button type="submit"
                                                                            class="btn btn-sm btn-danger">
                                                                            <i class="bi bi-trash"></i> Xóa
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    <hr>
                                                </c:if>

                                                <!-- Upload ảnh mới -->
                                                <label class="form-label">Thêm ảnh mới</label>
                                                <div class="upload-zone" id="uploadZone"
                                                    onclick="document.getElementById('fileInput').click();">
                                                    <i class="bi bi-cloud-arrow-up"></i>
                                                    <p>Kéo thả ảnh vào đây hoặc <strong>nhấn để chọn</strong></p>
                                                    <small class="text-muted">Chấp nhận JPG, PNG, WEBP. Tối đa
                                                        5MB/ảnh.</small>
                                                </div>

                                                <input type="file" id="fileInput" name="assetImages" accept="image/*"
                                                    multiple hidden>

                                                <!-- Preview ảnh đã chọn -->
                                                <div class="preview-grid" id="previewGrid"></div>
                                            </div>
                                        </div>

                                        <!-- ========== CỘT PHẢI: Giá trị & Submit ========== -->
                                        <div class="col-lg-4">
                                            <div class="form-card">
                                                <h5><i class="bi bi-currency-dollar me-2"></i>Giá trị & bảo hành</h5>

                                                <div class="mb-3">
                                                    <label for="price" class="form-label required">Giá trị (VNĐ)</label>
                                                    <input type="number" id="price" name="price" class="form-control"
                                                        required min="0" step="1000" placeholder="0"
                                                        value="${asset != null ? asset.price : ''}">
                                                </div>

                                                <div class="mb-3">
                                                    <label for="purchaseDate" class="form-label">Ngày mua</label>
                                                    <input type="date" id="purchaseDate" name="purchaseDate"
                                                        class="form-control"
                                                        value="<c:if test='${asset != null && asset.purchaseDate != null}'><fmt:formatDate value='${asset.purchaseDate}' pattern='yyyy-MM-dd' /></c:if>">
                                                </div>

                                                <div class="mb-3">
                                                    <label for="warrantyExpiryDate" class="form-label">Ngày hết bảo
                                                        hành</label>
                                                    <input type="date" id="warrantyExpiryDate" name="warrantyExpiryDate"
                                                        class="form-control"
                                                        value="<c:if test='${asset != null && asset.warrantyExpiryDate != null}'><fmt:formatDate value='${asset.warrantyExpiryDate}' pattern='yyyy-MM-dd' /></c:if>">
                                                </div>
                                            </div>

                                            <!-- Submit buttons -->
                                            <div class="form-card text-center">
                                                <button type="submit" class="btn btn-primary w-100 mb-2">
                                                    <i class="bi bi-check-lg me-1"></i>
                                                    ${formAction == 'update' ? 'Lưu thay đổi' : 'Thêm tài sản'}
                                                </button>
                                                <a href="${pageContext.request.contextPath}/asset/list"
                                                    class="btn btn-outline-secondary w-100">
                                                    Hủy
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </form>

                            </main>
                        </div>
                    </div>

                    <jsp:include page="../components/footer.jsp" />

                    <!-- ===== JavaScript: Preview ảnh & Drag-Drop ===== -->
                    <script>
                        const fileInput = document.getElementById('fileInput');
                        const previewGrid = document.getElementById('previewGrid');
                        const uploadZone = document.getElementById('uploadZone');

                        // Lưu DataTransfer để quản lý danh sách file
                        let dt = new DataTransfer();

                        // Khi chọn file
                        fileInput.addEventListener('change', function () {
                            for (let file of this.files) {
                                dt.items.add(file);
                            }
                            fileInput.files = dt.files;
                            renderPreviews();
                        });

                        // Drag & Drop
                        uploadZone.addEventListener('dragover', function (e) {
                            e.preventDefault();
                            this.classList.add('drag-over');
                        });
                        uploadZone.addEventListener('dragleave', function () {
                            this.classList.remove('drag-over');
                        });
                        uploadZone.addEventListener('drop', function (e) {
                            e.preventDefault();
                            this.classList.remove('drag-over');
                            for (let file of e.dataTransfer.files) {
                                if (file.type.startsWith('image/')) {
                                    dt.items.add(file);
                                }
                            }
                            fileInput.files = dt.files;
                            renderPreviews();
                        });

                        // Render preview thumbnails
                        function renderPreviews() {
                            previewGrid.innerHTML = '';
                            Array.from(dt.files).forEach((file, idx) => {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    const div = document.createElement('div');
                                    div.className = 'preview-item';
                                    div.innerHTML =
                                        '<img src="' + e.target.result + '" alt="preview">' +
                                        '<button type="button" class="remove-btn" data-index="' + idx + '">&times;</button>';
                                    previewGrid.appendChild(div);

                                    // Nút xóa ảnh khỏi preview
                                    div.querySelector('.remove-btn').addEventListener('click', function () {
                                        removeFile(parseInt(this.dataset.index));
                                    });
                                };
                                reader.readAsDataURL(file);
                            });
                        }

                        // Xóa 1 file khỏi DataTransfer
                        function removeFile(index) {
                            const newDt = new DataTransfer();
                            Array.from(dt.files).forEach((file, i) => {
                                if (i !== index) newDt.items.add(file);
                            });
                            dt = newDt;
                            fileInput.files = dt.files;
                            renderPreviews();
                        }
                    </script>

                </body>

                </html>