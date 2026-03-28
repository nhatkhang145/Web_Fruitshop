(function () {
    function getContextPath() {
        var body = document.body;
        return body ? body.getAttribute("data-context-path") || "" : "";
    }

    window.filterOrders = function (selectObject) {
        var value = selectObject && selectObject.value ? selectObject.value : "all";
        window.location.href = getContextPath() + "/admin/orders?status=" + value;
    };

    $(document).ready(function () {
        var table = $("#ordersTable");
        if (!table.length) {
            return;
        }

        table.DataTable({
            order: [[0, "desc"]],
            pageLength: 10,
            language: {
                search: "Tìm kiếm:",
                lengthMenu: "Hiển thị _MENU_ dòng",
                info: "Trang _PAGE_ / _PAGES_",
                paginate: {
                    first: "«",
                    last: "»",
                    next: ">",
                    previous: "<"
                },
                zeroRecords: "Không tìm thấy đơn hàng nào"
            }
        });
    });
})();
