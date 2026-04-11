<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Danh Mục Trái Cây</title>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/shop.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pagination.css" />
            </head>

            <body>
                <div class="main">
                    <!-- HEADER -->
                    <jsp:include page="header.jsp"></jsp:include>
                    <!-- CONTAINER -->
                    <!-- page title -->
                    <div class="breadcrumb">
                        <div class="grid">
                            <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
                            <i class="fa-solid fa-angle-right"></i>
                            <span>Sản phẩm</span>
                        </div>
                    </div>
                    <!--  -->
                    <div class="app__container">
                        <div class="grid">
                            <div class="grid__row app__content">
                                <!-- CỘT 2 -->
                                <div class="grid__column-2">
                                    <nav class="category">
                                        <h3 class="category_heading">
                                            <i class="category__heading-icon fas fa-list"></i>
                                            Danh Mục
                                        </h3>

                                        <ul class="category-list">
                                            <c:forEach items="${listC}" var="c">
                                                <c:if test="${c.parentId == 0}">
                                                    <li class="category-item">
                                                        <!-- Kiểm tra xem có danh mục con nào được chọn không -->
                                                        <c:set var="isChildSelected" value="false" />
                                                        <c:forEach items="${listC}" var="sub">
                                                            <c:if test="${sub.parentId == c.id && tag == sub.id}">
                                                                <c:set var="isChildSelected" value="true" />
                                                            </c:if>
                                                        </c:forEach>

                                                        <details class="category-details" ${tag==c.id || isChildSelected
                                                            ? 'open' : '' } ontoggle="toggleCategoryIcon(this)">
                                                            <summary class="category-summary">
                                                                <span class="category-toggle">${tag == c.id ||
                                                                    isChildSelected ? '-' : '+'}</span>
                                                                <a href="shop?cid=${c.id}&price=${priceTag}&sort=${sortTag}"
                                                                    style="${tag == c.id ? 'color: var(--primary-color); font-weight: bold; text-decoration: none;' : 'text-decoration: none; color: inherit;'}">
                                                                    ${c.name}
                                                                </a>
                                                            </summary>
                                                            <ul class="subcategory-list">
                                                                <c:forEach items="${listC}" var="sub">
                                                                    <c:if test="${sub.parentId == c.id}">
                                                                        <li>
                                                                            <a href="shop?cid=${sub.id}&price=${priceTag}&sort=${sortTag}"
                                                                                style="${tag == sub.id ? 'color: var(--primary-color); font-weight: bold;' : ''}">
                                                                                ${sub.name}
                                                                            </a>
                                                                        </li>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </ul>
                                                        </details>
                                                    </li>
                                                </c:if>
                                            </c:forEach>
                                        </ul>
                                    </nav>

                                    <!-- BỘ LỌC -->
                                    <nav class="filter">
                                        <h3 class="category_heading">
                                            <i class="fa-solid fa-filter"></i>
                                            Bộ Lọc Tìm Kiếm
                                        </h3>
                                        <ul class="category-list filter-list">
                                            <li class="category-item">
                                                <details open>
                                                    <summary class="filter-summary">Mức giá</summary>
                                                    <ul class="filter-price-list">
                                                        <li><a href="shop?cid=${cid}&price=0-200000&sort=${sortTag}"
                                                                class="filter-link ${priceTag == '0-200000' ? 'active' : ''}">Dưới
                                                                200.000đ</a></li>
                                                        <li><a href="shop?cid=${cid}&price=200000-500000&sort=${sortTag}"
                                                                class="filter-link ${priceTag == '200000-500000' ? 'active' : ''}">200.000đ
                                                                -
                                                                500.000đ</a></li>
                                                        <li><a href="shop?cid=${cid}&price=500000-1000000&sort=${sortTag}"
                                                                class="filter-link ${priceTag == '500000-1000000' ? 'active' : ''}">500.000đ
                                                                -
                                                                1.000.000đ</a></li>
                                                        <li><a href="shop?cid=${cid}&price=1000000-max&sort=${sortTag}"
                                                                class="filter-link ${priceTag == '1000000-max' ? 'active' : ''}">Trên
                                                                1.000.000đ</a>
                                                        </li>
                                                        <li class="clear-filter">
                                                            <a href="shop?cid=${cid}&sort=${sortTag}"
                                                                class="clear-filter-btn">
                                                                <i class="fa-solid fa-xmark"></i> Xóa lọc giá
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </details>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                                <!-- KẾT THÚC CỘT 2 -->

                                <!-- CỘT 10 -->
                                <div class="grid__column-10">
                                    <!-- Hiển thị thông báo tìm kiếm -->
                                    <c:if test="${isSearch}">
                                        <div
                                            style="padding: 15px; background: #f8f9fa; border-left: 4px solid #28a745; margin-bottom: 20px;">
                                            <strong>Kết quả tìm kiếm:</strong> "<em>${searchKeyword}</em>" - Tìm thấy
                                            <strong>${listP.size()}</strong> sản phẩm
                                        </div>
                                    </c:if>

                                    <div class="sort-filter"
                                        style="display: flex; justify-content: space-between; align-items: center; padding: 12px 22px; border-radius: 2px; background-color: rgba(0, 0, 0, 0.03);">
                                        <div style="display: flex; align-items: center;">
                                            <span class="sort-filter__label" style="margin-right: 15px;">Sắp xếp
                                                theo:</span>

                                            <form action="shop" method="get" id="sortForm">

                                                <c:if test="${not empty param.cid}">
                                                    <input type="hidden" name="cid" value="${param.cid}">
                                                </c:if>
                                                <c:if test="${not empty param.q}">
                                                    <input type="hidden" name="q" value="${param.q}">
                                                </c:if>
                                                <c:if test="${not empty priceTag}">
                                                    <input type="hidden" name="price" value="${priceTag}">
                                                </c:if>

                                                <select name="sort" onchange="this.form.submit()"
                                                    style="height: 34px; padding: 0 12px; border-radius: 2px; border: 1px solid rgba(0,0,0,0.1); background-color: #fff; min-width: 200px; cursor: pointer;">

                                                    <option value="new" ${sortTag=='new' ? 'selected' : '' }>Mới nhất
                                                    </option>
                                                    <option value="best_sell" ${sortTag=='best_sell' ? 'selected' : ''
                                                        }>Bán chạy nhất</option>
                                                    <option value="popular" ${sortTag=='popular' ? 'selected' : '' }>Phổ
                                                        biến (Lượt xem)</option>
                                                    <option value="price_asc" ${sortTag=='price_asc' ? 'selected' : ''
                                                        }>Giá: Thấp đến Cao
                                                    </option>
                                                    <option value="price_desc" ${sortTag=='price_desc' ? 'selected' : ''
                                                        }>Giá: Cao đến Thấp
                                                    </option>
                                                    <option value="old" ${sortTag=='old' ? 'selected' : '' }>Cũ nhất
                                                    </option>

                                                </select>
                                            </form>
                                        </div>

                                        <div class="sort-filter__page">
                                            <span class="sort-filter__page-current"
                                                style="color: var(--primary-color)">${tag != null ? tag :
                                                1}</span>
                                            <span class="sort-filter__page-total">/${endP}</span>
                                        </div>
                                    </div>

                                    <!-- Product item -->
                                    <div class="home-product">
                                        <div class="grid__row">
                                            <c:forEach items="${listP}" var="p">
                                                <c:set var="weekendDeal" value="${weekendDealMap[p.id]}" />
                                                <div class="grid__column-2-4">
                                                    <div class="product-card"
                                                        data-href="${pageContext.request.contextPath}/product-detail?pid=${p.id}">
                                                        <div class="product-image">
                                                            <a
                                                                href="${pageContext.request.contextPath}/product-detail?pid=${p.id}">
                                                                <img src="${p.image}" alt="${p.name}" loading="lazy" />
                                                            </a>

                                                            <%-- Hiển thị badge discount --%>
                                                                <c:choose>
                                                                    <%-- Ưu tiên 1: Weekend Deal badge --%>
                                                                        <c:when test="${not empty weekendDeal}">
                                                                            <div class="product-badge sale"
                                                                                style="background: linear-gradient(135deg, #ff6b6b, #ee5a6f);">
                                                                                -${weekendDeal.discountPercent}%</div>
                                                                            <c:if test="${not empty weekendDeal.tag}">
                                                                                <div
                                                                                    style="position: absolute; top: 45px; left: 10px; z-index: 10;">
                                                                                    <span
                                                                                        class="product-tag">${weekendDeal.tag}</span>
                                                                                </div>
                                                                            </c:if>
                                                                        </c:when>
                                                                        <%-- Ưu tiên 2: Sale thường badge --%>
                                                                            <c:when
                                                                                test="${p.salePrice > 0 && p.salePrice < p.price}">
                                                                                <div class="product-badge sale">-
                                                                                    <fmt:formatNumber
                                                                                        value="${(p.price - p.salePrice) / p.price * 100}"
                                                                                        maxFractionDigits="0" />%
                                                                                </div>
                                                                            </c:when>
                                                                </c:choose>

                                                                <div class="product-actions">
                                                                    <c:set var="isLiked"
                                                                        value="${likedIds.contains(p.id)}" />

                                                                    <a href="wishlist?action=${isLiked ? 'remove' : 'add'}&pid=${p.id}"
                                                                        class="action-btn"
                                                                        title="${isLiked ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}">

                                                                        <i class="${isLiked ? 'fas fa-heart' : 'far fa-heart'}"
                                                                            style="${isLiked ? 'color: red;' : ''}"></i>
                                                                    </a>

                                                                    <a href="${pageContext.request.contextPath}/product-detail?pid=${p.id}"
                                                                        class="action-btn" title="Xem nhanh">
                                                                        <i class="far fa-eye"></i>
                                                                    </a>

                                                                    <c:choose>
                                                                        <c:when test="${p.quantity == 0}">
                                                                            <a href="${pageContext.request.contextPath}/product-detail?pid=${p.id}"
                                                                                class="action-btn"
                                                                                style="opacity: 0.5; cursor: not-allowed;"
                                                                                title="Hết hàng">
                                                                                <i class="fas fa-shopping-basket"></i>
                                                                            </a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button class="action-btn add-to-cart-btn"
                                                                                data-id="${p.id}" title="Thêm vào giỏ">
                                                                                <i class="fas fa-shopping-basket"></i>
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                        </div>

                                                        <div class="product-info">
                                                            <div class="category">Trái cây nhập khẩu</div>

                                                            <h3>
                                                                <a href="${pageContext.request.contextPath}/product-detail?pid=${p.id}"
                                                                    title="${p.name}">${p.name}</a>
                                                            </h3>

                                                            <div class="rating"
                                                                style="color: #ffc107; font-size: 0.8rem; margin-bottom: 5px;">
                                                                <i class="fas fa-star"></i>
                                                                <i class="fas fa-star"></i>
                                                                <i class="fas fa-star"></i>
                                                                <i class="fas fa-star"></i>
                                                                <i class="fas fa-star-half-alt"></i>
                                                                <span style="color: #999;">(15)</span>
                                                            </div>

                                                            <div class="price">
                                                                <c:choose>
                                                                    <%-- Kiểm tra hết hàng trước --%>
                                                                        <c:when test="${p.quantity == 0}">
                                                                            <span class="current"
                                                                                style="color: #999; font-weight: 600;">Hết
                                                                                hàng</span>
                                                                        </c:when>
                                                                        <%-- Ưu tiên 1: Weekend Deal price --%>
                                                                            <c:when test="${not empty weekendDeal}">
                                                                                <c:set var="weekendPrice"
                                                                                    value="${p.price * (1 - weekendDeal.discountPercent / 100.0)}" />
                                                                                <span class="current"
                                                                                    style="color: #ff6b6b;">
                                                                                    <fmt:formatNumber
                                                                                        value="${weekendPrice}"
                                                                                        pattern="#,###" />đ
                                                                                </span>
                                                                                <span class="original">
                                                                                    <fmt:formatNumber value="${p.price}"
                                                                                        pattern="#,###" />đ
                                                                                </span>
                                                                            </c:when>
                                                                            <%-- Ưu tiên 2: Sale thường --%>
                                                                                <c:when
                                                                                    test="${p.salePrice > 0 && p.salePrice < p.price}">
                                                                                    <span class="current">
                                                                                        <fmt:formatNumber
                                                                                            value="${p.salePrice}"
                                                                                            pattern="#,###" />đ
                                                                                    </span>
                                                                                    <span class="original">
                                                                                        <fmt:formatNumber
                                                                                            value="${p.price}"
                                                                                            pattern="#,###" />đ
                                                                                    </span>
                                                                                </c:when>
                                                                                <%-- Mặc định: Giá gốc --%>
                                                                                    <c:otherwise>
                                                                                        <span class="current">
                                                                                            <fmt:formatNumber
                                                                                                value="${p.price}"
                                                                                                pattern="#,###" />đ
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <c:if test="${p.quantity > 0}">
                                                                    <span class="unit"
                                                                        style="font-size: 12px; color: #666;">/
                                                                        Kg</span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="col-12">
                                            <div class="pagination-wrapper">
                                                <c:if test="${endP > 1}">
                                                    <c:set var="currentPage"
                                                        value="${empty param.index ? 1 : param.index}" />

                                                    <!-- Previous Button -->
                                                    <c:choose>
                                                        <c:when test="${currentPage > 1}">
                                                            <a href="shop?index=${currentPage - 1}&cid=${cid}&price=${priceTag}&sort=${sortTag}"
                                                                class="pagination-btn pagination-prev">
                                                                <i class="fas fa-chevron-left"></i>
                                                                <span>Trang Trước</span>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="pagination-btn pagination-prev" disabled>
                                                                <i class="fas fa-chevron-left"></i>
                                                                <span>Trang Trước</span>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <!-- Page Numbers -->
                                                    <div class="pagination-pages">
                                                        <c:forEach begin="1" end="${endP}" var="i">
                                                            <c:choose>
                                                                <c:when test="${i == currentPage}">
                                                                    <span class="page-number active">${i}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="shop?index=${i}&cid=${cid}&price=${priceTag}&sort=${sortTag}"
                                                                        class="page-number">${i}</a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </div>

                                                    <!-- Next Button -->
                                                    <c:choose>
                                                        <c:when test="${currentPage < endP}">
                                                            <a href="shop?index=${currentPage + 1}&cid=${cid}&price=${priceTag}&sort=${sortTag}"
                                                                class="pagination-btn pagination-next">
                                                                <span>Trang Sau</span>
                                                                <i class="fas fa-chevron-right"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="pagination-btn pagination-next" disabled>
                                                                <span>Trang Sau</span>
                                                                <i class="fas fa-chevron-right"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- KẾT THÚC CỘT 10 -->
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                <!-- FOOTER -->
                <footer class="footer">
                    <div class="footer__main">
                        <div class="footer__grid">
                            <!-- Company Info -->
                            <div class="footer__company">
                                <div class="footer__brand">
                                    <a href="/">
                                        <img class="navbar__menu-logo-img"
                                            src="https://ik.imagekit.io/8tm3umulk/image/logonew_fG_70DXF8?updatedAt=1762866381508"
                                            alt="Organic Harvest Logo" />
                                    </a>
                                    <!-- <div class="footer__logo">T</div>
                  <h3 class="footer__company-name">Company</h3> -->
                                </div>
                                <p class="footer__description">
                                    Địa chỉ: khu phố 6, Thủ Đức, Thành phố Hồ Chí Minh, Việt Nam
                                </p>
                                <div class="footer__social">
                                    <a href="https://www.themedevhub.com" target="_blank"
                                        class="footer__social-link footer__social-link--facebook">
                                        <svg class="footer__social-icon" viewBox="0 0 24 24">
                                            <path
                                                d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
                                        </svg>
                                    </a>
                                    <a href="https://www.themedevhub.com" target="_blank"
                                        class="footer__social-link footer__social-link--twitter">
                                        <svg class="footer__social-icon" viewBox="0 0 24 24">
                                            <path
                                                d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z" />
                                        </svg>
                                    </a>
                                    <a href="https://www.themedevhub.com" target="_blank"
                                        class="footer__social-link footer__social-link--telegram">
                                        <svg class="footer__social-icon" viewBox="0 0 24 24">
                                            <path
                                                d="M12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12S18.627 0 12 0zm5.894 8.221l-1.97 9.28c-.145.658-.537.818-1.084.508l-3-2.21-1.446 1.394c-.16.16-.295.295-.605.295l.213-3.053 5.56-5.023c.242-.213-.054-.333-.373-.121l-6.871 4.326-2.962-.924c-.643-.204-.657-.643.136-.953l11.56-4.458c.538-.196 1.006.128.832.941z" />
                                        </svg>
                                    </a>
                                </div>
                            </div>

                            <!-- Quick Links -->
                            <div class="footer__section">
                                <h3 class="footer__title">Chính sách</h3>
                                <ul class="footer__links">
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/about-us" target="_blank"
                                            class="footer__link">Trang chủ</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/hire-experts" target="_blank"
                                            class="footer__link">Sản
                                            phẩm</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/themes" target="_blank"
                                            class="footer__link">Giới thiệu</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/contact" target="_blank"
                                            class="footer__link">Bài viết</a>
                                    </li>
                                </ul>
                            </div>

                            <!-- Hổ trợ khách hàng -->
                            <div class="footer__section">
                                <h3 class="footer__title">Hổ trợ khách hàng</h3>
                                <ul class="footer__links">
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/about-us" target="_blank"
                                            class="footer__link">Tìm kiếm
                                        </a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/hire-experts" target="_blank"
                                            class="footer__link">Chính sách
                                            bảo
                                            mật</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/themes" target="_blank"
                                            class="footer__link">Điều khoản dịch
                                            vụ</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/contact" target="_blank"
                                            class="footer__link">Hướng dẫn kiểm
                                            tra
                                            đơn hàng</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/contact" target="_blank"
                                            class="footer__link">Chính sách giao
                                            nhận</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/contact" target="_blank"
                                            class="footer__link">Chính sách
                                            thanh
                                            toán</a>
                                    </li>
                                    <li class="footer__link-item">
                                        <div class="footer__link-dot"></div>
                                        <a href="https://www.themedevhub.com/contact" target="_blank"
                                            class="footer__link">Chính sách đổi
                                            trả</a>
                                    </li>
                                </ul>
                            </div>

                            <!-- Newsletter -->
                            <div class="footer__section">
                                <h3 class="footer__title">Đăng kí nhận tin</h3>

                                <form class="footer__newsletter-form">
                                    <input type="email" placeholder="Nhập địa chỉ email"
                                        class="footer__newsletter-input" required />
                                    <button type="submit" class="footer__newsletter-button">
                                        Đăng kí
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Footer Bottom -->
                    <div class="footer__bottom">
                        <div class="footer__bottom-content">
                            <p class="footer__copyright">
                                &copy; 2025 Company. All rights reserved.
                            </p>
                            <ul class="footer__bottom-links">
                                <li>
                                    <a href="https://www.themedevhub.com/about-us" target="_blank"
                                        class="footer__bottom-link">About
                                        us</a>
                                </li>
                                <li>
                                    <a href="https://www.themedevhub.com/privacy-policy" target="_blank"
                                        class="footer__bottom-link">Terms</a>
                                </li>
                                <li>
                                    <a href="https://www.themedevhub.com/terms-and-conditions" target="_blank"
                                        class="footer__bottom-link">Privacy</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </footer>
                <script src="./assets/js/main.js"></script>
                <script>
                    function toggleCategoryIcon(detailsElement) {
                        const toggle = detailsElement.querySelector('.category-toggle');
                        if (detailsElement.open) {
                            toggle.textContent = '-';
                        } else {
                            toggle.textContent = '+';
                        }
                    }

                    function bindProductCardNavigation() {
                        const cards = document.querySelectorAll('.product-card[data-href]');
                        cards.forEach(function (card) {
                            card.style.cursor = 'pointer';
                            card.onclick = null;
                            card.addEventListener('click', function (e) {
                                if (e.target.closest('a, button, input, textarea, select, label')) {
                                    return;
                                }
                                const href = card.getAttribute('data-href');
                                if (href) {
                                    window.location.assign(href);
                                }
                            });
                        });

                        document.addEventListener('click', function (e) {
                            const card = e.target.closest('.product-card[data-href]');
                            if (!card) {
                                return;
                            }
                            if (e.target.closest('a, button, input, textarea, select, label')) {
                                return;
                            }
                            const href = card.getAttribute('data-href');
                            if (href) {
                                window.location.assign(href);
                            }
                        });
                    }

                    if (document.readyState === 'loading') {
                        document.addEventListener('DOMContentLoaded', bindProductCardNavigation);
                    } else {
                        bindProductCardNavigation();
                    }
                </script>
                </div>
            </body>

            </html>