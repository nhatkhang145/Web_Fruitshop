<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Danh sách yêu thích</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/wishlist.css" />
</head>

<body>
    <div class="main">
        <jsp:include page="header.jsp"></jsp:include>

        <div class="app__container" style="padding: 40px 0; background-color: #f5f5f5;">
            <div class="grid wide"> <div class="row sm-gutter app__content">
                    <div class="col l-12 m-12 c-12">

                        <div class="wishlist-header">
                            <h3><i class="fa-solid fa-heart" style="color: #d0011b; margin-right: 10px;"></i> Sản phẩm yêu thích</h3>
                            <span class="wishlist-count">${wishlist.size()} sản phẩm</span>
                        </div>

                        <c:if test="${empty wishlist}">
                            <div style="text-align: center; padding: 60px 0; background: #fff; border-radius: 8px;">
                                <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/cart/9bdd8040b334d31946f49e36beaf32db.png" alt="Empty" style="width: 100px; margin-bottom: 20px;">
                                <p style="font-size: 1.4rem; color: #666;">Chưa có sản phẩm nào trong danh sách yêu thích.</p>
                                <a href="shop" class="btn btn--primary" style="margin-top: 20px; text-decoration: none; display: inline-block; padding: 10px 20px;">Tiếp tục mua sắm</a>
                            </div>
                        </c:if>

                        <c:if test="${not empty wishlist}">
                            <div class="wishlist-grid">
                                <c:forEach items="${wishlist}" var="item">
                                    <div class="wishlist-item ${item.product.quantity == 0 ? 'disabled' : ''}">

                                        <a href="wishlist?action=remove&pid=${item.product.id}"
                                           class="btn-remove"
                                           onclick="return confirm('Bạn chắc chắn muốn bỏ sản phẩm này?')"
                                           title="Xóa khỏi yêu thích">
                                            <i class="fa-solid fa-xmark"></i>
                                        </a>

                                        <div class="wishlist-img">
                                            <a href="product-detail?pid=${item.product.id}">
                                                <img src="${item.product.image}" alt="${item.product.name}">
                                            </a>
                                            <%-- Check weekend deal first --%>
                                            <c:set var="weekendDeal" value="${weekendDeals[item.product.id]}" />
                                            <c:choose>
                                                <c:when test="${not empty weekendDeal}">
                                                    <span class="badge-sale">-${weekendDeal.discountPercent}%</span>
                                                    <c:if test="${not empty weekendDeal.tag}">
                                                        <div style="position: absolute; top: 45px; left: 10px; z-index: 10;">
                                                            <span class="product-tag">${weekendDeal.tag}</span>
                                                        </div>
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${item.product.salePrice > 0}">
                                                    <span class="badge-sale">Sale</span>
                                                </c:when>
                                            </c:choose>
                                            <c:if test="${item.product.quantity == 0}">
                                                <div class="overlay-out">Hết hàng</div>
                                            </c:if>
                                        </div>

                                        <div class="wishlist-info">
                                            <a href="product-detail?pid=${item.product.id}" class="wishlist-name">
                                                ${item.product.name}
                                            </a>

                                            <div class="wishlist-price">
                                                <%-- Priority: Weekend Deal > Sale > Original --%>
                                                <c:choose>
                                                    <c:when test="${item.product.quantity == 0}">
                                                        <span class="new" style="color: #999; font-weight: 600;">Hết hàng</span>
                                                    </c:when>
                                                    <c:when test="${not empty weekendDeal}">
                                                        <span class="new" style="color: #ff6b6b;">
                                                            <fmt:formatNumber value="${weekendDeal.discountedPrice}" pattern="#,###"/>đ
                                                        </span>
                                                        <span class="old">
                                                            <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>đ
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${item.product.salePrice > 0}">
                                                        <span class="new">
                                                            <fmt:formatNumber value="${item.product.salePrice}" pattern="#,###"/>đ
                                                        </span>
                                                        <span class="old">
                                                            <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>đ
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="new">
                                                            <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>đ
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="wishlist-status">
                                                <c:if test="${item.product.quantity > 0}">
                                                    <span class="in-stock"><i class="fa-solid fa-check"></i> Còn hàng</span>
                                                </c:if>
                                                <c:if test="${item.product.quantity == 0}">
                                                    <span class="out-stock"><i class="fa-solid fa-ban"></i> Hết hàng</span>
                                                </c:if>
                                            </div>

                                            <c:choose>
                                                <c:when test="${item.product.quantity > 0}">
                                                    <button class="btn-cart wishlist-buy-now-btn" data-id="${item.product.id}">
                                                        <i class="fa-solid fa-cart-plus"></i> Mua ngay
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-cart" style="background: #999; cursor: not-allowed;" disabled>
                                                        <i class="fa-solid fa-ban"></i> Hết hàng
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                    </div>
                </div>
            </div>
        </div>

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