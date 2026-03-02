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
        <link href="${pageContext.request.contextPath}/css/user-detail.css" rel="stylesheet">
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

                    <%-- Thong bao thanh cong --%>
                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("successMsg"); %>
                    </c:if>

                    <%-- Thong bao loi --%>
                    <c:if test="${not empty sessionScope.errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("errorMsg"); %>
                    </c:if>

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
                                                <%-- Nut edit - mo modal chi tiet + sua role --%>
                                                <button type="button" class="btn btn-sm btn-light me-1"
                                                        title="Xem chi tiết & Quản lý"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#userModal_${u.userId}">
                                                    <i class="fas fa-edit text-primary"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <%-- Phan trang --%>
                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-between align-items-center mt-4">
                                <div class="text-muted small">
                                    Trang <strong>${currentPage}</strong> /
                                    <strong>${totalPages}</strong>
                                    (Tổng: <strong>${totalUsers}</strong> người dùng)
                                </div>
                                <nav>
                                    <ul class="pagination pagination-sm mb-0">
                                        <%-- Nut trang truoc --%>
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/user-mgt/user-list?page=${currentPage - 1}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>

                                        <%-- Cac so trang --%>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li
                                                class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                   href="${pageContext.request.contextPath}/user-mgt/user-list?page=${i}">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:forEach>

                                        <%-- Nut trang sau --%>
                                        <li
                                            class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="${pageContext.request.contextPath}/user-mgt/user-list?page=${currentPage + 1}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>

                    </div>
                </main>

            </div>
        </div>

        <%--==========MODAL CHI TIET CHO TUNG USER (tao bang JSTL)==========--%>
        <c:forEach items="${list}" var="u">
            <div class="modal fade user-detail-modal" id="userModal_${u.userId}" tabindex="-1"
                 aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-user-circle me-2"></i>Chi tiết: ${u.fullName}
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">

                            <%-- Avatar section --%>
                            <div class="user-avatar-section">
                                <div class="avatar-circle">${u.fullName.substring(0,1)}</div>
                                <div class="user-name">${u.fullName}</div>
                                <div>
                                    <span
                                        class="badge bg-info-subtle text-info user-role-badge">${u.roleName}</span>
                                    <c:choose>
                                        <c:when test="${u.status == 'Active'}">
                                            <span
                                                class="badge bg-success-subtle text-success rounded-pill ms-1">Hoạt
                                                động</span>
                                            </c:when>
                                            <c:otherwise>
                                            <span
                                                class="badge bg-danger-subtle text-danger rounded-pill ms-1">Đã
                                                khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                </div>
                            </div>

                            <%-- Thong tin chi tiet --%>
                            <div class="user-info-grid">
                                <div class="user-info-item">
                                    <div class="info-label"><i class="fas fa-hashtag me-1"></i>User ID
                                    </div>
                                    <div class="info-value">${u.userId}</div>
                                </div>
                                <div class="user-info-item">
                                    <div class="info-label"><i class="fas fa-user me-1"></i>Tài khoản
                                    </div>
                                    <div class="info-value">${u.username}</div>
                                </div>
                                <div class="user-info-item">
                                    <div class="info-label"><i class="fas fa-envelope me-1"></i>Email
                                    </div>
                                    <div class="info-value">${u.email != null ? u.email : '-'}</div>
                                </div>
                                <div class="user-info-item">
                                    <div class="info-label"><i class="fas fa-phone me-1"></i>Điện thoại
                                    </div>
                                    <div class="info-value">${u.phone != null ? u.phone : '-'}</div>
                                </div>
                                <div class="user-info-item">
                                    <div class="info-label"><i class="fas fa-building me-1"></i>Phòng
                                        ban (ID)</div>
                                    <div class="info-value">${u.deptId > 0 ? u.deptId : '-'}</div>
                                </div>
                                <div class="user-info-item">
                                    <div class="info-label"><i class="fas fa-calendar me-1"></i>Ngày tạo
                                    </div>
                                    <div class="info-value">${u.createdAt != null ? u.createdAt : '-'}
                                    </div>
                                </div>
                            </div>

                            <%-- Form sua role va trang thai --%>
                            <div class="edit-section">
                                <h6><i class="fas fa-shield-alt me-2"></i>Quản lý vai trò & Trạng
                                    thái</h6>
                                <form
                                    action="${pageContext.request.contextPath}/user-mgt/update-role"
                                    method="POST">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold small">Vai
                                                trò</label>
                                            <select name="roleId" class="form-select">
                                                <c:forEach items="${roles}" var="r">
                                                    <option value="${r.roleId}" <c:if
                                                                test="${r.roleId == u.roleId}">selected
                                                            </c:if>>
                                                        ${r.roleName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold small">Trạng
                                                thái</label>
                                            <select name="status" class="form-select">
                                                <option value="Active" <c:if
                                                            test="${u.status == 'Active'}">selected</c:if>>
                                                            Hoạt động (Active)
                                                        </option>
                                                        <option value="Inactive" <c:if
                                                            test="${u.status != 'Active'}">selected</c:if>>
                                                            Đã khóa (Inactive)
                                                        </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="d-flex justify-content-end gap-2 mt-3">
                                            <button type="button"
                                                    class="btn btn-light rounded-pill px-4"
                                                    data-bs-dismiss="modal">
                                                <i class="fas fa-times me-1"></i>Đóng
                                            </button>
                                            <button type="submit"
                                                    class="btn btn-primary rounded-pill px-4">
                                                <i class="fas fa-save me-1"></i>Lưu thay đổi
                                            </button>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
        </c:forEach>

        <jsp:include page="/views/components/footer.jsp"></jsp:include>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>