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
                <div class="eyebrow">Warehouse management</div>
                <h1>Quản lý nhập kho</h1>
                <p>Theo dõi phiếu nhập, xem nhanh chi tiết, lọc theo thời gian và tạo phiếu mới trong một giao diện thống nhất.</p>
            </div>
            <div class="hero-actions">
                <button type="button" class="btn btn-primary" id="openCreateReceiptBtn">
                    <i class='bx bx-plus-circle'></i>
                    <span>Tạo phiếu nhập kho</span>
                </button>
            </div>
        </div>

        <section class="stats-grid">
            <article class="stat-card accent-teal">
                <div class="stat-icon"><i class='bx bx-receipt'></i></div>
                <div>
                    <span class="stat-label">Tổng phiếu nhập</span>
                    <strong>${totalReceipts != null ? totalReceipts : 0}</strong>
                    <small>Cập nhật liên tục</small>
                </div>
            </article>
            <article class="stat-card accent-blue">
                <div class="stat-icon"><i class='bx bx-package'></i></div>
                <div>
                    <span class="stat-label">Sản phẩm đã nhập</span>
                    <strong>3,482</strong>
                    <small>Trên toàn hệ thống</small>
                </div>
            </article>
            <article class="stat-card accent-gold">
                <div class="stat-icon"><i class='bx bx-wallet'></i></div>
                <div>
                    <span class="stat-label">Tổng giá trị nhập</span>
                    <strong>1.28 tỷ</strong>
                    <small>Tạm tính tháng này</small>
                </div>
            </article>
            <article class="stat-card accent-green">
                <div class="stat-icon"><i class='bx bx-check-shield'></i></div>
                <div>
                    <span class="stat-label">Phiếu đã duyệt</span>
                    <strong>114</strong>
                    <small>Đang chờ duyệt: 14</small>
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
                    <p>Click vào biểu tượng xem để mở chi tiết phiếu nhập.</p>
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
            <button type="button" class="btn btn-primary" id="openCreateFromDetailBtn">
                <i class='bx bx-copy-alt'></i>
                <span>Tạo phiếu tương tự</span>
            </button>
        </div>
    </div>
</div>

<div class="modal modal-fullscreen" id="createReceiptModal" aria-hidden="true">
    <div class="modal-content modal-xl modal-full">
        <div class="modal-header">
            <div>
                <p class="modal-kicker">Tạo phiếu nhập kho</p>
                <h2>Phiếu nhập mới</h2>
            </div>
            <button type="button" class="modal-close" data-close-modal>&times;</button>
        </div>
        <div class="modal-body">
            <div id="createReceiptMsg" class="form-msg is-hidden"></div>
            <form class="receipt-form" id="createReceiptForm">
                <div class="form-grid form-grid--wide">
                    <div class="form-group">
                        <label for="inputReceiptCode">Mã phiếu nhập <span class="required">*</span></label>
                        <input type="text" id="inputReceiptCode" name="receipt_code" placeholder="RCP-YYYYMMDD-0001" required />
                    </div>
                    <div class="form-group">
                        <label for="inputReceiptDate">Ngày nhập <span class="required">*</span></label>
                        <div class="input-icon">
                            <i class='bx bx-calendar'></i>
                            <input type="date" id="inputReceiptDate" name="receipt_date" class="input-date" required />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputCreator">Người lập phiếu <span class="required">*</span></label>
                        <input type="text" id="inputCreator" name="creator_name" value="${sessionScope.account.fullName}" data-default="${sessionScope.account.fullName}" placeholder="Tên người lập" required />
                    </div>
                    <div class="form-group form-group-full">
                        <label for="inputSupplierSelect">Nhà cung cấp <span class="required">*</span></label>
                        <div class="supplier-picker">
                            <div class="supplier-picker__col">
                                <span class="supplier-picker__label">Chọn từ danh sách</span>
                                <select id="inputSupplierSelect" name="supplier_select">
                                    <option value="">-- Chọn nhà cung cấp --</option>
                                    <c:forEach var="s" items="${suppliers}">
                                        <option value="${s.id}">${s.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="supplier-picker__col">
                                <span class="supplier-picker__label">Hoặc nhập mới</span>
                                <input type="text" id="inputSupplierName" name="supplier_name" placeholder="Nhập nhà cung cấp mới" />
                            </div>
                        </div>
                        <input type="hidden" id="inputSupplierId" name="supplier_id" />
                        <small class="field-hint">Chọn nhà cung cấp có sẵn hoặc nhập tên mới để thêm ngay trong phiếu.</small>
                    </div>
                    <div class="form-group form-group-full">
                        <label for="inputNote">Ghi chú <span class="required">*</span></label>
                        <textarea id="inputNote" name="note" rows="2" placeholder="Thông tin giao nhận, điều kiện, ghi chú kiểm hàng..." required></textarea>
                    </div>
                </div>

                <div class="line-items-card">
                    <div class="detail-lines__header detail-lines__header--split">
                        <div class="detail-lines__heading">
                            <h3>Danh sách hàng nhập</h3>
                            <span>Thêm từng dòng sản phẩm</span>
                        </div>
                        <button type="button" class="btn btn-dashed btn-dashed--compact" id="addLineItemBtn">
                            <i class='bx bx-plus'></i>
                            <span>Thêm dòng hàng</span>
                        </button>
                    </div>
                    <div class="line-item row-head">
                        <span>Mã sản phẩm</span>
                        <span>Số lượng</span>
                        <span>Đơn giá (VND)</span>
                        <span>Thành tiền</span>
                        <span></span>
                    </div>
                    <div id="lineItemsContainer">
                        <div class="line-item js-line-item">
                            <select class="line-product-select" name="product_id" required>
                                <option value="">-- Chọn mã sản phẩm --</option>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.id}">${p.id} - ${p.name}</option>
                                </c:forEach>
                            </select>
                            <input type="number" class="line-qty" name="quantity" placeholder="0" min="1" required />
                            <input type="number" class="line-price" name="price" placeholder="0" min="1" required />
                            <input type="text" class="line-total" placeholder="Tự tính" disabled />
                            <button type="button" class="line-remove-btn"><i class='bx bx-trash'></i></button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-ghost" data-close-modal>Hủy</button>
            <button type="button" class="btn btn-primary" id="saveReceiptBtn">
                <i class='bx bx-save'></i>
                <span>Lưu phiếu nhập</span>
            </button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/inventory-management.js"></script>
</body>
</html>