<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Chi tiết đơn hàng #${order.id} - Organic Harvest</title>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
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
                                    <img src="${sessionScope.account.avatar != null ? sessionScope.account.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}"
                                        alt="Avatar" class="brief-avatar" id="briefAvatar" />
                                    <div class="brief-info">
                                        <span class="brief-name">${sessionScope.account.fullName}</span>
                                        <a href="${pageContext.request.contextPath}/profile" class="brief-edit"><i
                                                class="fa-solid fa-pen"></i> Sửa hồ sơ</a>
                                    </div>
                                </div>

                                <ul class="profile-menu">
                                    <li class="profile-menu-item ">
                                        <a href="profile"><i class="fa-regular fa-user"></i> Hồ sơ của tôi</a>
                                    </li>
                                    <li class="profile-menu-item active">
                                        <a href="orders"><i class="fa-solid fa-box-open"></i> Đơn mua</a>
                                    </li>
                                    <li class="profile-menu-item">
                                        <a href="addresses"><i class="fa-solid fa-location-dot"></i> Địa chỉ</a>
                                    </li>
                                    <li class="profile-menu-item ">
                                        <a href="change-password.jsp"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                                    </li>
                                    <li class="profile-menu-item">
                                        <a href="wishlist"><i class="fa-regular fa-heart"></i> Yêu thích</a>
                                    </li>
                                    <li class="profile-menu-item">
                                        <a href="logout" style="color: red;"><i
                                                class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                                    </li>
                                </ul>
                            </aside>

                            <main class="profile-content order-detail-content">
                                <div class="order-detail-header">
                                    <div class="order-detail-title">
                                        <h2>Chi tiết đơn hàng #${order.id}</h2>
                                        <span class="order-date">
                                            Đặt lúc:
                                            <fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy" />
                                        </span>
                                    </div>
                                    <div class="order-status-badge status-${order.status}">
                                        ${order.statusDisplay}
                                    </div>
                                </div>

                                <div class="order-info-grid">
                                    <div class="info-card">
                                        <h3>Địa chỉ nhận hàng</h3>
                                        <div class="info-item">
                                            <div class="icon"><i class="fa-solid fa-user"></i></div>
                                            <div class="text">
                                                <strong>${order.fullname}</strong>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="icon"><i class="fa-solid fa-phone"></i></div>
                                            <div class="text">
                                                <span>${order.phone}</span>
                                            </div>
                                        </div>
                                        <div class="info-item">
                                            <div class="icon"><i class="fa-solid fa-location-dot"></i></div>
                                            <div class="text">
                                                <span>${order.address}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="info-card">
                                        <h3>Hình thức thanh toán & Ghi chú</h3>
                                        <div class="info-item">
                                            <div class="icon"><i class="fa-regular fa-credit-card"></i></div>
                                            <div class="text">
                                                <strong>${order.paymentMethod == 'cod' ? 'Thanh toán khi nhận hàng
                                                    (COD)' : 'Thanh toán VNPay'}</strong>
                                                <span>Trạng thái: ${order.paymentStatus == 1 ? 'Đã thanh toán' : 'Chưa
                                                    thanh toán'}</span>
                                            </div>
                                        </div>
                                        <c:if test="${not empty order.note}">
                                            <div class="info-item" style="margin-top: 15px;">
                                                <div class="icon"><i class="fa-regular fa-clipboard"></i></div>
                                                <div class="text">
                                                    <strong>Ghi chú:</strong>
                                                    <span>${order.note}</span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="order-items-section">
                                    <div class="items-header">Sản phẩm đã mua</div>
                                    <div class="item-list">
                                        <c:forEach items="${order.orderDetails}" var="item">
                                            <div class="item-row">
                                                <a
                                                    href="${pageContext.request.contextPath}/product-detail?pid=${item.productId}">
                                                    <img src="${item.product.image}" alt="${item.productName}"
                                                        class="item-image"
                                                        onerror="this.src='https://via.placeholder.com/80'" />
                                                </a>
                                                <div class="item-details">
                                                    <a href="${pageContext.request.contextPath}/product-detail?pid=${item.productId}"
                                                        class="item-name">
                                                        ${item.productName}
                                                    </a>
                                                </div>
                                                <div class="item-price-qty">
                                                    <div class="item-price">
                                                        <fmt:formatNumber value="${item.price}" type="number"
                                                            groupingUsed="true" />₫
                                                    </div>
                                                    <div class="item-qty">x${item.quantity}</div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="order-summary-section">
                                    <div class="summary-row">
                                        <span>Tạm tính</span>
                                        <span>
                                            <fmt:formatNumber value="${order.totalProductsMoney}" type="number"
                                                groupingUsed="true" />₫
                                        </span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Phí vận chuyển</span>
                                        <span>
                                            <fmt:formatNumber value="${order.shippingFee}" type="number"
                                                groupingUsed="true" />₫
                                        </span>
                                    </div>
                                    <c:set var="totalDiscount"
                                        value="${(order.totalProductsMoney + order.shippingFee) - order.finalAmount}" />
                                    <c:if test="${totalDiscount > 0}">
                                        <div class="summary-row" style="color: #ee4d2d;">
                                            <span>Khuyến mãi giảm</span>
                                            <span>-
                                                <fmt:formatNumber value="${totalDiscount}" type="number"
                                                    groupingUsed="true" />₫
                                            </span>
                                        </div>
                                    </c:if>

                                    <div class="summary-row total">
                                        <span>Tổng cộng</span>
                                        <span class="value">
                                            <fmt:formatNumber value="${order.finalAmount}" type="number"
                                                groupingUsed="true" />₫
                                        </span>
                                    </div>
                                </div>

                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline"
                                       style="padding: 8px 20px; border: 1px solid var(--primary-color); color: var(--primary-color); border-radius: 5px; text-decoration: none;">
                                        Quay lại
                                    </a>

                                    <c:if test="${order.status == 'pending'}">
                                        <form action="${pageContext.request.contextPath}/orders" method="post"
                                            style="display: inline;"
                                            onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                                            <input type="hidden" name="action" value="cancel" />
                                            <input type="hidden" name="orderId" value="${order.id}" />
                                            <button type="submit" class="btn btn-danger"
                                                style="padding: 8px 20px; background: #dc3545; color: #fff; border: none; border-radius: 5px; cursor: pointer;">Hủy
                                                đơn hàng</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.status == 'completed' || order.status == 'cancelled'}">
                                        <form action="${pageContext.request.contextPath}/repurchase" method="POST"
                                            style="display: inline;">
                                            <input type="hidden" name="orderId" value="${order.id}" />
                                            <button type="submit" class="btn btn-primary"
                                                style="padding: 8px 20px; background: var(--primary-color); color: #fff; border: none; border-radius: 5px; cursor: pointer;">Mua lại</button>
                                        </form>
                                    </c:if>
                                </div>

                            </main>
                        </div>
                    </div>
                </section>

                <jsp:include page="footer.jsp"></jsp:include>
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
            </body>

            </html>