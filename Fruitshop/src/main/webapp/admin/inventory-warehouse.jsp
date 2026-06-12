<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

			</div>
		</div>

		<section class="stats-grid">
			<article class="stat-card accent-blue">
				<div class="stat-icon"><i class='bx bx-grid-alt'></i></div>
				<div>
					<span class="stat-label">Tổng loại trái cây</span>
					<strong><fmt:formatNumber value="${totalProductTypes != null ? totalProductTypes : 0}" type="number" groupingUsed="true"/></strong>
					<small>Đang lưu thông trong kho</small>
				</div>
			</article>
			<article class="stat-card alert accent-gold">
				<div class="stat-icon"><i class='bx bx-error-circle'></i></div>
				<div>
					<span class="stat-label">Sắp hết (SL &lt; 10)</span>
					<strong><fmt:formatNumber value="${lowStockCount != null ? lowStockCount : 0}" type="number" groupingUsed="true"/></strong>
					<small>Cần nhập bổ sung</small>
				</div>
			</article>
			<article class="stat-card alert-danger accent-red">
				<div class="stat-icon"><i class='bx bx-timer'></i></div>
				<div>
					<span class="stat-label">Lô quá 3 ngày</span>
					<strong><fmt:formatNumber value="${oldBatchCount != null ? oldBatchCount : 0}" type="number" groupingUsed="true"/></strong>
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
						<th>Giá bán</th>
						<th>Số lượng tồn</th>
						<th>Ngày nhập</th>
						<th>Số ngày lưu kho</th>
						<th>Tình trạng</th>
						<th>Hành động</th>
					</tr>
					</thead>
					<tbody>
					<c:forEach var="product" items="${productStocks}">
						<tr class="stock-row" data-group="${product.groupKey}" data-code="${product.productCode}" data-name="${product.productName}" data-freshness="${product.freshnessKey}">
							<td>
									<div class="stock-main">
										<button class="tree-toggle" type="button" data-toggle="${product.groupKey}" aria-expanded="false">
											<i class='bx bx-chevron-right'></i>
										</button>
										<div class="fruit-info">
									<c:choose>
										<c:when test="${not empty product.image}">
											<c:choose>
												<c:when test="${fn:startsWith(product.image, 'http')}">
													<img class="stock-thumb" src="${product.image}" alt="${product.productName}" />
												</c:when>
												<c:otherwise>
													<img class="stock-thumb" src="${pageContext.request.contextPath}/${product.image}" alt="${product.productName}" />
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<img class="stock-thumb" src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='64' height='64'><rect width='64' height='64' rx='12' fill='%23e8f3f4'/><text x='50%25' y='55%25' text-anchor='middle' font-size='20' font-family='Arial' fill='%232f8087'>P</text></svg>" alt="${product.productName}" />
										</c:otherwise>
									</c:choose>
										<div>
											<strong>${product.productName}</strong>
											<span class="fruit-code">${product.productCode}</span>
										</div>
									</div>
								</div>
							</td>
							<td><fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> VND</td>
							<td>
								<span class="stock-qty ${product.quantity < 10 ? 'stock-low' : ''}">${product.quantity}</span>
							</td>
							<td>${product.oldestDateDisplay}</td>
							<td>
								<c:choose>
									<c:when test="${product.oldestAgeDays >= 0}">${product.oldestAgeDays} ngày</c:when>
									<c:otherwise>—</c:otherwise>
								</c:choose>
							</td>
							<td>
								<span class="status-badge ${product.statusBadgeClass}">
									<c:choose>
										<c:when test="${product.freshnessKey == 'critical'}">Cảnh báo hỏng</c:when>
										<c:when test="${product.freshnessKey == 'near'}">Cần chú ý</c:when>
										<c:otherwise>Tươi</c:otherwise>
									</c:choose>
								</span>
							</td>
							<td>—</td>
						</tr>
						<c:forEach var="batch" items="${product.batches}">
							<tr class="batch-row is-hidden" data-group="${product.groupKey}" data-freshness="${batch.freshnessKey}" data-item-id="${batch.itemId}">
								<td class="batch-cell">
									<div>
										<strong class="batch-code">${batch.batchCode}</strong>
										<span class="batch-note">${product.productName}</span>
									</div>
								</td>
								<td>—</td>
								<td>
									<span class="stock-qty ${batch.quantity < 10 ? 'stock-low' : ''}">${batch.quantity}</span>
								</td>
								<td>${batch.receiptDateDisplay}</td>
								<td>
									<c:choose>
										<c:when test="${batch.ageDays >= 0}">${batch.ageDays} ngày</c:when>
										<c:otherwise>—</c:otherwise>
									</c:choose>
								</td>
								<td>
									<span class="status-badge ${batch.statusBadgeClass}">
										<c:choose>
											<c:when test="${batch.freshnessKey == 'critical'}">Cảnh báo hỏng</c:when>
											<c:when test="${batch.freshnessKey == 'near'}">Cần chú ý</c:when>
											<c:otherwise>Tươi</c:otherwise>
										</c:choose>
									</span>
								</td>
								<td>
									<div class="action-group">
										<a href="${pageContext.request.contextPath}/admin/inventory-receipt-detail?id=${batch.receiptId}" class="icon-btn view" title="Xem chi tiết lô">
											<i class='bx bx-show'></i>
										</a>
										<button type="button" class="icon-btn danger js-batch-action" data-action="waste" data-batch="${batch.batchCode}" data-product="${product.productName}" data-qty="${batch.quantity}" title="Báo hỏng">
											<i class='bx bx-trash'></i>
										</button>
										<button type="button" class="icon-btn flash js-batch-action" data-action="flash" data-batch="${batch.batchCode}" data-product="${product.productName}" data-qty="${batch.quantity}" data-price="${product.price}" title="Đẩy sales">
											<i class='bx bx-bolt'></i>
										</button>
									</div>
								</td>
							</tr>
						</c:forEach>
					</c:forEach>
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
			<button type="button" class="btn btn-primary"><i class='bx bx-bolt'></i> Tạo Flash Sale ngay</button>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/inventory-warehouse.js"></script>
</body>
</html>
