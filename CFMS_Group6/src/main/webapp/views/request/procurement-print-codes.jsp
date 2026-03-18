<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In mã cá thể tài sản - PROC-${proc.procurementId}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/page-header.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/message.css" rel="stylesheet">

    <style>
        .barcode-card {
            border: 2px dashed #ccc;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            background: #fff;
            margin-bottom: 20px;
            page-break-inside: avoid;
        }
        .barcode-code {
            font-family: 'Courier New', Courier, monospace;
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 5px;
            letter-spacing: 2px;
        }
        .barcode-name {
            font-size: 0.9rem;
            color: #555;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        @media print {
            body * {
                visibility: hidden;
            }
            #printArea, #printArea * {
                visibility: visible;
            }
            #printArea {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>

<body class="d-flex flex-column">

    <jsp:include page="../components/header.jsp" />

    <div class="container-fluid flex-grow-1">
        <div class="row h-100">

            <jsp:include page="../components/sidebar.jsp">
                <jsp:param name="page" value="procurement_list" />
            </jsp:include>

            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 pb-4">

                <div class="cfms-page-header d-flex justify-content-between align-items-center">
                    <h2><i class="bi bi-printer me-2"></i>In mã cá thể tài sản vừa nhập kho</h2>
                    <div class="no-print">
                        <c:if test="${proc.allocationRequestId != null}">
                            <a href="${pageContext.request.contextPath}/request/allocation-assign?id=${proc.allocationRequestId}" class="btn btn-primary me-2">
                                <i class="bi bi-list-check me-1"></i>Tiếp tục: Cấp phát cá thể
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/request/procurement-detail?id=${proc.procurementId}" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Về Chi tiết Yêu cầu
                        </a>
                    </div>
                </div>

                <c:if test="${not empty successMsg}">
                    <div class="cfms-msg cfms-msg-success no-print">
                        <i class="bi bi-check-circle-fill mt-1 me-2"></i> ${successMsg}
                    </div>
                    <% session.removeAttribute("successMsg"); %>
                </c:if>

                <div class="card shadow-sm mb-4 no-print">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="card-title mb-1 text-primary">Đơn mua sắm PROC-${proc.procurementId}</h5>
                                <p class="text-muted mb-0">Hệ thống đã ghi nhận số lượng thực tế và tự động sinh mã định danh (Barcode) cho từng thiết bị.</p>
                            </div>
                            <button class="btn btn-success btn-lg" onclick="window.print()">
                                <i class="bi bi-printer-fill me-2"></i>IN TOÀN BỘ TEM
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Print Area (Tem nhãn) -->
                <div id="printArea">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-3">
                        <c:forEach items="${instances}" var="ad">
                            <div class="col">
                                <div class="barcode-card">
                                    <!-- Mô phỏng Barcode bằng icon/css, thực tế có thể dùng thư viện JsBarcode -->
                                    <i class="bi bi-upc-scan" style="font-size: 3rem; color: #333;"></i>
                                    <div class="barcode-code">${ad.instanceCode}</div>
                                    <div class="barcode-name" title="${ad.asset.assetName}">
                                        ${ad.asset.assetName}
                                    </div>
                                    <div style="font-size: 0.75rem; color: #888;">${ad.asset.category.categoryName}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${empty instances}">
                        <div class="alert alert-info border-0 rounded-3 shadow-sm text-center p-4">
                            <i class="bi bi-info-circle fs-3 text-info d-block mb-2"></i>
                            <h6 class="mb-0">Không tìm thấy mã cá thể nào được sinh ra từ quá trình nhập kho này.</h6>
                        </div>
                    </c:if>
                </div>

            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/message-auto-hide.js"></script>
</body>
</html>
