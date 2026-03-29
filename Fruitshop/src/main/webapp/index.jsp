<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Trang chủ - Organic Harvest</title>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />

                </head>

                <body>
                    <div class="main">
                        <!-- HEADER -->
                        <jsp:include page="header.jsp"></jsp:include>

                        <!-- SLIDE BANNER -->
                        <div id="slide">
                            <div class="slide-container">
                                <div class="slide-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty banners}">
                                            <c:forEach items="${banners}" var="banner">
                                                <%-- Xác định URL cho banner --%>
                                                    <c:set var="bannerUrl" value="#" />
                                                    <c:if
                                                        test="${not empty banner.linkType and banner.linkType != 'none'}">
                                                        <c:set var="bannerUrl"
                                                            value="${banner.getFullUrl(pageContext.request.contextPath)}" />
                                                    </c:if>
                                                    <c:if test="${empty banner.linkType and not empty banner.link}">
                                                        <c:set var="bannerUrl" value="${banner.link}" />
                                                    </c:if>

                                                    <%-- Toàn bộ slide-item có thể click --%>
                                                        <div class="slide-item"
                                                            onclick="window.location.href='${bannerUrl}'"
                                                            style="cursor: ${bannerUrl != '#' ? 'pointer' : 'default'};">
                                                            <img src="${pageContext.request.contextPath}/${banner.imageUrl}"
                                                                alt="${banner.title}" />
                                                            <div class="slide-caption">
                                                                <h2>${banner.title}</h2>
                                                                <p>${banner.description}</p>
                                                            </div>
                                                        </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="slide-item">
                                                <img src="https://i.pinimg.com/1200x/25/54/15/255415908ab241b565a5dbe42795519f.jpg"
                                                    alt="Fresh Fruit" />
                                                <div class="slide-caption">
                                                    <h2>Trái Cây Nhập Khẩu</h2>
                                                    <p>Những loại trái cây tươi ngon từ khắp nơi trên thế giới</p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <button class="nav-button prev-button" onclick="prevSlide()">&#10094;</button>
                                <button class="nav-button next-button" onclick="nextSlide()">&#10095;</button>

                                <div class="slide-indicators">
                                    <c:choose>
                                        <c:when test="${not empty banners}">
                                            <c:forEach items="${banners}" var="banner" varStatus="status">
                                                <span class="indicator-dot ${status.index == 0 ? 'active' : ''}"
                                                    onclick="goToSlide(${status.index})"></span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="indicator-dot active" onclick="goToSlide(0)"></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        <!-- main -->
                        <section id="main">
                            <section id="content">
                                <section id="top-offers">
                                    <div class="container">
                                        <div class="section-header">
                                            <h2>Sản phẩm mới nhất</h2>
                                            <div class="header-icons">
                                                <button class="home-icon"><i class="fas fa-star"></i></button>
                                            </div>
                                        </div>

                                        <div class="offers-carousel">
                                            <button class="arrow prev" aria-label="Previous products">
                                                <i class="fas fa-chevron-left"></i>
                                            </button>
                                            <button class="arrow next" aria-label="Next products">
                                                <i class="fas fa-chevron-right"></i>
                                            </button>

                                            <div class="carousel-container">
                                                <c:choose>
                                                    <c:when test="${not empty newProducts}">
                                                        <c:forEach items="${newProducts}" var="product">
                                                            <c:set var="weekendDeal"
                                                                value="${weekendDealMap[product.id]}" />
                                                            <div class="product-card">
                                                                <div class="product-image">
                                                                    <a
                                                                        href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${fn:startsWith(product.image, 'http')}">
                                                                                <img src="${product.image}"
                                                                                    alt="${product.name}"
                                                                                    loading="lazy" />
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="${pageContext.request.contextPath}/${product.image}"
                                                                                    alt="${product.name}"
                                                                                    loading="lazy" />
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </a>

                                                                    <%-- Hiển thị badge discount --%>
                                                                        <c:choose>
                                                                            <%-- Ưu tiên 1: Weekend Deal badge --%>
                                                                                <c:when test="${not empty weekendDeal}">
                                                                                    <div class="product-badge sale"
                                                                                        style="background: linear-gradient(135deg, #ff6b6b, #ee5a6f);">
                                                                                        -${weekendDeal.discountPercent}%
                                                                                    </div>
                                                                                    <c:if
                                                                                        test="${not empty weekendDeal.tag}">
                                                                                        <div
                                                                                            style="position: absolute; top: 45px; left: 10px; z-index: 10;">
                                                                                            <span
                                                                                                class="product-tag">${weekendDeal.tag}</span>
                                                                                        </div>
                                                                                    </c:if>
                                                                                </c:when>
                                                                                <%-- Ưu tiên 2: Sale thường badge --%>
                                                                                    <c:when
                                                                                        test="${product.salePrice > 0 && product.salePrice < product.price}">
                                                                                        <div class="product-badge sale">
                                                                                            -
                                                                                            <fmt:formatNumber
                                                                                                value="${(product.price - product.salePrice) / product.price * 100}"
                                                                                                maxFractionDigits="0" />
                                                                                            %
                                                                                        </div>
                                                                                    </c:when>
                                                                        </c:choose>

                                                                        <div class="product-actions">
                                                                            <c:set var="isLiked"
                                                                                value="${likedIds.contains(product.id)}" />
                                                                            <a href="${pageContext.request.contextPath}/wishlist?action=${isLiked ? 'remove' : 'add'}&pid=${product.id}"
                                                                                class="action-btn"
                                                                                title="${isLiked ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}">
                                                                                <i class="${isLiked ? 'fas fa-heart' : 'far fa-heart'}"
                                                                                    style="${isLiked ? 'color: red;' : ''}"></i>
                                                                            </a>
                                                                            <a href="${pageContext.request.contextPath}/product-detail?pid=${product.id}"
                                                                                class="action-btn" title="Xem nhanh">
                                                                                <i class="far fa-eye"></i>
                                                                            </a>
                                                                            <c:choose>
                                                                                <c:when test="${product.quantity == 0}">
                                                                                    <a href="${pageContext.request.contextPath}/product-detail?pid=${product.id}"
                                                                                        class="action-btn"
                                                                                        style="opacity: 0.5; cursor: not-allowed;"
                                                                                        title="Hết hàng">
                                                                                        <i
                                                                                            class="fas fa-shopping-basket"></i>
                                                                                    </a>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <button
                                                                                        class="action-btn add-to-cart-btn"
                                                                                        data-id="${product.id}"
                                                                                        title="Thêm vào giỏ">
                                                                                        <i
                                                                                            class="fas fa-shopping-basket"></i>
                                                                                    </button>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                </div>

                                                                <div class="product-info">
                                                                    <div class="category">Trái cây</div>
                                                                    <h3><a
                                                                            href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">${product.name}</a>
                                                                    </h3>

                                                                    <div class="rating"
                                                                        style="color: #ffc107; font-size: 0.8rem; margin-bottom: 5px;">
                                                                        <i class="fas fa-star"></i>
                                                                        <i class="fas fa-star"></i>
                                                                        <i class="fas fa-star"></i>
                                                                        <i class="fas fa-star"></i>
                                                                        <i class="fas fa-star-half-alt"></i>
                                                                        <span style="color: #999;">(0)</span>
                                                                    </div>

                                                                    <div class="price">
                                                                        <c:choose>
                                                                            <%-- Kiểm tra hết hàng trước --%>
                                                                                <c:when test="${product.quantity == 0}">
                                                                                    <span class="current"
                                                                                        style="color: #999; font-weight: 600;">Hết
                                                                                        hàng</span>
                                                                                </c:when>
                                                                                <%-- Ưu tiên 1: Weekend Deal price --%>
                                                                                    <c:when
                                                                                        test="${not empty weekendDeal}">
                                                                                        <c:set var="weekendPrice"
                                                                                            value="${product.price * (1 - weekendDeal.discountPercent / 100.0)}" />
                                                                                        <span class="current"
                                                                                            style="color: #ff6b6b;">
                                                                                            <fmt:formatNumber
                                                                                                value="${weekendPrice}"
                                                                                                type="number"
                                                                                                groupingUsed="true" />đ
                                                                                        </span>
                                                                                        <span class="original">
                                                                                            <fmt:formatNumber
                                                                                                value="${product.price}"
                                                                                                type="number"
                                                                                                groupingUsed="true" />đ
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <%-- Ưu tiên 2: Sale thường --%>
                                                                                        <c:when
                                                                                            test="${product.salePrice > 0 && product.salePrice < product.price}">
                                                                                            <span class="current">
                                                                                                <fmt:formatNumber
                                                                                                    value="${product.salePrice}"
                                                                                                    type="number"
                                                                                                    groupingUsed="true" />
                                                                                                đ
                                                                                            </span>
                                                                                            <span class="original">
                                                                                                <fmt:formatNumber
                                                                                                    value="${product.price}"
                                                                                                    type="number"
                                                                                                    groupingUsed="true" />
                                                                                                đ
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <%-- Mặc định: Giá gốc --%>
                                                                                            <c:otherwise>
                                                                                                <span class="current">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${product.price}"
                                                                                                        type="number"
                                                                                                        groupingUsed="true" />
                                                                                                    đ
                                                                                                </span>
                                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <c:if test="${product.quantity > 0}">
                                                                            <span class="unit"
                                                                                style="font-size: 12px; color: #666;">/
                                                                                Kg</span>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p style="text-align: center; padding: 20px; width: 100%;">Không
                                                            có sản phẩm nào</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </section>

                                <!-- -------------------------------------------------------------------------- -->

                                <section id="weekend-deals">
                                    <div class="container">
                                        <div class="section-header">
                                            <h2>🔥 Ưu Đãi </h2>
                                            <p class="section-subtitle">Giảm giá đặc biệt - Số lượng có hạn</p>
                                        </div>

                                        <div class="deal-wrapper">
                                            <c:choose>
                                                <c:when test="${not empty weekendDeals}">
                                                    <c:forEach items="${weekendDeals}" var="deal" varStatus="status">
                                                        <div class="deal-card ${status.first ? 'active' : ''}"
                                                            data-index="${status.index}">
                                                            <div class="deal-badge">
                                                                <span class="badge-text">HOT DEAL</span>
                                                                <span
                                                                    class="badge-discount">-${deal.discountPercent}%</span>
                                                            </div>

                                                            <div class="deal-content">
                                                                <div class="deal-info">
                                                                    <span class="deal-category">${deal.subtitle}</span>
                                                                    <h3 class="deal-title">${deal.product.name}</h3>
                                                                    <p class="deal-description">
                                                                        ${deal.product.description}</p>

                                                                    <div class="deal-pricing">
                                                                        <div class="price-box">
                                                                            <span class="sale-price">
                                                                                <fmt:formatNumber
                                                                                    value="${deal.discountedPrice}"
                                                                                    type="number" groupingUsed="true" />
                                                                                đ
                                                                            </span>
                                                                            <c:if test="${deal.product.price > 0}">
                                                                                <span class="original-price">
                                                                                    <fmt:formatNumber
                                                                                        value="${deal.product.price}"
                                                                                        type="number"
                                                                                        groupingUsed="true" />đ
                                                                                </span>
                                                                            </c:if>
                                                                        </div>
                                                                        <span class="price-unit">/Kg</span>
                                                                    </div>

                                                                    <div class="deal-timer"
                                                                        data-end-time="${deal.endDate.time}">
                                                                        <div class="timer-label">⏰ Kết thúc sau:</div>
                                                                        <div class="timer-boxes">
                                                                            <div class="timer-box">
                                                                                <span class="timer-value days">0</span>
                                                                                <span class="timer-unit">Ngày</span>
                                                                            </div>
                                                                            <div class="timer-box">
                                                                                <span class="timer-value hours">0</span>
                                                                                <span class="timer-unit">Giờ</span>
                                                                            </div>
                                                                            <div class="timer-box">
                                                                                <span
                                                                                    class="timer-value minutes">0</span>
                                                                                <span class="timer-unit">Phút</span>
                                                                            </div>
                                                                            <div class="timer-box">
                                                                                <span
                                                                                    class="timer-value seconds">0</span>
                                                                                <span class="timer-unit">Giây</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <a href="${pageContext.request.contextPath}/product-detail?pid=${deal.product.id}"
                                                                        class="deal-button">
                                                                        <span>Mua Ngay</span>
                                                                        <i class="fas fa-arrow-right"></i>
                                                                    </a>
                                                                </div>

                                                                <div class="deal-image">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${fn:startsWith(deal.product.image, 'http')}">
                                                                            <img src="${deal.product.image}"
                                                                                alt="${deal.product.name}" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/${deal.product.image}"
                                                                                alt="${deal.product.name}" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <div class="image-decoration"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>

                                                    <c:if test="${weekendDeals.size() > 1}">
                                                        <button class="deal-nav prev" onclick="prevDeal()"
                                                            aria-label="Previous deal">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </button>
                                                        <button class="deal-nav next" onclick="nextDeal()"
                                                            aria-label="Next deal">
                                                            <i class="fas fa-chevron-right"></i>
                                                        </button>

                                                        <div class="deal-indicators">
                                                            <c:forEach items="${weekendDeals}" var="deal"
                                                                varStatus="status">
                                                                <span class="indicator ${status.first ? 'active' : ''}"
                                                                    onclick="goToDeal(${status.index})"></span>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                </c:when>

                                                <c:otherwise>
                                                    <div class="deal-card active">
                                                        <div class="deal-content">
                                                            <div class="deal-info">
                                                                <span class="deal-category">Ưu đãi cuối tuần</span>
                                                                <h3 class="deal-title">Dừa sáp tươi ngon</h3>
                                                                <p class="deal-description">Thơm ngon mọng nước</p>
                                                                <div class="deal-pricing">
                                                                    <span class="sale-price">10.000đ</span>
                                                                </div>
                                                                <a href="${pageContext.request.contextPath}/shop"
                                                                    class="deal-button">
                                                                    <span>Xem sản phẩm</span>
                                                                    <i class="fas fa-arrow-right"></i>
                                                                </a>
                                                            </div>
                                                            <div class="deal-image">
                                                                <img src="https://botanica.risingbamboo.com/wp-content/uploads/2023/06/bn6-1.png"
                                                                    alt="Deal" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </section>
                                <section id="top-trending">
                                    <div class="container">
                                        <div class="section-header">
                                            <h2>Sản phẩm đề xuất</h2>
                                            <div class="header-icons">
                                                <button class="home-icon"><i class="fas fa-fire"></i></button>
                                            </div>
                                        </div>

                                        <div class="trending-grid">
                                            <c:choose>
                                                <c:when test="${not empty trendingProducts}">
                                                    <c:forEach items="${trendingProducts}" var="product">
                                                        <c:set var="weekendDeal"
                                                            value="${weekendDealMap[product.id]}" />
                                                        <div class="product-card">
                                                            <div class="product-image">
                                                                <a
                                                                    href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${fn:startsWith(product.image, 'http')}">
                                                                            <img src="${product.image}"
                                                                                alt="${product.name}" loading="lazy" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/${product.image}"
                                                                                alt="${product.name}" loading="lazy" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </a>

                                                                <%-- Hiển thị badge discount --%>
                                                                    <c:choose>
                                                                        <%-- Ưu tiên 1: Weekend Deal badge --%>
                                                                            <c:when test="${not empty weekendDeal}">
                                                                                <div class="product-badge sale"
                                                                                    style="background: linear-gradient(135deg, #ff6b6b, #ee5a6f);">
                                                                                    -${weekendDeal.discountPercent}%
                                                                                </div>
                                                                                <c:if
                                                                                    test="${not empty weekendDeal.tag}">
                                                                                    <div
                                                                                        style="position: absolute; top: 45px; left: 10px; z-index: 10;">
                                                                                        <span
                                                                                            class="product-tag">${weekendDeal.tag}</span>
                                                                                    </div>
                                                                                </c:if>
                                                                            </c:when>
                                                                            <%-- Ưu tiên 2: Sale thường badge --%>
                                                                                <c:when
                                                                                    test="${product.salePrice > 0 && product.salePrice < product.price}">
                                                                                    <div class="product-badge sale">-
                                                                                        <fmt:formatNumber
                                                                                            value="${(product.price - product.salePrice) / product.price * 100}"
                                                                                            maxFractionDigits="0" />%
                                                                                    </div>
                                                                                </c:when>
                                                                    </c:choose>

                                                                    <div class="product-actions">
                                                                        <c:set var="isLiked"
                                                                            value="${likedIds.contains(product.id)}" />
                                                                        <a href="${pageContext.request.contextPath}/wishlist?action=${isLiked ? 'remove' : 'add'}&pid=${product.id}"
                                                                            class="action-btn"
                                                                            title="${isLiked ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}">
                                                                            <i class="${isLiked ? 'fas fa-heart' : 'far fa-heart'}"
                                                                                style="${isLiked ? 'color: red;' : ''}"></i>
                                                                        </a>
                                                                        <a href="${pageContext.request.contextPath}/product-detail?pid=${product.id}"
                                                                            class="action-btn" title="Xem nhanh">
                                                                            <i class="far fa-eye"></i>
                                                                        </a>
                                                                        <c:choose>
                                                                            <c:when test="${product.quantity == 0}">
                                                                                <a href="${pageContext.request.contextPath}/product-detail?pid=${product.id}"
                                                                                    class="action-btn"
                                                                                    style="opacity: 0.5; cursor: not-allowed;"
                                                                                    title="Hết hàng">
                                                                                    <i
                                                                                        class="fas fa-shopping-basket"></i>
                                                                                </a>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <button
                                                                                    class="action-btn add-to-cart-btn"
                                                                                    data-id="${product.id}"
                                                                                    title="Thêm vào giỏ">
                                                                                    <i
                                                                                        class="fas fa-shopping-basket"></i>
                                                                                </button>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                            </div>

                                                            <div class="product-info">
                                                                <div class="category">Trái cây</div>
                                                                <h3><a
                                                                        href="${pageContext.request.contextPath}/product-detail?pid=${product.id}">${product.name}</a>
                                                                </h3>

                                                                <div class="rating"
                                                                    style="color: #ffc107; font-size: 0.8rem; margin-bottom: 5px;">
                                                                    <i class="fas fa-star"></i>
                                                                    <i class="fas fa-star"></i>
                                                                    <i class="fas fa-star"></i>
                                                                    <i class="fas fa-star"></i>
                                                                    <i class="fas fa-star-half-alt"></i>
                                                                    <span style="color: #999;">(0)</span>
                                                                </div>

                                                                <div class="price">
                                                                    <c:choose>
                                                                        <%-- Kiểm tra hết hàng trước --%>
                                                                            <c:when test="${product.quantity == 0}">
                                                                                <span class="current"
                                                                                    style="color: #999; font-weight: 600;">Hết
                                                                                    hàng</span>
                                                                            </c:when>
                                                                            <%-- Ưu tiên 1: Weekend Deal price --%>
                                                                                <c:when test="${not empty weekendDeal}">
                                                                                    <c:set var="weekendPrice"
                                                                                        value="${product.price * (1 - weekendDeal.discountPercent / 100.0)}" />
                                                                                    <span class="current"
                                                                                        style="color: #ff6b6b;">
                                                                                        <fmt:formatNumber
                                                                                            value="${weekendPrice}"
                                                                                            type="number"
                                                                                            groupingUsed="true" />đ
                                                                                    </span>
                                                                                    <span class="original">
                                                                                        <fmt:formatNumber
                                                                                            value="${product.price}"
                                                                                            type="number"
                                                                                            groupingUsed="true" />đ
                                                                                    </span>
                                                                                </c:when>
                                                                                <%-- Ưu tiên 2: Sale thường --%>
                                                                                    <c:when
                                                                                        test="${product.salePrice > 0 && product.salePrice < product.price}">
                                                                                        <span class="current">
                                                                                            <fmt:formatNumber
                                                                                                value="${product.salePrice}"
                                                                                                type="number"
                                                                                                groupingUsed="true" />đ
                                                                                        </span>
                                                                                        <span class="original">
                                                                                            <fmt:formatNumber
                                                                                                value="${product.price}"
                                                                                                type="number"
                                                                                                groupingUsed="true" />đ
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <%-- Mặc định: Giá gốc --%>
                                                                                        <c:otherwise>
                                                                                            <span class="current">
                                                                                                <fmt:formatNumber
                                                                                                    value="${product.price}"
                                                                                                    type="number"
                                                                                                    groupingUsed="true" />
                                                                                                đ
                                                                                            </span>
                                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <c:if test="${product.quantity > 0}">
                                                                        <span class="unit"
                                                                            style="font-size: 12px; color: #666;">/
                                                                            Kg</span>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <p style="text-align: center; padding: 20px; grid-column: 1 / -1;">
                                                        Không có sản phẩm nào</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </section>
                            </section>
                        </section>
                        <!-- video -->
                        <section class="hero-video">
                            <video autoplay muted loop class="hero-video__video">
                                <source src="https://botanica.risingbamboo.com/wp-content/uploads/2023/06/Video-HD.mp4"
                                    type="video/mp4" />
                                Your browser does not support the video tag.
                            </video>
                            <div class="hero-video__overlay">
                                <h1>HÀNH TRÌNH TỪ NÔNG TRẠI ĐẾN BÀN ĂN</h1>
                                <p>Tươi ngon – An toàn – Dinh dưỡng mỗi ngày</p>
                                <span>Cam kết chất lượng trong từng sản phẩm</span>
                            </div>
                        </section>
                        <!-- blog -->
                        <section class="blog">
                            <div class="blog__container">
                                <!-- Tiêu đề section -->
                                <span class="blog__subtitle">Tin mới nhất</span>
                                <h2 class="blog__title">Bài viết</h2>

                                <!-- Grid bài viết -->
                                <div class="blog__grid">
                                    <!-- Bài viết 1 -->
                                    <div class="blog__item">
                                        <img src="https://ik.imagekit.io/8tm3umulk/image/s%E1%BA%A3n%20ph%E1%BA%A9m/dua?updatedAt=1762455965231"
                                            alt="Blog 1" class="blog__image" />
                                        <div class="blog__content">
                                            <div class="blog__meta">
                                                <span class="blog__author">Đăng bởi Admin</span>
                                                <span class="blog__date">7/3/2025</span>
                                            </div>
                                            <h3 class="blog__post-title">
                                                12 loại trái cây và rau củ bạn nhất định nên có...
                                            </h3>
                                            <a href="${pageContext.request.contextPath}#" class="blog__link">Xem thêm
                                                →</a>
                                        </div>
                                    </div>

                                    <!-- Bài viết 2 -->
                                    <div class="blog__item">
                                        <img src="https://ik.imagekit.io/8tm3umulk/image/s%E1%BA%A3n%20ph%E1%BA%A9m/dua?updatedAt=1762455965231"
                                            alt="Blog 2" class="blog__image" />
                                        <div class="blog__content">
                                            <div class="blog__meta">
                                                <span class="blog__author">Đăng bởi Admin</span>
                                                <span class="blog__date">29/6/2025</span>
                                            </div>
                                            <h3 class="blog__post-title">
                                                Dinh dưỡng & calo trong nước cam tươi...
                                            </h3>
                                            <a href="${pageContext.request.contextPath}#" class="blog__link">Xem thêm
                                                →</a>
                                        </div>
                                    </div>

                                    <!-- Bài viết 3 -->
                                    <div class="blog__item">
                                        <img src="https://ik.imagekit.io/8tm3umulk/image/s%E1%BA%A3n%20ph%E1%BA%A9m/dua?updatedAt=1762455965231"
                                            alt="Blog 3" class="blog__image" />
                                        <div class="blog__content">
                                            <div class="blog__meta">
                                                <span class="blog__author">Đăng bởi Admin</span>
                                                <span class="blog__date">16/11/2025</span>
                                            </div>
                                            <h3 class="blog__post-title">
                                                Những công thức nấu ăn số lượng lớn giúp bạn...
                                            </h3>
                                            <a href="${pageContext.request.contextPath}#" class="blog__link">Xem thêm
                                                →</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                        <!-- FOOTER -->
                        <jsp:include page="footer.jsp"></jsp:include>

                        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                    </div>
                </body>

                </html>