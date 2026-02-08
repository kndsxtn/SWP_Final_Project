<%-- 
    Document   : sidebar.jsp
    Created on : Feb 4, 2026, 4:32:50 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <ul class="nav flex-column">
            
            <li class="nav-item">
                <a class="nav-link ${param.page == 'home' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                    <i class="bi bi-house-door me-2"></i> Tổng quan
                </a>
            </li>

            <c:if test="${sessionScope.user.roleName == 'Admin'}">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>QUẢN TRỊ</span>
                </h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'user' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/user-list">
                        <i class="bi bi-people me-2"></i>
                        Người dùng
                    </a>
                </li>
            </c:if>

            <c:if test="${sessionScope.user.roleName == 'Asset Staff' || sessionScope.user.roleName == 'Asset Manager'}">
                <h6 class="sidebar-heading px-3 mt-4 mb-1 text-muted">
                    <span>TÀI SẢN</span>
                </h6>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'asset_list' ? 'active' : ''}" href="${pageContext.request.contextPath}/asset/list">
                        <i class="bi bi-pc-display me-2"></i>
                        Danh sách tài sản
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'request' ? 'active' : ''}" href="${pageContext.request.contextPath}/request/list">
                        <i class="bi bi-inbox me-2"></i>
                        Yêu cầu cấp phát
                    </a>
                </li>
            </c:if>
            
          
            
        </ul>
    </div>
</nav>