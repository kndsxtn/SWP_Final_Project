<%-- Document : list Created on : Feb 3, 2026, 10:15:20 AM Author : quang --%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý danh mục - CFMS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/filter.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/paging.css" rel="stylesheet">

    </head>

    <body class="d-flex flex-column">

        <jsp:include page="../components/header.jsp"></jsp:include>

            <div class="container-fluid flex-grow-1">
                <div class="row h-100">


                <jsp:include page="../components/sidebar.jsp">
                    <jsp:param name="page" value="category_list" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                    <!-- ===== Page Header ===== -->
                    <div class="cfms-page-header">
                        <h2><i class="bi bi-tags"></i> Danh sách danh mục tài sản</h2>
                        <c:if test="${user.roleName == 'Finance Head' || user.roleName == 'Asset Staff'}">
                            <a href="${pageContext.request.contextPath}/category/CreateCategoryController"
                               class="btn btn-primary">
                                <i class="bi bi-plus-lg me-1"></i>Thêm danh mục
                            </a>
                        </c:if>
                    </div>
                    <!-- ===== Status ===== -->
                    <c:if test ="${not empty status}">
                        <c:if test = "${status.contains('Lỗi')}">
                            <div class="cfms-msg cfms-msg-error">
                                <i class="bi bi-exclamation-triangle-fill"></i> ${status}
                            </div>
                        </c:if>
                        <c:if test = "${not status.contains('Lỗi')}">
                            <div class="cfms-msg cfms-msg-success">
                                <i class="bi bi-check-circle-fill"></i> ${status}
                            </div>
                        </c:if>
                    </c:if>
                    <c:if test="${not empty sessionScope.FLASH_MSG}">
                        <c:if test = "${sessionScope.FLASH_MSG.contains('Lỗi')}">
                            <div class="cfms-msg cfms-msg-error">
                                <i class="bi bi-info-circle me-1"></i> ${sessionScope.FLASH_MSG}
                            </div>
                        </c:if>
                        <c:if test = "${not sessionScope.FLASH_MSG.contains('Lỗi')}">
                            <div class="cfms-msg cfms-msg-success">
                                <i class="bi bi-check-circle-fill"></i> ${sessionScope.FLASH_MSG}
                            </div>
                        </c:if>

                        <c:remove var="FLASH_MSG" scope="session" />
                    </c:if>
                    <!-- ===== Filter & Search Bar ===== -->
                    <form class="cfms-filter" method="get"
                          action="${pageContext.request.contextPath}/category/ViewCategoryController">

                        <!-- Search input -->
                        <div class="filter-search">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0">
                                    <i class="bi bi-search text-muted"></i>
                                </span>
                                <input type="text" name="keyword" class="form-control border-start-0"
                                       placeholder="Tìm theo tên danh mục, mã hậu tố, mô tả..." value="${keyword}">
                            </div>
                        </div>

                        <!-- Select -->
                        <!--                        <div class="filter-select">
                                            <select name="prefix_keyword" class="form-select">
                                                <option value="">-- Mã tài sản --</option>
                
                                            </select>
                                        </div>-->

                        <!-- Action buttons -->
                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search me-1"></i>Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/category/ViewCategoryController"
                               class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Xóa lọc
                            </a>
                        </div>
                    </form>
                    <!--Table-->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên danh mục</th>
                                    <th>Mã hậu tố</th>
                                    <th>Mô tả</th>
                                        <c:if
                                            test="${user.roleName == 'Finance Head' || user.roleName == 'Asset Staff'}">
                                        <th class="text-center">Hành động</th>
                                        </c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${catList}" var="c" begin="${tool.start}" end="${tool.end}">
                                    <tr>
                                        <td class="text-muted">${c.categoryId}</td>
                                        <td class="fw-semibold">${c.categoryName}</td>
                                        <td>
                                            <span class="badge bg-info-subtle text-info px-3">
                                                ${c.prefixCode}
                                            </span>
                                        </td>
                                        <td>${empty c.description?'Danh mục hiện không có mô tả':c.description}</td>
                                        <c:if
                                            test="${user.roleName == 'Finance Head' || user.roleName == 'Asset Staff'}">
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/category/UpdateCategoryController?id=${c.categoryId}"
                                                   class="btn btn-sm btn-light me-1" title="Sửa">
                                                    <i class="bi bi-pencil-square text-primary"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/category/DeleteCategoryController?id=${c.categoryId}"
                                                   class="btn btn-sm btn-light"
                                                   onclick="return confirm('Bạn có chắc muốn xóa?');"
                                                   title="Xóa">
                                                    <i class="bi bi-trash text-danger"></i>
                                                </a>
                                            </td>
                                        </c:if>

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
                    <hr/>
                    <!-- Paging -->
                    <div class ="cfms-paging" ${tool.totalPage <=1 ? 'hidden':''}>
                        <div>
                            <span class="paging-info">
                                Hiển thị trang <strong>${tool.index+1}</strong>/${tool.totalPage} (${tool.size} danh mục)
                            </span>
                        </div>
                        <ul class="pagination">
                            <c:if test='${tool.index!=0}'>
                                <a class="page-link" href='ViewCategoryController?index=0'>&laquo;</a>
                                <a class="page-link" href='ViewCategoryController?index=${tool.index-1}'>&lsaquo;</a>
                            </c:if>
                            <c:forEach var = 'index' begin ='${tool.pageStart}' end ='${tool.pageEnd}'>
                                <a class="page-link" href='ViewCategoryController?index=${index}'>${index+1}</a>
                            </c:forEach>
                            <c:if test='${tool.index!=tool.totalPage-1}'>
                                <a class="page-link" href='ViewCategoryController?index=${tool.index+1}'>&rsaquo;</a>
                                <a class="page-link" href='ViewCategoryController?index=${tool.totalPage-1}'>&raquo;</a>
                            </c:if>
                        </ul>
                    </div>
                </main>
            </div>
        </div>
        <jsp:include page="../components/footer.jsp"></jsp:include>

    </body>

</html>