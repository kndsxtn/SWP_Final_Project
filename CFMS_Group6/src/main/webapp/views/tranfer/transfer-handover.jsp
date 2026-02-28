<%-- Document : transfer-handover Created on : Feb 13, 2026, 2:28:15 PM Author : Pham Van Tung --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>JSP Page</title>
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
                <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            </head>

            <body class="d-flex flex-column">

                <jsp:include page="../components/header.jsp"></jsp:include>

                <div class="container-fluid flex-grow-1">
                    <div class="row h-100">

                        <jsp:include page="../components/sidebar.jsp">
                            <jsp:param name="page" value="transfer_list" />
                        </jsp:include>

                        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                            <div
                                class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                <h1 class="h2 text-secondary" style="font-weight: 500;">Đơn bàn giao</h1>
                            </div>

                            <div class="table-responsive shadow-sm rounded bg-white p-3 mb-4">
                                <table class="table table-hover align-middle border-bottom" style="color: #495057;">
                                    <thead class="table-light text-muted" style="border-bottom: 2px solid #dee2e6;">
                                        <tr>
                                            <th class="fw-semibold">Mã phiếu</th>
                                            <th class="fw-semibold">Phòng nguồn</th>
                                            <th class="fw-semibold">Phòng đích</th>
                                            <th class="fw-semibold">Ngày tạo</th>
                                            <th class="fw-semibold">Trạng thái</th>
                                            <th class="fw-semibold text-center">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody style="border-top: none;">
                                        <c:forEach items="${list}" var="t">
                                            <c:if
                                                test="${t.status != 'Pending' && t.status != 'Rejected' && t.status != 'Cancelled'}">
                                                <tr>
                                                    <td class="fw-medium text-primary">${t.transferId}</td>
                                                    <td>${t.sourceRoom.roomName}</td>
                                                    <td>${t.destRoom.roomName}</td>
                                                    <td>${t.createdDate}</td>

                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${t.status == 'Approved'}">
                                                                <span
                                                                    class="badge bg-danger border border-danger-subtle rounded-pill px-3 py-2 fw-normal"
                                                                    style="background-color: #f8d7da !important; color: #842029 !important;">Chưa
                                                                    Bàn Giao</span>
                                                            </c:when>
                                                            <c:when test="${t.status == 'Ongoing'}">
                                                                <span
                                                                    class="badge bg-warning text-dark border border-warning-subtle rounded-pill px-3 py-2 fw-normal"
                                                                    style="background-color: #fff3cd !important; color: #664d03 !important;">Đang
                                                                    chờ xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${t.status == 'Completed'}">
                                                                <span
                                                                    class="badge bg-success border border-success-subtle rounded-pill px-3 py-2 fw-normal"
                                                                    style="background-color: #d1e7dd !important; color: #0f5132 !important;">Đã
                                                                    hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${t.status == 'Returned'}">
                                                                <span
                                                                    class="badge bg-secondary border border-secondary-subtle rounded-pill px-3 py-2 fw-normal"
                                                                    style="background-color: #e2e3e5 !important; color: #41464b !important;">Đích
                                                                    từ chối (Đã nhận lại)</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>

                                                    <td class="text-center">
                                                        <div class="d-flex gap-2 justify-content-center flex-wrap">
                                                            <a href="${pageContext.request.contextPath}/transfer/detail?id=${t.transferId}"
                                                                class="btn btn-sm btn-outline-primary shadow-sm">
                                                                <i class="bi bi-eye"></i> Xem tài sản
                                                            </a>

                                                            <c:if test="${t.status == 'Approved'}">
                                                                <a href="${pageContext.request.contextPath}/transfer/update?id=${t.transferId}&status=Ongoing&room=${t.sourceRoom.roomName}"
                                                                    class="btn btn-sm btn-outline-success shadow-sm">
                                                                    <i class="bi bi-box-seam"></i> Bàn giao
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <a href="${pageContext.request.contextPath}/transfer/confirm"
                                class="btn btn-outline-secondary px-4 shadow-sm">
                                <i class="bi bi-arrow-left"></i> Trở về
                            </a>
                        </main>


                    </div>
                </div>


                <jsp:include page="../components/footer.jsp"></jsp:include>

            </body>

            </html>