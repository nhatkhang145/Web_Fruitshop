<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phiếu nhập kho</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@2.1.4/css/boxicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-management.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/inventory-receipt-detail.css">
</head>
<body data-context-path="${pageContext.request.contextPath}" data-receipt-id="${receipt.id}">
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="inventory" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main class="receipt-detail-page">
        <div class="page-hero">
            <div class="hero-copy">
                <p class="eyebrow">Phiếu nhập kho</p>
                <h1>Chi tiết phiếu nhập kho</h1>
                <div class="detail-meta">
                    <span>Mã phiếu: <strong>${receipt.code}</strong></span>
                    <span>Ngày nhập: <strong>${receiptDateDisplay}</strong></span>
                </div>
            </div>
            <div class="hero-actions">
                <c:if test="${fn:toUpperCase(receipt.status) == 'PENDING'}">
                    <button class="btn btn-primary" id="approveBtn">
                        <i class='bx bx-check'></i>
                        <span>Phê duyệt</span>
                    </button>
                    <button class="btn btn-ghost" id="rejectBtn">
                        <i class='bx bx-x'></i>
                        <span>Từ chối</span>
                    </button>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/inventory-management" class="btn btn-ghost">
                    <i class='bx bx-arrow-back'></i>
                    <span>Quay lại</span>
                </a>
            </div>
        </div>

        <section class="panel detail-panel">
            <div class="panel-header">
                <div>
                    <h2>Thông tin phiếu</h2>
                    <p>Tổng hợp thông tin nhà cung cấp, trạng thái và ghi chú phiếu.</p>
                </div>
                <div class="panel-chip">
                    Trạng thái:
                    <span class="status-badge ${fn:toLowerCase(receipt.status)}">${receipt.status}</span>
                </div>
            </div>

            <div class="detail-grid">
                <div class="detail-card">
                    <span class="detail-label">Nhà cung cấp</span>
                    <strong>${receipt.supplierName}</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Người tạo</span>
                    <strong>ID: ${receipt.createdBy}</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Tổng sản phẩm</span>
                    <strong>${itemCount} mặt hàng</strong>
                </div>
                <div class="detail-card highlight">
                    <span class="detail-label">Tổng giá trị</span>
                    <strong><fmt:formatNumber value="${receipt.totalAmount}" groupingUsed="true" pattern="#,##0" /> VND</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Ngày tạo</span>
                    <strong>${createdAtDisplay}</strong>
                </div>
                <div class="detail-card">
                    <span class="detail-label">Cập nhật lần cuối</span>
                    <strong>${updatedAtDisplay}</strong>
                </div>
            </div>

            <div class="detail-note">
                <span>Ghi chú phiếu nhập</span>
                <p>${empty receipt.note ? 'Không có' : receipt.note}</p>
            </div>
        </section>

        <section class="panel detail-lines-panel">
            <div class="panel-header">
                <div>
                    <h2>Danh sách hàng nhập</h2>
                    <p>Danh sách chi tiết mặt hàng trong phiếu (${itemCount} sản phẩm).</p>
                </div>
                <div class="panel-chip">Tổng: <fmt:formatNumber value="${receipt.totalAmount}" groupingUsed="true" pattern="#,##0" /> VND</div>
            </div>

            <c:choose>
                <c:when test="${empty items}">
                    <div class="empty-state">
                        <i class='bx bx-inbox'></i>
                        <h3>Không có dòng hàng</h3>
                        <p>Phiếu này chưa có sản phẩm nào.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="receipt-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th>Giá đơn vị</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${items}" varStatus="status">
                                    <tr>
                                        <td>${status.index + 1}</td>
                                        <td>${item.productName}</td>
                                        <td>${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.unitPrice}" groupingUsed="true" pattern="#,##0" /> VND</td>
                                        <td><strong><fmt:formatNumber value="${item.totalPrice}" groupingUsed="true" pattern="#,##0" /> VND</strong></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <section class="panel detail-extra-panel">
            <div class="panel-header">
                <div>
                    <h2>Thông tin khác</h2>
                    <p>Lịch sử thao tác và thông tin bổ sung.</p>
                </div>
            </div>

            <div class="detail-lines">
                <div class="detail-lines__header detail-lines__header--split">
                    <div class="detail-lines__heading">
                        <h3>Nhật ký phiếu</h3>
                        <span>Tổng hợp sự kiện quan trọng</span>
                    </div>
                </div>
                <ul>
                    <li>
                        <span>Tạo phiếu</span>
                        <strong>Admin (ID: ${receipt.createdBy}) - ${createdAtDisplay}</strong>
                    </li>
                </ul>
            </div>
        </section>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/inventory-receipt-detail.js"></script>
</body>
</html>
