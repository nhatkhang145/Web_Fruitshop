<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Quản lý tồn kho nâng cao | Admin</title>

	<link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-warehouse.css" />
	<meta name="contextPath" content="${pageContext.request.contextPath}" />
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
	<jsp:param name="activePage" value="stock-management" />
</jsp:include>

<div class="content">
	<jsp:include page="/admin/layout/header.jsp" />

	<main class="inventory-page">
		<div class="page-hero">
			<div class="hero-copy">
				<h1>Quản lý tồn kho </h1>
				
			</div>
			<div class="hero-actions">
				<a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/inventory-management">
					<i class='bx bx-archive-in'></i>
					<span>Phiếu nhập/xuất kho</span>
				</a>
			</div>
		</div>

		<section class="stats-grid">
			<article class="stat-card accent-blue">
				<div class="stat-icon"><i class='bx bx-grid-alt'></i></div>
				<div>
					<span class="stat-label">Tổng loại trái cây</span>
					<strong>68</strong>
					<small>Đang lưu thông trong kho</small>
				</div>
			</article>
			<article class="stat-card alert accent-gold">
				<div class="stat-icon"><i class='bx bx-error-circle'></i></div>
				<div>
					<span class="stat-label">Sắp hết (SL &lt; 10)</span>
					<strong>9</strong>
					<small>Cần nhập bổ sung</small>
				</div>
			</article>
			<article class="stat-card alert-danger accent-red">
				<div class="stat-icon"><i class='bx bx-timer'></i></div>
				<div>
					<span class="stat-label">Lô quá 3 ngày</span>
					<strong>6</strong>
					<small>Ưu tiên đẩy bán gấp</small>
				</div>
			</article>
		</section>

		<section class="panel stock-panel">
			<div class="panel-header stock-header">
				<div>
					<h2>Bảng tồn kho theo lô </h2>
					<p>Lô nhập trước, lưu kho lâu hơn được ưu tiên xuất trước.</p>
				</div>
			</div>

			<div class="stock-filters">
				<div class="search-box">
					<label class="sr-only" for="stockSearch">Tìm kiếm sản phẩm</label>
					<i class='bx bx-search'></i>
					<input type="text" id="stockSearch" placeholder="Tìm theo mã hoặc tên trái cây" />
				</div>
				<div class="filter-field">
					<label for="stockCategory">Danh mục</label>
					<select id="stockCategory">
						<option value="all">Tất cả</option>
						<option value="imported">Trái cây nhập khẩu</option>
						<option value="domestic">Trái cây nội địa</option>
					</select>
				</div>
				<div class="filter-field">
					<label for="stockFreshness">Tình trạng</label>
					<select id="stockFreshness">
						<option value="all">Tất cả</option>
						<option value="fresh">Tươi (1-2 ngày)</option>
						<option value="near">Cần chú ý (3-4 ngày)</option>
						<option value="critical">Cảnh báo hỏng (&gt; 5 ngày)</option>
					</select>
				</div>
				<div class="filter-actions">
					<button type="button" class="btn btn-ghost" id="clearFiltersBtn">
						<i class='bx bx-refresh'></i>
						<span>Xóa bộ lọc</span>
					</button>
				</div>
			</div>

			<div class="table-wrap">
				<table class="receipt-table stock-table" id="stockTable">
					<thead>
					<tr>
						<th>Sản phẩm / Lô</th>
						<th>Danh mục</th>
						<th>Giá bán</th>
						<th>Số lượng tồn</th>
						<th>Ngày nhập</th>
						<th>Số ngày lưu kho</th>
						<th>Tình trạng</th>
						<th>Hành động</th>
					</tr>
					</thead>
					<tbody>
					<tr class="stock-row" data-group="apple" data-code="FRU-0012" data-name="Táo Fuji" data-category="imported" data-freshness="fresh">
						<td>
							<button class="tree-toggle" type="button" data-toggle="apple" aria-expanded="false">
								<i class='bx bx-chevron-right'></i>
							</button>
							<div class="fruit-info">
								<img class="stock-thumb" src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='64' height='64'><rect width='64' height='64' rx='12' fill='%23e8f3f4'/><text x='50%25' y='55%25' text-anchor='middle' font-size='20' font-family='Arial' fill='%232f8087'>T</text></svg>" alt="Táo Fuji" />
								<div>
									<strong>Táo Fuji</strong>
									<span class="fruit-code">FRU-0012</span>
								</div>
							</div>
						</td>
						<td>Trái cây nhập khẩu</td>
						<td>52.000 VND</td>
						<td>
							<span class="stock-qty">120</span>
						</td>
						<td>22/05/2026</td>
						<td>2 ngày</td>
						<td><span class="status-badge safe">Tươi</span></td>
						<td>—</td>
					</tr>
					<tr class="batch-row is-hidden" data-group="apple" data-freshness="near">
						<td class="batch-cell">
							
							<div>
								<strong class="batch-code">LO-AP-240519</strong>
								<span class="batch-note">Táo Fuji</span>
							</div>
						</td>
						<td>—</td>
						<td>—</td>
						<td>
							<span class="stock-qty">40</span>
						</td>
						<td>19/05/2026</td>
						<td>4 ngày</td>
						<td><span class="status-badge near"> Chú ý</span></td>
						<td>
							<div class="action-group">
								<button type="button" class="icon-btn danger js-batch-action" data-action="waste" data-batch="LO-AP-240519" data-product="Táo Fuji" data-qty="40" title="Báo hỏng">
									<i class='bx bx-trash'></i>
								</button>
								<button type="button" class="icon-btn warn js-batch-action" data-action="grade" data-batch="LO-AP-240519" data-product="Táo Fuji" data-qty="40" title="Chuyển loại">
									<i class='bx bx-down-arrow-alt'></i>
								</button>
								<button type="button" class="icon-btn flash js-batch-action" data-action="flash" data-batch="LO-AP-240519" data-product="Táo Fuji" data-qty="40" data-price="52000" title="Đẩy sales">
									<i class='bx bx-bolt'></i>
								</button>
							</div>
						</td>
					</tr>
					<tr class="batch-row is-hidden" data-group="apple" data-freshness="fresh">
						<td class="batch-cell">
							
							<div>
								<strong class="batch-code">LO-AP-240521</strong>
								<span class="batch-note">Táo Fuji</span>
							</div>
						</td>
						<td>—</td>
						<td>—</td>
						<td>
							<span class="stock-qty">80</span>
						</td>
						<td>21/05/2026</td>
						<td>2 ngày</td>
						<td><span class="status-badge safe">Tươi</span></td>
						<td>
							<div class="action-group">
								<button type="button" class="icon-btn danger js-batch-action" data-action="waste" data-batch="LO-AP-240521" data-product="Táo Fuji" data-qty="80" title="Báo hỏng">
									<i class='bx bx-trash'></i>
								</button>
								<button type="button" class="icon-btn warn js-batch-action" data-action="grade" data-batch="LO-AP-240521" data-product="Táo Fuji" data-qty="80" title="Chuyển loại">
									<i class='bx bx-down-arrow-alt'></i>
								</button>
								<button type="button" class="icon-btn flash js-batch-action" data-action="flash" data-batch="LO-AP-240521" data-product="Táo Fuji" data-qty="80" data-price="52000" title="Đẩy sales">
									<i class='bx bx-bolt'></i>
								</button>
							</div>
						</td>
					</tr>
					<tr class="stock-row" data-group="strawberry" data-code="FRU-0077" data-name="Dâu tây Đà Lạt" data-category="domestic" data-freshness="critical">
						<td>
							<button class="tree-toggle" type="button" data-toggle="strawberry" aria-expanded="false">
								<i class='bx bx-chevron-right'></i>
							</button>
							<div class="fruit-info">
								<img class="stock-thumb" src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='64' height='64'><rect width='64' height='64' rx='12' fill='%23e8f3f4'/><text x='50%25' y='55%25' text-anchor='middle' font-size='20' font-family='Arial' fill='%232f8087'>D</text></svg>" alt="Dâu tây Đà Lạt" />
								<div>
									<strong>Dâu tây Đà Lạt</strong>
									<span class="fruit-code">FRU-0077</span>
								</div>
							</div>
						</td>
						<td>Trái cây nội địa</td>
						<td>88.000 VND</td>
						<td>
							<span class="stock-qty stock-low">26</span>
						</td>
						<td>19/05/2026</td>
						<td>4 ngày</td>
						<td><span class="status-badge critical"><i class='bx bxs-error'></i>Cảnh báo hỏng</span></td>
						<td>—</td>
					</tr>
					<tr class="batch-row is-hidden" data-group="strawberry" data-freshness="critical">
						<td class="batch-cell">
							
							<div>
								<strong class="batch-code">LO-DAU-240517</strong>
								<span class="batch-note">Dâu tây Đà Lạt</span>
							</div>
						</td>
						<td>—</td>
						<td>—</td>
						<td>
							<span class="stock-qty stock-low">10</span>
						</td>
						<td>17/05/2026</td>
						<td>6 ngày</td>
						<td><span class="status-badge critical"><i class='bx bxs-error'></i>Cảnh báo hỏng</span></td>
						<td>
							<div class="action-group">
								<button type="button" class="icon-btn danger js-batch-action" data-action="waste" data-batch="LO-DAU-240517" data-product="Dâu tây Đà Lạt" data-qty="10" title="Báo hỏng">
									<i class='bx bx-trash'></i>
								</button>
								<button type="button" class="icon-btn warn js-batch-action" data-action="grade" data-batch="LO-DAU-240517" data-product="Dâu tây Đà Lạt" data-qty="10" title="Chuyển loại">
									<i class='bx bx-down-arrow-alt'></i>
								</button>
								<button type="button" class="icon-btn flash js-batch-action" data-action="flash" data-batch="LO-DAU-240517" data-product="Dâu tây Đà Lạt" data-qty="10" data-price="88000" title="Đẩy sales">
									<i class='bx bx-bolt'></i>
								</button>
							</div>
						</td>
					</tr>
					<tr class="batch-row is-hidden" data-group="strawberry" data-freshness="near">
						<td class="batch-cell">
							
							<div>
								<strong class="batch-code">LO-DAU-240520</strong>
								<span class="batch-note">Dâu tây Đà Lạt</span>
							</div>
						</td>
						<td>—</td>
						<td>—</td>
						<td>
							<span class="stock-qty">16</span>
						</td>
						<td>20/05/2026</td>
						<td>3 ngày</td>
						<td><span class="status-badge near">Cần chú ý</span></td>
						<td>
							<div class="action-group">
								<button type="button" class="icon-btn danger js-batch-action" data-action="waste" data-batch="LO-DAU-240520" data-product="Dâu tây Đà Lạt" data-qty="16" title="Báo hỏng">
									<i class='bx bx-trash'></i>
								</button>
								<button type="button" class="icon-btn warn js-batch-action" data-action="grade" data-batch="LO-DAU-240520" data-product="Dâu tây Đà Lạt" data-qty="16" title="Chuyển loại">
									<i class='bx bx-down-arrow-alt'></i>
								</button>
								<button type="button" class="icon-btn flash js-batch-action" data-action="flash" data-batch="LO-DAU-240520" data-product="Dâu tây Đà Lạt" data-qty="16" data-price="88000" title="Đẩy sales">
									<i class='bx bx-bolt'></i>
								</button>
							</div>
						</td>
					</tr>
					</tbody>
				</table>
			</div>

			<div class="empty-state is-hidden" id="stockEmpty">
				<i class='bx bx-package'></i>
				<h3>Không tìm thấy kết quả</h3>
				<p>Thử đổi từ khóa tìm kiếm hoặc bộ lọc nâng cao.</p>
			</div>

			<div class="table-footer is-hidden" id="batchPaginationWrap">
				<div class="batch-info" id="batchPageInfo">Hiển thị 0 / 0 lô</div>
				<div class="pagination" id="batchPagination">
					<button type="button" class="btn btn-ghost" id="batchPrev" aria-label="Trang trước">Trước</button>
					<div class="page-list" id="batchPages"></div>
					<button type="button" class="btn btn-ghost" id="batchNext" aria-label="Trang sau">Sau</button>
				</div>
			</div>
		</section>
	</main>
