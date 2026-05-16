// Mock functionality - Sau khi có backend sẽ gọi API
document.getElementById('approveBtn').addEventListener('click', function() {
    if (confirm('Bạn có chắc chắn muốn phê duyệt phiếu này? Hệ thống sẽ cập nhật tồn kho.')) {
        // TODO: Gọi API approve
        console.log('Phê duyệt phiếu');
        alert('Chức năng này sẽ được triển khai ở bước tiếp theo');
    }
});

document.getElementById('rejectBtn').addEventListener('click', function() {
    if (confirm('Bạn có chắc chắn muốn từ chối phiếu này?')) {
        // TODO: Gọi API reject
        console.log('Từ chối phiếu');
        alert('Chức năng này sẽ được triển khai ở bước tiếp theo');
    }
});
