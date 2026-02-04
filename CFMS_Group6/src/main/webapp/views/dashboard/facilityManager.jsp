<%-- 
    Document   : Facility Manager
    Created on : Feb 2, 2026, 9:01:35 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Yêu cầu Cấp phát - CFMS</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="#">CFMS System</a>
            <div class="d-flex text-white align-items-center">
                <span class="me-3">Xin chào, ${sessionScope.account.username}</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-light">Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid" style="margin-top: 60px;">
        <div class="row">
            
            <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse" style="min-height: 100vh; border-right: 1px solid #dee2e6;">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="dashboard">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active bg-primary text-white rounded" href="allocation-list">
                                <i class="bi bi-box-seam me-2"></i> Yêu cầu Cấp phát
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="#">
                                <i class="bi bi-pc-display me-2"></i> Quản lý Tài sản
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="#">
                                <i class="bi bi-arrow-left-right me-2"></i> Điều chuyển
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pt-3">
                
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                    <h1 class="h2">Danh sách Yêu cầu Cấp phát</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i> Tạo yêu cầu mới
                        </button>
                    </div>
                </div>

                <div class="table-responsive shadow-sm rounded">
                    <table class="table table-hover table-striped align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>#ID</th>
                                <th>Người yêu cầu</th>
                                <th>Phòng ban</th>
                                <th>Ngày tạo</th>
                                <th>Nội dung</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>REQ-001</strong></td>
                                <td>Nguyễn Văn A</td>
                                <td>Phòng CNTT</td>
                                <td>03/02/2026</td>
                                <td>Xin cấp 02 Laptop Dell</td>
                                <td><span class="badge bg-warning text-dark">Chờ duyệt</span></td>
                                <td>
                                    <a href="#" class="btn btn-sm btn-outline-primary" title="Xem chi tiết"><i class="bi bi-eye"></i></a>
                                    <a href="#" class="btn btn-sm btn-success" title="Duyệt"><i class="bi bi-check-lg"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>REQ-002</strong></td>
                                <td>Trần Thị B</td>
                                <td>Phòng Kế toán</td>
                                <td>01/02/2026</td>
                                <td>Xin cấp 01 Máy in</td>
                                <td><span class="badge bg-success">Đã duyệt</span></td>
                                <td>
                                    <a href="#" class="btn btn-sm btn-outline-primary"><i class="bi bi-eye"></i></a>
                                </td>
                            </tr>
                             <tr>
                                <td><strong>REQ-003</strong></td>
                                <td>Lê Văn C</td>
                                <td>Phòng Nhân sự</td>
                                <td>30/01/2026</td>
                                <td>Xin cấp 05 Ghế xoay</td>
                                <td><span class="badge bg-danger">Từ chối</span></td>
                                <td>
                                    <a href="#" class="btn btn-sm btn-outline-primary"><i class="bi bi-eye"></i></a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>