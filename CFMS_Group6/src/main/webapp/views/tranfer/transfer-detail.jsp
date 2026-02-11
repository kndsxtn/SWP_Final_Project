<%-- 
    Document   : transfer-detail
    Created on : Feb 11, 2026, 7:33:52 PM
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

                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <table class="table table-bordered table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>#</th>
                                    <th>Tên tài sản</th>
                                    <th>Mã tài sản</th>
                                    <th>Trạng thái lúc chuyển</th>
                                    <th>Ngày chuyển</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${transferDetails}" var="t" varStatus="st">
                                    <tr>
                                        <td>${st.index + 1}</td>
                                        <td>${t.asset.assetName}</td>
                                        <td>${t.asset.assetCode}</td>                                       
                                        <td>${t.statusAtTransfer}</td>
                                        <td>${t.transferDate}</td>
                                      

                                        
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>


                    </div>



                </main>

            </div>
        </div>

        <jsp:include page="../components/footer.jsp"></jsp:include>

    </body>
</html>
