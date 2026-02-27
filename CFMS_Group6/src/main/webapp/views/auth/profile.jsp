<%-- Trang ho so ca nhan: cap nhat thong tin + doi mat khau --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Ho so &amp; Bao mat - CFMS</title>

        <%-- Bootstrap, FontAwesome, Bootstrap Icons, CSS rieng --%>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="${pageContext.request.contextPath}/css/user-list.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/profile.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    </head>

    <body class="d-flex flex-column">

        <%-- Header chung --%>
        <jsp:include page="/views/components/header.jsp"></jsp:include>

            <div class="container-fluid flex-grow-1">
                <div class="row h-100">

                <%-- Sidebar, danh dau muc "profile" dang active --%>
                <jsp:include page="/views/components/sidebar.jsp">
                    <jsp:param name="page" value="profile" />
                </jsp:include>

                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                    <%-- Tieu de trang --%>
                    <div
                        class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h4 class="fw-bold text-dark m-0">
                            <i class="bi bi-person-circle me-2 text-primary"></i>Ho so ca nhan
                        </h4>
                    </div>

                    <%-- Thong bao thanh cong --%>
                    <c:if test="${not empty sessionScope.successMsg}">
                        <div class="alert alert-success alert-dismissible fade show"
                             role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMsg}
                            <button type="button" class="btn-close"
                                    data-bs-dismiss="alert"></button>
                        </div>
                        <%-- Xoa sau khi hien thi de tranh lap lai khi F5 --%>
                        <% session.removeAttribute("successMsg"); %>
                    </c:if>

                    <%-- Thong bao loi --%>
                    <c:if test="${not empty sessionScope.errorMsg}">
                        <div class="alert alert-danger alert-dismissible fade show"
                             role="alert">
                            <i
                                class="fas fa-exclamation-circle me-2"></i>${sessionScope.errorMsg}
                            <button type="button" class="btn-close"
                                    data-bs-dismiss="alert"></button>
                        </div>
                        <% session.removeAttribute("errorMsg"); %>
                    </c:if>

                    <div class="card shadow-sm border-0 p-4" style="border-radius: 20px;">

                        <%-- Thanh chuyen tab --%>
                        <ul class="nav nav-pills mb-4 bg-light p-2 rounded-pill mx-auto"
                            id="pills-tab" role="tablist" style="width: fit-content;">
                            <li class="nav-item" role="presentation">
                                <button
                                    class="nav-link active rounded-pill px-4 fw-bold"
                                    id="pills-info-tab" data-bs-toggle="pill"
                                    data-bs-target="#pills-info" type="button"
                                    role="tab">
                                    <i class="fas fa-user-edit me-2"></i> Thong tin ca
                                    nhan
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link rounded-pill px-4 fw-bold"
                                        id="pills-pass-tab" data-bs-toggle="pill"
                                        data-bs-target="#pills-pass" type="button"
                                        role="tab">
                                    <i class="fas fa-key me-2"></i> Doi mat khau
                                </button>
                            </li>
                        </ul>

                        <div class="tab-content" id="pills-tabContent">

                            <%--=====TAB 1: Cap nhat thong tin ca nhan=====POST
                                /profile/update | Fields: fullName, email, phone --%>
                            <div class="tab-pane fade show active" id="pills-info"
                                 role="tabpanel">
                                <div
                                    class="row align-items-center justify-content-center">

                                    <%-- Avatar: lay chu cai dau ho ten, hien thi
                                        vai tro --%>
                                    <div
                                        class="col-md-4 text-center border-end">
                                        <div class="pic mx-auto mb-3 shadow">
                                            ${sessionScope.user.fullName.substring(0,1)}
                                        </div>
                                        <h4 class="fw-bold">
                                            ${sessionScope.user.fullName}</h4>
                                        <span
                                            class="badge bg-primary-subtle text-primary rounded-pill px-3">
                                            ${sessionScope.user.roleName}
                                        </span>
                                    </div>

                                    <%-- Form cap nhat --%>
                                    <div class="col-md-6 px-4">
                                        <form
                                            action="${pageContext.request.contextPath}/profile/update"
                                            method="POST">
                                            <div class="mb-3">
                                                <label
                                                    class="small fw-bold text-muted mb-1">Ho
                                                    va Ten</label>
                                                <input type="text"
                                                       name="fullName"
                                                       class="form-control border-2 border-secondary-subtle py-2"
                                                       value="${sessionScope.user.fullName}"
                                                       required>
                                            </div>
                                            <div class="mb-3">
                                                <label
                                                    class="small fw-bold text-muted mb-1">Email</label>
                                                <input type="email"
                                                       name="email"
                                                       class="form-control border-2 border-secondary-subtle py-2"
                                                       value="${sessionScope.user.email}"
                                                       required>
                                            </div>
                                            <div class="mb-4">
                                                <label
                                                    class="small fw-bold text-muted mb-1">So
                                                    dien thoai</label>
                                                <input type="text"
                                                       name="phone"
                                                       class="form-control border-2 border-secondary-subtle py-2"
                                                       value="${sessionScope.user.phone}"
                                                       required>
                                            </div>
                                            <button type="submit"
                                                    class="btn btn-primary w-100 rounded-pill fw-bold py-2">
                                                Cap nhat thong tin
                                            </button>
                                        </form>
                                    </div>

                                </div>
                            </div><%-- end TAB 1 --%>

                            <%--=====TAB 2: Doi mat khau=====POST
                                /change-password | Fields: oldPass, newPass,
                                confirmPass --%>
                            <div class="tab-pane fade" id="pills-pass"
                                 role="tabpanel">
                                <div class="col-md-5 mx-auto">

                                    <div class="text-center mb-4">
                                        <i
                                            class="fas fa-lock text-warning fa-3x"></i>
                                        <h4 class="fw-bold mt-2">Thiet lap
                                            mat khau moi</h4>
                                    </div>

                                    <form
                                        action="${pageContext.request.contextPath}/change-password"
                                        method="POST">
                                        <%-- Mat khau cu: de xac thuc truoc
                                            khi doi --%>
                                        <div class="mb-3">
                                            <label
                                                class="small fw-bold text-muted mb-1">Mat
                                                khau hien tai</label>
                                            <input type="password"
                                                   name="oldPass"
                                                   class="form-control border-2 border-secondary-subtle py-2"
                                                   required>
                                        </div>
                                        <%-- Mat khau moi --%>
                                        <div class="mb-3">
                                            <label
                                                class="small fw-bold text-muted mb-1">Mat
                                                khau moi</label>
                                            <input type="password"
                                                   name="newPass"
                                                   class="form-control border-2 border-secondary-subtle py-2"
                                                   required>
                                        </div>
                                        <%-- Xac nhan lai mat khau
                                            moi, phai khop voi
                                            newPass --%>
                                        <div class="mb-4">
                                            <label
                                                class="small fw-bold text-muted mb-1">Xac
                                                nhan mat khau
                                                moi</label>
                                            <input
                                                type="password"
                                                name="confirmPass"
                                                class="form-control border-2 border-secondary-subtle py-2"
                                                required>
                                        </div>
                                        <button type="submit"
                                                class="btn btn-dark w-100 rounded-pill fw-bold py-2">
                                            Xac nhan doi mat
                                            khau
                                        </button>
                                    </form>

                                </div>
                            </div><%-- end TAB 2 --%>

                        </div><%-- end tab-content --%>

                    </div><%-- end card --%>

                </main>

            </div>
        </div>

        <%-- Footer chung --%>
        <jsp:include page="/views/components/footer.jsp"></jsp:include>

        <%-- Bootstrap JS (can cho chuc nang tab) --%>
        <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </body>

</html>