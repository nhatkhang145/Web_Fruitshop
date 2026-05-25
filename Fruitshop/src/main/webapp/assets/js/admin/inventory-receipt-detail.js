
document.getElementById('approveBtn').addEventListener('click', function() {
    if (confirm('Bạn có chắc chắn muốn phê duyệt phiếu này? Hệ thống sẽ cập nhật tồn kho.')) {
        console.log('Phê duyệt phiếu');
        alert('Chức năng này sẽ được triển khai ở bước tiếp theo');
    }
});

document.getElementById('rejectBtn').addEventListener('click', function() {
    if (confirm('Bạn có chắc chắn muốn từ chối phiếu này?')) {
        console.log('Từ chối phiếu');
        alert('Chức năng này sẽ được triển khai ở bước tiếp theo');
    }
});
