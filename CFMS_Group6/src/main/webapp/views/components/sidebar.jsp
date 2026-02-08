<%-- 
    Document   : sidebar.jsp
    Created on : Feb 4, 2026, 4:32:50 PM
    Author     : Nguyen Dinh Giap
--%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="constant.Message" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="side">
    <div class="brand-logo mb-4">
        <h4 class="text-white"><i class="fas fa-shield-alt me-2"></i>CFMS SYSTEM</h4>
    </div>

    <c:if test="${sessionScope.user.roleName == Message.ADMIN}">
        <p class="text-uppercase small fw-bold mb-2 text-secondary px-3">Hệ thống</p>
        <a href="${pageContext.request.contextPath}/admin/user-list" 
           class="${param.active == 'user' ? 'active' : ''}">
            <i class="fas fa-users-cog"></i> Quản lý Actor
        </a>
    </c:if>

    <c:if test="${sessionScope.user.roleName != Message.ADMIN}">
        <p class="text-uppercase small fw-bold mb-2 text-secondary px-3">Nghiệp vụ</p>
        <a href="${pageContext.request.contextPath}/asset/list" 
           class="${param.active == 'category' ? 'active' : ''}">
            <i class="fas fa-box-open"></i> Tài sản
        </a>
        <a href="${pageContext.request.contextPath}/request/list" 
           class="${param.active == 'request' ? 'active' : ''}">
            <i class="fas fa-file-invoice"></i> Yêu cầu
        </a>
    </c:if>
    <c:if test="${sessionScope.user.roleName == Message.NV_QUAN_LY}">
        <p class="text-uppercase small fw-bold mb-2 text-secondary px-3">Quản lý</p>
        <a href="${pageContext.request.contextPath}/ViewCategory" 
           class="${param.active == 'asset' ? 'active' : ''}">
            <i class="fas fa-box-open"></i> Danh sách danh mục
        </a>
    </c:if>

    <div style="margin-top: auto; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px;">
        <a href="${pageContext.request.contextPath}/profile" class="${param.active == 'profile' ? 'active' : ''}">
            <i class="fas fa-user-circle"></i> Hồ sơ cá nhân
        </a>
    </div>
</div>