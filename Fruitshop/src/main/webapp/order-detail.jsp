<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi tiết đơn hàng #${order.id} - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-detail.css" />
</head>
<body>
<jsp:include page="header.jsp"></jsp:include>

<div class="breadcrumb">
    <div class="container">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a> &gt;
        <a href="${pageContext.request.contextPath}/profile">Tài khoản</a> &gt;
        <a href="${pageContext.request.contextPath}/orders">Đơn mua</a> &gt;
        <span>Chi tiết đơn hàng #${order.id}</span>
    </div>
</div>

<section class="profile-section">
    <div class="container">
        <div class="profile-container">
            <aside class="profile-sidebar">
                <div class="profile-user-brief">
                    <img src="${sessionScope.account.avatar != null ? sessionScope.account.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}" alt="Avatar" class="brief-avatar" />
                    <div class="brief-info">
                        <span class="brief-name">${sessionScope.account.fullName}</span>
                        <a href="${pageContext.request.contextPath}/profile" class="brief-edit"><i class="fa-solid fa-pen"></i> Sửa hồ sơ</a>
                    </div>
                </div>
                <ul class="profile-menu">
                    <li class="profile-menu-item"><a href="profile"><i class="fa-regular fa-user"></i> Hồ sơ của tôi</a></li>
                    <li class="profile-menu-item active"><a href="orders"><i class="fa-solid fa-box-open"></i> Đơn mua</a></li>
                    <li class="profile-menu-item"><a href="addresses"><i class="fa-solid fa-location-dot"></i> Địa chỉ</a></li>
                    <li class="profile-menu-item"><a href="change-password.jsp"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a></li>
                    <li class="profile-menu-item"><a href="wishlist"><i class="fa-regular fa-heart"></i> Yêu thích</a></li>
                    <li class="profile-menu-item"><a href="logout" style="color: red;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
                </ul>
            </aside>

            <main class="profile-content">
                <div class="order-detail-wrapper">
                    <div class="order-detail-header">
                        <div class="order-info">
                            <h3>Chi tiết đơn hàng #${order.id}</h3>
                            <span style="color: #666; font-size: 14px;">Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                        </div>
                        <div class="order-status status-${order.status}">
                            ${order.statusDisplay}
                        </div>
                    </div>

                    <div class="order-summary-box">
                        <div class="summary-card">
                            <h4>Địa chỉ nhận hàng</h4>
                            <p><strong>${order.fullname}</strong></p>
                            <p>SĐT: ${order.phone}</p>
                            <p>Địa chỉ: ${order.address}</p>
                        </div>
                        <div class="summary-card">
                            <h4>Thông tin thanh toán</h4>
                            <p>Phương thức: <strong>${order.paymentMethodDisplay}</strong></p>
                            <p>Trạng thái: <strong>${order.paymentStatusDisplay}</strong></p>
                            <c:if test="${not empty order.note}">
                                <p>Ghi chú: ${order.note}</p>
                            </c:if>
                        </div>
                    </div>

                    <table class="order-items-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${order.orderDetails}" var="item">
                                <tr>
                                    <td>
                                        <div class="product-info">
                                            <img src="${pageContext.request.contextPath}/${item.product.image}" alt="${item.productName}" class="product-image" onerror="this.src='https://via.placeholder.com/60'" />
                                            <span>${item.productName}</span>
                                        </div>
                                    </td>
                                    <td><fmt:formatNumber value="${item.price}" type="number" groupingUsed="true" />₫</td>
                                    <td>${item.quantity}</td>
                                    <td><fmt:formatNumber value="${item.totalDouble}" type="number" groupingUsed="true" />₫</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="order-totals">
                        <div class="total-row">
                            <span>Tạm tính:</span>
                            <span><fmt:formatNumber value="${order.totalProductsMoney}" type="number" groupingUsed="true" />₫</span>
                        </div>
                        <div class="total-row">
                            <span>Phí vận chuyển:</span>
                            <span><fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true" />₫</span>
                        </div>
                        <c:if test="${order.discountAmount > 0}">
                            <div class="total-row">
                                <span>Giảm giá:</span>
                                <span>-<fmt:formatNumber value="${order.discountAmount}" type="number" groupingUsed="true" />₫</span>
                            </div>
                        </c:if>
                        <div class="total-row final">
                            <span>Tổng cộng:</span>
                            <span><fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true" />₫</span>
                        </div>
                    </div>

                    <div style="margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/orders" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Quay lại đơn mua</a>
                    </div>
                </div>
            </main>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>
