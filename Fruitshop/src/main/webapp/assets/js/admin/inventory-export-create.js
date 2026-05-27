document.addEventListener("DOMContentLoaded", function () {
    const createReceiptForm = document.getElementById("createReceiptForm");
    const createMsg = document.getElementById("createReceiptMsg");
    const receiptCodeInput = document.getElementById("inputReceiptCode");
    const receiptDateInput = document.getElementById("inputReceiptDate");
    const creatorInput = document.getElementById("inputCreator");
    const noteInput = document.getElementById("inputNote");
    const exportTypeSelect = document.getElementById("inputExportType");
    const supplierSelect = document.getElementById("inputSupplierSelect");
    const supplierNameInput = document.getElementById("inputSupplierName");
    const supplierIdInput = document.getElementById("inputSupplierId");
    const addLineBtn = document.getElementById("addLineItemBtn");
    const lineContainer = document.getElementById("lineItemsContainer");
    const saveReceiptBtn = document.getElementById("saveReceiptBtn");
    const resetFormBtn = document.getElementById("resetFormBtn");
    const summaryCode = document.getElementById("summaryCode");
    const summaryDate = document.getElementById("summaryDate");
    const summarySupplier = document.getElementById("summarySupplier");
    const summaryCreator = document.getElementById("summaryCreator");
    const summaryTotal = document.getElementById("summaryTotal");
    const summaryItems = document.getElementById("summaryItems");

    function formatCurrency(val) {
        return Number(val).toLocaleString("vi-VN") + " VND";
    }

    function formatDate(value) {
        if (!value) return "--/--/----";
        const parts = value.split("-");
        if (parts.length !== 3) return value;
        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    function showMsg(text, isError) {
        if (!createMsg) return;
        createMsg.textContent = text;
        createMsg.className = "form-msg " + (isError ? "form-msg--error" : "form-msg--success");
    }

    function getSupplierLabel() {
        const typedName = (supplierNameInput?.value || "").trim();
        if (typedName) return typedName;
        if (supplierSelect && supplierSelect.value) {
            return supplierSelect.selectedOptions[0]?.textContent || "";
        }
        return "Chưa chọn";
    }

    function updateSummary() {
        if (summaryCode) summaryCode.textContent = receiptCodeInput?.value?.trim() || "---";
        if (summaryDate) summaryDate.textContent = formatDate(receiptDateInput?.value || "");
        if (summarySupplier) summarySupplier.textContent = getSupplierLabel();
        if (summaryCreator) summaryCreator.textContent = creatorInput?.value?.trim() || "---";
    }

    function updateTotals() {
        const rows = lineContainer?.querySelectorAll(".js-line-item") || [];
        let totalQty = 0;
        let totalValue = 0;

        rows.forEach(function (row) {
            const qty = parseInt(row.querySelector(".line-qty")?.value, 10) || 0;
            const unitPrice = parseFloat(row.querySelector(".line-price")?.value) || 0;
            totalQty += qty;
            totalValue += qty * unitPrice;
        });

        if (summaryTotal) summaryTotal.textContent = formatCurrency(totalValue);
        if (summaryItems) summaryItems.textContent = totalQty + " mặt hàng";
    }

    function syncSupplierFromSelect() {
        if (!supplierSelect || !supplierIdInput) return;
        const selectedId = supplierSelect.value || "";
        supplierIdInput.value = selectedId;
        if (selectedId && supplierNameInput) supplierNameInput.value = "";
        updateSummary();
    }

    function syncSupplierFromInput() {
        if (!supplierNameInput || !supplierIdInput) return;
        if ((supplierNameInput.value || "").trim().length > 0) {
            supplierIdInput.value = "";
            if (supplierSelect) supplierSelect.value = "";
        }
        updateSummary();
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
            updateTotals();
        }

        qty?.addEventListener("input", calcTotal);
        price?.addEventListener("input", calcTotal);
        row.querySelector(".line-product-select")?.addEventListener("change", updateTotals);
        del?.addEventListener("click", function () {
            const allRows = lineContainer.querySelectorAll(".js-line-item");
            if (allRows.length > 1) row.remove();
            updateTotals();
        });
    }

    function cloneFirstLineItem() {
        const first = lineContainer?.querySelector(".js-line-item");
        if (!first) return null;
        const clone = first.cloneNode(true);
        clone.querySelector(".line-product-select").value = "";
        clone.querySelector(".line-qty").value = "";
        clone.querySelector(".line-price").value = "";
        clone.querySelector(".line-total").value = "";
        bindLineItemEvents(clone);
        return clone;
    }

    function resetCreateForm() {
        if (createReceiptForm) createReceiptForm.reset();
        if (createMsg) createMsg.className = "form-msg is-hidden";
        if (creatorInput && creatorInput.dataset.default) {
            creatorInput.value = creatorInput.dataset.default;
        }
        if (supplierIdInput) supplierIdInput.value = "";
        if (supplierSelect) supplierSelect.value = "";
        if (lineContainer) {
            const rows = lineContainer.querySelectorAll(".js-line-item");
            rows.forEach(function (r, i) {
                if (i > 0) r.remove();
            });
            if (rows[0]) {
                rows[0].querySelector(".line-product-select").value = "";
                rows[0].querySelector(".line-qty").value = "";
                rows[0].querySelector(".line-price").value = "";
                rows[0].querySelector(".line-total").value = "";
            }
        }
        updateSummary();
        updateTotals();
    }

    supplierSelect?.addEventListener("change", syncSupplierFromSelect);
    supplierNameInput?.addEventListener("input", syncSupplierFromInput);
    receiptCodeInput?.addEventListener("input", updateSummary);
    receiptDateInput?.addEventListener("change", updateSummary);
    creatorInput?.addEventListener("input", updateSummary);
    noteInput?.addEventListener("input", updateSummary);

    lineContainer?.querySelectorAll(".js-line-item").forEach(bindLineItemEvents);

    addLineBtn?.addEventListener("click", function () {
        const clone = cloneFirstLineItem();
        if (clone && lineContainer) lineContainer.appendChild(clone);
    });

    resetFormBtn?.addEventListener("click", function () {
        resetCreateForm();
    });

    saveReceiptBtn?.addEventListener("click", function () {
        const receiptCode = receiptCodeInput?.value?.trim();
        const supplierName = supplierNameInput?.value?.trim();
        const supplierIdValue = supplierIdInput?.value?.trim();
        const receiptDate = receiptDateInput?.value?.trim();
        const creatorName = creatorInput?.value?.trim();
        const note = noteInput?.value?.trim() || "";
        const exportType = exportTypeSelect?.value || "SALES";

        if (!receiptCode) {
            showMsg("Vui lòng nhập mã phiếu xuất.", true);
            return;
        }
        if (!creatorName) {
            showMsg("Vui lòng nhập người lập phiếu.", true);
            return;
        }
        if (!supplierName && !supplierIdValue) {
            showMsg("Vui lòng chọn hoặc nhập đơn vị nhận.", true);
            return;
        }
        if (!receiptDate) {
            showMsg("Vui lòng nhập ngày xuất kho.", true);
            return;
        }
        if (!note) {
            showMsg("Vui lòng nhập lý do hoặc ghi chú xuất kho.", true);
            return;
        }

        const lineRows = lineContainer?.querySelectorAll(".js-line-item") || [];
        const items = [];
        let valid = true;

        lineRows.forEach(function (row, idx) {
            const productIdValue = row.querySelector(".line-product-select")?.value?.trim();
            const qty = parseInt(row.querySelector(".line-qty")?.value, 10) || 0;
            const unitPrice = parseFloat(row.querySelector(".line-price")?.value) || 0;
            const productId = parseInt(productIdValue, 10);

            if (!productIdValue || Number.isNaN(productId) || qty <= 0 || unitPrice <= 0) {
                showMsg("Dòng hàng " + (idx + 1) + ": vui lòng chọn mã sản phẩm, số lượng và đơn giá hợp lệ.", true);
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
        const url = ctx + "/admin/inventory-export-create";

        const body = new URLSearchParams();
        body.append("receipt_code", receiptCode);
        body.append("creator_name", creatorName);
        if (supplierIdValue) {
            body.append("supplier_id", supplierIdValue);
        }
        if (supplierName) {
            body.append("supplier_name", supplierName);
        }
        body.append("receipt_date", receiptDate);
        body.append("export_type", exportType);
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
                    showMsg("Tạo phiếu xuất thành công! Mã: " + data.receipt_code, false);
                    setTimeout(function () {
                        window.location.href = ctx + "/admin/stock-export";
                    }, 1200);
                } else {
                    showMsg("Lỗi: " + (data.message || "Không xác định"), true);
                    saveReceiptBtn.disabled = false;
                    saveReceiptBtn.querySelector("span").textContent = "Lưu phiếu xuất";
                }
            })
            .catch(function (err) {
                showMsg("Lỗi kết nối: " + err.message, true);
                saveReceiptBtn.disabled = false;
                saveReceiptBtn.querySelector("span").textContent = "Lưu phiếu xuất";
            });
    });

    updateSummary();
    updateTotals();
});
