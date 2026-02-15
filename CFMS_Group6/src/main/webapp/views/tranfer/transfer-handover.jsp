<%-- 
    Document   : transfer-handover
    Created on : Feb 13, 2026, 2:28:15 PM
    Author     : Admin
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
                    <h1>Đơn bàn giao</h1>
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <table class="table table-bordered table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Phòng nguồn</th>
                                    <th>Phòng đích</th>
                                    <th>Ngày tạo</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list}" var="t">
                                    <c:if test="${t.status != 'Pending' && t.status != 'Rejected' && t.status != 'Cancelled'}">
                                        <tr>
                                            <td>${t.transferId}</td>                                      
                                            <td>${t.sourceRoom.roomName}</td>
                                            <td>${t.destRoom.roomName}</td>
                                            <td>${t.createdDate}</td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.status == 'Approved'}">
                                                        <span class="badge bg-danger">Chưa Bàn Giao</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'Ongoing'}">
                                                        <span class="badge bg-success">Đã Bàn Giao</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'Completed'}">
                                                        <span class="badge bg-success">Đã hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'Failed'}">
                                                        <span class="badge bg-success">Bên đích từ chối nhận, tài sản đã được hoàn trả</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <a href="${pageContext.request.contextPath}/transfer/detail?id=${t.transferId}" class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye"></i> Xem tài sản cần bàn giao
                                                </a>

                                                <c:if test="${t.status == 'Approved'}">
                                                    <a href="${pageContext.request.contextPath}/transfer/update?id=${t.transferId}&status=Ongoing&room=${t.sourceRoom.roomName}" class="btn btn-sm btn-success">
                                                        <i class="bi ">Xác nhận bàn giao</i>
                                                    </a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>


                    </div>
                    <a href="${pageContext.request.contextPath}/transfer/confirm" class="btn btn-sm btn-warning">
                    <i class="bi ">Trở về</i>
                </a>
                </main>
                    

            </div>
        </div>
        

        <jsp:include page="../components/footer.jsp"></jsp:include>

    </body>
</html>
