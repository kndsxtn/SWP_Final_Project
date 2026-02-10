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
                    <div>
                        <c:if test="${categoryForm == 'create'}">
                            <form action="${pageContext.request.contextPath}/category/CreateCategoryController" method = post>
                                Tên<input type="text" name="category_name" class="form-control" placeholder="Nhập tên danh mục..." required/>
                                Mã Tiền Tố<input type="text" name="prefix_code" class="form-control" placeholder="VD: PC, LAP..."/>
                                Mô tả<input type="text" name="description" class="form-control" placeholder="Nhập mô tả ngắn gọn..."/>
                                <button type="submit">
                                    Tạo mới
                                </button>         
                            </form>

                        </c:if>
                        <c:if test="${categoryForm == 'update'}">
                            <form action="${pageContext.request.contextPath}/category/UpdateCategoryController" method = post>
                                Id<input type="text"value="${category.categoryId}" class="form-control bg-light" disabled/>
                                <input type="hidden" name="category_id" value="${category.categoryId}" />
                                Tên<input type="text" name="category_name" class="form-control" value="${category.categoryName}" required/>
                                Mã Tiền Tố<input type="text" name="prefix_code" class="form-control" value="${category.prefixCode}"/>
                                Mô tả<input type="text" name="description" class="form-control" value="${category.description}"/>
                                <button type="submit">
                                    Cập nhật
                                </button>                
                            </form>

                        </c:if>
                    </div>

                </main>

            </div>
        </div>
        <jsp:include page="../components/footer.jsp"></jsp:include>
    </body>
</html>