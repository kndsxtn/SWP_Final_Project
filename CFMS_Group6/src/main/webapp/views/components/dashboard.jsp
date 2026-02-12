<%-- Document : dashboard.jsp Description: Trang tổng quan chung - hiển thị nội dung theo role Author : Nguyen Dang
    Khang, Vũ Quang Hiếu --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tổng quan - CFMS</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

                <!-- Dashboard specific style -->
                <style>
                    /* ─── Stat Cards ─── */
                    .stat-card {
                        background: #fff;
                        border: 1px solid #e9ecef;
                        border-radius: 12px;
                        padding: 24px;
                        transition: transform 0.2s, box-shadow 0.2s;
                        height: 100%;
                    }

                    .stat-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                    }

                    .stat-card .stat-icon {
                        width: 48px;
                        height: 48px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.4rem;
                    }

                    .stat-card .stat-value {
                        font-size: 2rem;
                        font-weight: 700;
                        line-height: 1;
                        margin-top: 12px;
                    }

                    .stat-card .stat-label {
                        font-size: 0.85rem;
                        color: #6c757d;
                        margin-top: 4px;
                    }

                    .icon-primary {
                        background: #e8f0fe;
                        color: #1a73e8;
                    }

                    .icon-success {
                        background: #e6f4ea;
                        color: #1e8e3e;
                    }

                    .icon-warning {
                        background: #fef7e0;
                        color: #f9ab00;
                    }

                    .icon-danger {
                        background: #fce8e6;
                        color: #d93025;
                    }

                    .icon-info {
                        background: #e8f5fd;
                        color: #0288d1;
                    }

                    .icon-secondary {
                        background: #f1f3f4;
                        color: #5f6368;
                    }

                    /* ─── Section headings ─── */
                    .section-heading {
                        font-size: 1rem;
                        font-weight: 600;
                        color: #5f6368;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        margin: 32px 0 16px;
                        padding-bottom: 8px;
                        border-bottom: 2px solid #e9ecef;
                    }

                    /* ─── Quick link cards ─── */
                    .quick-link {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 16px 20px;
                        background: #fff;
                        border: 1px solid #e9ecef;
                        border-radius: 10px;
                        text-decoration: none;
                        color: #333;
                        transition: all 0.2s;
                    }

                    .quick-link:hover {
                        border-color: #1a73e8;
                        color: #1a73e8;
                        box-shadow: 0 2px 8px rgba(26, 115, 232, 0.12);
                    }

                    .quick-link i {
                        font-size: 1.3rem;
                        width: 36px;
                        height: 36px;
                        border-radius: 8px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: #e8f0fe;
                        color: #1a73e8;
                    }

                    .quick-link span {
                        font-weight: 500;
                    }

                    /* ─── Welcome banner ─── */
                    .welcome-banner {
                        background: linear-gradient(135deg, #1a73e8 0%, #4285f4 100%);
                        color: #fff;
                        border-radius: 14px;
                        padding: 28px 32px;
                        margin-bottom: 28px;
                    }

                    .welcome-banner h3 {
                        font-weight: 600;
                        margin-bottom: 4px;
                    }

                    .welcome-banner p {
                        opacity: 0.9;
                        margin-bottom: 0;
                    }
                </style>
            </head>

            <body class="d-flex flex-column">

                <jsp:include page="../components/header.jsp"></jsp:include>

                <div class="container-fluid flex-grow-1">
                    <div class="row h-100">

                        <jsp:include page="../components/sidebar.jsp">
                            <jsp:param name="page" value="home" />
                        </jsp:include>

                        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                            <c:set var="role" value="${sessionScope.user.roleName}" />

                            <!-- ===== Welcome Banner ===== -->
                            <div class="welcome-banner mt-3">
                                <h3>Xin chào, ${sessionScope.user.fullName}!</h3>
                                <p>
                                    <c:choose>
                                        <c:when test="${role == 'Admin'}">Bạn đang quản trị hệ thống CFMS.</c:when>
                                        <c:when test="${role == 'Principal'}">Chào mừng Hiệu trưởng. Dưới đây là tổng
                                            quan hệ thống.</c:when>
                                        <c:when test="${role == 'Vice Principal'}">Chào mừng Phó Hiệu trưởng. Dưới đây
                                            là tổng quan hệ thống.</c:when>
                                        <c:when test="${role == 'Finance Head'}">Tổng quan tình hình tài sản và phiếu
                                            chờ duyệt.</c:when>
                                        <c:when test="${role == 'Asset Staff'}">Tổng quan công việc quản lý tài sản hôm
                                            nay.</c:when>
                                        <c:when test="${role == 'Head of Dept'}">Tổng quan tài sản và yêu cầu bộ môn của
                                            bạn.</c:when>
                                        <c:otherwise>Chào mừng bạn quay trở lại hệ thống.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <!-- ═════════════════════════════════════════════════════
                     ADMIN
                ══════════════════════════════════════════════════════ -->
                            <c:if test="${role == 'Admin'}">
                                <h6 class="section-heading">Quản trị hệ thống</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-primary"><i class="bi bi-people"></i></div>
                                            <div class="stat-value">${totalAssets}</div>
                                            <div class="stat-label">Tổng tài sản</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-info"><i class="bi bi-tags"></i></div>
                                            <div class="stat-value">${totalCategories}</div>
                                            <div class="stat-label">Danh mục</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-secondary"><i class="bi bi-door-open"></i></div>
                                            <div class="stat-value">${totalRooms}</div>
                                            <div class="stat-label">Phòng</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Quick links -->
                                <h6 class="section-heading">Truy cập nhanh</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/admin/user-list" class="quick-link">
                                            <i class="bi bi-people"></i>
                                            <span>Quản lý người dùng</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/admin/role-list" class="quick-link">
                                            <i class="bi bi-shield-lock"></i>
                                            <span>Quản lý vai trò</span>
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                            <!-- ═════════════════════════════════════════════════════
                     ASSET STAFF (Nhân viên quản lý tài sản)
                ══════════════════════════════════════════════════════ -->
                            <c:if test="${role == 'Asset Staff'}">

                                <!-- Thống kê tài sản -->
                                <h6 class="section-heading">Tổng quan tài sản</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-primary"><i class="bi bi-box-seam"></i></div>
                                            <div class="stat-value">${totalAssets}</div>
                                            <div class="stat-label">Tổng tài sản</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-success"><i class="bi bi-check-circle"></i></div>
                                            <div class="stat-value">${assetsInUse}</div>
                                            <div class="stat-label">Đang sử dụng</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-info"><i class="bi bi-archive"></i></div>
                                            <div class="stat-value">${assetsNew}</div>
                                            <div class="stat-label">Trong kho (Mới)</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-warning"><i class="bi bi-tools"></i></div>
                                            <div class="stat-value">${assetsMaintenance}</div>
                                            <div class="stat-label">Đang bảo trì</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Công việc chờ xử lý -->
                                <h6 class="section-heading">Chờ xử lý</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-warning"><i class="bi bi-inbox"></i></div>
                                            <div class="stat-value">${pendingAllocations}</div>
                                            <div class="stat-label">Yêu cầu cấp phát</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-info"><i class="bi bi-arrow-left-right"></i>
                                            </div>
                                            <div class="stat-value">${pendingTransfers}</div>
                                            <div class="stat-label">Phiếu điều chuyển</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-danger"><i class="bi bi-wrench"></i></div>
                                            <div class="stat-value">${pendingMaintenance}</div>
                                            <div class="stat-label">Yêu cầu bảo trì</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Quick links -->
                                <h6 class="section-heading">Truy cập nhanh</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/asset/list" class="quick-link">
                                            <i class="bi bi-pc-display-horizontal"></i>
                                            <span>Danh sách tài sản</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/request/allocation-list"
                                            class="quick-link">
                                            <i class="bi bi-inbox"></i>
                                            <span>Yêu cầu cấp phát</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/category/list" class="quick-link">
                                            <i class="bi bi-tags"></i>
                                            <span>Danh mục tài sản</span>
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                            <!-- ═════════════════════════════════════════════════════
                     FINANCE HEAD (Trưởng phòng TC-KT)
                ══════════════════════════════════════════════════════ -->
                            <c:if test="${role == 'Finance Head'}">

                                <h6 class="section-heading">Tổng quan tài sản</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-primary"><i class="bi bi-box-seam"></i></div>
                                            <div class="stat-value">${totalAssets}</div>
                                            <div class="stat-label">Tổng tài sản</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-success"><i class="bi bi-check-circle"></i></div>
                                            <div class="stat-value">${assetsInUse}</div>
                                            <div class="stat-label">Đang sử dụng</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-danger"><i
                                                    class="bi bi-exclamation-triangle"></i></div>
                                            <div class="stat-value">${assetsBroken}</div>
                                            <div class="stat-label">Hỏng</div>
                                        </div>
                                    </div>
                                </div>

                                <h6 class="section-heading">Chờ duyệt</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-warning"><i class="bi bi-inbox"></i></div>
                                            <div class="stat-value">${pendingAllocations}</div>
                                            <div class="stat-label">Yêu cầu cấp phát</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-info"><i class="bi bi-arrow-left-right"></i>
                                            </div>
                                            <div class="stat-value">${pendingTransfers}</div>
                                            <div class="stat-label">Phiếu điều chuyển</div>
                                        </div>
                                    </div>
                                </div>

                                <h6 class="section-heading">Truy cập nhanh</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/asset/list" class="quick-link">
                                            <i class="bi bi-pc-display-horizontal"></i>
                                            <span>Danh sách tài sản</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/request/allocation-list"
                                            class="quick-link">
                                            <i class="bi bi-inbox"></i>
                                            <span>Yêu cầu cấp phát</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/transfer/list" class="quick-link">
                                            <i class="bi bi-arrow-left-right"></i>
                                            <span>Phiếu điều chuyển</span>
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                            <!-- ═════════════════════════════════════════════════════
                     PRINCIPAL / VICE PRINCIPAL (Hiệu trưởng / Phó HT)
                ══════════════════════════════════════════════════════ -->
                            <c:if test="${role == 'Principal' || role == 'Vice Principal'}">

                                <h6 class="section-heading">Tổng quan hệ thống</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-primary"><i class="bi bi-box-seam"></i></div>
                                            <div class="stat-value">${totalAssets}</div>
                                            <div class="stat-label">Tổng tài sản</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-info"><i class="bi bi-tags"></i></div>
                                            <div class="stat-value">${totalCategories}</div>
                                            <div class="stat-label">Danh mục</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-success"><i class="bi bi-check-circle"></i></div>
                                            <div class="stat-value">${assetsInUse}</div>
                                            <div class="stat-label">Đang sử dụng</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-danger"><i
                                                    class="bi bi-exclamation-triangle"></i></div>
                                            <div class="stat-value">${assetsBroken}</div>
                                            <div class="stat-label">Hỏng</div>
                                        </div>
                                    </div>
                                </div>

                                <h6 class="section-heading">Truy cập nhanh</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/request/procurement-list"
                                            class="quick-link">
                                            <i class="bi bi-clipboard-check"></i>
                                            <span>Duyệt mua sắm</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/report/dashboard"
                                            class="quick-link">
                                            <i class="bi bi-bar-chart-line"></i>
                                            <span>Tổng quan báo cáo</span>
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                            <!-- ═════════════════════════════════════════════════════
                     HEAD OF DEPT (Trưởng bộ môn)
                ══════════════════════════════════════════════════════ -->
                            <c:if test="${role == 'Head of Dept'}">

                                <h6 class="section-heading">Bộ môn của tôi</h6>
                                <div class="row g-3 mb-3">
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-primary"><i
                                                    class="bi bi-pc-display-horizontal"></i></div>
                                            <div class="stat-value">${deptAssets != null ? deptAssets : 0}</div>
                                            <div class="stat-label">Tài sản bộ môn</div>
                                        </div>
                                    </div>
                                    <div class="col-6 col-lg-3">
                                        <div class="stat-card">
                                            <div class="stat-icon icon-info"><i class="bi bi-send"></i></div>
                                            <div class="stat-value">${myAllocations != null ? myAllocations : 0}</div>
                                            <div class="stat-label">Yêu cầu đã gửi</div>
                                        </div>
                                    </div>
                                </div>

                                <h6 class="section-heading">Truy cập nhanh</h6>
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/request/allocation-add"
                                            class="quick-link">
                                            <i class="bi bi-plus-square"></i>
                                            <span>Tạo yêu cầu cấp phát</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/request/allocation-list"
                                            class="quick-link">
                                            <i class="bi bi-send"></i>
                                            <span>Yêu cầu của tôi</span>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/asset/dept" class="quick-link">
                                            <i class="bi bi-pc-display-horizontal"></i>
                                            <span>Tài sản bộ môn</span>
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                        </main>

                    </div>
                </div>

                <jsp:include page="../components/footer.jsp"></jsp:include>

            </body>

            </html>