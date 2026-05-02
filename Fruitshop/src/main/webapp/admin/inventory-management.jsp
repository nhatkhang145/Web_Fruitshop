<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                    <strong>128</strong>
                    <small>+12 trong 7 ngày</small>
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
                <div class="panel-chip">Hiển thị 5/128 phiếu</div>
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
                    <tr data-code="PNK-2026-018" data-date="2026-05-02" data-supplier="Công ty TNHH GreenFarm" data-total-items="18" data-total-value="42850000" data-status="Đã duyệt" data-creator="Nguyễn Minh Anh" data-note="Nhập bổ sung trái cây nhập khẩu cho chi nhánh trung tâm." data-lines="Cam Úc x120;Táo Envy x90;Nho đen Mỹ x60">
                        <td><span class="receipt-code">PNK-2026-018</span></td>
                        <td>02/05/2026 09:20</td>
                        <td>Công ty TNHH GreenFarm</td>
                        <td>18</td>
                        <td>42.850.000 VND</td>
                        <td><span class="status-badge approved">Đã duyệt</span></td>
                        <td>
                            <button type="button" class="icon-btn view js-view-receipt" title="Xem chi tiết">
                                <i class='bx bx-show'></i>
                            </button>
                        </td>
                    </tr>
                    <tr data-code="PNK-2026-017" data-date="2026-04-29" data-supplier="Đại lý Hương Việt" data-total-items="12" data-total-value="27600000" data-status="Chờ duyệt" data-creator="Trần Thu Hằng" data-note="Phiếu nhập hàng tươi theo kế hoạch tuần." data-lines="Dâu tây Đà Lạt x50;Việt quất x40;Kiwi x70">
                        <td><span class="receipt-code">PNK-2026-017</span></td>
                        <td>29/04/2026 14:45</td>
                        <td>Đại lý Hương Việt</td>
                        <td>12</td>
                        <td>27.600.000 VND</td>
                        <td><span class="status-badge pending">Chờ duyệt</span></td>
                        <td>
                            <button type="button" class="icon-btn view js-view-receipt" title="Xem chi tiết">
                                <i class='bx bx-show'></i>
                            </button>
                        </td>
                    </tr>
                    <tr data-code="PNK-2026-016" data-date="2026-04-27" data-supplier="FreshMart Supply" data-total-items="22" data-total-value="65100000" data-status="Đã duyệt" data-creator="Lê Quốc Bảo" data-note="Lô hàng đầu tuần cho hệ thống." data-lines="Lê Nam Phi x100;Cam vàng x130;Mãng cầu x80">
                        <td><span class="receipt-code">PNK-2026-016</span></td>
                        <td>27/04/2026 10:10</td>
                        <td>FreshMart Supply</td>
                        <td>22</td>
                        <td>65.100.000 VND</td>
                        <td><span class="status-badge approved">Đã duyệt</span></td>
                        <td>
                            <button type="button" class="icon-btn view js-view-receipt" title="Xem chi tiết">
                                <i class='bx bx-show'></i>
                            </button>
                        </td>
                    </tr>
                    <tr data-code="PNK-2026-015" data-date="2026-04-22" data-supplier="Vina Fruit Co." data-total-items="9" data-total-value="19800000" data-status="Tạm lưu" data-creator="Phạm Gia Huy" data-note="Chờ đối soát hóa đơn." data-lines="Xoài cát x80;Chuối già x90;Mít x20">
                        <td><span class="receipt-code">PNK-2026-015</span></td>
                        <td>22/04/2026 16:30</td>
                        <td>Vina Fruit Co.</td>
                        <td>9</td>
                        <td>19.800.000 VND</td>
                        <td><span class="status-badge draft">Tạm lưu</span></td>
                        <td>
                            <button type="button" class="icon-btn view js-view-receipt" title="Xem chi tiết">
                                <i class='bx bx-show'></i>
                            </button>
                        </td>
                    </tr>
                    <tr data-code="PNK-2026-014" data-date="2026-04-18" data-supplier="Tropical Hub" data-total-items="15" data-total-value="35500000" data-status="Đã duyệt" data-creator="Ngô Hồng Nhung" data-note="Phiếu nhập cho kho khu vực miền Nam." data-lines="Thanh long x100;Dừa xiêm x120;Dưa hấu x75">
                        <td><span class="receipt-code">PNK-2026-014</span></td>
                        <td>18/04/2026 11:05</td>
                        <td>Tropical Hub</td>
                        <td>15</td>
                        <td>35.500.000 VND</td>
                        <td><span class="status-badge approved">Đã duyệt</span></td>
                        <td>
                            <button type="button" class="icon-btn view js-view-receipt" title="Xem chi tiết">
                                <i class='bx bx-show'></i>
                            </button>
                        </td>
                    </tr>
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
                    <h3>Danh sách mặt hàng</h3>
                    <span>Tham khảo để kiểm tra số lượng và loại hàng</span>
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

<div class="modal" id="createReceiptModal" aria-hidden="true">
    <div class="modal-content modal-xl">
        <div class="modal-header">
            <div>
                <p class="modal-kicker">Tạo phiếu nhập kho</p>
                <h2>Phiếu nhập mới</h2>
            </div>
            <button type="button" class="modal-close" data-close-modal>&times;</button>
        </div>
        <div class="modal-body">
            <form class="receipt-form">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Mã phiếu nhập</label>
                        <input type="text" placeholder="Tự động hoặc nhập thủ công" />
                    </div>
                    <div class="form-group">
                        <label>Ngày nhập</label>
                        <input type="datetime-local" />
                    </div>
                    <div class="form-group">
                        <label>Nhà cung cấp</label>
                        <input type="text" placeholder="Tên nhà cung cấp" />
                    </div>
                    <div class="form-group">
                        <label>Người lập phiếu</label>
                        <input type="text" placeholder="Nhân viên phụ trách" />
                    </div>
                    <div class="form-group form-group-full">
                        <label>Ghi chú</label>
                        <textarea rows="3" placeholder="Thông tin giao nhận, điều kiện, ghi chú kiểm hàng..."></textarea>
                    </div>
                </div>

                <div class="line-items-card">
                    <div class="detail-lines__header">
                        <h3>Danh sách hàng nhập</h3>
                        <span>Thiết kế trước giao diện, chưa nối dữ liệu backend</span>
                    </div>
                    <div class="line-item row-head">
                        <span>Sản phẩm</span>
                        <span>Số lượng</span>
                        <span>Đơn giá</span>
                        <span>Thành tiền</span>
                        <span></span>
                    </div>
                    <div class="line-item">
                        <input type="text" placeholder="Ví dụ: Táo Envy" />
                        <input type="number" placeholder="0" />
                        <input type="number" placeholder="0" />
                        <input type="text" placeholder="Tự tính" disabled />
                        <button type="button" class="line-remove-btn"><i class='bx bx-trash'></i></button>
                    </div>
                    <div class="line-item">
                        <input type="text" placeholder="Ví dụ: Nho đen Mỹ" />
                        <input type="number" placeholder="0" />
                        <input type="number" placeholder="0" />
                        <input type="text" placeholder="Tự tính" disabled />
                        <button type="button" class="line-remove-btn"><i class='bx bx-trash'></i></button>
                    </div>
                    <button type="button" class="btn btn-dashed" id="addLineItemBtn">
                        <i class='bx bx-plus'></i>
                        <span>Thêm dòng hàng</span>
                    </button>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-ghost" data-close-modal>Hủy</button>
            <button type="button" class="btn btn-primary">
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