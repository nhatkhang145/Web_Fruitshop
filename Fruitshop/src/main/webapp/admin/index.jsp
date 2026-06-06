<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Thống kê lợi nhuận | Admin</title>

                <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/profit-report.css" />
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            </head>

            <body>

                <jsp:include page="layout/sidebar.jsp">
                    <jsp:param name="activePage" value="dashboard" />
                </jsp:include>
                <div class="content">

                    <jsp:include page="layout/header.jsp" />

                    <main>
                        <div class="page-hero">
                            <div class="hero-copy">
                                <p class="eyebrow">Báo cáo</p>
                                <h1>Thống kê lợi nhuận</h1>
                                <p>Tổng hợp nhập, xuất, doanh thu, giá vốn và tồn kho theo bộ lọc thời gian.</p>
                            </div>
                            <div class="hero-actions">
                                <button type="button" class="btn btn-ghost" id="exportBtn">
                                    <i class='bx bx-cloud-download'></i>
                                    <span>Tải báo cáo</span>
                                </button>
                            </div>
                        </div>

                        <section class="stats-grid stats-grid--kpi">
                            <article class="stat-card accent-teal">

                                <div>
                                    <span class="stat-label">Nhập kho</span>
                                    <strong>
                                        <fmt:formatNumber value="${totalImportValue != null ? totalImportValue : 0}"
                                            type="number" groupingUsed="true" /> VND
                                    </strong>
                                    <small>Tổng giá trị nhập</small>
                                </div>
                            </article>
                            <!-- <article class="stat-card accent-blue">
                
                <div>
                    <span class="stat-label">Xuất kho</span>
                    <strong><fmt:formatNumber value="${totalExportValue != null ? totalExportValue : 0}" type="number" groupingUsed="true"/> VND</strong>
                    <small>Đã xuất kho</small>
                </div>
            </article> -->
                            <article class="stat-card accent-gold">

                                <div>
                                    <span class="stat-label">Doanh thu</span>
                                    <strong>
                                        <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}"
                                            type="number" groupingUsed="true" /> VND
                                    </strong>
                                    <small>Đơn hoàn tất</small>
                                </div>
                            </article>
                            <article class="stat-card accent-green">

                                <div>
                                    <span class="stat-label">COGS</span>
                                    <strong>
                                        <fmt:formatNumber value="${totalCogs != null ? totalCogs : 0}" type="number"
                                            groupingUsed="true" /> VND
                                    </strong>
                                    <small>Giá vốn bán ra</small>
                                </div>
                            </article>
                            <article class="stat-card accent-rose">

                                <div>
                                    <span class="stat-label">Hư hỏng</span>
                                    <strong>
                                        <fmt:formatNumber value="${totalWasteCost != null ? totalWasteCost : 0}"
                                            type="number" groupingUsed="true" /> VND
                                    </strong>
                                    <small>Chi phí loại bỏ</small>
                                </div>
                            </article>
                            <article class="stat-card accent-slate">

                                <div>
                                    <span class="stat-label">Lợi nhuận</span>
                                    <strong>
                                        <fmt:formatNumber value="${totalProfit != null ? totalProfit : 0}" type="number"
                                            groupingUsed="true" /> VND
                                    </strong>
                                    <small>Doanh thu - giá vốn</small>
                                </div>
                            </article>
                            <article class="stat-card accent-citrus">

                                <div>
                                    <span class="stat-label">Giá trị tồn</span>
                                    <strong>
                                        <fmt:formatNumber
                                            value="${totalInventoryValue != null ? totalInventoryValue : 0}"
                                            type="number" groupingUsed="true" /> VND
                                    </strong>
                                    <small>Tồn hiện tại</small>
                                </div>
                            </article>
                        </section>

                        <section class="panel toolbar-panel report-filters">
                            <form class="filter-form" action="${pageContext.request.contextPath}/admin/dashboard"
                                method="GET">
                                <div class="filter-field">
                                    <label for="startDate">Từ ngày</label>
                                    <input type="date" id="startDate" name="startDate" value="${startDate}" />
                                </div>
                                <div class="filter-field">
                                    <label for="endDate">Đến ngày</label>
                                    <input type="date" id="endDate" name="endDate" value="${endDate}" />
                                </div>
                                <div class="filter-field">
                                    <label for="exportType">Loại xuất</label>
                                    <select id="exportType" name="exportType">
                                        <option value="all" ${empty currentExportType || currentExportType=='all'
                                            ? 'selected' : '' }>Tất cả</option>
                                        <option value="SALES" ${currentExportType=='SALES' ? 'selected' : '' }>Bán hàng
                                        </option>
                                        <option value="INTERNAL" ${currentExportType=='INTERNAL' ? 'selected' : '' }>Nội
                                            bộ</option>
                                        <option value="TRANSFER" ${currentExportType=='TRANSFER' ? 'selected' : '' }>
                                            Điều chuyển</option>
                                        <option value="WASTE" ${currentExportType=='WASTE' ? 'selected' : '' }>Sản phẩm
                                            hỏng</option>
                                    </select>
                                </div>
                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-primary">Áp dụng</button>
                                    <a class="btn btn-ghost"
                                        href="${pageContext.request.contextPath}/admin/dashboard">Đặt lại</a>
                                </div>
                            </form>
                        </section>

                        <section class="report-grid">
                            <article class="panel chart-panel">
                                <div class="panel-header">
                                    <div>
                                        <h2>Doanh thu vs COGS vs Lợi nhuận</h2>
                                        <p>So sánh theo khoảng thời gian đã chọn.</p>
                                    </div>
                                    <div class="panel-chip">Line chart</div>
                                </div>
                                <div class="chart-box">
                                    <canvas id="profitLineChart"></canvas>
                                </div>
                            </article>

                            <article class="panel chart-panel">
                                <div class="panel-header">
                                    <div>
                                        <h2>Xuất kho theo loại</h2>
                                        <p>Phân bổ giá trị xuất theo export type.</p>
                                    </div>
                                    <div class="panel-chip">Bar chart</div>
                                </div>
                                <div class="chart-box">
                                    <canvas id="exportTypeChart"></canvas>
                                </div>
                            </article>
                        </section>

                        <section class="panel table-panel">
                            <div class="panel-header">
                                <div>
                                    <h2>Top sản phẩm lợi nhuận</h2>
                                    <p>Hạng lợi nhuận cao nhất và thấp nhất trong kỳ.</p>
                                </div>
                            </div>

                            <div class="table-split">
                                <div>
                                    <h3 class="table-title">Lợi nhuận cao</h3>
                                    <div class="table-wrap">
                                        <table class="receipt-table">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Số lượng</th>
                                                    <th>Doanh thu</th>
                                                    <th>COGS</th>
                                                    <th>Lợi nhuận</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${topProfitProducts}">
                                                    <tr>
                                                        <td>${item.productName}</td>
                                                        <td>${item.quantity}</td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.revenue}" type="number"
                                                                groupingUsed="true" /> VND
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.cogs}" type="number"
                                                                groupingUsed="true" /> VND
                                                        </td>
                                                        <td><span class="profit-badge positive">
                                                                <fmt:formatNumber value="${item.profit}" type="number"
                                                                    groupingUsed="true" /> VND
                                                            </span></td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty topProfitProducts}">
                                                    <tr>
                                                        <td colspan="5" class="table-empty">Chưa có dữ liệu lợi nhuận
                                                            cao.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div>
                                    <h3 class="table-title">Lợi nhuận thấp</h3>
                                    <div class="table-wrap">
                                        <table class="receipt-table">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Số lượng</th>
                                                    <th>Doanh thu</th>
                                                    <th>COGS</th>
                                                    <th>Lợi nhuận</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${topLossProducts}">
                                                    <tr>
                                                        <td>${item.productName}</td>
                                                        <td>${item.quantity}</td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.revenue}" type="number"
                                                                groupingUsed="true" /> VND
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${item.cogs}" type="number"
                                                                groupingUsed="true" /> VND
                                                        </td>
                                                        <td><span class="profit-badge negative">
                                                                <fmt:formatNumber value="${item.profit}" type="number"
                                                                    groupingUsed="true" /> VND
                                                            </span></td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty topLossProducts}">
                                                    <tr>
                                                        <td colspan="5" class="table-empty">Chưa có dữ liệu lợi nhuận
                                                            thấp.</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </main>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
                <script>
                    const lineLabels = [
                        <c:forEach items="${reportLabels}" var="label" varStatus="loop">
                            "${label}"<c:if test="${not loop.last}">,</c:if>
                        </c:forEach>
                    ];
                    const revenueSeries = [
                        <c:forEach items="${revenueSeries}" var="value" varStatus="loop">
                            ${value}<c:if test="${not loop.last}">,</c:if>
                        </c:forEach>
                    ];
                    const cogsSeries = [
                        <c:forEach items="${cogsSeries}" var="value" varStatus="loop">
                            ${value}<c:if test="${not loop.last}">,</c:if>
                        </c:forEach>
                    ];
                    const profitSeries = [
                        <c:forEach items="${profitSeries}" var="value" varStatus="loop">
                            ${value}<c:if test="${not loop.last}">,</c:if>
                        </c:forEach>
                    ];

                    const lineCanvas = document.getElementById('profitLineChart');
                    if (lineCanvas) {
                        new Chart(lineCanvas.getContext('2d'), {
                            type: 'line',
                            data: {
                                labels: lineLabels,
                                datasets: [
                                    {
                                        label: 'Doanh thu',
                                        data: revenueSeries,
                                        borderColor: '#2f8087',
                                        backgroundColor: 'rgba(47, 128, 135, 0.18)',
                                        borderWidth: 2,
                                        tension: 0.35,
                                        fill: true
                                    },
                                    {
                                        label: 'COGS',
                                        data: cogsSeries,
                                        borderColor: '#c18a00',
                                        backgroundColor: 'rgba(193, 138, 0, 0.16)',
                                        borderWidth: 2,
                                        tension: 0.35,
                                        fill: true
                                    },
                                    {
                                        label: 'Lợi nhuận',
                                        data: profitSeries,
                                        borderColor: '#2f9955',
                                        backgroundColor: 'rgba(47, 153, 85, 0.16)',
                                        borderWidth: 2,
                                        tension: 0.35,
                                        fill: true
                                    }
                                ]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: {
                                            callback: function (value) {
                                                return value.toLocaleString('vi-VN') + ' VND';
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }

                    const exportTypeLabels = [
                        <c:forEach items="${exportTypeLabels}" var="label" varStatus="loop">
                            "${label}"<c:if test="${not loop.last}">,</c:if>
                        </c:forEach>
                    ];
                    const exportTypeSeries = [
                        <c:forEach items="${exportTypeSeries}" var="value" varStatus="loop">
                            ${value}<c:if test="${not loop.last}">,</c:if>
                        </c:forEach>
                    ];

                    const barCanvas = document.getElementById('exportTypeChart');
                    if (barCanvas) {
                        const exportTypeDisplayLabels = exportTypeLabels.map((label) => {
                            switch (label) {
                                case 'SALES':
                                    return 'Bán hàng';
                                case 'INTERNAL':
                                    return 'Nội bộ';
                                case 'TRANSFER':
                                    return 'Điều chuyển';
                                case 'WASTE':
                                    return 'Sản phẩm hỏng';
                                default:
                                    return label;
                            }
                        });
                        const barColors = exportTypeLabels.map((label) => {
                            switch (label) {
                                case 'SALES':
                                    return '#2c73d2';
                                case 'INTERNAL':
                                    return '#6f7d83';
                                case 'TRANSFER':
                                    return '#2f8087';
                                case 'WASTE':
                                    return '#d04b5b';
                                default:
                                    return '#2f8087';
                            }
                        });

                        new Chart(barCanvas.getContext('2d'), {
                            type: 'bar',
                            data: {
                                labels: exportTypeDisplayLabels,
                                datasets: [{
                                    label: 'Giá trị xuất',
                                    data: exportTypeSeries,
                                    backgroundColor: barColors,
                                    borderRadius: 10
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: {
                                            callback: function (value) {
                                                return value.toLocaleString('vi-VN') + ' VND';
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }
                </script>
            </body>

            </html>