</div>

<div class="modal" id="wasteModal" aria-hidden="true">
	<div class="modal-content modal-small">
		<div class="modal-header">
			<div>
				<p class="modal-kicker">Báo hỏng</p>
				<h2 id="wasteTitle">Ghi nhận hao hụt</h2>
			</div>
			<button type="button" class="modal-close" data-close-modal>&times;</button>
		</div>
		<div class="modal-body">
			<p class="modal-desc">Nhập số lượng bị hỏng để trừ kho cho lô <strong id="wasteBatch">—</strong>.</p>
			<div class="form-group">
				<label for="wasteQty">Số lượng hỏng - Tối đa: <span id="wasteMax">0</span></label>
				<input type="number" id="wasteQty" min="1" placeholder="Ví dụ: 5" />
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-ghost" data-close-modal>Hủy</button>
			<button type="button" class="btn btn-primary">Xác nhận báo hỏng</button>
		</div>
	</div>
</div>

<div class="modal" id="gradeModal" aria-hidden="true">
	<div class="modal-content modal-small">
		<div class="modal-header">
			<div>
				<p class="modal-kicker">Chuyển loại</p>
				<h2 id="gradeTitle">Chuyển trái cây xuống loại 2</h2>
			</div>
			<button type="button" class="modal-close" data-close-modal>&times;</button>
		</div>
		<div class="modal-body">
			<p class="modal-desc">Chuyển lô <strong id="gradeBatch">—</strong> sang chế biến/nước ép.</p>
			<div class="form-group">
				<label for="gradeQty">Số lượng chuyển loại - Tối đa: <span id="gradeMax">0</span></label>
				<input type="number" id="gradeQty" min="1" placeholder="Ví dụ: 8" />
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-ghost" data-close-modal>Hủy</button>
			<button type="button" class="btn btn-primary">Xác nhận chuyển loại</button>
		</div>
	</div>
