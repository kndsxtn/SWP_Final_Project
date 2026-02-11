<%-- 
    Document   : transfer-list
    Created on : Feb 10, 2026, 8:47:36 PM
    Author     : Pham Van Tung
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>
    <body class="d-flex flex-column">

        <jsp:include page="../components/header.jsp"></jsp:include>

            <div class="container-fluid flex-grow-1">
                <div class="row h-100"> 

                <jsp:include page="../components/sidebar.jsp">
                    <jsp:param name="page" value="transfer_list"/>
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <table class="table table-bordered table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Mã phiếu</th>
                                    <th>Người tạo</th>
                                    <th>Phòng nguồn</th>
                                    <th>Phòng đích</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list}" var="t" varStatus="st">
                                    <tr>
                                        <td>${st.index + 1}</td>
                                        <td>${t.transferId}</td>
                                        <td>${t.creator.fullName}</td>                                       
                                        <td>${t.sourceRoom.roomName}</td>
                                        <td>${t.destRoom.roomName}</td>
                                        <td>${t.createdDate}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${t.status == 'Pending'}">
                                                    <span class="badge bg-warning">Chờ duyệt</span>
                                                </c:when>
                                                <c:when test="${t.status == 'Approved'}">
                                                    <span class="badge bg-success">Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${t.status == 'Rejected'}">
                                                    <span class="badge bg-danger">Từ chối</span>
                                                </c:when>
                                                <c:when test="${t.status == 'Completed'}">
                                                    <span class="badge bg-success">Đã hoàn thành</span>
                                                </c:when>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <a href="${pageContext.request.contextPath}/transfer/detail?id=${t.transferId}" class="btn btn-sm btn-primary">
                                                <i class="bi bi-eye"></i> Xem
                                            </a>

                                            <c:if test="${sessionScope.user.roleName== 'Asset Staff' && t.status == 'Pending'}">
                                                <a href="transfer-reject?id=${t.transferId}" class="btn btn-sm btn-danger">
                                                    <i class="bi bi-x">Huỷ đơn</i>
                                                </a>
                                            </c:if>
                                            <c:if test="${sessionScope.user.roleName== 'Finance Head' && t.status == 'Pending'}">
                                                <a href="transfer-reject?id=${t.transferId}" class="btn btn-sm btn-success">
                                                    <i class="bi bi-x">Duyệt đơn</i>
                                                </a>
                                                <a href="transfer-reject?id=${t.transferId}" class="btn btn-sm btn-warning">
                                                    <i class="bi bi-x">Từ chối đơn</i>
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>


                    </div>

                    <div class="row">
                        <!-- <div class="col-md-12">
                            <div class="alert alert-success">
                                Chào mừng <strong>${sessionScope.user.fullName}</strong> quay trở lại hệ thống!
                            </div>
                        </div> -->
                    </div>

                </main>

            </div>
        </div>

        <jsp:include page="../components/footer.jsp"></jsp:include>

    </body>
</html>
