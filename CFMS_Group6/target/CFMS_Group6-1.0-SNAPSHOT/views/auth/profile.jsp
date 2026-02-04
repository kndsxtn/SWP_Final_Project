<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ & Bảo mật - CFMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/css/user-list.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/profile.css" rel="stylesheet">

</head>
<body>

    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="active" value="profile" />
    </jsp:include>

    <div class="main">
        <jsp:include page="/views/common/navbar.jsp">
            <jsp:param name="title" value="Cá nhân / Thiết lập tài khoản" />
        </jsp:include>

        <div class="box">
            <div class="card shadow-sm border-0 p-4" style="border-radius: 20px;">
                
                <ul class="nav nav-pills mb-4 bg-light p-2 rounded-pill mx-auto" id="pills-tab" role="tablist" style="width: fit-content;">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active rounded-pill px-4 fw-bold" id="pills-info-tab" data-bs-toggle="pill" data-bs-target="#pills-info" type="button" role="tab">
                            <i class="fas fa-user-edit me-2"></i> Thông tin cá nhân
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link rounded-pill px-4 fw-bold" id="pills-pass-tab" data-bs-toggle="pill" data-bs-target="#pills-pass" type="button" role="tab">
                            <i class="fas fa-key me-2"></i> Đổi mật khẩu
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="pills-tabContent">
                    
                    <div class="tab-pane fade show active" id="pills-info" role="tabpanel">
                        <div class="row align-items-center justify-content-center">
                            <div class="col-md-4 text-center border-end">
                                <div class="pic mx-auto mb-3 shadow">${sessionScope.user.fullName.substring(0,1)}</div>
                                <h4 class="fw-bold">${sessionScope.user.fullName}</h4>
                                <span class="badge bg-primary-subtle text-primary rounded-pill px-3">${sessionScope.user.roleName}</span>
                            </div>
                            <div class="col-md-6 px-4">
                                <form action="${pageContext.request.contextPath}/profile/update" method="POST">
                                    <div class="mb-3">
                                        <label class="small fw-bold text-muted mb-1">Họ và Tên</label>
                                        <input type="text" name="fullName" class="form-control border-2 border-secondary-subtle py-2" value="${sessionScope.user.fullName}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="small fw-bold text-muted mb-1">Email</label>
                                        <input type="email" name="email" class="form-control border-2 border-secondary-subtle py-2" value="${sessionScope.user.email}" required>
                                    </div>
                                    <div class="mb-4">
                                        <label class="small fw-bold text-muted mb-1">Số điện thoại</label>
                                        <input type="text" name="phone" class="form-control border-2 border-secondary-subtle py-2" value="${sessionScope.user.phone}" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold py-2">Cập nhật thông tin</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="pills-pass" role="tabpanel">
                        <div class="col-md-5 mx-auto">
                            <div class="text-center mb-4">
                                <i class="fas fa-lock text-warning fa-3x"></i>
                                <h4 class="fw-bold mt-2">Thiết lập mật khẩu mới</h4>
                            </div>
                            <form action="${pageContext.request.contextPath}/change-password" method="POST">
                                <div class="mb-3">
                                    <label class="small fw-bold text-muted mb-1">Mật khẩu hiện tại</label>
                                    <input type="password" name="oldPass" class="form-control border-2 border-secondary-subtle py-2" required>
                                </div>
                                <div class="mb-3">
                                    <label class="small fw-bold text-muted mb-1">Mật khẩu mới</label>
                                    <input type="password" name="newPass" class="form-control border-2 border-secondary-subtle py-2" required>
                                </div>
                                <div class="mb-4">
                                    <label class="small fw-bold text-muted mb-1">Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPass" class="form-control border-2 border-secondary-subtle py-2" required>
                                </div>
                                <button type="submit" class="btn btn-dark w-100 rounded-pill fw-bold py-2">Xác nhận đổi mật khẩu</button>
                            </form>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>