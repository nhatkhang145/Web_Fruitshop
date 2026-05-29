document.addEventListener("DOMContentLoaded", function () {
	var searchInput = document.getElementById("stockSearch");
	var freshnessSelect = document.getElementById("stockFreshness");
	var clearFiltersBtn = document.getElementById("clearFiltersBtn");
	var table = document.getElementById("stockTable");
	var emptyState = document.getElementById("stockEmpty");
	var batchPaginationWrap = document.getElementById("batchPaginationWrap");
	var batchPrev = document.getElementById("batchPrev");
	var batchNext = document.getElementById("batchNext");
	var batchPages = document.getElementById("batchPages");
	var batchPageInfo = document.getElementById("batchPageInfo");
	var currentBatchPage = 1;
	var batchPageSize = 10;

	function getBatchRows(group) {
		if (!table) return [];
		return Array.from(table.querySelectorAll(".batch-row[data-group='" + group + "']"));
	}

	function updateGroupVisibility(row, group) {
		var batchRows = getBatchRows(group);
		var show = row.classList.contains("is-open") && !row.classList.contains("is-hidden");
		batchRows.forEach(function (batch) {
			batch.classList.toggle("is-hidden", !show);
		});
	}

	function getVisibleBatchRows() {
		if (!table) return [];
		return Array.from(table.querySelectorAll(".batch-row")).filter(function (row) {
			if (row.classList.contains("is-hidden")) return false;
			var group = row.dataset.group || "";
			var parent = table.querySelector(".stock-row[data-group='" + group + "']");
			if (!parent || parent.classList.contains("is-hidden")) return false;
			return parent.classList.contains("is-open");
		});
	}

	function renderBatchPages(pageCount) {
		if (!batchPages) return;
		batchPages.innerHTML = "";
		if (pageCount <= 1) return;
		for (var i = 1; i <= pageCount; i += 1) {
			var btn = document.createElement("button");
			btn.type = "button";
			btn.className = "page-btn" + (i === currentBatchPage ? " is-active" : "");
			btn.textContent = String(i);
			btn.dataset.page = String(i);
			btn.addEventListener("click", function (event) {
				var target = event.currentTarget;
				currentBatchPage = Number(target.dataset.page || "1");
				updatePagination();
			});
			batchPages.appendChild(btn);
		}
	}

	function updateBatchSummary(total) {
		if (!batchPageInfo) return;
		if (total === 0) {
			batchPageInfo.textContent = "Hiển thị 0 / 0 lô";
			return;
		}
		var start = (currentBatchPage - 1) * batchPageSize + 1;
		var end = Math.min(start + batchPageSize - 1, total);
		batchPageInfo.textContent = "Hiển thị " + start + "-" + end + " / " + total + " lô";
	}

	function updatePagination() {
		if (!table || !batchPaginationWrap) return;
		var batches = getVisibleBatchRows();
		var total = batches.length;
		var pageCount = Math.max(1, Math.ceil(total / batchPageSize));

		if (currentBatchPage > pageCount) {
			currentBatchPage = pageCount;
		}

		batches.forEach(function (row, index) {
			var startIndex = (currentBatchPage - 1) * batchPageSize;
			var endIndex = startIndex + batchPageSize;
			row.classList.toggle("is-paged-hidden", index < startIndex || index >= endIndex);
		});

		var shouldShow = total > batchPageSize;
		batchPaginationWrap.classList.toggle("is-hidden", !shouldShow);
		updateBatchSummary(total);
		renderBatchPages(pageCount);

		if (batchPrev) batchPrev.disabled = currentBatchPage <= 1;
		if (batchNext) batchNext.disabled = currentBatchPage >= pageCount;
	}

	function applyFilters() {
		var query = (searchInput?.value || "").trim().toLowerCase();
		var freshness = freshnessSelect?.value || "all";
		var visible = 0;

		(table ? Array.from(table.querySelectorAll(".stock-row")) : []).forEach(function (row) {
			var code = (row.dataset.code || "").toLowerCase();
			var name = (row.dataset.name || "").toLowerCase();
			var rowFreshness = row.dataset.freshness || "";
			var batchRows = getBatchRows(row.dataset.group || "");
			var batchMatch = batchRows.some(function (batch) {
				return (batch.dataset.freshness || "") === freshness;
			});
			var matchesBase = query === "" || code.includes(query) || name.includes(query);
			var matches = matchesBase && (freshness === "all" || rowFreshness === freshness || batchMatch);

			row.classList.toggle("is-hidden", !matches);
			if (matches) visible += 1;

			if (matchesBase && freshness !== "all" && batchMatch && rowFreshness !== freshness) {
				row.classList.add("is-open");
				var toggleBtn = row.querySelector(".tree-toggle");
				if (toggleBtn) {
					toggleBtn.setAttribute("aria-expanded", "true");
				}
			}
			updateGroupVisibility(row, row.dataset.group || "");
		});

		emptyState?.classList.toggle("is-hidden", visible !== 0);
		currentBatchPage = 1;
		updatePagination();
	}

	document.querySelectorAll(".tree-toggle").forEach(function (btn) {
		btn.addEventListener("click", function () {
			var row = btn.closest(".stock-row");
			if (!row) return;
			var group = row.dataset.group || "";
			var isOpen = row.classList.toggle("is-open");
			btn.setAttribute("aria-expanded", isOpen ? "true" : "false");
			updateGroupVisibility(row, group);
			updatePagination();
		});
	});

	searchInput?.addEventListener("input", applyFilters);
	freshnessSelect?.addEventListener("change", applyFilters);
	clearFiltersBtn?.addEventListener("click", function () {
		if (searchInput) searchInput.value = "";
		if (freshnessSelect) freshnessSelect.value = "all";
		applyFilters();
	});
	applyFilters();

	batchPrev?.addEventListener("click", function () {
		if (currentBatchPage <= 1) return;
		currentBatchPage -= 1;
		updatePagination();
	});

	batchNext?.addEventListener("click", function () {
		var total = getVisibleBatchRows().length;
		var pageCount = Math.max(1, Math.ceil(total / batchPageSize));
		if (currentBatchPage >= pageCount) return;
		currentBatchPage += 1;
		updatePagination();
	});

	var wasteModal = document.getElementById("wasteModal");
	var gradeModal = document.getElementById("gradeModal");
	var flashModal = document.getElementById("flashModal");
	var wasteBatch = document.getElementById("wasteBatch");
	var gradeBatch = document.getElementById("gradeBatch");
	var flashBatch = document.getElementById("flashBatch");
	var flashQty = document.getElementById("flashQty");
	var wasteQtyInput = document.getElementById("wasteQty");
	var gradeQtyInput = document.getElementById("gradeQty");
	var flashPriceInput = document.getElementById("flashPrice");
	var wasteMax = document.getElementById("wasteMax");
	var gradeMax = document.getElementById("gradeMax");
	var flashCurrentPrice = document.getElementById("flashCurrentPrice");

	function formatCurrency(value) {
		var number = Number(value);
		if (!Number.isFinite(number)) return "—";
		return number.toLocaleString("vi-VN") + " VND";
	}

	function openModal(modal) {
		if (!modal) return;
		modal.classList.add("show");
		modal.setAttribute("aria-hidden", "false");
	}

	function closeModal(modal) {
		if (!modal) return;
		modal.classList.remove("show");
		modal.setAttribute("aria-hidden", "true");
	}

	document.querySelectorAll(".js-batch-action").forEach(function (btn) {
		btn.addEventListener("click", function () {
			var action = btn.dataset.action;
			var batch = btn.dataset.batch || "—";
			var qty = btn.dataset.qty || "—";
			var qtyNumber = Number(qty);
			var priceNumber = Number(btn.dataset.price || "");
			var batchRow = btn.closest('.batch-row');
			var groupKey = batchRow?.dataset.group || '';
			if (wasteModal) wasteModal.dataset.group = groupKey;
			if (wasteModal) wasteModal.dataset.batchCode = batch;
			if (wasteModal) wasteModal.dataset.batchQty = String(qtyNumber || 0);
			if (wasteModal) wasteModal.dataset.batchItemId = batchRow?.dataset.itemId || '';

			if (action === "waste") {
				if (wasteBatch) wasteBatch.textContent = batch;
				if (wasteMax) wasteMax.textContent = Number.isFinite(qtyNumber) ? qtyNumber : "—";
				if (wasteQtyInput) {
					if (Number.isFinite(qtyNumber)) {
						wasteQtyInput.max = String(qtyNumber);
					} else {
						wasteQtyInput.removeAttribute("max");
					}
					wasteQtyInput.value = "";
				}
				openModal(wasteModal);
			}

			if (action === "grade") {
				if (gradeBatch) gradeBatch.textContent = batch;
				if (gradeMax) gradeMax.textContent = Number.isFinite(qtyNumber) ? qtyNumber : "—";
				if (gradeQtyInput) {
					if (Number.isFinite(qtyNumber)) {
						gradeQtyInput.max = String(qtyNumber);
					} else {
						gradeQtyInput.removeAttribute("max");
					}
					gradeQtyInput.value = "";
				}
				openModal(gradeModal);
			}

			if (action === "flash") {
				if (flashBatch) flashBatch.textContent = batch;
				if (flashQty) flashQty.textContent = qty;
				if (flashCurrentPrice) {
					flashCurrentPrice.textContent = Number.isFinite(priceNumber)
						? formatCurrency(priceNumber)
						: "—";
				}
				if (flashPriceInput) {
					if (Number.isFinite(priceNumber)) {
						flashPriceInput.max = String(priceNumber);
					} else {
						flashPriceInput.removeAttribute("max");
					}
					flashPriceInput.value = "";
				}
				openModal(flashModal);
			}
		});
	});

	(function () {
		if (!wasteModal) return;
		var footerBtn = wasteModal.querySelector('.modal-footer .btn-primary');
		footerBtn?.addEventListener('click', function () {
			var groupKey = wasteModal.dataset.group || '';
			var batchCode = wasteModal.dataset.batchCode || '';
			var batchQty = Number(wasteModal.dataset.batchQty || '0');
			var qtyVal = Number(wasteQtyInput?.value || '0');
			if (!groupKey) {
				alert('Không xác định được sản phẩm.');
				return;
			}
			if (!Number.isFinite(qtyVal) || qtyVal <= 0) {
				alert('Vui lòng nhập số lượng hỏng hợp lệ.');
				return;
			}
			if (batchQty > 0 && qtyVal > batchQty) {
				alert('Số lượng hỏng không thể lớn hơn số lượng trong lô.');
				return;
			}

			var pid = null;
			var m = groupKey.match(/product-(\d+)/);
			if (m) pid = Number(m[1]);
			if (!pid) {
				alert('Không xác định được ID sản phẩm.');
				return;
			}

			
			var stockRow = document.querySelector('.stock-row[data-group="' + groupKey + '"]');
			var unitPrice = 0;
			if (stockRow) {
				var priceCell = stockRow.cells && stockRow.cells[1] ? stockRow.cells[1].textContent : '';
					if (priceCell) {
					var num = priceCell.replace(/[^0-9\.\-]/g, '');
					unitPrice = Number(num) || 0;
				}
			}

			var batchItemId = wasteModal.dataset.batchItemId ? Number(wasteModal.dataset.batchItemId) : null;
			var items = [{ productId: pid, quantity: qtyVal, unitPrice: unitPrice > 0 ? unitPrice : 1, batchItemId: batchItemId }];

			
			var ctx = document.querySelector("meta[name='contextPath']")?.content || '';
			var url = ctx + '/admin/inventory-export-create';
			var body = new URLSearchParams();
			var today = new Date();
			var yyyy = today.getFullYear();
			var mm = String(today.getMonth()+1).padStart(2,'0');
			var dd = String(today.getDate()).padStart(2,'0');
			var todayStr = yyyy + '-' + mm + '-' + dd;

			body.append('receipt_date', todayStr);
			body.append('export_type', 'WASTE');
			body.append('note', 'Báo hỏng tự động cho ' + batchCode);
			body.append('waste_reason', 'Báo hỏng lô ' + batchCode);
			body.append('items', JSON.stringify(items));

			footerBtn.disabled = true;
			footerBtn.textContent = 'Đang tạo...';

			fetch(url, {
				method: 'POST',
				headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
				body: body.toString()
			}).then(function (res) { return res.json(); })
			.then(function (data) {
				footerBtn.disabled = false;
				footerBtn.textContent = 'Xác nhận báo hỏng';
					if (data.success) {
						closeModal(wasteModal);
						alert('Tạo phiếu báo hỏng thành công. Số lượng trong lô sẽ được trừ khi phiếu được duyệt.');
				} else {
					alert('Lỗi: ' + (data.message || 'Không xác định'));
				}
			}).catch(function (err) {
				footerBtn.disabled = false;
				footerBtn.textContent = 'Xác nhận báo hỏng';
				alert('Lỗi kết nối: ' + err.message);
			});
		});
	})();

	document.querySelectorAll("[data-close-modal]").forEach(function (btn) {
		btn.addEventListener("click", function () {
			closeModal(wasteModal);
			closeModal(gradeModal);
			closeModal(flashModal);
		});
	});

	[wasteModal, gradeModal, flashModal].forEach(function (modal) {
		modal?.addEventListener("click", function (e) {
			if (e.target === modal) {
				closeModal(modal);
			}
		});
	});
});