</div>

<div class="modal" id="flashModal" aria-hidden="true">
	<div class="modal-content modal-small">
		<div class="modal-header">
			<div>
				<p class="modal-kicker">Đẩy sales</p>
				<h2>Tạo Flash Sale ngay</h2>
			</div>
			<button type="button" class="modal-close" data-close-modal>&times;</button>
		</div>
		<div class="modal-body">
			<div class="flash-meta">
				<span>Lô hàng:</span>
				<strong id="flashBatch">—</strong>
				<span>Số lượng còn:</span>
				<strong id="flashQty">—</strong>
				<span>Giá hiện tại:</span>
				<strong id="flashCurrentPrice">—</strong>
			</div>
			<div class="form-grid">
				<div class="form-group">
					<label for="flashPrice">Giá khuyến mãi (VND)</label>
					<input type="number" id="flashPrice" min="1000" placeholder="Ví dụ: 35000" />
				</div>
				<div class="form-group">
					<label for="flashDuration">Hiển thị trong (giờ)</label>
					<input type="number" id="flashDuration" min="1" placeholder="Ví dụ: 24" />
				</div>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-ghost" data-close-modal>Hủy</button>
			<button type="button" class="btn btn-primary">Tạo Flash Sale ngay</button>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/inventory-warehouse.js"></script>
</body>
</html>
