function filterDeals(status) {
    const rows = document.querySelectorAll('.deal-row');
    rows.forEach((row) => {
        row.style.display = (status === 'all' || row.dataset.status === status) ? '' : 'none';
    });
}

function toggleStatus(dealId, currentStatus, contextPath) {
    const actionText = currentStatus === 1 ? 'TẮT' : 'BẬT';
    if (confirm('Bạn có chắc muốn ' + actionText + ' deal này?')) {
        window.location.href = contextPath + '/admin/weekend-deals?action=toggle&id=' + dealId;
    }
}

function deleteDeal(dealId, contextPath) {
    if (confirm('Bạn có chắc muốn XÓA deal này? Hành động này không thể hoàn tác!')) {
        window.location.href = contextPath + '/admin/weekend-deals?action=delete&id=' + dealId;
    }
}

function updateCountdowns() {
    document.querySelectorAll('.countdown').forEach((countdown) => {
        const endTime = parseInt(countdown.dataset.endTime, 10);
        const now = Date.now();
        const remaining = endTime - now;

        if (remaining > 0) {
            const days = Math.floor(remaining / (1000 * 60 * 60 * 24));
            const hours = Math.floor((remaining % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((remaining % (1000 * 60 * 60)) / (1000 * 60));
            const text = countdown.querySelector('.countdown-text');
            if (text) {
                text.textContent = 'Còn ' + days + 'd ' + hours + 'h ' + minutes + 'm';
            }
        } else {
            countdown.innerHTML = '<i class="bx bx-time"></i> Đã hết hạn';
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    const contextPath = document.body.dataset.contextPath || '';

    const filterSelect = document.getElementById('dealStatusFilter');
    if (filterSelect) {
        filterSelect.addEventListener('change', (event) => {
            filterDeals(event.target.value);
        });
    }

    document.querySelectorAll('.btn-toggle').forEach((button) => {
        button.addEventListener('click', () => {
            const dealId = parseInt(button.dataset.dealId, 10);
            const currentStatus = parseInt(button.dataset.currentStatus, 10);
            toggleStatus(dealId, currentStatus, contextPath);
        });
    });

    document.querySelectorAll('.btn-delete').forEach((button) => {
        button.addEventListener('click', () => {
            const dealId = parseInt(button.dataset.dealId, 10);
            deleteDeal(dealId, contextPath);
        });
    });

    updateCountdowns();
    setInterval(updateCountdowns, 60000);
});
