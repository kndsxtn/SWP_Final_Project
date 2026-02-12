<%--
    Document   : sidebar.jsp
    Created on : Feb 4, 2026, 4:32:50 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">

<c:set var="role" value="${sessionScope.user.roleName}" />

<nav id="sidebarMenu" class="cfms-sidebar col-md-3 col-lg-2 d-md-block collapse">
    <div class="d-flex flex-column h-100 position-sticky pt-2">
        <ul class="nav flex-column flex-grow-1">

            <!-- ========== COMMON: Dashboard ========== -->
            <li class="nav-item">
                <a class="nav-link ${param.page == 'home' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/dashboard">
                    <i class="bi bi-grid-1x2"></i> Tổng quan
                </a>
            </li>

            <!-- ========== ADMIN ========== -->
            <c:if test="${role == 'Admin'}">
                <h6 class="sidebar-heading">Quản trị hệ thống</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'user' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/user-list">
                        <i class="bi bi-people"></i> Quản lý người dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'role' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/role-list">
                        <i class="bi bi-shield-lock"></i> Quản lý vai trò
                    </a>
                </li>
            </c:if>

            <!-- ========== STAFF (Asset Management Staff) ========== -->
            <c:if test="${role == 'Asset Staff'}">

                <!-- Group 1: Danh mục tài sản -->
                <h6 class="sidebar-heading">Danh mục tài sản</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'category_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/category/list">
                        <i class="bi bi-tags"></i> Danh sách danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'category_add' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/category/add">
                        <i class="bi bi-tag"></i> Thêm danh mục
                    </a>
                </li>

                <!-- Group 2: Quản lý tài sản -->
                <h6 class="sidebar-heading">Quản lý tài sản</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'asset_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/asset/list">
                        <i class="bi bi-pc-display-horizontal"></i> Danh sách tài sản
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'asset_detail' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/asset/list">
                        <i class="bi bi-info-circle"></i> Chi tiết tài sản
                    </a>
                </li>

                <!-- Group 3: Cấp phát & Mua sắm -->
                <h6 class="sidebar-heading">Cấp phát & Mua sắm</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'allocation_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/allocation-list">
                        <i class="bi bi-inbox"></i> Yêu cầu cấp phát
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'inventory_check' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/asset/inventory-check">
                        <i class="bi bi-box-seam"></i> Kiểm tra tồn kho
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'procurement_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/procurement-list">
                        <i class="bi bi-cart-plus"></i> Đề xuất mua sắm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'procurement_add' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/procurement-add">
                        <i class="bi bi-cart3"></i> Tạo đề xuất mua sắm
                    </a>
                </li>

                <!-- Group 4: Điều chuyển -->
                <h6 class="sidebar-heading">Điều chuyển tài sản</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'transfer_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/transfer/list">
                        <i class="bi bi-arrow-left-right"></i> Phiếu điều chuyển
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'transfer_add' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/transfer/add">
                        <i class="bi bi-plus-circle"></i> Tạo phiếu điều chuyển
                    </a>
                </li>

                <!-- Group 5: Báo cáo -->
                <h6 class="sidebar-heading">Báo cáo</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'report_asset' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/report/asset">
                        <i class="bi bi-file-earmark-bar-graph"></i> Báo cáo tài sản
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'report_request' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/report/request">
                        <i class="bi bi-file-earmark-text"></i> Báo cáo yêu cầu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'report_transfer' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/report/transfer">
                        <i class="bi bi-file-earmark-arrow-up"></i> Báo cáo điều chuyển
                    </a>
                </li>

            </c:if>

            <!-- ========== FINANCE HEAD ========== -->
            <c:if test="${role == 'Finance Head'}">
                <h6 class="sidebar-heading">Tài sản</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'asset_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/asset/list">
                        <i class="bi bi-pc-display-horizontal"></i> Danh sách tài sản
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'allocation_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/allocation-list">
                        <i class="bi bi-inbox"></i> Yêu cầu cấp phát
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'transfer_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/transfer/list">
                        <i class="bi bi-arrow-left-right"></i> Phiếu điều chuyển
                    </a>
                </li>
            </c:if>

            <!-- ========== PRINCIPAL / VICE PRINCIPAL ========== -->
            <c:if test="${role == 'Principal' || role == 'Vice Principal'}">
                <h6 class="sidebar-heading">Phê duyệt</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'procurement_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/procurement-list">
                        <i class="bi bi-clipboard-check"></i> Duyệt mua sắm
                    </a>
                </li>
                <h6 class="sidebar-heading">Báo cáo</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'report_dashboard' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/report/dashboard">
                        <i class="bi bi-bar-chart-line"></i> Tổng quan báo cáo
                    </a>
                </li>
            </c:if>

            <!-- ========== HEAD OF DEPT ========== -->
            <c:if test="${role == 'Head of Dept'}">
                <h6 class="sidebar-heading">Yêu cầu</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'allocation_list' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/allocation-list">
                        <i class="bi bi-send"></i> Yêu cầu của tôi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'allocation_add' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/request/allocation-add">
                        <i class="bi bi-plus-square"></i> Tạo yêu cầu cấp phát
                    </a>
                </li>
                <h6 class="sidebar-heading">Tài sản</h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'dept_assets' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/asset/dept">
                        <i class="bi bi-pc-display-horizontal"></i> Tài sản bộ môn
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'transfer_confirm' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/transfer/confirm">
                        <i class="bi bi-check2-square"></i> Xác nhận điều chuyển
                    </a>
                </li>
            </c:if>

        </ul>

        <!-- Bottom: Profile -->
        <div class="sidebar-bottom">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'profile' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/profile">
                        <i class="bi bi-person-circle"></i> Hồ sơ cá nhân
                    </a>
                </li>
            </ul>
        </div>

    </div>
</nav>
