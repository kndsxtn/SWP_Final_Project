<%-- 
    Document   : transfer-add
    Created on : Feb 10, 2026, 8:56:19 PM
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
                    <jsp:param name="page" value="transfer_add"/>
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">

                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h2>${msg}</h2>
                    </div>
                    <form action="${pageContext.request.contextPath}/transfer/addstep2" method="get">

                        <div class="form-box">
                            <h3>Chọn phòng nguồn và phòng đích</h3>

                            <div class="row">
                                <label>Phòng Đích</label>
                                <select name="destinationRoom" required onchange="this.form.submit()">
                                    <option value="">-- Select --</option>
                                    <c:forEach items="${rooms}" var="r">
                                        <c:if test="${r.roomId != param.sourceRoom}">
                                            <option value="${r.roomId}"
                                                    ${r.roomId == param.destinationRoom ? "selected" : ""}>
                                                ${r.roomName}
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="row">
                                <label>Phòng Nguồn</label>
                                <select name="sourceRoom" required onchange="this.form.submit()">
                                    <option value="">-- Select --</option>
                                    <c:forEach items="${rooms}" var="r">
                                        <c:if test="${r.roomId != param.destinationRoom}">
                                            <option value="${r.roomId}"
                                                    ${r.roomId == param.sourceRoom ? "selected" : ""}>
                                                ${r.roomName}
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>


                        </div>
                    </form>


                    <c:if test="${not empty assets}">
                        <form action="${pageContext.request.contextPath}/transfer/addstep2" method="post">

                            <table class="table">
                                <tr>
                                    <th>Chọn</th>
                                    <th>Mã Tài Sản</th>
                                    <th>Tên Tài Sản</th>
                                    <th>Trạng Thái</th>
                                </tr>

                                <c:forEach items="${assets}" var="a">
                                    <tr>
                                        <td>
                                            <input type="checkbox" name="assetIds" value="${a.assetId}">
                                        </td>
                                        <td>${a.assetCode}</td>
                                        <td>${a.assetName}</td>
                                        <td>${a.status}</td>
                                    </tr>
                                </c:forEach>
                            </table>
                            <div class="row">
                                <label>Ghi Chú</label>
                                <textarea name="note">${param.note}</textarea>
                            </div>

                            <button type="submit" class="btn btn-primary">Tạo Đơn</button>
                        </form>
                    </c:if>
            </div>


        </div>
    </div>

    <jsp:include page="../components/footer.jsp"></jsp:include>

</body>
</html>
