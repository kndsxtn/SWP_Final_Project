<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">

        <!-- CSS của bạn -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    </head>

    <body>

        <div class="container mt-4">

            <!-- HEADER -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold">
                    <i class="fas fa-chart-line me-2"></i> Admin Dashboard
                </h3>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>

            <!-- STATISTIC CARDS -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card card-box bg-gradient-primary text-white">
                        <div class="card-body">
                            <h6>Total Users</h6>
                            <h3>${totalUsers}</h3>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-box bg-gradient-success text-white">
                        <div class="card-body">
                            <h6>Active Users</h6>
                            <h3>${activeUsers}</h3>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-box bg-gradient-warning text-white">
                        <div class="card-body">
                            <h6>Inactive Users</h6>
                            <h3>${inactiveUsers}</h3>
                        </div>
                    </div>
                </div>
            </div>

            <!-- USER TABLE -->
            <div class="card">
                <div class="card-header fw-bold">
                    User List
                </div>

                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>User</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>

                            <!-- Không có user -->
                            <c:if test="${empty listUser}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">
                                        No users found
                                    </td>
                                </tr>
                            </c:if>

                            <!-- Danh sách user -->
                            <c:forEach items="${listUser}" var="u" varStatus="i">
                                <tr>
                                    <td>${i.count}</td>

                                    <!-- User + avatar -->
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="avatar-circle">
                                                <c:out value="${u.username.substring(0,1)}"/>
                                            </div>
                                            <span>${u.username}</span>
                                        </div>
                                    </td>

                                    <td>${u.username}</td>

                                    <!-- Role -->
                                    <td>
                                        <span class="badge bg-info">
                                            ${u.roleName}
                                        </span>
                                    </td>

                                    <!-- Status -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status eq 'Active'}">
                                                <span class="badge bg-success">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
            </div>

        </div>

    </body>
</html>
