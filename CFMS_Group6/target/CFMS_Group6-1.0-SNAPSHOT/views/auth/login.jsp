<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập Hệ Thống</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body>

    <div class="login-card fade-in-down">
        <div class="card-header-custom text-center">
            <div class="login-icon">
                <i class="fas fa-user-circle"></i>
            </div>
            <h3 class="title-text">Hệ thống Quản lý</h3>
            <p class="text-muted small">Vui lòng đăng nhập để tiếp tục</p>

            <div class="error-summary mb-3">
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger py-2" role="alert" style="font-size: 0.85rem;">
                        <i class="fas fa-exclamation-triangle me-2"></i> ${errorMsg}
                    </div>
                </c:if>
                <c:if test="${not empty errorPass}">
                    <div class="alert alert-danger py-2" role="alert" style="font-size: 0.85rem;">
                        <i class="fas fa-lock me-2"></i> ${errorPass}
                    </div>
                </c:if>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/loginHome" method="POST">
            <div class="mb-3">
                <label class="custom-label">Tên đăng nhập</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                    <input type="text" name="username" value="${username}" 
                           class="form-control custom-input ${not empty errorMsg ? 'is-invalid' : ''}" 
                           placeholder="Nhập tên tài khoản" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="custom-label">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" 
                           class="form-control custom-input ${not empty errorPass ? 'is-invalid' : ''}" 
                           placeholder="Mật khẩu" required>
                </div>
            </div>

            <button type="submit" class="btn btn-submit w-100">
                ĐĂNG NHẬP <i class="fas fa-arrow-right ms-2"></i>
            </button>

            <div class="divider">Hoặc</div>

            <a href="${pageContext.request.contextPath}/login-google" class="btn-google w-100">
                <svg width="18" height="18" viewBox="0 0 48 48" class="me-2">
                    <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                    <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
                    <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24s.92 7.54 2.56 10.78l7.97-6.19z"/>
                    <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.31-8.16 2.31-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
                </svg>
                Tiếp tục với Google
            </a>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Quên mật khẩu?</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>