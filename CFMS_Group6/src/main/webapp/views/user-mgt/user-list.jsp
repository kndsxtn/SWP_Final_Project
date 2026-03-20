<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý người dùng - CFMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/filter.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/paging.css" rel="stylesheet">
    </head>

    <body class="d-flex flex-column">

        <jsp:include page="../components/header.jsp"></jsp:include>

            <div class="container-fluid flex-grow-1">
                <div class="row h-100">

                <jsp:include page="../components/sidebar.jsp">
                    <jsp:param name="page" value="user" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                    <%-- Page Header --%>
                    <div class="cfms-page-header">
                        <h2><i class="bi bi-people"></i> Quản lý người dùng</h2>
                        <a href="${pageContext.request.contextPath}/user-mgt/user-create"
                           class="btn btn-primary">
                            <i class="bi bi-person-plus me-1"></i>Thêm người dùng
                        </a>
                    </div>

                    <%-- Thong bao --%>
                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="col-md-8 ms-auto mb-3 cfms-msg text-end">
                            <i class="bi bi-check-circle me-1"></i>${sessionScope.successMsg}
                        </div>
                        <% session.removeAttribute("successMsg"); %>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMsg}">
                        <div class="col-md-8 ms-auto mb-3 cfms-msg text-end" style="color:#dc3545;">
                            <i class="bi bi-exclamation-circle me-1"></i>${sessionScope.errorMsg}
                        </div>
                        <% session.removeAttribute("errorMsg"); %>
                    </c:if>

                    <%-- Filter Search --%>
                    <div class="card shadow-sm border-0 mb-4" style="border-radius: 15px;">
                        <div class="card-body p-3">
                            <form action="${pageContext.request.contextPath}/user-mgt/user-list" method="GET" class="row g-3">
                                <div class="col-md-5">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-end-0">
                                            <i class="bi bi-search text-muted"></i>
                                        </span>
                                        <input type="text" name="searchQuery" class="form-control border-start-0" 
                                               placeholder="Tìm theo tên hoặc email..." value="${searchQuery}">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-end-0">
                                            <i class="bi bi-person-badge text-muted"></i>
                                        </span>
                                        <select name="roleId" class="form-select border-start-0">
                                            <option value="">Tất cả vai trò</option>
                                            <c:forEach items="${roles}" var="r">
                                                <option value="${r.roleId}" ${selectedRoleId == r.roleId ? 'selected' : ''}>
                                                    ${r.roleName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary flex-grow-1">
                                        <i class="bi bi-funnel me-1"></i>Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/user-mgt/user-list" class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-clockwise"></i>
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- Table --%>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tài khoản</th>
                                    <th>Họ và tên</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list}" var="u">
                                    <tr>
                                        <td class="text-muted">${u.userId}</td>
                                        <td class="fw-semibold">${u.username}</td>
                                        <td>${u.fullName}</td>
                                        <td>
                                            <span
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
                                            <c:choose>
                                                <c:when test="${u.roleName == 'Admin'}">
                                                    <%-- Admin duoc bao ve, khong cho chinh sua --%>
                                                    <span class="badge bg-secondary px-3 py-2"
                                                          title="Tai khoan Admin duoc bao ve">
                                                        <i class="fas fa-shield-alt me-1"></i>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-sm btn-light"
                                                            title="Xem chi tiet" data-bs-toggle="modal"
                                                            data-bs-target="#userModal_${u.userId}">
                                                        <i class="bi bi-pencil-square text-primary"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty list}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            Không có người dùng nào phù hợp với kết quả tìm kiếm
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        <hr />

                        <%-- Phan trang --%>
                        <c:if test="${totalPages > 1}">
                            <div class="cfms-paging">
                                <ul class="pagination">
                                    <c:set var="searchParam" value="searchQuery=${searchQuery}&roleId=${selectedRoleId}" />
                                    
                                    <c:if test="${currentPage > 1}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/user-mgt/user-list?page=${currentPage - 1}&${searchParam}"><</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a class="page-link ${i == currentPage ? 'active' : ''}"
                                           href="${pageContext.request.contextPath}/user-mgt/user-list?page=${i}&${searchParam}">${i}</a>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/user-mgt/user-list?page=${currentPage + 1}&${searchParam}">></a>

                                    </c:if>
                                </ul>
                            </div>
                        </c:if>
                    </div>
                    </div>

                </main>

            </div>
        </div>

        <%-- MODALS chi tiet tung user --%>
        <c:forEach items="${list}" var="u">
            <c:if test="${u.roleName != 'Admin'}">
                <div class="modal fade" id="userModal_${u.userId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="bi bi-person-circle me-2"></i>Chi tiet: ${u.fullName}
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">

                                <%-- Thong tin --%>
                                <div class="row g-3 mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">User
                                            ID</label>
                                        <div class="form-control-plaintext">${u.userId}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Tài
                                            khoản</label>
                                        <div class="form-control-plaintext">${u.username}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Họ và
                                            tên</label>
                                        <div class="form-control-plaintext">${u.fullName}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Email</label>
                                        <div class="form-control-plaintext">${u.email != null ? u.email :
                                                                              '-'}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Dien
                                            thoai</label>
                                        <div class="form-control-plaintext">${u.phone != null ? u.phone :
                                                                              '-'}</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-muted">Phong ban
                                            (ID)</label>
                                        <div class="form-control-plaintext">${u.deptId > 0 ? u.deptId : '-'}
                                        </div>
                                    </div>
                                </div>

                                <hr />

                                <%-- Form cap nhat role va status --%>
                                <form action="${pageContext.request.contextPath}/user-mgt/update-role"
                                      method="POST">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-semibold small">Vai trò</label>
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
                                            <label class="form-label fw-semibold small">Trạng thái</label>
                                            <select name="status" class="form-select">
                                                <option value="Active" <c:if test="${u.status == 'Active'}">selected</c:if>>
                                                        Hoạt động
                                                    </option>
                                                    <option value="Inactive" <c:if test="${u.status != 'Active'}">selected</c:if>>
                                                        Đã khóa (Inactive)
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-12 d-flex justify-content-end gap-2 mt-3">
                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                                    <i class="bi bi-x-lg me-1"></i>Đóng
                                                </button>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-save me-1"></i>Lưu thay đổi
                                                </button>
                                            </div>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>
            </c:if>
        </c:forEach>

        <jsp:include page="../components/footer.jsp"></jsp:include>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>