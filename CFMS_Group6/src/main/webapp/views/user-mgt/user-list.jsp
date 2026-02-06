<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý người dùng - CFMS</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="${pageContext.request.contextPath}/css/user-list.css" rel="stylesheet">
    </head>
    <body>
        <div class="main">
            <jsp:include page="/views/components/navbar.jsp">
                <jsp:param name="title" value="Hệ thống / Quản lý người dùng" />
            </jsp:include>

            <div class="box">
                <div class="card border-0 shadow-sm p-4">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tài khoản</th>
                                    <th>Họ và Tên</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list}" var="l">
                                    <tr>
                                        <td class="text-muted">${l.userId}</td>
                                        <td><span class="fw-semibold">${l.username}</span></td>
                                        <td>${u.fullName}</td>
                                        <td><span class="badge bg-info-subtle text-info px-3">${l.roleName}</span></td>
                                        <td class="text-center">
                                            <a href="edit?id=${l.userId}" class="btn btn-sm btn-light me-1" title="Sửa">
                                                <i class="fas fa-edit text-primary"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>