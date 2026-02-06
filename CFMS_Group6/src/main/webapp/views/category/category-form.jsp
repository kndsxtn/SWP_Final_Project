<%-- 
    Document   : form
    Created on : Feb 3, 2026, 11:23:35 AM
    Author     : quang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Biểu mẫu danh mục</title>
    </head>
    <body>
        <form action="CreateCategory" method="post">
            Tạo danh mục mới: <input type="text" name="category_name"/><br/>
            Nhập tiền tố cho danh mục: <input type="text" name="prefix_code"/><br/>
            Nhập mô tả cho danh mục: <input type="text" name="description"/><br/>
            <input type="submit" name = "cat_form_submit" value="Tạo danh mục mới"/>
        </form>
    </body>
</html>
