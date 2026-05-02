<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phiếu nhập kho</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css">
    <style>
        .detail-page {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px 0;
        }

        .detail-header {
            background: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .detail-header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 24px;
        }

        .detail-header-code {
            color: #7f8c8d;
            font-size: 14px;
            margin-top: 5px;
        }

        .detail-actions {
            display: flex;
            gap: 10px;
        }

        .detail-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .info-section {
            background: white;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .info-section h2 {
            color: #2c3e50;
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 12px;
            font-weight: 600;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .info-value {
            font-size: 15px;
            color: #2c3e50;
            font-weight: 500;
        }

        .info-value.highlight {
            color: #FF6B35;
            font-size: 18px;
            font-weight: 600;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 12px;
            width: fit-content;
        }

        .status-pending {
            background: #FEF3C7;
            color: #92400E;
        }

        .status-approved {
            background: #D1FAE5;
            color: #065F46;
        }

        .status-rejected {
            background: #FEE2E2;
            color: #7F1D1D;
        }

        .items-table-wrapper {
            overflow-x: auto;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .items-table thead {
            background: #f8f9fa;
        }

        .items-table th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e9ecef;
        }

        .items-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            color: #495057;
        }

        .items-table tbody tr:hover {
            background: #f8f9fa;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .no-items {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }

        .no-items i {
            font-size: 48px;
            color: #e9ecef;
            margin-bottom: 15px;
            display: block;
        }

        .summary-row {
            display: flex;
            justify-content: flex-end;
            gap: 40px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
        }

        .summary-item {
            text-align: right;
        }

        .summary-item.total {
            border-left: 2px solid #e9ecef;
            padding-left: 40px;
        }

        .summary-label {
            font-size: 12px;
            color: #7f8c8d;
            text-transform: uppercase;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .summary-value {
            font-size: 18px;
            color: #2c3e50;
            font-weight: 600;
        }

        .summary-item.total .summary-value {
            color: #FF6B35;
            font-size: 22px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            text-decoration: none;
            font-size: 14px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .btn-primary {
            background: #FF6B35;
            color: white;
        }

        .btn-primary:hover {
            background: #E55A2B;
        }

        .btn-danger {
            background: #EF4444;
            color: white;
        }

        .btn-danger:hover {
            background: #DC2626;
        }

        .btn-secondary {
            background: #e9ecef;
            color: #2c3e50;
        }

        .btn-secondary:hover {
            background: #dee2e6;
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .btn:disabled:hover {
            transform: none;
            box-shadow: none;
        }

        .timeline {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        .timeline-item {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            font-size: 13px;
            color: #7f8c8d;
        }

        .timeline-dot {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .timeline-dot i {
            font-size: 12px;
            color: #7f8c8d;
        }

        @media (max-width: 768px) {
            .detail-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .detail-actions {
                width: 100%;
                justify-content: flex-start;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .items-table {
                font-size: 12px;
            }

            .items-table th,
            .items-table td {
                padding: 10px;
            }

            .summary-row {
                flex-direction: column;
                gap: 15px;
            }

            .summary-item.total {
                border-left: none;
                padding-left: 0;
                border-top: 1px solid #e9ecef;
                padding-top: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="detail-page">
        <div class="detail-header">
            <div>
                <h1>Chi tiết phiếu nhập kho</h1>
                <div class="detail-header-code">Mã phiếu: <strong>RCP-20260502-0001</strong></div>
            </div>
            <div class="detail-actions">
                <button class="btn btn-primary" id="approveBtn">
                    <i class='bx bx-check'></i> Phê duyệt
                </button>
                <button class="btn btn-danger" id="rejectBtn">
                    <i class='bx bx-x'></i> Từ chối
                </button>
                <a href="/Fruitshop_Web/admin/inventory-management" class="btn btn-secondary">
                    <i class='bx bx-arrow-back'></i> Quay lại
                </a>
            </div>
        </div>

        <div class="detail-content">
            <!-- Thông tin phiếu -->
            <div class="info-section">
                <h2>Thông tin phiếu</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Mã phiếu</span>
                        <span class="info-value">RCP-20260502-0001</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Nhà cung cấp</span>
                        <span class="info-value">Công ty Cổ phần Nông sản Việt</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày nhập</span>
                        <span class="info-value">02/05/2026</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái</span>
                        <span class="status-badge status-pending">PENDING</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Tổng giá trị</span>
                        <span class="info-value highlight">1,500,000 VND</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ghi chú</span>
                        <span class="info-value">Nhập hàng định kỳ hàng tháng</span>
                    </div>
                </div>
            </div>

            <!-- Dòng hàng nhập kho -->
            <div class="info-section">
                <h2>Dòng hàng nhập kho (3 sản phẩm)</h2>
                <div class="items-table-wrapper">
                    <table class="items-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên sản phẩm</th>
                                <th class="text-right">Số lượng</th>
                                <th class="text-right">Giá đơn vị</th>
                                <th class="text-right">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Táo đỏ Mỹ</td>
                                <td class="text-right">100</td>
                                <td class="text-right">5,000 VND</td>
                                <td class="text-right"><strong>500,000 VND</strong></td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Cam sành Việt Nam</td>
                                <td class="text-right">150</td>
                                <td class="text-right">4,000 VND</td>
                                <td class="text-right"><strong>600,000 VND</strong></td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Chuối vàng Trung Quốc</td>
                                <td class="text-right">120</td>
                                <td class="text-right">2,500 VND</td>
                                <td class="text-right"><strong>300,000 VND</strong></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="summary-row">
                    <div class="summary-item">
                        <div class="summary-label">Số dòng</div>
                        <div class="summary-value">3</div>
                    </div>
                    <div class="summary-item total">
                        <div class="summary-label">Tổng cộng</div>
                        <div class="summary-value">1,400,000 VND</div>
                    </div>
                </div>
            </div>

            <!-- Thông tin thêm -->
            <div class="info-section">
                <h2>Thông tin khác</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Người tạo</span>
                        <span class="info-value">Admin (ID: 1)</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày tạo</span>
                        <span class="info-value">02/05/2026 14:30</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Cập nhật lần cuối</span>
                        <span class="info-value">02/05/2026 14:30</span>
                    </div>
                </div>

                <!-- Timeline hoạt động -->
                <div class="timeline">
                    <div class="timeline-item">
                        <div class="timeline-dot">
                            <i class='bx bx-plus'></i>
                        </div>
                        <div>
                            <strong>Tạo phiếu</strong> - Admin - 02/05/2026 14:30
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
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
    </script>
</body>
</html>
