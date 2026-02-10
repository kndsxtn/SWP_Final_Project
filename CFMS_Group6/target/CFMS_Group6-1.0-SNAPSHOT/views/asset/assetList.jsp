<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <html>

            <head>
                <title>Danh sách tài sản</title>
                <style>
                    table {
                        border-collapse: collapse;
                        width: 100%;
                        margin-top: 20px;
                    }

                    th,
                    td {
                        border: 1px solid #ddd;
                        padding: 12px;
                        text-align: left;
                    }

                    th {
                        background-color: #f4f4f4;
                    }

                    tr:hover {
                        background-color: #f9f9f9;
                    }

                    .status-badge {
                        padding: 5px 10px;
                        border-radius: 4px;
                        font-size: 12px;
                    }

                    .new {
                        background: #e3f2fd;
                        color: #1976d2;
                    }
                </style>
            </head>

            <body>
                <h2>Hệ thống Quản lý Tài sản</h2>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Mã tài sản</th>
                            <th>Tên tài sản</th>
                            <th>Giá trị</th>
                            <th>Trạng thái</th>
                            <th>Mô tả</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${assets}" var="a">
                            <tr>
                                <td>${a.assetId}</td>
                                <td><strong>${a.assetCode}</strong></td>
                                <td>${a.assetName}</td>
                                <td>
                                    <fmt:formatNumber value="${a.price}" type="currency" currencySymbol="VNĐ" />
                                </td>
                                <td>
                                    <span class="status-badge ${a.status.toLowerCase()}">${a.status}</span>
                                </td>
                                <td>${a.description}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty assets}">
                            <tr>
                                <td colspan="6" style="text-align: center;">Không có tài sản nào trong hệ thống.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </body>

            </html>