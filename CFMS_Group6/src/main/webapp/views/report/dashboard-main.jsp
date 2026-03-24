<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Báo Cáo Tổng Quan Tài Sản</title>
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
                <jsp:param name="page" value="report_dashboard" />
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-5">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                    <h1 class="h2 text-secondary" style="font-weight: 500;">Báo Cáo Tổng Quan Tài Sản</h1>
                </div>

                <!-- Nút Tác Vụ -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body p-3 bg-white rounded d-flex justify-content-between align-items-center">
                        <div class="text-muted small">
                            <i class="bi bi-info-circle"></i> Báo cáo hiển thị tình trạng tài sản tính đến thời điểm hiện tại.
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/report/dashboard" class="btn btn-primary px-4 shadow-sm">
                                <i class="bi bi-arrow-clockwise"></i> Làm Mới Dữ Liệu
                            </a>
                            <button onclick="exportPDF()" class="btn btn-success px-4 shadow-sm">
                                <i class="bi bi-file-earmark-pdf"></i> Xuất PDF
                            </button>
                        </div>
                    </div>
                </div>

                <!-- PDF Content Area -->
                <div class="card shadow-sm border-0">
                    <div class="card-body d-flex justify-content-center bg-white">
                        <div id="report-content" class="p-4 px-md-5 w-100 text-dark bg-white">
                            <!-- Header Document -->
                            <div class="row text-center mb-4">
                                <div class="col-6 text-start">
                                    <h6 class="fw-bold mb-1 fs-5">BỘ GIÁO DỤC VÀ ĐÀO TẠO</h6>
                                    <p class="mb-2 fs-6">TRƯỜNG TRUNG HỌC PHỔ THÔNG HÀ NỘI</p>
                                    <div class="divider"></div>
                                </div>
                                <div class="col-6">
                                    <h6 class="fw-bold mb-1 fs-5">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</h6>
                                    <p class="mb-2 fs-6 fw-bold">Độc Lập - Tự Do - Hạnh Phúc</p>
                                    <div class="divider mx-auto"></div>
                                </div>
                            </div>

                            <!-- Title -->
                            <div class="text-center my-5">
                                <h3 class="fw-bold fs-4 mb-1">BÁO CÁO TỔNG QUAN TÀI SẢN</h3>
                                <p class="fs-6">(Tính đến ngày: <span id="currentDate"></span>)</p>
                            </div>

                            <c:set var="t1" value="0" />
                            <c:set var="t2" value="0" />
                            <c:set var="t3" value="0" />
                            <c:set var="t4" value="0" />
                            <c:set var="t5" value="0" />
                            <c:set var="t6" value="0" />
                            <c:set var="tTotal" value="0" />

                            <!-- Table Data -->
                            <table class="table table-bordered text-center align-middle report-table mb-5">
                                <thead class="fw-bold text-dark" style="background-color: #f8f9fa;">
                                    <tr>
                                        <th style="width: 5%;">STT</th>
                                        <th style="width: 15%;">Danh Mục</th>
                                        <th style="width: 20%;">Tên Tài Sản</th>
                                        <th style="width: 10%;">Trong Kho</th>
                                        <th style="width: 10%;">Sử Dụng</th>
                                        <th style="width: 10%;">Bảo Trì</th>
                                        <th style="width: 8%;">Hỏng</th>
                                        <th style="width: 8%;">Thanh Lý</th>
                                        <th style="width: 7%;">Mất</th>
                                        <th style="width: 7%;">Tổng</th>
                                    </tr>
                                </thead>
                                <tbody class="text-dark">
                                    <c:choose>
                                        <c:when test="${not empty reportData}">
                                            <c:forEach items="${reportData}" var="item">
                                                <tr>
                                                    <td>${item.stt}</td>
                                                    <td>${item.categoryName}</td>
                                                    <td class="text-start">${item.assetName}</td>
                                                    <td>${item.inStockCount}</td>
                                                    <td>${item.inUseCount}</td>
                                                    <td>${item.maintenanceCount}</td>
                                                    <td>${item.brokenCount}</td>
                                                    <td>${item.liquidatedCount}</td>
                                                    <td>${item.lostCount}</td>
                                                    <td class="fw-bold">${item.totalCount}</td>
                                                </tr>
                                                <c:set var="t1" value="${t1 + item.inStockCount}" />
                                                <c:set var="t2" value="${t2 + item.inUseCount}" />
                                                <c:set var="t3" value="${t3 + item.maintenanceCount}" />
                                                <c:set var="t4" value="${t4 + item.brokenCount}" />
                                                <c:set var="t5" value="${t5 + item.liquidatedCount}" />
                                                <c:set var="t6" value="${t6 + item.lostCount}" />
                                                <c:set var="tTotal" value="${tTotal + item.totalCount}" />
                                            </c:forEach>
                                            <tr class="fw-bold" style="background-color: #f0f0f0;">
                                                <td colspan="3">TỔNG CỘNG</td>
                                                <td>${t1}</td>
                                                <td>${t2}</td>
                                                <td>${t3}</td>
                                                <td>${t4}</td>
                                                <td>${t5}</td>
                                                <td>${t6}</td>
                                                <td class="fs-5">${tTotal}</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="10" class="text-center">Không có dữ liệu tài sản tương ứng với bộ lọc.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>

                            <!-- Footer Signatures -->
                            <div class="row mt-5 pt-3">
                                <div class="col-6"></div>
                                <div class="col-6 text-center pe-md-5">
                                    <h6 class="fw-bold fs-6 mb-1">NGƯỜI LẬP BIỂU</h6>
                                    <p class="fst-italic" style="margin-bottom: 120px;">(Ký và ghi rõ họ tên)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const now = new Date();
            const dateStr = now.toLocaleDateString('vi-VN');
            document.getElementById('currentDate').innerText = dateStr;
        });

        function exportPDF() {
            if (confirm("Bạn có đồng ý xuất báo cáo này ra file PDF không?")) {
                const element = document.getElementById('report-content');
                
                const opt = {
                    margin:       10,
                    filename:     'Bao_Cao_Tong_Quan_Tai_San_${startDate}_${endDate}.pdf',
                    image:        { type: 'jpeg', quality: 0.98 },
                    html2canvas:  { scale: 2, useCORS: true },
                    jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
                };

                html2pdf().set(opt).from(element).save();
            }
        }
    </script>
</body>
</html>
