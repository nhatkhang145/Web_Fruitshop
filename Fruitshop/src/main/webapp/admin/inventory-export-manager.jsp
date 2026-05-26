<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Quản lý xuất kho | Admin</title>

                <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css" />
                <meta name="contextPath" content="${pageContext.request.contextPath}" />
            </head>

            <body>
                <jsp:include page="/admin/layout/sidebar.jsp">
                    <jsp:param name="activePage" value="stock-export" />
                </jsp:include>

                <div class="content">
                    <jsp:include page="/admin/layout/header.jsp" />

                    <main>
                        <div class="page-hero">
                            <div class="hero-copy">
                                <h1>Quản lý xuất kho</h1>
                                <p>Theo dõi phiếu xuất, xem nhanh chi tiết, lọc theo thời gian và tạo phiếu mới.</p>
                            </div>
                            <div class="hero-actions">
                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/inventory-export-create">
                                    <i class='bx bx-plus-circle'></i>
                                    <span>Tạo phiếu xuất kho</span>
                                </a>
                            </div>
                        </div>

                        <section class="stats-grid">
                            <article class="stat-card accent-teal">
                                <div class="stat-icon"><i class='bx bx-archive-out'></i></div>
                                <div>
                                    <span class="stat-label">Tổng phiếu xuất</span>
                                    <strong><fmt:formatNumber value="${totalExports != null ? totalExports : 0}" type="number" groupingUsed="true"/></strong>
                                    <small>Cập nhật liên tục</small>
                                </div>
                            </article>
                            <article class="stat-card accent-blue">
                                <div class="stat-icon"><i class='bx bx-cart'></i></div>
                                <div>
                                    <span class="stat-label">Phiếu bán hàng</span>
                                    <strong><fmt:formatNumber value="${salesExports != null ? salesExports : 0}" type="number" groupingUsed="true"/></strong>
                                    <small>Đơn hàng đã xuất</small>
                                </div>
                            </article>
                            <article class="stat-card accent-gold">
                                <div class="stat-icon"><i class='bx bx-package'></i></div>
                                <div>
                                    <span class="stat-label">Tổng số lượng xuất</span>
                                    <strong><fmt:formatNumber value="${totalExportItems != null ? totalExportItems : 0}" type="number" groupingUsed="true"/></strong>
                                    <small>Trên toàn hệ thống</small>
                                </div>
                            </article>
                            <article class="stat-card accent-green">
                                <div class="stat-icon"><i class='bx bx-timer'></i></div>
                                <div>
                                    <span class="stat-label">Phiếu chờ xử lý</span>
                                    <strong><fmt:formatNumber value="${pendingExports != null ? pendingExports : 0}" type="number" groupingUsed="true"/></strong>
                                    <small>Cần kiểm tra</small>
                                </div>
                            </article>
                        </section>

                        <section class="panel toolbar-panel">
                            <div class="search-area">
                                <label for="receiptSearch">Tìm kiếm theo mã xuất kho</label>
                                <div class="search-box">
                                    <i class='bx bx-search'></i>
                                    <input type="text" id="receiptSearch" placeholder="Ví dụ: PXK-2026-018" />
                                </div>
                            </div>

                            <div class="date-filter-group">
                                <div class="filter-field">
                                    <label for="fromDate">Từ ngày</label>
                                    <input type="date" id="fromDate" />
                                </div>
                                <div class="filter-field">
                                    <label for="toDate">Đến ngày</label>
                                    <input type="date" id="toDate" />
                                </div>
                                <div class="filter-actions">
                                    <button type="button" class="btn btn-ghost" id="resetFiltersBtn">Đặt lại</button>
                                </div>
                            </div>
                        </section>

                        <section class="panel receipt-list-panel">
                            <div class="panel-header">
                                <div>
                                    <h2>Danh sách phiếu xuất kho</h2>
                                </div>
                                <div class="panel-chip">Hiển thị ${totalExports != null ? totalExports : 0} phiếu</div>
                            </div>

                            <div class="table-wrap">
                                <table class="receipt-table" id="receiptTable">
                                    <thead>
                                        <tr>
                                            <th>Mã phiếu</th>
                                            <th>Ngày xuất</th>
                                            <th>Loại xuất</th>
                                            <th>Tổng SL</th>
                                            <th>Tổng tiền</th>
                                            <th>Người tạo</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${exportList}">
                                            <tr data-code="${item.code}" data-date="${item.dateData}">
                                                <td><span class="receipt-code">${item.code}</span></td>
                                                <td>${item.dateDisplay}</td>
                                                <td>${item.exportType}</td>
                                                <td>${item.totalQuantity}</td>
                                                <td><fmt:formatNumber value="${item.totalValue}" type="number" groupingUsed="true"/> VND</td>
                                                <td>${item.creatorName}</td>
                                                <td><span class="status-badge ${item.statusClass}">${item.statusDisplay}</span></td>
                                                <td>
                                                    <a class="icon-btn view" href="${pageContext.request.contextPath}/admin/inventory-export-detail?id=${item.id}" title="Xem chi tiết">
                                                        <i class='bx bx-show'></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="empty-state is-hidden" id="emptyState">
                                <i class='bx bx-package'></i>
                                <h3>Không tìm thấy phiếu xuất phù hợp</h3>
                                <p>Thử thay đổi mã phiếu hoặc khoảng thời gian lọc.</p>
                            </div>
                        </section>
                    </main>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
            </body>

            </html>