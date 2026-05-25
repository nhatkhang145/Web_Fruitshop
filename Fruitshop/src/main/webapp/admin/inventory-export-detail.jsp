<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phiếu xuất kho</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-receipt-detail.css">
</head>
<body>
    <div class="detail-page">
        <div class="detail-header">
            <div>
                <h1>Chi tiết phiếu xuất kho</h1>
                <div class="detail-header-code">Mã phiếu: <strong>${receipt.code}</strong></div>
            </div>
            <div class="detail-actions">
                <button class="btn btn-primary" id="approveBtn">
                    <i class='bx bx-check'></i> Xác nhận xuất
                </button>
                <button class="btn btn-danger" id="rejectBtn">
                    <i class='bx bx-x'></i> Từ chối
                </button>
                <a href="${pageContext.request.contextPath}/admin/stock-export.jsp" class="btn btn-secondary">
                    <i class='bx bx-arrow-back'></i> Quay lại
                </a>
            </div>
        </div>

        <div class="detail-content">
            <div class="info-section">
                <h2>Thông tin phiếu</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Mã phiếu</span>
                        <span class="info-value">${receipt.code}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Đơn vị nhận</span>
                        <span class="info-value">${receipt.receiverName}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày xuất</span>
                        <span class="info-value">
                            <fmt:formatDate value="${receipt.exportDate}" pattern="dd/MM/yyyy" />
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Loại xuất</span>
                        <span class="info-value">${receipt.exportType}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái</span>
                        <span class="status-badge status-${fn:toLowerCase(receipt.status)}">${receipt.status}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Tổng giá trị</span>
                        <span class="info-value highlight"><fmt:formatNumber value="${receipt.totalAmount}" groupingUsed="true" pattern="#,##0" /> VND</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ghi chú</span>
                        <span class="info-value">${empty receipt.note ? 'Không có' : receipt.note}</span>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h2>Dòng hàng xuất kho (${itemCount} sản phẩm)</h2>
                <div class="items-table-wrapper">
                    <c:choose>
                        <c:when test="${empty items}">
                            <div class="no-items">
                                <i class='bx bx-inbox'></i>
                                <h3>Không có dòng hàng</h3>
                                <p>Phiếu này chưa có sản phẩm nào</p>
                            </div>
                        </c:when>
                        <c:otherwise>
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
                                    <c:forEach var="item" items="${items}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>${item.productName}</td>
                                            <td class="text-right">${item.quantity}</td>
                                            <td class="text-right"><fmt:formatNumber value="${item.unitPrice}" groupingUsed="true" pattern="#,##0" /> VND</td>
                                            <td class="text-right"><strong><fmt:formatNumber value="${item.totalPrice}" groupingUsed="true" pattern="#,##0" /> VND</strong></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="summary-row">
                    <div class="summary-item">
                        <div class="summary-label">Số dòng</div>
                        <div class="summary-value">${itemCount}</div>
                    </div>
                    <div class="summary-item total">
                        <div class="summary-label">Tổng cộng</div>
                        <div class="summary-value"><fmt:formatNumber value="${receipt.totalAmount}" groupingUsed="true" pattern="#,##0" /> VND</div>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h2>Thông tin khác</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Người tạo</span>
                        <span class="info-value">ID: ${receipt.createdBy}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Ngày tạo</span>
                        <span class="info-value"><fmt:formatDate value="${receipt.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Cập nhật lần cuối</span>
                        <span class="info-value"><fmt:formatDate value="${receipt.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </div>
                </div>

                <div class="timeline">
                    <div class="timeline-item">
                        <div class="timeline-dot">
                            <i class='bx bx-plus'></i>
                        </div>
                        <div>
                            <strong>Tạo phiếu</strong> - Admin (ID: ${receipt.createdBy}) - <fmt:formatDate value="${receipt.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/admin/inventory-export-detail.js"></script>
</body>
</html>
