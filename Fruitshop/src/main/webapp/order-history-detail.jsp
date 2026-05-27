<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Chi tiết đơn hàng #${order.id}</title>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css" />
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/order-history-detail.css" />
                </head>

                <body>
                    <jsp:include page="header.jsp"></jsp:include>

                    <div class="breadcrumb">
                        <div class="container">
                            <a href="${pageContext.request.contextPath}/">Trang chủ</a> &gt;
                            <a href="${pageContext.request.contextPath}/orders">Đơn mua</a> &gt; <span>Chi tiết</span>
                        </div>
                    </div>

                    <section class="profile-section">
                        <div class="container">
                            <div class="profile-container">
                                <aside class="profile-sidebar">
                                    <div class="profile-user-brief">
                                        <img src="${sessionScope.account.avatar != null ? sessionScope.account.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}"
                                            alt="Avatar" class="brief-avatar" />
                                        <div class="brief-info">
                                            <span class="brief-name">${sessionScope.account.fullName}</span>
                                            <a href="${pageContext.request.contextPath}/profile" class="brief-edit">
                                                <i class="fa-solid fa-pen"></i> Sửa hồ sơ
                                            </a>
                                        </div>
                                    </div>
                                    <ul class="profile-menu">
                                        <li class="profile-menu-item">
                                            <a href="${pageContext.request.contextPath}/profile"><i
                                                    class="fa-regular fa-user"></i> Hồ sơ của tôi</a>
                                        </li>
                                        <li class="profile-menu-item active">
                                            <a href="${pageContext.request.contextPath}/orders"><i
                                                    class="fa-solid fa-box-open"></i> Đơn mua</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="${pageContext.request.contextPath}/addresses"><i
                                                    class="fa-solid fa-location-dot"></i> Địa chỉ</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="${pageContext.request.contextPath}/change-password.jsp"><i
                                                    class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="${pageContext.request.contextPath}/wishlist"><i
                                                    class="fa-regular fa-heart"></i> Yêu thích</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="${pageContext.request.contextPath}/logout" class="logout-link"><i
                                                    class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                                        </li>
                                    </ul>
                                </aside>

                                <main class="profile-content">
                                    <div class="order-detail-container">
                                        <div class="order-card">
                                            <div class="order-header">
                                                <div>
                                                    <strong>Mã đơn: #${order.id}</strong>
                                                    <span class="order-header-date">
                                                        <fmt:formatDate value="${order.createdAt}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </span>
                                                </div>
                                                <span class="order-status">${order.statusDisplay}</span>
                                            </div>
                                            <div class="order-grid">
                                                <div>
                                                    <div><strong>Người nhận</strong></div>
                                                    <div>${order.fullname}</div>
                                                    <div>${order.phone}</div>
                                                    <div>${order.address}</div>
                                                </div>
                                                <div>
                                                    <div><strong>Thanh toán</strong></div>
                                                    <div>${order.paymentMethodDisplay}</div>
                                                    <div>${order.paymentStatusDisplay}</div>
                                                </div>
                                                <div>
                                                    <div><strong>Ghi chú</strong></div>
                                                    <div>${not empty order.note ? order.note : 'Không có ghi chú'}</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="order-card order-items">
                                            <h3 class="order-items-title">Sản phẩm</h3>
                                            <table>
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
                                                                        <c:when test="${not empty item.product.image}">
                                                                            <img src="${item.product.image}"
                                                                                alt="${item.productName}" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="https://via.placeholder.com/48x48"
                                                                                alt="${item.productName}" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <div>
                                                                        <div>${item.productName}</div>
                                                                        <div class="item-product-meta">ID:
                                                                            ${item.productId}</div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <fmt:formatNumber value="${item.price}" type="number"
                                                                    groupingUsed="true" /> ₫
                                                            </td>
                                                            <td>x ${item.quantity}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${item.total}" type="number"
                                                                    groupingUsed="true" /> ₫
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="order-card">
                                            <div class="summary-row">
                                                <span>Tạm tính</span>
                                                <span>
                                                    <fmt:formatNumber value="${order.totalProductsMoney}" type="number"
                                                        groupingUsed="true" /> ₫
                                                </span>
                                            </div>
                                            <div class="summary-row">
                                                <span>Vận chuyển</span>
                                                <span>
                                                    <fmt:formatNumber value="${order.shippingFee}" type="number"
                                                        groupingUsed="true" /> ₫
                                                </span>
                                            </div>
                                            <c:if test="${order.discountAmount > 0}">
                                                <div class="summary-row">
                                                    <span>Giảm giá</span>
                                                    <span>-
                                                        <fmt:formatNumber value="${order.discountAmount}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </span>
                                                </div>
                                            </c:if>
                                            <div class="summary-row summary-total">
                                                <span>Tổng cộng</span>
                                                <span class="price">
                                                    <fmt:formatNumber value="${order.finalAmount}" type="number"
                                                        groupingUsed="true" /> ₫
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </main>
                            </div>
                        </div>
                    </section>

                    <jsp:include page="footer.jsp"></jsp:include>
                    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                </body>

                </html>