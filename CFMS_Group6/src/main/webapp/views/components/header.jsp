<%-- 
    Document   : header.jsp
    Created on : Feb 4, 2026, 4:32:40 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="navbar navbar-dark sticky-top bg-primary flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3 fs-6" href="${pageContext.request.contextPath}/dashboard">
        CFMS SYSTEM
    </a>
    <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="navbar-nav w-100">
        <div class="nav-item text-nowrap d-flex justify-content-end align-items-center px-3">
            <span class="text-white me-3">
                Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.roleName})
            </span>
            <a class="btn btn-sm btn-light text-primary fw-bold" href="${pageContext.request.contextPath}/logout">
                Đăng xuất
            </a>
        </div>
    </div>
</header>
