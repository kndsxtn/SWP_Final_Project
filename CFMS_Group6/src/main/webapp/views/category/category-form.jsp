<%-- 
    Document   : form
    Created on : Feb 3, 2026, 11:23:35 AM
    Author     : quang
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Biểu mẫu danh mục</title>
        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/user-list.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/views/components/sidebar.jsp">
            <jsp:param name="active" value="category"/>
        </jsp:include>
        <div class="main">
            <jsp:include page="/views/components/navbar.jsp">
                <jsp:param name="title" value="Hệ thống / Quản lý danh mục / Biểu mẫu"/>
            </jsp:include>
            <div class="box">
                <div class="container-fluid">
                    <div class="row justify-content-center">
                        <div class="col-md-8"> <c:if test="${not empty status}">
                                <div class="alert alert-info alert-dismissible fade show shadow-sm border-0" role="alert">
                                    <i class="fas fa-info-circle me-2"></i> ${status}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <div class="card border-0 shadow-sm p-4">
                                <%-- FORM CREATE --%>
                                <c:if test="${categoryForm == 'create'}"> 
                                    <div class="card-body">
                                        <h4 class="fw-bold text-dark mb-4 border-bottom pb-3">
                                            <i class="fas fa-plus-circle text-primary me-2"></i>Tạo danh mục mới
                                        </h4>
                                        <form action="${pageContext.request.contextPath}/CreateCategory" method="post" class="needs-validation">
                                            <div class="row g-3">
                                                <div class="col-md-12">
                                                    <label class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label>
                                                    <input type="text" name="category_name" class="form-control" placeholder="Nhập tên danh mục..." required/>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label fw-semibold">Mã tiền tố (Prefix)</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-light"><i class="fas fa-tag"></i></span>
                                                        <input type="text" name="prefix_code" class="form-control" placeholder="VD: PC, LAP..."/>
                                                    </div>
                                                    <div class="form-text small">Mã dùng để sinh ID tài sản (VD: PC-001)</div>
                                                </div>
                                                <div class="col-md-8">
                                                    <label class="form-label fw-semibold">Mô tả</label>
                                                    <input type="text" name="description" class="form-control" placeholder="Nhập mô tả ngắn gọn..."/>
                                                </div>
                                                <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                                                    <a href="${pageContext.request.contextPath}/ViewCategory" class="btn btn-light rounded-pill px-4">
                                                        Hủy bỏ
                                                    </a>
                                                    <button type="submit" name="cat_form_submit" class="btn btn-primary rounded-pill px-4 shadow-sm">
                                                        <i class="fas fa-save me-2"></i> Tạo mới
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>
                                <%-- FORM UPDATE --%>
                                <c:if test="${categoryForm == 'update'}"> 
                                    <div class="card-body">
                                        <h4 class="fw-bold text-dark mb-4 border-bottom pb-3">
                                            <i class="fas fa-edit text-warning me-2"></i>Cập nhật danh mục
                                        </h4>

                                        <form action="${pageContext.request.contextPath}/UpdateCategory" method="post">
                                            <div class="row g-3">
                                                <div class="col-md-2">
                                                    <label class="form-label fw-semibold">ID</label>
                                                    <input type="text"value="${category.categoryId}" class="form-control bg-light" disabled/>
                                                    <input type="hidden" name="category_id" value="${categoryId}" />
                                                </div>

                                                <div class="col-md-10">
                                                    <label class="form-label fw-semibold">Tên danh mục</label>
                                                    <input type="text" name="category_name" value="${category.categoryName}" class="form-control" required/>
                                                </div>

                                                <div class="col-md-4">
                                                    <label class="form-label fw-semibold">Mã tiền tố</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-light"><i class="fas fa-tag"></i></span>
                                                        <input type="text" name="prefix_code" value="${category.prefixCode}" class="form-control"/>
                                                    </div>
                                                </div>

                                                <div class="col-md-8">
                                                    <label class="form-label fw-semibold">Mô tả</label>
                                                    <input type="text" name="description" value="${category.description}" class="form-control"/>
                                                </div>

                                                <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                                                    <a href="${pageContext.request.contextPath}/ViewCategory" class="btn btn-light rounded-pill px-4">
                                                        Quay lại
                                                    </a>
                                                    <button type="submit" name="cat_form_submit" class="btn btn-warning text-white rounded-pill px-4 shadow-sm">
                                                        <i class="fas fa-sync-alt me-2"></i> Cập nhật
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>