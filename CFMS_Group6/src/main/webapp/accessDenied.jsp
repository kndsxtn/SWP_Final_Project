<%-- Document : accessDenied.jsp Description: Trang hiển thị khi user không có quyền truy cập Author : CFMS Group6 --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Không có quyền truy cập - CFMS</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

                <style>
                    body {
                        background: #f0f2f5;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: 100vh;
                        margin: 0;
                        font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
                    }

                    .denied-card {
                        background: #fff;
                        border-radius: 16px;
                        padding: 48px;
                        text-align: center;
                        max-width: 480px;
                        box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
                    }

                    .denied-icon {
                        font-size: 4rem;
                        color: #d93025;
                        margin-bottom: 16px;
                    }

                    .denied-card h2 {
                        font-weight: 700;
                        color: #202124;
                        margin-bottom: 12px;
                    }

                    .denied-card p {
                        color: #5f6368;
                        margin-bottom: 24px;
                    }
                </style>
            </head>

            <body>
                <div class="denied-card">
                    <div class="denied-icon">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <h2>Không có quyền truy cập</h2>
                    <p>Bạn không có quyền thực hiện thao tác này. Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là
                        lỗi.</p>

                    <div class="d-flex gap-2 justify-content-center">
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                            <i class="bi bi-house me-1"></i>Về trang chủ
                        </a>
                        <button onclick="history.back()" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Quay lại
                        </button>
                    </div>
                </div>
            </body>

            </html>