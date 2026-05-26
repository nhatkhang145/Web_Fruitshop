// Mock functionality - Sau khi co backend se goi API
var approveBtn = document.getElementById("approveBtn");
var rejectBtn = document.getElementById("rejectBtn");

approveBtn?.addEventListener("click", function () {
    if (confirm("Bạn có chắc chắn muốn xác nhận xuất kho? Hệ thống sẽ trừ tồn kho.")) {
        console.log("Xác nhận xuất kho");
        alert("Chức năng này sẽ được triển khai ở bước tiếp theo");
    }
});

rejectBtn?.addEventListener("click", function () {
    if (confirm("Bạn có chắc chắn muốn từ chối phiếu xuất kho?")) {
        console.log("Từ chối phiếu xuất");
        alert("Chức năng này sẽ được triển khai ở bước tiếp theo");
    }
});
