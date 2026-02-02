<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập Hệ Thống</title>
    
    <!-- Bootstrap 5 CSS-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- CSS Tùy chỉnh (Đã chứa các class rút gọn) -->
    <link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body>

    <div class="login-card p-4 fade-in-down">
        <div class="card-header-custom">
            <div class="login-icon">
                <i class="fas fa-user-circle"></i>
            </div>
            <h3 class="title-text">Welcome Back!</h3>
            <p class="subtitle-text">Hệ thống Quản lý Thiết bị (CFMS)</p>
        </div>
        
        <div class="card-body">
            <!-- Thông báo lỗi -->
            <c:if test="${not empty errorMessage}">
                <div class="error-msg">
                    <i class="fas fa-exclamation-circle me-2"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/loginHome" method="POST">
                
                <!-- Username Input -->
                <div class="mb-3">
                    <label for="username" class="custom-label">Tên đăng nhập</label>
                    <div class="input-group">
                        <span class="input-group-text input-icon">
                            <i class="fas fa-user"></i>
                        </span>
                        <input type="text" class="form-control custom-input" id="username" name="username" 
                               value="${username}" placeholder="Nhập username..." required autofocus>
                    </div>
                </div>
                
                <!-- Password Input -->
                <div class="mb-4">
                    <label for="password" class="custom-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text input-icon">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" class="form-control custom-input" id="password" name="password" 
                               placeholder="Nhập mật khẩu..." required>
                    </div>
                </div>
                
                <!-- Login Button -->
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-submit">
                        ĐĂNG NHẬP <i class="fas fa-arrow-right ms-2"></i>
                    </button>
                </div>
                
                <!-- Forgot Password Link -->
                <div class="text-center mt-3">
                    <a href="#" class="forgot-link">Quên mật khẩu?</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>