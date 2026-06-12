<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Yêu thích - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/wishlist.css" />
</head>

<body>
<div class="main">
    <jsp:include page="header.jsp"></jsp:include>

    <div class="breadcrumb">
        <div class="container">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a> &gt;
            <a href="${pageContext.request.contextPath}/profile">Tài khoản</a> &gt; <span>Yêu thích</span>
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
                            <a href="${pageContext.request.contextPath}/profile"><i class="fa-regular fa-user"></i> Hồ sơ của tôi</a>
                        </li>
                        <li class="profile-menu-item">
                            <a href="${pageContext.request.contextPath}/orders"><i class="fa-solid fa-box-open"></i> Đơn mua</a>
                        </li>
                        <li class="profile-menu-item">
                            <a href="${pageContext.request.contextPath}/addresses"><i class="fa-solid fa-location-dot"></i> Địa chỉ</a>
                        </li>
                        <li class="profile-menu-item">
                            <a href="${pageContext.request.contextPath}/change-password.jsp"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                        </li>
                        <li class="profile-menu-item active">
                            <a href="${pageContext.request.contextPath}/wishlist"><i class="fa-regular fa-heart"></i> Yêu thích</a>
                        </li>
                        <li class="profile-menu-item">
                            <a href="${pageContext.request.contextPath}/logout" class="wishlist-logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                        </li>
                    </ul>
                </aside>

                <main class="profile-content">
                    <div class="wishlist-header">
                        <h2><i class="fa-solid fa-heart" style="color: #d0011b; margin-right: 10px;"></i> Danh sách yêu thích (${wishlist.size()})</h2>
                    </div>

                    <c:choose>
                        <c:when test="${empty wishlist}">
                            <div class="wishlist-empty">
                                <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/cart/9bdd8040b334d31946f49e36beaf32db.png" alt="Empty" style="width: 100px; margin-bottom: 20px;">
                                <p style="font-size: 1.4rem; color: #666;">Chưa có sản phẩm nào trong danh sách yêu thích.</p>
                                <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary" style="margin-top: 15px;">Mua sắm ngay</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="wishlist-grid">
                                <c:forEach items="${wishlist}" var="item">
                                    <c:set var="product" value="${item.product}" />
                                    <c:set var="weekendDeal" value="${weekendDeals[product.id]}" />

                                    <div class="wishlist-card ${product.quantity == 0 ? 'disabled' : ''}">
                                        <a href="wishlist?action=remove&pid=${product.id}" class="btn-remove"
                                           onclick="return confirm('Bạn chắc chắn muốn bỏ sản phẩm này?')" title="Xóa khỏi yêu thích">
                                            <i class="fa-solid fa-xmark"></i>
                                        </a>

                                        <div class="wishlist-image">
                                            <a href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">
                                                <img src="${product.image}" alt="${product.name}" />
                                            </a>
                                            <c:choose>
                                                <c:when test="${not empty weekendDeal}">
                                                    <span class="badge-sale">-${weekendDeal.discountPercent}%</span>
                                                    <c:if test="${not empty weekendDeal.tag}">
                                                        <div style="position: absolute; top: 45px; left: 10px; z-index: 10;">
                                                            <span class="product-tag">${weekendDeal.tag}</span>
                                                        </div>
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${product.salePrice > 0}">
                                                    <span class="badge-sale">Sale</span>
                                                </c:when>
                                            </c:choose>
                                            <c:if test="${product.quantity == 0}">
                                                <div class="overlay-out">Hết hàng</div>
                                            </c:if>
                                        </div>

                                        <div class="wishlist-body">
                                            <a class="wishlist-name" href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">
                                                    ${product.name}
                                            </a>
                                            <div class="wishlist-price">
                                                <c:choose>
                                                    <c:when test="${product.quantity == 0}">
                                                        <span class="price-current" style="color: #999;">Hết hàng</span>
                                                    </c:when>
                                                    <c:when test="${not empty weekendDeal}">
                                                        <span class="price-current"><fmt:formatNumber value="${weekendDeal.discountedPrice}" pattern="#,###"/> ₫</span>
                                                        <span class="price-old"><fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫</span>
                                                    </c:when>
                                                    <c:when test="${product.salePrice > 0}">
                                                        <span class="price-current"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/> ₫</span>
                                                        <span class="price-old"><fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price-current"><fmt:formatNumber value="${product.price}" pattern="#,###"/> ₫</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="wishlist-meta">
                                                <c:choose>
                                                    <c:when test="${product.quantity > 0}">
                                                        <span class="in-stock"><i class="fa-solid fa-check"></i> Còn hàng (Tồn: ${product.quantity})</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="out-stock"><i class="fa-solid fa-ban"></i> Hết hàng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="wishlist-actions">
                                                <c:choose>
                                                    <c:when test="${product.quantity > 0}">
                                                        <button class="btn btn-cart wishlist-buy-now-btn" data-id="${product.id}">
                                                            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-cart" style="background: #999; cursor: not-allowed;" disabled>
                                                            <i class="fa-solid fa-ban"></i> Hết hàng
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>

                                                <a class="btn btn-danger" href="${pageContext.request.contextPath}/wishlist?action=remove&pid=${product.id}" onclick="return confirm('Bạn chắc chắn muốn bỏ sản phẩm này khỏi danh sách yêu thích?')">
                                                    <i class="fa-regular fa-trash-can"></i> Xóa khỏi yêu thích
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>
    </section>

    <jsp:include page="footer.jsp"></jsp:include>
</div>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const buyNowBtns = document.querySelectorAll('.wishlist-buy-now-btn');

        buyNowBtns.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const productId = this.getAttribute('data-id');
                const contextPath = '${pageContext.request.contextPath}';

                fetch(contextPath + '/add-to-cart?pid=' + productId + '&quantity=1', {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(response => {
                        window.location.href = contextPath + '/cart.jsp';
                    })
                    .catch(error => {
                        console.error('Lỗi khi thêm vào giỏ:', error);
                        window.location.href = contextPath + '/cart.jsp';
                    });
            });
        });
    });
</script>
</body>
</html>