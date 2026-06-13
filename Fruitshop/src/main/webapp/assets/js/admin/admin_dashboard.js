
function switchTab(tabId, title) {
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
    document.getElementById('tab-' + tabId).classList.add('active');
    const activeBtn = document.querySelector('.tab-btn[data-tab="' + tabId + '"]');
    if (activeBtn) activeBtn.classList.add('active');
    document.getElementById('pageTabTitle').textContent = title;

    const input = document.getElementById('activeTabInput');
    if (input) input.value = tabId;
}


window.addEventListener('DOMContentLoaded', () => {
    const savedTab = document.getElementById('activeTabInput')?.value || 'profit';
    const titles = {
        'profit': 'Thống kê lợi nhuận',
        'inventory': 'Thống kê kho',
        'promotion': 'Thống kê khuyến mãi'
    };
    switchTab(savedTab, titles[savedTab] || 'Thống kê lợi nhuận');
});


window.addEventListener('DOMContentLoaded', () => {
    if (typeof dashboardData === 'undefined') return;

    const lineCanvas = document.getElementById('profitLineChart');
    if (lineCanvas) {
        new Chart(lineCanvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: dashboardData.lineLabels,
                datasets: [
                    {
                        label: 'Doanh thu',
                        data: dashboardData.revenueSeries,
                        borderColor: '#2f8087',
                        backgroundColor: 'rgba(47, 128, 135, 0.18)',
                        borderWidth: 2,
                        tension: 0.35,
                        fill: true
                    },
                    {
                        label: 'COGS',
                        data: dashboardData.cogsSeries,
                        borderColor: '#c18a00',
                        backgroundColor: 'rgba(193, 138, 0, 0.16)',
                        borderWidth: 2,
                        tension: 0.35,
                        fill: true
                    },
                    {
                        label: 'Lợi nhuận',
                        data: dashboardData.profitSeries,
                        borderColor: '#2f9955',
                        backgroundColor: 'rgba(47, 153, 85, 0.16)',
                        borderWidth: 2,
                        tension: 0.35,
                        fill: true
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return value.toLocaleString('vi-VN') + ' VND';
                            }
                        }
                    }
                }
            }
        });
    }


    const invCanvas = document.getElementById('inventoryExportChart');
    if (invCanvas) {
        const exportLbls = dashboardData.exportTypeLabels.map(l => l === 'SALES' ? 'Bán hàng' : l === 'WASTE' ? 'Hàng hỏng' : l);
        new Chart(invCanvas.getContext('2d'), {
            type: 'bar',
            data: {
                labels: exportLbls,
                datasets: [{ label: 'Giá trị xuất', data: dashboardData.exportTypeSeries, backgroundColor: ['#2c73d2', '#d04b5b'], borderRadius: 10 }]
            },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { callback: v => v.toLocaleString('vi-VN') + ' VND' } } } }
        });
    }

    const promoStackedCanvas = document.getElementById('promoStackedChart');
    if (promoStackedCanvas) {
        new Chart(promoStackedCanvas.getContext('2d'), {
            type: 'bar',
            data: {
                labels: dashboardData.lineLabels,
                datasets: [
                    { label: 'Weekend Deal', data: dashboardData.wdSeries, backgroundColor: '#c18a00' },
                    { label: 'Sale Price', data: dashboardData.saleSeries, backgroundColor: '#2f8087' }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: { stacked: true },
                    y: { stacked: true, beginAtZero: true, ticks: { callback: v => v.toLocaleString('vi-VN') + ' VND' } }
                }
            }
        });
    }

    const promoDonutCanvas = document.getElementById('promoDonutChart');
    if (promoDonutCanvas) {
        const normalRev = dashboardData.totalRev - dashboardData.wdRev - dashboardData.saleRev;

        new Chart(promoDonutCanvas.getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Weekend Deal', 'Sale Price', 'Giá thường'],
                datasets: [{
                    data: [dashboardData.wdRev, dashboardData.saleRev, normalRev],
                    backgroundColor: ['#c18a00', '#2f8087', '#94a3b8'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: { callbacks: { label: ctx => ctx.label + ': ' + ctx.raw.toLocaleString('vi-VN') + ' VND' } }
                }
            }
        });
    }

    const exportBtn = document.getElementById('exportBtn');
    if (exportBtn) {
        exportBtn.addEventListener('click', () => {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const exportType = document.getElementById('exportType').value;
            const tab = document.getElementById('activeTabInput')?.value || 'profit';

            const url = new URL(window.location.href);
            url.searchParams.set('action', 'export');
            url.searchParams.set('startDate', startDate);
            url.searchParams.set('endDate', endDate);
            url.searchParams.set('exportType', exportType);
            url.searchParams.set('tab', tab);

            window.location.href = url.toString();
        });
    }
});
