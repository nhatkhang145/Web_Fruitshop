<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý nhập kho | Admin</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css" />
    <meta name="contextPath" content="${pageContext.request.contextPath}" />
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="inventory" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main>
        <div class="page-hero">
            <div class="hero-copy">
                <h1>Quản lý nhập kho</h1>
                <p>Theo dõi phiếu nhập, xem nhanh chi tiết, lọc theo thời gian và tạo phiếu mới.</p>
            </div>
            <div class="hero-actions">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/inventory-receipt-new">
                    <i class='bx bx-plus-circle'></i>
                    <span>Tạo phiếu nhập kho</span>
                </a>
            </div>
        </div>

        <section class="stats-grid">
            <article class="stat-card accent-teal">
                <div class="stat-icon"><i class='bx bx-receipt'></i></div>
                <div>
                    <span class="stat-label">Tổng phiếu nhập</span>
                    <strong><fmt:formatNumber value="${totalReceipts != null ? totalReceipts : 0}" type="number" groupingUsed="true"/></strong>
                    <small>Cập nhật liên tục</small>
                </div>
            </article>
            <article class="stat-card accent-blue">
                <div class="stat-icon"><i class='bx bx-package'></i></div>
                <div>
                    <span class="stat-label">Sản phẩm đã nhập</span>
                    <strong><fmt:formatNumber value="${totalImportedItems != null ? totalImportedItems : 0}" type="number" groupingUsed="true"/></strong>
                    <small>Trên toàn hệ thống</small>
                </div>
            </article>
            <article class="stat-card accent-gold">
                <div class="stat-icon"><i class='bx bx-wallet'></i></div>
                <div>
                    <span class="stat-label">Tổng giá trị nhập</span>
                    <strong><fmt:formatNumber value="${totalImportedValueThisMonth != null ? totalImportedValueThisMonth : 0}" type="number" groupingUsed="true"/> VND</strong>
                    <small>Tạm tính tháng này</small>
                </div>
            </article>
            <article class="stat-card accent-green">
                <div class="stat-icon"><i class='bx bx-check-shield'></i></div>
                <div>
                    <span class="stat-label">Phiếu đã duyệt</span>
                    <strong><fmt:formatNumber value="${approvedReceipts != null ? approvedReceipts : 0}" type="number" groupingUsed="true"/></strong>
                    <small>Đang chờ duyệt: <fmt:formatNumber value="${pendingReceipts != null ? pendingReceipts : 0}" type="number" groupingUsed="true"/></small>
                </div>
            </article>
        </section>

        <section class="panel toolbar-panel">
            <div class="search-area">
                <label for="receiptSearch">Tìm kiếm theo mã nhập kho</label>
                <div class="search-box">
                    <i class='bx bx-search'></i>
                    <input type="text" id="receiptSearch" placeholder="Ví dụ: PNK-2026-018" />
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
                    <h2>Danh sách phiếu nhập kho</h2>
                   
                </div>
                <div class="panel-chip">Hiển thị ${totalReceipts != null ? totalReceipts : 0} phiếu</div>
            </div>

            <div class="table-wrap">
                <table class="receipt-table" id="receiptTable">
                    <thead>
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Ngày nhập</th>
                        <th>Nhà cung cấp</th>
                        <th>Số mặt hàng</th>
                        <th>Giá trị</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${receiptList}">
                        <tr data-code="${item.code}" 
                            data-date="${item.dateData}" 
                            data-supplier="${item.supplierName}" 
                            data-total-items="${item.totalItems}" 
                            data-total-value="${item.totalValue}" 
                            data-status="${item.statusDisplay}" 
                            data-creator="${item.creatorName}" 
                            data-note="${item.note}" 
                            data-lines="${item.lines}">
                            <td><span class="receipt-code">${item.code}</span></td>
                            <td>${item.dateDisplay}</td>
                            <td>${item.supplierName}</td>
                            <td>${item.totalItems}</td>
                            <td><fmt:formatNumber value="${item.totalValue}" type="number" groupingUsed="true"/> VND</td>
                            <td><span class="status-badge ${item.statusClass}">${item.statusDisplay}</span></td>
                            <td>
                                <button type="button" class="icon-btn view js-view-receipt" title="Xem chi tiết">
                                    <i class='bx bx-show'></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="empty-state is-hidden" id="emptyState">
                <i class='bx bx-package'></i>
                <h3>Không tìm thấy phiếu nhập phù hợp</h3>
                <p>Thử thay đổi mã phiếu hoặc khoảng thời gian lọc.</p>
            </div>
        </section>
    </main>
</div>

<div class="modal" id="receiptDetailModal" aria-hidden="true">
    <div class="modal-content modal-large">
        <div class="modal-header">
            <div>
                <p class="modal-kicker">Chi tiết phiếu nhập</p>
                <h2 id="detailCode">PNK-2026-018</h2>
            </div>
            <button type="button" class="modal-close" data-close-modal>&times;</button>
        </div>
        <div class="modal-body">
            <div class="detail-grid">
                <div class="detail-card">
                    <span class="detail-label">Ngày nhập</span>
                    <strong id="detailDate">02/05/2026 09:20</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Nhà cung cấp</span>
                    <strong id="detailSupplier">Công ty TNHH GreenFarm</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Người tạo</span>
                    <strong id="detailCreator">Nguyễn Minh Anh</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Tổng sản phẩm</span>
                    <strong id="detailItems">18 mặt hàng</strong>
                </div>
                <div class="detail-card highlight">
                    <span class="detail-label">Tổng giá trị</span>
                    <strong id="detailValue">42.850.000 VND</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Trạng thái</span>
                    <strong id="detailStatus">Đã duyệt</strong>
                </div>
            </div>

            <div class="detail-note">
                <span>Ghi chú phiếu nhập</span>
                <p id="detailNote">Nhập bổ sung trái cây nhập khẩu cho chi nhánh trung tâm.</p>
            </div>

            <div class="detail-lines">
                <div class="detail-lines__header">
                    <div class="detail-lines__heading">
                        <h3>Danh sách mặt hàng</h3>
                        <span>Tham khảo để kiểm tra số lượng và loại hàng</span>
                    </div>
                </div>
                <ul id="detailLines"></ul>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-ghost" data-close-modal>Đóng</button>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/inventory-receipt-new">
                <i class='bx bx-copy-alt'></i>
                <span>Tạo phiếu mới</span>
            </a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/inventory-management.js"></script>
</body>
</html>