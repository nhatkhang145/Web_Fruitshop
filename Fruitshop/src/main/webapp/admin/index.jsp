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
                                <h1 id="pageTabTitle">Thống kê lợi nhuận</h1>
                                <p>Tổng hợp nhập, xuất, doanh thu, giá vốn và tồn kho theo bộ lọc thời gian.</p>
                            </div>
                            <div class="hero-actions">
                                <button type="button" class="btn btn-ghost" id="exportBtn">
                                    <i class='bx bx-cloud-download'></i>
                                    <span>Tải báo cáo</span>
                                </button>
                            </div>
                        </div>

                        <%-- Tab Navigation --%>
                            <div class="tab-nav">
                                <button class="tab-btn active" data-tab="profit"
                                    onclick="switchTab('profit', 'Thống kê lợi nhuận')">
                                    <i class='bx bx-trending-up'></i> Doanh thu
                                </button>
                                <button class="tab-btn" data-tab="inventory"
                                    onclick="switchTab('inventory', 'Thống kê kho')">
                                    <i class='bx bx-package'></i> Kho
                                </button>
                                <button class="tab-btn" data-tab="promotion"
                                    onclick="switchTab('promotion', 'Thống kê khuyến mãi')">
                                    <i class='bx bx-purchase-tag'></i> Khuyến mãi
                                </button>
                            </div>

                            <section class="panel toolbar-panel report-filters">
                                <form class="filter-form" action="${pageContext.request.contextPath}/admin/dashboard"
                                    method="GET">

                                    <input type="hidden" id="activeTabInput" name="tab"
                                        value="${param.tab != null ? param.tab : 'profit'}" />

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
                                            <option value="SALES" ${currentExportType=='SALES' ? 'selected' : '' }>Bán
                                                hàng</option>
                                            <option value="WASTE" ${currentExportType=='WASTE' ? 'selected' : '' }>Sản
                                                phẩm hỏng</option>
                                        </select>
                                    </div>

                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">Áp dụng</button>
                                        <a class="btn btn-ghost"
                                            href="${pageContext.request.contextPath}/admin/dashboard">Đặt lại</a>
                                    </div>
                                </form>
                            </section>

                            <div id="tab-profit" class="tab-content active">

                                <section class="stats-grid stats-grid--kpi">
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
                                                <fmt:formatNumber value="${totalCogs != null ? totalCogs : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Giá vốn bán ra</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-slate">
                                        <div>
                                            <span class="stat-label">Lợi nhuận</span>
                                            <strong>
                                                <fmt:formatNumber value="${totalProfit != null ? totalProfit : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Doanh thu - giá vốn</small>
                                        </div>
                                    </article>
                                </section>

                                <section class="report-grid">
                                    <article class="panel chart-panel" style="grid-column: 1 / -1;">
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
                                                            <th>SL</th>
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
                                                                    <fmt:formatNumber value="${item.revenue}"
                                                                        type="number" groupingUsed="true" /> VND
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${item.cogs}" type="number"
                                                                        groupingUsed="true" /> VND
                                                                </td>
                                                                <td>
                                                                    <span class="profit-badge positive">
                                                                        <fmt:formatNumber value="${item.profit}"
                                                                            type="number" groupingUsed="true" /> VND
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty topProfitProducts}">
                                                            <tr>
                                                                <td colspan="5" class="table-empty">Chưa có dữ liệu.
                                                                </td>
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
                                                            <th>SL</th>
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
                                                                    <fmt:formatNumber value="${item.revenue}"
                                                                        type="number" groupingUsed="true" /> VND
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${item.cogs}" type="number"
                                                                        groupingUsed="true" /> VND
                                                                </td>
                                                                <td>
                                                                    <span class="profit-badge negative">
                                                                        <fmt:formatNumber value="${item.profit}"
                                                                            type="number" groupingUsed="true" /> VND
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <c:if test="${empty topLossProducts}">
                                                            <tr>
                                                                <td colspan="5" class="table-empty">Chưa có dữ liệu.
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </section>

                            </div>

                            <div id="tab-inventory" class="tab-content">

                                <section class="stats-grid stats-grid--kpi">
                                    <article class="stat-card accent-teal">
                                        <div>
                                            <span class="stat-label">Giá trị tồn kho</span>
                                            <strong>
                                                <fmt:formatNumber
                                                    value="${totalInventoryValue != null ? totalInventoryValue : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Tồn hiện tại</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-gold">
                                        <div>
                                            <span class="stat-label">Tổng nhập kho</span>
                                            <strong>
                                                <fmt:formatNumber
                                                    value="${totalImportValue != null ? totalImportValue : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Trong kỳ</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-rose">
                                        <div>
                                            <span class="stat-label">Hàng hỏng / Hủy</span>
                                            <strong>
                                                <fmt:formatNumber value="${totalWasteCost != null ? totalWasteCost : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Chi phí loại bỏ</small>
                                        </div>
                                    </article>
                                </section>

                                <section class="report-grid">
                                    <article class="panel chart-panel" style="grid-column: 1 / -1;">
                                        <div class="panel-header">
                                            <div>
                                                <h2>Phân bổ xuất kho theo loại</h2>
                                                <p>So sánh bán hàng vs hàng hỏng trong kỳ.</p>
                                            </div>
                                            <div class="panel-chip">Bar chart</div>
                                        </div>
                                        <div class="chart-box">
                                            <canvas id="inventoryExportChart"></canvas>
                                        </div>
                                    </article>
                                </section>

                            </div>

                            <div id="tab-promotion" class="tab-content">

                                <section class="stats-grid stats-grid--kpi promo-kpi">
                                    <article class="stat-card accent-gold">
                                        <div>
                                            <span class="stat-label"><i class='bx bx-calendar-week'></i> Weekend
                                                Deal</span>
                                            <strong>
                                                <fmt:formatNumber
                                                    value="${weekendDealRevenue != null ? weekendDealRevenue : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Doanh thu từ Weekend Deal</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-teal">
                                        <div>
                                            <span class="stat-label"><i class='bx bx-purchase-tag'></i> Sale
                                                Price</span>
                                            <strong>
                                                <fmt:formatNumber
                                                    value="${salePriceRevenue != null ? salePriceRevenue : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Doanh thu từ giá khuyến mãi</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-rose">
                                        <div>
                                            <span class="stat-label"><i class='bx bx-discount'></i> Đã giảm giá</span>
                                            <strong>
                                                <fmt:formatNumber
                                                    value="${totalDiscountAmount != null ? totalDiscountAmount : 0}"
                                                    type="number" groupingUsed="true" /> VND
                                            </strong>
                                            <small>Tổng số tiền giảm cho khách</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-green">
                                        <div>
                                            <span class="stat-label"><i class='bx bx-bolt-circle'></i> Deal đang
                                                chạy</span>
                                            <strong>${activeWeekendDeals} WD &nbsp;·&nbsp;${activeSaleProducts}
                                                SP</strong>
                                            <small>Weekend Deals · Sản phẩm sale</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-slate">
                                        <div>
                                            <span class="stat-label"><i class='bx bx-pie-chart-alt-2'></i> %Doanh thu
                                                KM</span>
                                            <strong>${pctPromoRevenue}%</strong>
                                            <small>Doanh thu khuyến mãi / tổng</small>
                                        </div>
                                    </article>
                                    <article class="stat-card accent-citrus">
                                        <div>
                                            <span class="stat-label"><i class='bx bx-receipt'></i> % Đơn có KM</span>
                                            <strong>${pctPromoOrders}%</strong>
                                            <small>${promotionOrders} / ${totalCompletedOrders} đơn hoàn tất</small>
                                        </div>
                                    </article>
                                </section>

                                <section class="report-grid">
                                    <article class="panel chart-panel">
                                        <div class="panel-header">
                                            <div>
                                                <h2>Doanh thu khuyến mãi theo ngày</h2>
                                                <p>Weekend Deal vs Giá sale trong kỳ đã chọn.</p>
                                            </div>
                                            <div class="panel-chip">Stacked bar</div>
                                        </div>
                                        <div class="chart-box">
                                            <canvas id="promoStackedChart"></canvas>
                                        </div>
                                    </article>
                                    <article class="panel chart-panel">
                                        <div class="panel-header">
                                            <div>
                                                <h2>Phân bổ doanh thu</h2>
                                                <p>Tỉ lệ Weekend Deal · Sale · Thường.</p>
                                            </div>
                                            <div class="panel-chip">Donut</div>
                                        </div>
                                        <div class="chart-box">
                                            <canvas id="promoDonutChart"></canvas>
                                        </div>
                                    </article>
                                </section>

                            </div>

                    </main>
                </div>

                <script>
                    const dashboardData = {
                        lineLabels: [
                            <c:forEach items="${reportLabels}" var="label" varStatus="loop">
                                "${label}"<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        revenueSeries: [
                            <c:forEach items="${revenueSeries}" var="value" varStatus="loop">
                                ${value}<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        wdSeries: [
                            <c:forEach items="${wdSeries}" var="value" varStatus="loop">
                                ${value}<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        saleSeries: [
                            <c:forEach items="${saleSeries}" var="value" varStatus="loop">
                                ${value}<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        cogsSeries: [
                            <c:forEach items="${cogsSeries}" var="value" varStatus="loop">
                                ${value}<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        profitSeries: [
                            <c:forEach items="${profitSeries}" var="value" varStatus="loop">
                                ${value}<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        exportTypeLabels: [
                            <c:forEach items="${exportTypeLabels}" var="label" varStatus="loop">
                                "${label}"<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        exportTypeSeries: [
                            <c:forEach items="${exportTypeSeries}" var="value" varStatus="loop">
                                ${value}<c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        ],
                        wdRev: ${ weekendDealRevenue != null ? weekendDealRevenue : 0},
                    saleRev: ${ salePriceRevenue != null ? salePriceRevenue : 0 },
                    totalRev: ${ totalRevenue != null ? totalRevenue : 0 }
    };
                </script>
                <script src="${pageContext.request.contextPath}/assets/js/admin/admin_dashboard.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
            </body>

            </html>