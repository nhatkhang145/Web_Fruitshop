document.addEventListener("DOMContentLoaded", function () {
    const table = document.getElementById("receiptTable");
    const emptyState = document.getElementById("emptyState");
    const searchInput = document.getElementById("receiptSearch");
    const fromDateInput = document.getElementById("fromDate");
    const toDateInput = document.getElementById("toDate");
    const resetFiltersBtn = document.getElementById("resetFiltersBtn");
    const openCreateReceiptBtn = document.getElementById("openCreateReceiptBtn");
    const createReceiptModal = document.getElementById("createReceiptModal");
    const detailModal = document.getElementById("receiptDetailModal");
    const openCreateFromDetailBtn = document.getElementById("openCreateFromDetailBtn");
    const detailCode = document.getElementById("detailCode");
    const detailDate = document.getElementById("detailDate");
    const detailSupplier = document.getElementById("detailSupplier");
    const detailCreator = document.getElementById("detailCreator");
    const detailItems = document.getElementById("detailItems");
    const detailValue = document.getElementById("detailValue");
    const detailStatus = document.getElementById("detailStatus");
    const detailNote = document.getElementById("detailNote");
    const detailLines = document.getElementById("detailLines");
    const addLineItemBtn = document.getElementById("addLineItemBtn");

    const modalSelectors = [createReceiptModal, detailModal].filter(Boolean);

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

    function formatCurrency(value) {
        try {
            return Number(value).toLocaleString("vi-VN") + " VND";
        } catch (error) {
            return value + " VND";
        }
    }

    function getTableRows() {
        return table ? Array.from(table.querySelectorAll("tbody tr")) : [];
    }

    function applyFilters() {
        const query = (searchInput?.value || "").trim().toLowerCase();
        const fromDate = fromDateInput?.value || "";
        const toDate = toDateInput?.value || "";
        let visibleCount = 0;

        getTableRows().forEach(function (row) {
            const code = (row.dataset.code || "").toLowerCase();
            const rowDate = row.dataset.date || "";
            const matchQuery = query === "" || code.includes(query);
            const matchFrom = fromDate === "" || rowDate >= fromDate;
            const matchTo = toDate === "" || rowDate <= toDate;
            const visible = matchQuery && matchFrom && matchTo;

            row.classList.toggle("is-hidden", !visible);
            if (visible) visibleCount += 1;
        });

        if (emptyState) {
            emptyState.classList.toggle("is-hidden", visibleCount !== 0);
        }
    }

    function fillReceiptDetail(row) {
        if (!row) return;

        const code = row.dataset.code || "";
        const linesRaw = row.dataset.lines || "";
        const lines = linesRaw.split(";").map(function (item) {
            return item.trim();
        }).filter(Boolean);

        if (detailCode) detailCode.textContent = code;
        if (detailDate) detailDate.textContent = row.cells[1]?.textContent?.trim() || "";
        if (detailSupplier) detailSupplier.textContent = row.dataset.supplier || "";
        if (detailCreator) detailCreator.textContent = row.dataset.creator || "";
        if (detailItems) detailItems.textContent = (row.dataset.totalItems || "0") + " mặt hàng";
        if (detailValue) detailValue.textContent = formatCurrency(row.dataset.totalValue || 0);
        if (detailStatus) detailStatus.textContent = row.dataset.status || "";
        if (detailNote) detailNote.textContent = row.dataset.note || "";

        if (detailLines) {
            detailLines.innerHTML = "";
            if (lines.length === 0) {
                detailLines.innerHTML = '<li><span>Chưa có dòng hàng</span><strong>-</strong></li>';
            } else {
                lines.forEach(function (line) {
                    const parts = line.split(" x");
                    const label = parts[0] || line;
                    const qty = parts[1] ? "x" + parts[1] : "";
                    const li = document.createElement("li");
                    li.innerHTML = '<span>' + label + '</span><strong>' + qty + '</strong>';
                    detailLines.appendChild(li);
                });
            }
        }
    }

    document.querySelectorAll(".js-view-receipt").forEach(function (button) {
        button.addEventListener("click", function () {
            const row = button.closest("tr");
            fillReceiptDetail(row);
            openModal(detailModal);
        });
    });

    openCreateReceiptBtn?.addEventListener("click", function () {
        openModal(createReceiptModal);
    });

    openCreateFromDetailBtn?.addEventListener("click", function () {
        closeModal(detailModal);
        openModal(createReceiptModal);
    });

    addLineItemBtn?.addEventListener("click", function () {
        const card = addLineItemBtn.closest(".line-items-card");
        if (!card) return;

        const row = document.createElement("div");
        row.className = "line-item";
        row.innerHTML = `
            <input type="text" placeholder="Tên sản phẩm" />
            <input type="number" placeholder="0" />
            <input type="number" placeholder="0" />
            <input type="text" placeholder="Tự tính" disabled />
            <button type="button" class="line-remove-btn"><i class='bx bx-trash'></i></button>
        `;
        card.insertBefore(row, addLineItemBtn);

        row.querySelector(".line-remove-btn")?.addEventListener("click", function () {
            row.remove();
        });
    });

    document.querySelectorAll("[data-close-modal]").forEach(function (button) {
        button.addEventListener("click", function () {
            modalSelectors.forEach(closeModal);
        });
    });

    modalSelectors.forEach(function (modal) {
        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                closeModal(modal);
            }
        });
    });

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
});