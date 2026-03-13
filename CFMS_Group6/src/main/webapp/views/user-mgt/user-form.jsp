<%-- Form them nguoi dung moi – POST /user-mgt/user-create --%>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Them nguoi dung - CFMS</title>
                <%-- Bootstrap, FontAwesome, Bootstrap Icons, CSS rieng --%>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
                    
                    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
            </head>

            <body class="d-flex flex-column">

                <%-- Header chung --%>
                    <jsp:include page="/views/components/header.jsp"></jsp:include>

                    <div class="container-fluid flex-grow-1">
                        <div class="row h-100">

                            <%-- Sidebar, danh dau muc "user" dang active --%>
                                <jsp:include page="/views/components/sidebar.jsp">
                                    <jsp:param name="page" value="user" />
                                </jsp:include>

                                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                                    <%-- Tieu de trang --%>
                                        <div class="cfms-page-header">
                                            <h2><i class="bi bi-person-plus"></i> Thêm người dùng mới</h2>
                                            <%-- Nut quay lai danh sach --%>
                                                <a href="${pageContext.request.contextPath}/user-mgt/user-list"
                                                    class="btn btn-outline-secondary">
                                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                                </a>
                                        </div>

                                        <%-- Thong bao loi (username trung, ...) --%>
                                            <c:if test="${not empty sessionScope.errorMsg}">
                                                <div class="col-md-8 ms-auto mb-3 cfms-msg text-end" style="color:#dc3545;">
                                                    <i class="bi bi-exclamation-circle me-1"></i>${sessionScope.errorMsg}
                                                </div>
                                                <% session.removeAttribute("errorMsg"); %>
                                            </c:if>

                                            <%-- Card chua form --%>
                                                <div class="card border-0 shadow-sm p-4" style="max-width: 650px;">
                                                    <h5 class="fw-bold mb-4 text-dark">
                                                        <i class="fas fa-user-edit me-2 text-primary"></i>Thông tin tài khoản
                                                    </h5>

                                                    <%-- Form POST them user --%>
                                                        <form
                                                            action="${pageContext.request.contextPath}/user-mgt/user-create"
                                                            method="POST" id="createUserForm" novalidate>

                                                            <div class="row g-3">

                                                                <%-- Ho va ten --%>
                                                                    <div class="col-md-6">
                                                                        <label class="form-label fw-semibold">Họ Và Tên
                                                                            <span class="text-danger">*</span></label>
                                                                        <input type="text" name="fullName"
                                                                            class="form-control py-2"
                                                                            value="${oldFullName}"
                                                                            placeholder="Nguyen Van A" required>
                                                                        <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                                                    </div>

                                                                    <%-- Email --%>
                                                                        <div class="col-md-6">
                                                                            <label class="form-label fw-semibold">Email
                                                                                <span
                                                                                    class="text-danger">*</span></label>
                                                                            <input type="email" name="email"
                                                                                class="form-control py-2"
                                                                                value="${oldEmail}"
                                                                                placeholder="example@email.com"
                                                                                required>
                                                                            <div class="invalid-feedback">Email không hợp lệ</div>
                                                                        </div>

                                                                        <%-- So dien thoai --%>
                                                                            <div class="col-md-6">
                                                                                <label class="form-label fw-semibold">Số điện thoại</label>
                                                                                <input type="text" name="phone"
                                                                                    class="form-control py-2"
                                                                                    value="${oldPhone}"
                                                                                    placeholder="0901234567"
                                                                                    pattern="[0-9]{9,11}">
                                                                                <div class="invalid-feedback">Số điện thoại không hợp lệ(9-11 số)</div>
                                                                            </div>

                                                                            <%-- Vai tro (Role) – lay tu DB --%>
                                                                                <div class="col-md-6">
                                                                                    <label
                                                                                        class="form-label fw-semibold">Vai
                                                                                        Trò <span
                                                                                            class="text-danger">*</span></label>
                                                                                    <select name="roleId"
                                                                                        class="form-select py-2"
                                                                                        required>
                                                                                        <option value="" disabled
                                                                                            selected>-- Chọn vai trò --
                                                                                        </option>
                                                                                        <c:forEach items="${roles}"
                                                                                            var="r">
                                                                                            <option value="${r.roleId}"
                                                                                                <c:if
                                                                                                test="${r.roleId == oldRoleId}">
                                                                                                selected</c:if>>
                                                                                                ${r.roleName}
                                                                                            </option>
                                                                                        </c:forEach>
                                                                                    </select>
                                                                                    <div class="invalid-feedback">Vui lòng chọn vai trò</div>
                                                                                </div>

                                                                                <hr class="my-2">
                                                                                <h6 class="fw-bold text-muted">Thông tin đăng nhập</h6>

                                                                                <%-- Ten tai khoan --%>
                                                                                    <div class="col-md-6">
                                                                                        <label
                                                                                            class="form-label fw-semibold">Tên tài khoản <span
                                                                                                class="text-danger">*</span></label>
                                                                                        <input type="text"
                                                                                            name="username"
                                                                                            class="form-control py-2"
                                                                                            value="${oldUsername}"
                                                                                            placeholder="user123"
                                                                                            required autocomplete="off">
                                                                                        <div class="invalid-feedback">
                                                                                           Vui lòng nhập tên tài khoản
                                                                                        </div>
                                                                                    </div>

                                                                                    <%-- Mat khau mac dinh --%>
                                                                                        <div class="col-md-6">
                                                                                            <label
                                                                                                class="form-label fw-semibold">Mật Khẩu <span
                                                                                                    class="text-danger">*</span></label>
                                                                                            <div class="input-group">
                                                                                                <input type="password"
                                                                                                    name="password"
                                                                                                    id="passInput"
                                                                                                    class="form-control py-2"
                                                                                                    placeholder="Tối thiểu 1 ký tự"
                                                                                                    required
                                                                                                    minlength="1"
                                                                                                    autocomplete="new-password">
                                                                                                <%-- Nut hien/an mat
                                                                                                    khau --%>
                                                                                                    <button
                                                                                                        class="btn btn-outline-secondary"
                                                                                                        type="button"
                                                                                                        id="togglePass">
                                                                                                        <i class="fas fa-eye"
                                                                                                            id="eyeIcon"></i>
                                                                                                    </button>
                                                                                            </div>
                                                                                            <div
                                                                                                class="invalid-feedback">
                                                                                                Mật khẩu ít nhất 1 ký tự</div>
                                                                                        </div>

                                                            </div><%-- end row --%>

                                                                <%-- Nut hanh dong --%>
                                                                    <div class="d-flex gap-2 mt-4">
                                                                        <button type="submit"
                                                                            class="btn btn-primary px-5 rounded-pill fw-bold py-2">
                                                                            <i class="fas fa-user-plus me-2"></i>Tạo tài khoản
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/user-mgt/user-list"
                                                                            class="btn btn-light px-4 rounded-pill fw-bold py-2">
                                                                            Hủy
                                                                        </a>
                                                                    </div>

                                                        </form>
                                                </div><%-- end card --%>

                                </main>

                        </div>
                    </div>

                    <%-- Footer chung --%>
                        <jsp:include page="/views/components/footer.jsp"></jsp:include>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Validate Bootstrap khi submit
                            (() => {
                                const form = document.getElementById('createUserForm');
                                form.addEventListener('submit', e => {
                                    if (!form.checkValidity()) {
                                        e.preventDefault();
                                        e.stopPropagation();
                                    }
                                    form.classList.add('was-validated');
                                });
                            })();

                            // Hien / an mat khau khi bam icon mat
                            document.getElementById('togglePass').addEventListener('click', () => {
                                const inp = document.getElementById('passInput');
                                const icon = document.getElementById('eyeIcon');
                                if (inp.type === 'password') {
                                    inp.type = 'text';
                                    icon.classList.replace('fa-eye', 'fa-eye-slash');
                                } else {
                                    inp.type = 'password';
                                    icon.classList.replace('fa-eye-slash', 'fa-eye');
                                }
                            });
                        </script>

            </body>

            </html>