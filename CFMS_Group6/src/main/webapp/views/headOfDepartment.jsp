<%-- 
    Document   : Head of Department
    Created on : Feb 2, 2026, 9:01:40 PM
    Author     : Nguyen Dang Khang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello teacher</h1>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
    </body>
</html>
