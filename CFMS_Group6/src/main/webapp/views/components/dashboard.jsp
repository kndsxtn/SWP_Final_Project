<%-- 
    Document   : dashboard.jsp
    Created on : Feb 4, 2026, 9:18:16 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CFMS</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    
    <style>
        html, body {
            height: 100%;
        }
    </style>
</head>

<body class="d-flex flex-column">

    <jsp:include page="../components/header.jsp"></jsp:include>

    <div class="container-fluid flex-grow-1">
        <div class="row h-100"> 
            
            <jsp:include page="../components/sidebar.jsp">
                <jsp:param name="page" value="home"/>
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Tổng quan hệ thống</h1>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <div class="alert alert-success">
                            Chào mừng <strong>${sessionScope.user.fullName}</strong> quay trở lại hệ thống!
                        </div>
                    </div>
                </div>

            </main>
            
            </div>
    </div>

    <jsp:include page="../components/footer.jsp"></jsp:include>

</body>
</html>