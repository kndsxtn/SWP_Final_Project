<%-- Document : transfer-detail Created on : Feb 11, 2026, 7:33:52 PM Author : Pham Van Tung --%>

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
                                <h1 class="h2 text-secondary" style="font-weight: 500;">Chi tiết phiếu điều chuyển</h1>
                            </div>

                            <div class="table-responsive shadow-sm rounded bg-white p-3 mb-4">
                                <table class="table table-hover align-middle border-bottom" style="color: #495057;">
                                    <thead class="table-light text-muted" style="border-bottom: 2px solid #dee2e6;">
                                        <tr>
                                            <th class="fw-semibold">#</th>
                                            <th class="fw-semibold">Tên tài sản</th>
                                            <th class="fw-semibold">Mã tài sản</th>
                                            <th class="fw-semibold">Trạng thái lúc chuyển</th>
                                            <th class="fw-semibold">Ngày chuyển</th>
                                        </tr>
                                    </thead>
                                    <tbody style="border-top: none;">
                                        <c:forEach items="${transferDetails}" var="t" varStatus="st">
                                            <tr>
                                                <td class="text-muted">${st.index + 1}</td>
                                                <td class="fw-medium">${t.assetName}</td>
                                                <td class="text-secondary">${t.assetDetail.instanceCode}</td>
                                                <td>
                                                    <span class="badge bg-light text-dark border border-secondary-subtle px-2 py-1 fw-normal">
                                                        <c:choose>
                                                            <c:when test="${t.statusAtTransfer == 'In_Stock'}">Đang trong kho</c:when>
                                                            <c:when test="${t.statusAtTransfer == 'In_Use'}">Đang sử dụng</c:when>
                                                            <c:when test="${t.statusAtTransfer == 'Maintenance'}">Đang bảo trì</c:when>
                                                            <c:when test="${t.statusAtTransfer == 'Broken'}">Hỏng</c:when>
                                                            <c:when test="${t.statusAtTransfer == 'Liquidated'}">Thanh lý</c:when>
                                                            <c:when test="${t.statusAtTransfer == 'Lost'}">Mất</c:when>
                                                            <c:otherwise>${t.statusAtTransfer}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td class="text-muted">${t.transferDate}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="d-flex justify-content-between">
                                <div>
                                    <c:choose>
                                        <c:when test="${param.from == 'handover'}">
                                            <a href="${pageContext.request.contextPath}/transfer/handover"
                                                class="btn btn-outline-secondary px-4 shadow-sm">
                                                <i class="bi bi-arrow-left"></i> Trở về đơn bàn giao
                                            </a>
                                        </c:when>
                                        <c:when test="${param.from == 'receive'}">
                                            <a href="${pageContext.request.contextPath}/transfer/receive"
                                                class="btn btn-outline-secondary px-4 shadow-sm">
                                                <i class="bi bi-arrow-left"></i> Trở về đơn nhận
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/transfer/list"
                                                class="btn btn-outline-secondary px-4 shadow-sm">
                                                <i class="bi bi-arrow-left"></i> Trở về danh sách
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div>
                                    <%-- Finance Head --%>
                                    <c:if test="${sessionScope.user.roleName == 'Finance Head' && transfer.status == 'Pending'}">
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Approved"
                                            class="btn btn-success px-4 shadow-sm ms-2">
                                            <i class="bi bi-check-circle"></i> Duyệt đơn
                                        </a>
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Rejected"
                                            class="btn btn-warning px-4 shadow-sm ms-2">
                                            <i class="bi bi-x-square"></i> Từ chối
                                        </a>
                                    </c:if>

                                    <%-- Asset Staff --%>
                                    <c:if test="${sessionScope.user.roleName == 'Asset Staff' && transfer.status == 'Pending'}">
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Cancelled"
                                            class="btn btn-danger px-4 shadow-sm ms-2">
                                            <i class="bi bi-x-circle"></i> Huỷ đơn
                                        </a>
                                    </c:if>

                                    <%-- Department Head (Source) --%>
                                    <c:if test="${transfer.status == 'Approved' && transfer.sourceRoom.deptId == userDeptId}">
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Ongoing&room=${transfer.sourceRoom.roomName}"
                                            class="btn btn-success px-4 shadow-sm ms-2">
                                            <i class="bi bi-box-seam"></i> Bàn giao tài sản
                                        </a>
                                    </c:if>
                                    
                                    <c:if test="${transfer.status == 'Returned' && transfer.sourceRoom.deptId == userDeptId}">
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Return_Confirmed&room=${transfer.sourceRoom.roomName}"
                                            class="btn btn-warning px-4 shadow-sm ms-2"
                                            onclick="return confirm('Xác nhận đã nhận lại tài sản trả về?');">
                                            <i class="bi bi-arrow-return-left"></i> Xác nhận nhận lại tài sản
                                        </a>
                                    </c:if>

                                    <%-- Department Head (Dest) --%>
                                    <c:if test="${transfer.status == 'Ongoing' && transfer.destRoom.deptId == userDeptId}">
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Completed&room=${transfer.destRoom.roomName}"
                                            class="btn btn-success px-4 shadow-sm ms-2">
                                            <i class="bi bi-check-circle"></i> Nhận tài sản
                                        </a>
                                        <a href="${pageContext.request.contextPath}/transfer/update?id=${transfer.transferId}&status=Returned&room=${transfer.sourceRoom.roomName}"
                                            class="btn btn-danger px-4 shadow-sm ms-2">
                                            <i class="bi bi-x-circle"></i> Từ chối nhận tài sản
                                        </a>
                                    </c:if>
                                </div>
                            </div>



                        </main>

                    </div>
                </div>

                <jsp:include page="../components/footer.jsp"></jsp:include>

            </body>

            </html>