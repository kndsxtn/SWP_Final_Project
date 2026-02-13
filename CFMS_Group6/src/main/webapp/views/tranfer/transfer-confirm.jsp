<%-- 
    Document   : transfer-confirm
    Created on : Feb 13, 2026, 2:06:36 PM
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

                    <div class="d-flex justify-content-center align-items-center flex-column mt-5">
                        <h2 class="mb-4 fw-bold text-primary">
                            <i class="bi bi-box-arrow-right"></i> Xác nhận bàn giao
                        </h2>

                        <div class="d-flex gap-4">
                            <a href="${pageContext.request.contextPath}/transfer/handover"
                               class="btn btn-lg btn-outline-primary px-5 py-3 shadow-sm">
                                <i class="bi bi-truck fs-4 d-block mb-2"></i>
                                Đơn bàn giao
                            </a>

                            <a href="${pageContext.request.contextPath}/transfer/receive"
                               class="btn btn-lg btn-outline-success px-5 py-3 shadow-sm">
                                <i class="bi bi-box-seam fs-4 d-block mb-2"></i>
                                Đơn nhận
                            </a>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <jsp:include page="../components/footer.jsp"></jsp:include>

    </body>
</html>
