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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
            ${categoryForm == 'create'?'Thêm danh mục':'Cập nhật danh mục'} - CFMS
        </title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/filter.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
    </head>
    <body class="d-flex flex-column">
        <jsp:include page="../components/header.jsp"></jsp:include>

            <div class="container-fluid flex-grow-1">
                <div class="row h-100"> 

                <c:if test="${categoryForm == 'create'}">
                    <jsp:include page="../components/sidebar.jsp">
                        <jsp:param name="page" value="category_form"/>
                    </jsp:include>
                </c:if>
                <c:if test="${categoryForm == 'update'}">
                    <jsp:include page="../components/sidebar.jsp">
                        <jsp:param name="page" value="category_list"/>
                    </jsp:include>
                </c:if>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                    <!-- ===== Page Header ===== -->
                    <c:if test="${categoryForm == 'create'}">
                        <div class="cfms-page-header">
                            <h2><i class="bi bi-tag"></i> Thêm danh mục tài sản</h2>
                        </div>
                    </c:if>
                    <c:if test="${categoryForm == 'update'}">
                        <div class="cfms-page-header">
                            <h2><i class="bi bi-tag"></i> Cập nhật danh mục tài sản</h2>
                        </div>
                    </c:if>



                    <div class="card-body p-4">
                        <c:if test="${categoryForm == 'create'}">
                            <form action="${pageContext.request.contextPath}/category/CreateCategoryController" method = post>
                                <div class="row">
                                    <div class="col-md-8 mb-3">
                                        <label for="catName" class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label>
                                        <input type="text" id="catName" name="category_name" class="form-control" placeholder="Ví dụ: Máy tính xách tay..." required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="preCode" class="form-label fw-semibold">Mã Tiền Tố <span class="text-danger">*</span></label>
                                        <input type="text" id="preCode" name="prefix_code" class="form-control text-uppercase" placeholder="VD: LAP">
                                        <div class="form-text">Mã dùng để sinh ID tài sản (VD: LAP001)</div>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="desc" class="form-label fw-semibold">Mô tả</label>
                                    <textarea id="desc" name="description" class="form-control" rows="3" placeholder="Nhập mô tả ngắn gọn về danh mục này..."></textarea>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button type="reset" class="btn btn-light border">
                                        <i class="bi bi-arrow-counterclockwise"></i> Nhập lại
                                    </button>
                                    <button type="submit" class="btn btn-primary px-4">
                                        <i class="bi bi-plus-lg"></i> Tạo mới
                                    </button>
                                </div>
                            </form>
                        </c:if>
                        <c:if test="${categoryForm == 'update'}">
                            <form action="${pageContext.request.contextPath}/category/UpdateCategoryController" method = post>
                                <input type="hidden" name="category_id" value="${category.categoryId}" />

                                <div class="row">
                                    <div class="col-md-2 mb-3">
                                        <label class="form-label fw-semibold">ID</label>
                                        <input type="text" value="${category.categoryId}" class="form-control bg-light text-secondary" disabled>
                                    </div>

                                    <div class="col-md-7 mb-3">
                                        <label for="upName" class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label>
                                        <input type="text" id="upName" name="category_name" class="form-control" value="${category.categoryName}" required>
                                    </div>

                                    <div class="col-md-3 mb-3">
                                        <label for="upCode" class="form-label fw-semibold">Mã Tiền Tố</label>
                                        <input type="text" id="upCode" name="prefix_code" class="form-control text-uppercase" value="${category.prefixCode}">
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label for="upDesc" class="form-label fw-semibold">Mô tả</label>
                                    <textarea id="upDesc" name="description" class="form-control" rows="3">${category.description}</textarea>
                                </div>

                                <div class="d-flex justify-content-end gap-2">
                                    <a href="${pageContext.request.contextPath}/category/ViewCategoryController" class="btn btn-secondary">
                                        Hủy bỏ
                                    </a>
                                    <button type="submit" class="btn btn-warning text-white px-4">
                                        <i class="bi bi-save"></i> Cập nhật
                                    </button>
                                </div>         
                            </form>
                        </c:if>
                    </div>

                </main>
            </div>

        </div>

        <jsp:include page="../components/footer.jsp"></jsp:include>
        <c:if test ="${not empty status}">
            <div class="col-md-8 ms-auto mb-3 cfms-msg text-end">
                ${status}
            </div>
        </c:if>
    </body>
</html>