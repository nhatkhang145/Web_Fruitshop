<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/order-detail.css"/>
    <title>Chi tiết Đơn hàng #${order.id}</title>
</head>

<body>

<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="orders"/>
</jsp:include>

<div class="content">

    <jsp:include page="/admin/layout/header.jsp"/>

    <main>
        <div class="header">
            <div class="left">
                <h1 id="pageTitle">Chi tiết Đơn hàng #${order.id}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
                    <li>/</li>
                    <li>
                        <a href="#" class="active" id="breadcrumbTitle">#${order.id}</a>
                    </li>
                </ul>
            </div>
            <a href="#" class="report" id="printInvoiceBtn" onclick="window.print()">
                <i class="bx bx-printer"></i>
                <span>In Hóa đơn</span>
            </a>
        </div>

        <div class="bottom-data">
            <div class="order-detail">
                <form id="orderDetailForm" action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="order-detail__form">
                    <input type="hidden" name="orderId" value="${order.id}">

                    <div class="order-detail__main">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Sản phẩm đã mua</legend>
                            <div class="table-responsive">
                                <table class="order-detail__item-table">
                                    <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Tổng</th>
                                    </tr>
                                    </thead>
                                    <tbody>

                                    <c:forEach items="${order.orderDetails}" var="item">
                                        <tr>
                                            <td>
                                                <div class="item-product">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(item.product.image, 'http')}">
                                                            <img src="${item.product.image}" alt="${item.productName}"
                                                                 onerror="this.src='https://via.placeholder.com/60x60'"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="${pageContext.request.contextPath}/${item.product.image}"
                                                                 alt="${item.productName}"
                                                                 onerror="this.src='https://via.placeholder.com/60x60'"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="item-info">
                                                        <p class="product-name">${item.productName}</p>
                                                        <small class="product-id">Mã SP: #${item.productId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><fmt:formatNumber value="${item.price}" pattern="#,###" /> ₫</td>
                                            <td>x ${item.quantity}</td>
                                            <td class="font-weight-bold text-primary"><fmt:formatNumber value="${item.total}" pattern="#,###" /> ₫</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="order-detail__card mt-4">
                            <legend class="order-detail__legend">
                                <i class='bx bx-message-square-detail'></i> Ghi chú của Khách hàng
                            </legend>
                            <div class="order-detail__customer-note-box">
                                <p class="order-detail__customer-note">
                                    ${not empty order.note ? order.note : "Không có ghi chú nào từ khách hàng."}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="order-detail__sidebar">
                        <div class="order-detail__card highlight-card">
                            <legend class="order-detail__legend">
                                <i class='bx bx-refresh'></i> Cập nhật Trạng thái
                            </legend>
                            <div class="order-detail__group">
                                <select id="orderStatus" name="status" class="order-detail__input custom-select">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Đang xử lý</option>
                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Đang giao hàng</option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                                <button type="submit" class="btn-submit order-detail__save-btn mt-3">
                                    <i class='bx bx-save'></i> Lưu Thay Đổi
                                </button>
                            </div>
                        </div>

                        <div class="order-detail__card mt-4">
                            <legend class="order-detail__legend"><i class='bx bx-user'></i> Thông tin Khách hàng</legend>
                            <div class="order-detail__customer-info">
                                <div class="info-row">
                                    <i class='bx bx-id-card'></i>
                                    <span><strong>${order.fullname}</strong></span>
                                </div>
                                <div class="info-row">
                                    <i class='bx bx-phone'></i>
                                    <span>${order.phone}</span>
                                </div>
                                <hr class="divider"/>
                                <div class="info-row align-items-start">
                                    <i class='bx bx-map mt-1'></i>
                                    <span>
                                        <strong>Địa chỉ Giao hàng:</strong><br/>
                                        <span class="text-muted">${order.address}</span>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="order-detail__card mt-4">
                            <legend class="order-detail__legend"><i class='bx bx-credit-card'></i> Thanh toán & Tài chính</legend>
                            <ul class="order-detail__financials">
                                <li>
                                    <span class="label">Tổng tiền hàng:</span>
                                    <span class="value"><fmt:formatNumber value="${order.totalProductsMoney}" pattern="#,###" /> ₫</span>
                                </li>
                                <li>
                                    <span class="label">Phí vận chuyển:</span>
                                    <span class="value"><fmt:formatNumber value="${order.shippingFee}" pattern="#,###" /> ₫</span>
                                </li>
                                <c:if test="${order.discountAmount > 0}">
                                    <li class="discount">
                                        <span class="label">Giảm giá:</span>
                                        <span class="value">-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> ₫</span>
                                    </li>
                                </c:if>
                                <li class="total">
                                    <strong class="label">Khách phải trả:</strong>
                                    <strong class="value text-primary"><fmt:formatNumber value="${order.finalAmount}" pattern="#,###" /> ₫</strong>
                                </li>
                            </ul>
                            <hr class="divider"/>
                            <div class="payment-info">
                                <p><strong>Phương thức:</strong> <span class="badge badge-light">${order.paymentMethod == 'cod' ? 'Thanh toán COD' : 'VNPay'}</span></p>
                                <p class="mt-2">
                                    <strong>Trạng thái:</strong>
                                    <span class="status-badge ${order.paymentStatus == 1 ? 'status-paid' : 'status-unpaid'}">
                                        <i class='bx ${order.paymentStatus == 1 ? "bx-check-circle" : "bx-time-five"}'></i>
                                        ${order.paymentStatus == 1 ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>

</body>
</html>
