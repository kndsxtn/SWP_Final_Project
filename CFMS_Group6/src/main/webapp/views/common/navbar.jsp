<%-- 
    Document   : navbar
    Created on : Feb 4, 2026, 4:39:43 PM
    Author     : Nguyen Dinh Giap
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="nav">
    <div class="text-muted fw-medium">
        <i class="fas fa-bars me-2"></i> ${param.title}
    </div>
    <div class="d-flex align-items-center">
        <span class="me-3 text-dark">Xin chào, <b class="text-primary">${sessionScope.user.fullName}</b></span>
        <a href="${pageContext.request.contextPath}/logout" class="out btn btn-sm btn-outline-danger rounded-pill px-3">
            Đăng Xuất <i class="fas fa-power-off ms-1"></i>
        </a>
    </div>
</div>