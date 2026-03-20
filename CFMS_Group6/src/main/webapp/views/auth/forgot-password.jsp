<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - CFMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .forgot-card {
            background: white;
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
        }
        .btn-primary {
            background: #764ba2;
            border: none;
            padding: 0.8rem;
            border-radius: 10px;
        }
        .btn-primary:hover {
            background: #667eea;
        }
        .back-link {
            text-decoration: none;
            color: #764ba2;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <div class="forgot-card">
        <div class="text-center mb-4">
            <h3 class="fw-bold">Quên mật khẩu?</h3>
            <p class="text-muted">Nhập email liên kết với tài khoản của bạn để nhận mật khẩu mới.</p>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i>${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("errorMsg"); %>
        </c:if>

        <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
            <div class="mb-4">
                <label class="form-label fw-semibold">Email tài khoản</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0">
                        <i class="bi bi-envelope text-muted"></i>
                    </span>
                    <input type="email" name="email" class="form-control border-start-0 bg-light" 
                           placeholder="example@gmail.com" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100 mb-3">
                <i class="bi bi-send me-2"></i>Gửi mật khẩu mới
            </button>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/loginHome" class="back-link">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại trang đăng nhập
                </a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
