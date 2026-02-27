<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý người dùng - CFMS</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
            <link href="${pageContext.request.contextPath}/css/user-list.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        </head>

        <body class="d-flex flex-column">

            <jsp:include page="/views/components/header.jsp"></jsp:include>

            <div class="container-fluid flex-grow-1">
                <div class="row h-100">

                    <jsp:include page="/views/components/sidebar.jsp">
                        <jsp:param name="page" value="user" />
                    </jsp:include>

                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                        <div
                            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h4 class="fw-bold text-dark m-0"><i class="bi bi-people me-2 text-primary"></i>Quản lý
                                người dùng</h4>
                        </div>
                        <div class="card border-0 shadow-sm p-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h3 class="fw-bold text-dark m-0">Danh sách người dùng</h3>
                                    <p class="text-muted small">Cấp quyền và quản lý tài khoản hệ thống</p>
                                </div>
                                <a href="user-create" class="btn btn-primary px-4 rounded-pill shadow-sm">
                                    <i class="fas fa-user-plus me-2"></i> Thêm người dùng mới
                                </a>
                            </div>

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
                                        <c:forEach items="${list}" var="u">
                                            <tr>
                                                <td class="text-muted">${u.userId}</td>
                                                <td><span class="fw-semibold">${u.username}</span></td>
                                                <td>${u.fullName}</td>
                                                <td><span
                                                        class="badge bg-info-subtle text-info px-3">${u.roleName}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.status == 'Active'}">
                                                            <span
                                                                class="badge bg-success-subtle text-success rounded-pill">Hoạt
                                                                động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-danger-subtle text-danger rounded-pill">Đã
                                                                khóa</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <a href="edit?id=${u.userId}" class="btn btn-sm btn-light me-1"
                                                        title="Sửa">
                                                        <i class="fas fa-edit text-primary"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                    </main>
                </div>
            </div>

            <jsp:include page="/views/components/footer.jsp"></jsp:include>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>