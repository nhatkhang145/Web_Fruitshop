<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tổng quan - Admin</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_dashboard.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<jsp:include page="layout/sidebar.jsp">
    <jsp:param name="activePage" value="dashboard" />
</jsp:include>
<div class="content">

    <jsp:include page="layout/header.jsp" />

    <main>
        <div class="header">
            <div class="left">
                <h1>Tổng quan</h1>
                <ul class="breadcrumb">
                    <li><a href="#">Thống kê</a></li>
                    <li>/</li>
                    <li><a href="#" class="active">Tổng quan</a></li>
                </ul>
            </div>
            <a href="#" class="report" id="exportBtn">
                <i class="bx bx-cloud-download"></i>
                <span>Tải báo cáo</span>
            </a>
        </div>

        <ul class="insights">
            <li>
                <i class="bx bx-calendar-check"></i>
                <span class="info">
              <h3>${totalOrders}</h3>
              <p>Tổng đơn hàng</p>
            </span>
            </li>
            <li>
                <i class="bx bx-show-alt"></i>
                <span class="info">
              <h3>${totalUsers}</h3>
              <p>Khách hàng</p>
            </span>
            </li>
            <li>
                <i class="bx bx-dollar-circle"></i>
                <span class="info">
              <h3><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ"/></h3>
              <p>Tổng doanh thu</p>
            </span>
            </li>
        </ul>

        <div class="bottom-data">
            <div class="orders">
                <div class="header">
                    <h3>Biểu đồ doanh thu</h3>
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="filter-form" style="display: flex; gap: 10px; align-items: center;">
                        <input type="date" name="startDate" value="${startDate}" class="form-control">
                        <span>đến</span>
                        <input type="date" name="endDate" value="${endDate}" class="form-control">
                        <button type="submit" class="btn-filter" style="background: var(--primary); color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">Lọc</button>
                    </form>
                </div>
                <div class="chart-container-sm">
                    <canvas id="salesChart7Days"></canvas>
                </div>
            </div>

            <div class="reminders">
                <div class="header">
                    <h3>Sản phẩm sắp hết hàng</h3>
                    <a href="${pageContext.request.contextPath}/admin/products" class="view-all">
                        Xem tất cả <i class="bx bx-right-arrow-alt"></i>
                    </a>
                </div>
                <ul class="task-list">
                    <c:forEach items="${lowStockProducts}" var="p">
                        <li class="low-stock">
                            <div class="task-title">
                                <c:choose>
                                    <c:when test="${fn:startsWith(p.image, 'http')}">
                                        <img src="${p.image}" alt="${p.name}" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}" />
                                    </c:otherwise>
                                </c:choose>
                                <p>${p.name}</p>
                            </div>
                            <span class="stock-count" style="color: var(--danger);">Còn ${p.quantity}</span>
                        </li>
                    </c:forEach>
                    <c:if test="${empty lowStockProducts}">
                        <p style="padding: 20px; text-align: center;">Không có sản phẩm nào sắp hết hàng.</p>
                    </c:if>
                </ul>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script>
    const ctx = document.getElementById('salesChart7Days').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {

            labels: [
                <c:forEach items="${revenueLabels}" var="label" varStatus="loop">
                "${label}"<c:if test="${not loop.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Doanh thu (VNĐ)',

                data: [
                    <c:forEach items="${revenueData}" var="value" varStatus="loop">
                    ${value}<c:if test="${not loop.last}">,</c:if>
                    </c:forEach>
                ],
                borderColor: '#388E3C',
                backgroundColor: 'rgba(56, 142, 60, 0.2)',
                borderWidth: 2,
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString('vi-VN') + ' đ';
                        }
                    }
                }
            }
        }
    });
</script>
</body>

</html>