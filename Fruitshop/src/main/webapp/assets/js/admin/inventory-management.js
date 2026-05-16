document.addEventListener("DOMContentLoaded", function () {

    const table = document.getElementById("receiptTable");
    const emptyState = document.getElementById("emptyState");
    const searchInput = document.getElementById("receiptSearch");
    const fromDateInput = document.getElementById("fromDate");
    const toDateInput = document.getElementById("toDate");
    const resetFiltersBtn = document.getElementById("resetFiltersBtn");
    const openCreateBtn = document.getElementById("openCreateReceiptBtn");
    const createModal = document.getElementById("createReceiptModal");
    const detailModal = document.getElementById("receiptDetailModal");
    const saveReceiptBtn = document.getElementById("saveReceiptBtn");
    const createReceiptForm = document.getElementById("createReceiptForm");
    const createMsg = document.getElementById("createReceiptMsg");
    const receiptCodeInput = document.getElementById("inputReceiptCode");
    const creatorInput = document.getElementById("inputCreator");
    const lineContainer = document.getElementById("lineItemsContainer");
    const addLineBtn = document.getElementById("addLineItemBtn");
    const detailCode = document.getElementById("detailCode");
    const detailDate = document.getElementById("detailDate");
    const detailSupplier = document.getElementById("detailSupplier");
    const detailCreator = document.getElementById("detailCreator");
    const detailItems = document.getElementById("detailItems");
    const detailValue = document.getElementById("detailValue");
    const detailStatus = document.getElementById("detailStatus");
    const detailNote = document.getElementById("detailNote");
    const detailLines = document.getElementById("detailLines");
    const openFromDetailBtn = document.getElementById("openCreateFromDetailBtn");
    const modalList = [createModal, detailModal].filter(Boolean);

    function openModal(m) {
        if (!m) return;
        m.classList.add("show");
        m.setAttribute("aria-hidden", "false");
    }

    function closeModal(m) {
        if (!m) return;
        m.classList.remove("show");
        m.setAttribute("aria-hidden", "true");
    }

    modalList.forEach(function (m) {
        m.addEventListener("click", function (e) {
            if (e.target === m) closeModal(m);
        });
    });
    document.querySelectorAll("[data-close-modal]").forEach(function (btn) {
        btn.addEventListener("click", function () {
            modalList.forEach(closeModal);
        });
    });

    openCreateBtn?.addEventListener("click", function () {
        resetCreateForm();
        openModal(createModal);
    });
    openFromDetailBtn?.addEventListener("click", function () {
        closeModal(detailModal);
        resetCreateForm();
        openModal(createModal);
    });

    function formatCurrency(val) {
        return Number(val).toLocaleString("vi-VN") + " VND";
    }

    function showMsg(text, isError) {
        if (!createMsg) return;
        createMsg.textContent = text;
        createMsg.className = "form-msg " + (isError ? "form-msg--error" : "form-msg--success");
    }

    function resetCreateForm() {
        if (createReceiptForm) createReceiptForm.reset();
        if (createMsg) createMsg.className = "form-msg is-hidden";
        if (creatorInput && creatorInput.dataset.default) {
            creatorInput.value = creatorInput.dataset.default;
        }
        if (lineContainer) {
            const rows = lineContainer.querySelectorAll(".js-line-item");
            rows.forEach(function (r, i) {
                if (i > 0) r.remove();
            });
            if (rows[0]) {
                rows[0].querySelector(".line-product-input").value = "";
                rows[0].querySelector(".line-qty").value = "";
                rows[0].querySelector(".line-price").value = "";
                rows[0].querySelector(".line-total").value = "";
            }
        }
    }

    function cloneFirstLineItem() {
        const first = lineContainer?.querySelector(".js-line-item");
        if (!first) return null;
        const clone = first.cloneNode(true);
        clone.querySelector(".line-product-input").value = "";
        clone.querySelector(".line-qty").value = "";
        clone.querySelector(".line-price").value = "";
        clone.querySelector(".line-total").value = "";
        bindLineItemEvents(clone);
        return clone;
    }

    function bindLineItemEvents(row) {
        const qty = row.querySelector(".line-qty");
        const price = row.querySelector(".line-price");
        const total = row.querySelector(".line-total");
        const del = row.querySelector(".line-remove-btn");

        function calcTotal() {
            const q = parseFloat(qty?.value) || 0;
            const p = parseFloat(price?.value) || 0;
            if (total) total.value = q > 0 && p > 0 ? (q * p).toLocaleString("vi-VN") : "";
        }

        qty?.addEventListener("input", calcTotal);
        price?.addEventListener("input", calcTotal);
        del?.addEventListener("click", function () {
            const allRows = lineContainer.querySelectorAll(".js-line-item");
            if (allRows.length > 1) row.remove();
        });
    }


    lineContainer?.querySelectorAll(".js-line-item").forEach(bindLineItemEvents);

    addLineBtn?.addEventListener("click", function () {
        const clone = cloneFirstLineItem();
        if (clone && lineContainer) lineContainer.appendChild(clone);
    });

    saveReceiptBtn?.addEventListener("click", function () {
        const receiptCode = receiptCodeInput?.value?.trim();
        const supplierIdValue = document.getElementById("inputSupplierId")?.value?.trim();
        const receiptDate = document.getElementById("inputReceiptDate")?.value?.trim();
        const creatorName = creatorInput?.value?.trim();
        const note = document.getElementById("inputNote")?.value?.trim() || "";

        if (!receiptCode) {
            showMsg("Vui lòng nhập mã phiếu nhập.", true);
            return;
        }
        if (!creatorName) {
            showMsg("Vui lòng nhập người lập phiếu.", true);
            return;
        }
        const supplierId = parseInt(supplierIdValue, 10);
        if (!supplierIdValue || Number.isNaN(supplierId)) {
            showMsg("Vui lòng nhập mã nhà cung cấp hợp lệ.", true);
            return;
        }
        if (!receiptDate) {
            showMsg("Vui lòng nhập ngày nhập kho.", true);
            return;
        }
        if (!note) {
            showMsg("Vui lòng nhập ghi chú.", true);
            return;
        }

        // Collect line items
        const lineRows = lineContainer?.querySelectorAll(".js-line-item") || [];
        const items = [];
        let valid = true;

        lineRows.forEach(function (row, idx) {
            const productIdValue = row.querySelector(".line-product-input")?.value?.trim();
            const qty = parseInt(row.querySelector(".line-qty")?.value) || 0;
            const unitPrice = parseFloat(row.querySelector(".line-price")?.value) || 0;
            const productId = parseInt(productIdValue, 10);

            if (!productIdValue || Number.isNaN(productId) || qty <= 0 || unitPrice <= 0) {
                showMsg("Dòng hàng " + (idx + 1) + ": vui lòng nhập mã sản phẩm, số lượng và đơn giá hợp lệ.", true);
                valid = false;
                return;
            }
            items.push({productId: parseInt(productId), quantity: qty, unitPrice: unitPrice});
        });

        if (!valid) return;
        if (items.length === 0) {
            showMsg("Vui lòng thêm ít nhất 1 dòng hàng.", true);
            return;
        }

        saveReceiptBtn.disabled = true;
        saveReceiptBtn.querySelector("span").textContent = "Đang lưu...";

        const ctx = document.querySelector("meta[name='contextPath']")?.content || "";
        const url = ctx + "/admin/inventory-receipt-create";

        const body = new URLSearchParams();
        body.append("receipt_code", receiptCode);
        body.append("creator_name", creatorName);
        body.append("supplier_id", supplierId);
        body.append("receipt_date", receiptDate);
        body.append("note", note);
        body.append("items", JSON.stringify(items.map(function (i) {
            return {productId: i.productId, quantity: i.quantity, unitPrice: i.unitPrice};
        })));

        fetch(url, {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"},
            body: body.toString()
        })
            .then(function (res) {
                return res.json();
            })
            .then(function (data) {
                if (data.success) {
                    showMsg("Tạo phiếu thành công! Mã: " + data.receipt_code, false);
                    setTimeout(function () {
                        closeModal(createModal);
                        location.reload();
                    }, 1200);
                } else {
                    showMsg("Lỗi: " + (data.message || "Không xác định"), true);
                    saveReceiptBtn.disabled = false;
                    saveReceiptBtn.querySelector("span").textContent = "Lưu phiếu nhập";
                }
            })
            .catch(function (err) {
                showMsg("Lỗi kết nối: " + err.message, true);
                saveReceiptBtn.disabled = false;
                saveReceiptBtn.querySelector("span").textContent = "Lưu phiếu nhập";
            });
    });

    function applyFilters() {
        const query = (searchInput?.value || "").trim().toLowerCase();
        const fromDate = fromDateInput?.value || "";
        const toDate = toDateInput?.value || "";
        let visible = 0;

        (table ? Array.from(table.querySelectorAll("tbody tr")) : []).forEach(function (row) {
            const code = (row.dataset.code || "").toLowerCase();
            const rowDate = row.dataset.date || "";
            const match = (query === "" || code.includes(query))
                && (fromDate === "" || rowDate >= fromDate)
                && (toDate === "" || rowDate <= toDate);
            row.classList.toggle("is-hidden", !match);
            if (match) visible++;
        });

        emptyState?.classList.toggle("is-hidden", visible !== 0);
    }

    searchInput?.addEventListener("input", applyFilters);
    fromDateInput?.addEventListener("change", applyFilters);
    toDateInput?.addEventListener("change", applyFilters);
    resetFiltersBtn?.addEventListener("click", function () {
        if (searchInput) searchInput.value = "";
        if (fromDateInput) fromDateInput.value = "";
        if (toDateInput) toDateInput.value = "";
        applyFilters();
    });
    applyFilters();


    document.querySelectorAll(".js-view-receipt").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const row = btn.closest("tr");
            if (!row) return;
            const lines = (row.dataset.lines || "").split(";").map(function (s) {
                return s.trim();
            }).filter(Boolean);

            if (detailCode) detailCode.textContent = row.dataset.code || "";
            if (detailDate) detailDate.textContent = row.cells[1]?.textContent?.trim() || "";
            if (detailSupplier) detailSupplier.textContent = row.dataset.supplier || "";
            if (detailCreator) detailCreator.textContent = row.dataset.creator || "";
            if (detailItems) detailItems.textContent = (row.dataset.totalItems || "0") + " mặt hàng";
            if (detailValue) detailValue.textContent = formatCurrency(row.dataset.totalValue || 0);
            if (detailStatus) detailStatus.textContent = row.dataset.status || "";
            if (detailNote) detailNote.textContent = row.dataset.note || "";

            if (detailLines) {
                detailLines.innerHTML = lines.length === 0
                    ? '<li><span>Chưa có dòng hàng</span><strong>-</strong></li>'
                    : lines.map(function (l) {
                        const p = l.split(" x");
                        return '<li><span>' + (p[0] || l) + '</span><strong>' + (p[1] ? "x" + p[1] : "") + '</strong></li>';
                    }).join("");
            }
            openModal(detailModal);
        });
    });
});