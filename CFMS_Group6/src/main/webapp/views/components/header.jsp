<%--
    Document   : header.jsp
    Created on : Feb 4, 2026, 4:32:40 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

<header class="cfms-header navbar navbar-dark sticky-top flex-md-nowrap p-0">

    <!-- Brand -->
    <a class="navbar-brand col-md-3 col-lg-2 me-0" href="${pageContext.request.contextPath}/dashboard">
        <span class="brand-icon">
            <i class="bi bi-building-gear"></i>
        </span>
        <span>
            <span class="d-block">CFMS</span>
            <span class="brand-text-sub d-none d-sm-block">Campus Facility Management</span>
        </span>
    </a>

    <!-- Mobile toggler -->
    <button class="navbar-toggler position-absolute d-md-none collapsed" type="button"
            data-bs-toggle="collapse" data-bs-target="#sidebarMenu"
            aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Right side: User info + Logout -->
    <div class="navbar-nav w-100 justify-content-end">
        <div class="header-user-area">

            <!-- Avatar -->
            <span class="user-avatar">
                <i class="bi bi-person-fill"></i>
            </span>

            <!-- Name & role -->
            <div class="user-info">
                <span class="user-name">${sessionScope.user.fullName}</span>
                <span class="user-role">${sessionScope.user.roleName}</span>
            </div>

            <span class="header-divider"></span>

            <!-- Logout -->
            <a class="btn btn-logout" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right"></i>
                <span class="d-none d-sm-inline">Đăng xuất</span>
            </a>

        </div>
    </div>

</header>
