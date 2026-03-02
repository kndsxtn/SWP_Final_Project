<%-- Document : transfer-list Created on : Feb 10, 2026, 8:47:36 PM Author : Pham Van Tung --%>

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
                                <h1 class="h2 text-secondary" style="font-weight: 500;">Danh sách yêu cầu điều chuyển
                                </h1>
                            </div>

                            <div class="table-responsive shadow-sm rounded bg-white p-3 mb-4">
                                <table id="transferTable" class="table table-hover align-middle border-bottom"
                                    style="color: #495057;">
                                    <thead class="table-light text-muted" style="border-bottom: 2px solid #dee2e6;">
                                        <tr>
                                            <th class="fw-semibold">#</th>
                                            <th class="fw-semibold">Mã phiếu</th>
                                            <th class="fw-semibold">Người tạo</th>
                                            <th class="fw-semibold">Phòng nguồn</th>
                                            <th class="fw-semibold">Phòng đích</th>
                                            <th class="fw-semibold">Ngày tạo</th>
                                            <th class="fw-semibold">Trạng thái</th>
                                            <th class="fw-semibold text-center">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody style="border-top: none;">
                                        <c:forEach items="${list}" var="t" varStatus="st">
                                            <tr>
                                                <td class="text-muted">${st.index + 1}</td>
                                                <td class="fw-medium text-primary">${t.transferId}</td>
                                                <td>${t.creator.fullName}</td>
                                                <td>${t.sourceRoom.roomName}</td>
                                                <td>${t.destRoom.roomName}</td>
                                                <td>${t.createdDate}</td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${t.status == 'Pending'}">
                                                            <span
                                                                class="badge bg-warning text-dark border border-warning-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #fff3cd !important;">Chờ
                                                                duyệt</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Ongoing'}">
                                                            <span
                                                                class="badge bg-info text-dark border border-info-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #cff4fc !important;">Đang vận
                                                                chuyển</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Approved'}">
                                                            <span
                                                                class="badge bg-success border border-success-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #d1e7dd !important; color: #0f5132 !important;">Đã
                                                                duyệt</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Rejected'}">
                                                            <span
                                                                class="badge bg-danger border border-danger-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #f8d7da !important; color: #842029 !important;">Từ
                                                                chối duyệt</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Completed'}">
                                                            <span
                                                                class="badge bg-success border border-success-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #d1e7dd !important; color: #0f5132 !important;">Hoàn
                                                                thành</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Cancelled'}">
                                                            <span
                                                                class="badge bg-secondary border border-secondary-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #e2e3e5 !important; color: #41464b !important;">Đã
                                                                huỷ</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Returned'}">
                                                            <span
                                                                class="badge bg-warning text-dark border border-warning-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #fff3cd !important; color: #664d03 !important;">Chờ
                                                                xác nhận trả hàng</span>
                                                        </c:when>
                                                        <c:when test="${t.status == 'Return_Confirmed'}">
                                                            <span
                                                                class="badge bg-secondary border border-secondary-subtle rounded-pill px-3 py-2 fw-normal"
                                                                style="background-color: #e2e3e5 !important; color: #41464b !important;">Đã
                                                                xác nhận trả hàng</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>

                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/transfer/detail?id=${t.transferId}"
                                                            class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                            <i class="bi bi-eye"></i>
                                                        </a>

                                                        <c:if
                                                            test="${sessionScope.user.roleName== 'Asset Staff' && t.status == 'Pending'}">
                                                            <a href="${pageContext.request.contextPath}/transfer/update?id=${t.transferId}&status=Cancelled"
                                                                class="btn btn-sm btn-outline-danger" title="Huỷ đơn">
                                                                <i class="bi bi-x-circle"></i>
                                                            </a>
                                                        </c:if>
                                                        <c:if
                                                            test="${sessionScope.user.roleName== 'Finance Head' && t.status == 'Pending'}">
                                                            <a href="${pageContext.request.contextPath}/transfer/update?id=${t.transferId}&status=Approved"
                                                                class="btn btn-sm btn-outline-success"
                                                                title="Duyệt đơn">
                                                                <i class="bi bi-check-circle"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/transfer/update?id=${t.transferId}&status=Rejected"
                                                                class="btn btn-sm btn-outline-warning" title="Từ chối">
                                                                <i class="bi bi-x-square"></i>
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <c:if test="${totalPages > 1}">
                                <div class="d-flex justify-content-between align-items-center mt-3 mb-3">
                                    <div class="text-muted small">
                                        Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                                        (Tổng: <strong>${totalItems}</strong> phiếu)
                                    </div>
                                    <nav>
                                        <ul class="pagination pagination-sm mb-0">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/transfer/list?page=${currentPage - 1}">
                                                    <i class="bi bi-chevron-left"></i>
                                                </a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="${pageContext.request.contextPath}/transfer/list?page=${i}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="${pageContext.request.contextPath}/transfer/list?page=${currentPage + 1}">
                                                    <i class="bi bi-chevron-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </c:if>

                        </main>

                    </div>
                </div>

                <jsp:include page="../components/footer.jsp"></jsp:include>

            </body>

            </html>