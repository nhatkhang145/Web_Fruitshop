// Mock functionality - Sau khi co backend se goi API
var approveBtn = document.getElementById("approveBtn");
var rejectBtn = document.getElementById("rejectBtn");

approveBtn?.addEventListener("click", function () {
    if (confirm("Ban co chac chan muon xac nhan xuat kho? He thong se tru ton kho.")) {
        // TODO: Goi API xac nhan xuat
        console.log("Xac nhan xuat kho");
        alert("Chuc nang nay se duoc trien khai o buoc tiep theo");
    }
});

rejectBtn?.addEventListener("click", function () {
    if (confirm("Ban co chac chan muon tu choi phieu xuat?")) {
        // TODO: Goi API tu choi
        console.log("Tu choi phieu xuat");
        alert("Chuc nang nay se duoc trien khai o buoc tiep theo");
    }
});
