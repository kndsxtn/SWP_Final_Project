<%-- 
    Document   : login
    Created on : Jan 30, 2026, 9:47:49 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .error { color: red; font-weight: bold; }
        </style>
    </head>
    <body>
        <div align="center">
            <h2>Hệ thống Quản lý Thiết bị CFMS</h2>
            
            <% 
               String err = (String) request.getAttribute("error");
               if(err != null) { 
            %>
                <p class="error"><%= err %></p>
            <% } %>

            <form action="login" meth  od="post">
                <table>
                    <tr>
                        <td>Username:</td>
                        <td><input type="text" name="user" required/></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="password" name="pass" required/></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" value="Đăng nhập"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
