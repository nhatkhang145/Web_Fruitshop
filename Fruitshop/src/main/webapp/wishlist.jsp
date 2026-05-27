<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Yêu thích - Organic Harvest</title>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/wishlist.css" />
            </head>

            <body>
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
                                        <a href="${pageContext.request.contextPath}/profile"><i
                                                class="fa-regular fa-user"></i> Hồ sơ của tôi</a>
                                    </li>
                                    <li class="profile-menu-item">
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
                                    <li class="profile-menu-item active">
                                        <a href="${pageContext.request.contextPath}/wishlist"><i
                                                class="fa-regular fa-heart"></i> Yêu thích</a>
                                    </li>
                                    <li class="profile-menu-item">
                                        <a href="${pageContext.request.contextPath}/logout" class="wishlist-logout"><i
                                                class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                                    </li>
                                </ul>
                            </aside>

                            <main class="profile-content">
                                <div class="wishlist-header">
                                    <h2>Danh sách yêu thích</h2>
                                </div>

                                <c:choose>
                                    <c:when test="${empty wishlist}">
                                        <div class="wishlist-empty">
                                            <i class="fa-regular fa-heart"></i>
                                            <p>Chưa có sản phẩm nào trong danh sách yêu thích</p>
                                            <a href="${pageContext.request.contextPath}/shop"
                                                class="btn btn-primary">Mua sắm ngay</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="wishlist-grid">
                                            <c:forEach items="${wishlist}" var="item">
                                                <c:set var="product" value="${item.product}" />
                                                <c:set var="weekendDeal" value="${weekendDeals[product.id]}" />
                                                <div class="wishlist-card">
                                                    <a class="wishlist-image"
                                                        href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">
                                                        <img src="${product.image}" alt="${product.name}" />
                                                    </a>
                                                    <div class="wishlist-body">
                                                        <a class="wishlist-name"
                                                            href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">
                                                            ${product.name}
                                                        </a>
                                                        <div class="wishlist-price">
                                                            <c:choose>
                                                                <c:when test="${not empty weekendDeal}">
                                                                    <span class="price-current">
                                                                        <fmt:formatNumber
                                                                            value="${weekendDeal.discountedPrice}"
                                                                            type="number" groupingUsed="true" /> ₫
                                                                    </span>
                                                                    <span class="price-old">
                                                                        <fmt:formatNumber value="${product.price}"
                                                                            type="number" groupingUsed="true" /> ₫
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${product.salePrice > 0}">
                                                                    <span class="price-current">
                                                                        <fmt:formatNumber value="${product.salePrice}"
                                                                            type="number" groupingUsed="true" /> ₫
                                                                    </span>
                                                                    <span class="price-old">
                                                                        <fmt:formatNumber value="${product.price}"
                                                                            type="number" groupingUsed="true" /> ₫
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="price-current">
                                                                        <fmt:formatNumber value="${product.price}"
                                                                            type="number" groupingUsed="true" /> ₫
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="wishlist-meta">
                                                            <span>Tồn kho: ${product.quantity}</span>
                                                        </div>
                                                        <div class="wishlist-actions">
                                                            <a class="btn btn-outline"
                                                                href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">Xem
                                                                sản phẩm</a>
                                                            <a class="btn btn-danger"
                                                                href="${pageContext.request.contextPath}/wishlist?action=remove&pid=${product.id}">Bỏ
                                                                thích</a>
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
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
            </body>

            </html>