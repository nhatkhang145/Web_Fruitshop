document.addEventListener("DOMContentLoaded", function () {
    var table = document.getElementById("receiptTable");
    var emptyState = document.getElementById("emptyState");
    var searchInput = document.getElementById("receiptSearch");
    var fromDateInput = document.getElementById("fromDate");
    var toDateInput = document.getElementById("toDate");
    var resetFiltersBtn = document.getElementById("resetFiltersBtn");

    function applyFilters() {
        var query = (searchInput?.value || "").trim().toLowerCase();
        var fromDate = fromDateInput?.value || "";
        var toDate = toDateInput?.value || "";
        var visible = 0;

        (table ? Array.from(table.querySelectorAll("tbody tr")) : []).forEach(function (row) {
            var code = (row.dataset.code || "").toLowerCase();
            var rowDate = row.dataset.date || "";
            var match = (query === "" || code.includes(query))
                && (fromDate === "" || rowDate >= fromDate)
                && (toDate === "" || rowDate <= toDate);
            row.classList.toggle("is-hidden", !match);
            if (match) visible += 1;
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
});
