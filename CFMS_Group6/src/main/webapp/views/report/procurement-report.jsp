<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Báo Cáo Mua Sắm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Include html2pdf library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        #report-content {
            font-family: 'Times New Roman', Times, serif;
            max-width: 900px;
        }
        .divider {
            border-top: 1px solid black;
            width: 50%;
        }
        .report-table th, .report-table td {
            border: 1px solid black !important;
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100 bg-light">
    <jsp:include page="../components/header.jsp"></jsp:include>

    <div class="container-fluid flex-grow-1">
        <div class="row h-100">
            <jsp:include page="../components/sidebar.jsp">
                <jsp:param name="page" value="report_procedure" />
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-5">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                    <h1 class="h2 text-secondary" style="font-weight: 500;">Báo Cáo Thống Kê Yêu Cầu Mua Sắm</h1>
                </div>

                <!-- Lọc Theo Date -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body p-4 bg-white rounded">
                        <form action="${pageContext.request.contextPath}/report/procedure" method="GET" class="row g-3 align-items-end">
                            <div class="col-md-4">
                                <label for="startDate" class="form-label fw-semibold text-muted">Từ Ngày:</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="endDate" class="form-label fw-semibold text-muted">Đến Ngày:</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}" required>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-primary px-4 shadow-sm w-100">
                                    <i class="bi bi-funnel"></i> Xem Báo Cáo
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>

                <!-- Show report only if both dates are provided -->
                <c:if test="${not empty startDate and not empty endDate}">
                    <div class="d-flex justify-content-end mb-3">
                        <button onclick="exportPDF()" class="btn btn-success px-4 shadow-sm">
                            <i class="bi bi-file-earmark-pdf"></i> Xuất PDF
                        </button>
                    </div>

                    <!-- PDF Content Area -->
                    <div class="card shadow-sm border-0">
                        <div class="card-body d-flex justify-content-center bg-white">
                            <div id="report-content" class="p-4 px-md-5 w-100 text-dark bg-white">
                                <!-- Header Document -->
                                <div class="row text-center mb-4">
                                    <div class="col-6">
                                        <h6 class="fw-bold mb-1 fs-5">TRƯỜNG THPT HÀ NỘI</h6>
                                        <div class="divider mx-auto"></div>
                                    </div>
                                    <div class="col-6">
                                        <h6 class="fw-bold mb-1 fs-5">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</h6>
                                        <p class="mb-2 fs-6 fw-bold">Độc Lập - Tự Do - Hạnh Phúc</p>
                                        <div class="divider mx-auto"></div>
                                    </div>
                                </div>

                                <!-- Title -->
                                <div class="text-center my-5">
                                    <h3 class="fw-bold fs-4 mb-1">BÁO CÁO THỐNG KÊ YÊU CẦU MUA SẮM</h3>
                                    <span class="fs-6">(Từ ngày ${startDate} đến ngày ${endDate})</span>
                                </div>

                                <!-- Table Data -->
                                <table class="table table-bordered text-center align-middle report-table mb-5">
                                    <thead class="fw-bold text-dark">
                                        <tr>
                                            <th style="width: 10%;">STT</th>
                                            <th style="width: 30%;">Người Duyệt</th>
                                            <th style="width: 40%;">Tên Danh Mục Tài Sản</th>
                                            <th style="width: 20%;">Số Lượng</th>
                                        </tr>
                                    </thead>
                                    <tbody class="text-dark">
                                        <c:choose>
                                            <c:when test="${not empty reportData}">
                                                <c:forEach items="${reportData}" var="item">
                                                    <c:forEach items="${item.details}" var="detail" varStatus="loop">
                                                        <tr>
                                                            <c:if test="${loop.index == 0}">
                                                                <td rowspan="${item.details.size()}">${item.stt}</td>
                                                                <td rowspan="${item.details.size()}">${item.approverName}</td>
                                                            </c:if>
                                                            <td>${detail.categoryName}</td>
                                                            <td>${detail.quantity}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="4" class="text-center">Không có dữ liệu mua sắm tương ứng với khoảng thời gian được chọn.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>

                                <!-- Footer Signatures -->
                                <div class="row mt-5 pt-3">
                                    <div class="col-6"></div>
                                    <div class="col-6 text-center pe-md-5">
                                        <h6 class="fw-bold fs-6 mb-1">NGƯỜI BÁO CÁO</h6>
                                        <p class="fst-italic" style="margin-bottom: 120px;">(Ký và ghi rõ họ tên)</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

            </main>
        </div>
    </div>

    <script>
        function exportPDF() {
            const element = document.getElementById('report-content');
            
            const opt = {
                margin:       10,
                filename:     'Bao_Cao_Yeu_Cau_Mua_Sam_${startDate}_${endDate}.pdf',
                image:        { type: 'jpeg', quality: 0.98 },
                html2canvas:  { scale: 2, useCORS: true },
                jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };

            html2pdf().set(opt).from(element).save();
        }
    </script>
</body>
</html>
