<%-- 
    Document   : list
    Created on : Feb 3, 2026, 10:15:20 AM
    Author     : quang
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý danh mục tài sản - CFMS</title>
        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/user-list.css" rel="stylesheet">
    </head>
    <body>

        <!-- Sidebar -->
        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active" value="category"/>
        </jsp:include>

        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/views/components/navbar.jsp">
                <jsp:param name="title" value="Hệ thống / Quản lý danh mục tài sản"/>
            </jsp:include>

            <div class="box">
                <div class="card border-0 shadow-sm p-4">

                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h3 class="fw-bold text-dark m-0">Danh sách danh mục tài sản</h3>
                            <p class="text-muted small">Quản lý và phân loại tài sản trong hệ thống</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/category/CreateCategory"
                           class="btn btn-primary px-4 rounded-pill shadow-sm">
                            <i class="fas fa-plus me-2"></i> Thêm danh mục
                        </a>
                    </div>

                    <!-- Search / Filter -->
                    <form action="${pageContext.request.contextPath}/category/ViewCategory" method="post" class="row g-2 mb-3">
                        <div class="col-md-4">
                            <input type="text" name="keyword" class="form-control"
                                   placeholder="Tìm theo tên, mã hoặc mô tả..."
                                   value="${param.keyword}">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="fas fa-search me-1"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>

                    <!-- Table -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên danh mục</th>
                                    <th>Mã hậu tố</th>
                                    <th>Mô tả</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${catList}" var="c">
                                    <tr>
                                        <td class="text-muted">${c.categoryId}</td>
                                        <td class="fw-semibold">${c.categoryName}</td>
                                        <td>
                                            <span class="badge bg-info-subtle text-info px-3">
                                                ${c.prefixCode}
                                            </span>
                                        </td>
                                        <td>${c.description}</td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/category/UpdateCategory?id=${c.categoryId}"
                                               class="btn btn-sm btn-light me-1" title="Sửa">
                                                <i class="fas fa-edit text-primary"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/category/DeleteCategory?id=${c.categoryId}"
                                               class="btn btn-sm btn-light"
                                               onclick="return confirm('Bạn có chắc muốn xóa?');"
                                               title="Xóa">
                                                <i class="fas fa-trash text-danger"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty catList}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            Không có danh mục nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>