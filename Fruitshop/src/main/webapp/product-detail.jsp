<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width,initial-scale=1" />
                <title>
                    <c:out value="${detail.name}" /> — Organic Harvest
                </title>

                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                <link rel="stylesheet" href="<c:url value='/assets/css/main.css'/>" />
                <link rel="stylesheet" href="<c:url value='/assets/css/base.css'/>" />
                <link rel="stylesheet" href="<c:url value='/assets/css/product-detail.css'/>" />
            </head>

            <body>

                <main class="main product-detail-page">
                    <jsp:include page="header.jsp"></jsp:include>

                    <div class="breadcrumb">
                        <div class="container">
                            <a href="<c:url value='/index.jsp'/>">Trang chủ</a>
                            <i class="fa-solid fa-angle-right"></i>
                            <a href="<c:url value='/shop'/>">Cửa hàng</a>
                            <i class="fa-solid fa-angle-right"></i>
                            <span>
                                <c:out value="${detail.name}" />
                            </span>
                        </div>
                    </div>

                    <div class="container">
                        <div class="product-detail__container">
                            <div class="product-detail__top">

                                <div class="product-gallery">
                                    <div class="product-gallery__thumbs">
                                        <div class="thumb-item active" onclick="changeImage(this)">
                                            <img src="<c:out value='${detail.image}'/>"
                                                alt="<c:out value='${detail.image}'/>" class="zoomable-thumb">
                                        </div>
                                        <c:forEach var="img" items="${detail.productImages}">
                                            <c:if test="${not empty img.imageUrl}">
                                                <div class="thumb-item" onclick="changeImage(this)">
                                                    <img src="<c:out value='${img.imageUrl}'/>"
                                                        alt="<c:out value='${detail.name}'/>" class="zoomable-thumb">
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <div class="product-gallery__main">
                                        <img id="mainImage" src="<c:out value='${detail.image}'/>"
                                            alt="<c:out value='${detail.name}'/>" class="zoomable-main">
                                    </div>
                                </div>

                                <div class="product-info">
                                    <h1 class="product-title">
                                        <c:out value="${detail.name}" />
                                    </h1>

                                    <div class="product-meta-row">
                                        <div class="product-rating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= detail.averageRating}">
                                                        <i class="fa-solid fa-star"></i>
                                                    </c:when>
                                                    <c:when test="${i - detail.averageRating <= 0.5}">
                                                        <i class="fa-solid fa-star-half-stroke"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fa-regular fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <span>(
                                                <fmt:formatNumber value="${detail.averageRating}" minFractionDigits="1"
                                                    maxFractionDigits="1" />/5 -
                                                <c:out value="${detail.reviewCount}" /> đánh giá)
                                            </span>
                                        </div>
                                        <span class="divider">|</span>
                                        <span class="product-sku">Mã SP: <strong>
                                                <c:out value="${detail.productCode}" />
                                            </strong></span>
                                        <span class="divider">|</span>
                                        <span class="stock-status in-stock">
                                            <c:choose>
                                                <c:when test="${detail.quantity > 0}">Còn hàng</c:when>
                                                <c:otherwise>Hết hàng</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="divider">|</span>
                                        <span class="product-sold">Đã bán: <strong>
                                                <fmt:formatNumber value="${soldCount}" pattern="#,###" />
                                            </strong></span>
                                    </div>

                                    <div class="product-price-box">
                                        <c:choose>
                                            <c:when test="${not empty weekendDeal}">
                                                <c:set var="weekendPrice"
                                                    value="${detail.price * (1 - weekendDeal.discountPercent / 100.0)}" />
                                                <span class="current-price" style="color: #ff6b6b;">
                                                    <fmt:formatNumber value="${weekendPrice}" pattern="#,###" />₫
                                                </span>
                                                <span class="old-price">
                                                    <fmt:formatNumber value="${detail.price}" pattern="#,###" />₫
                                                </span>
                                                <span class="discount-percent"
                                                    style="background: linear-gradient(135deg, #ff6b6b, #ee5a6f);">
                                                    -
                                                    <c:out value="${weekendDeal.discountPercent}" />%
                                                </span>
                                            </c:when>

                                            <c:when test="${detail.salePrice > 0 && detail.salePrice < detail.price}">
                                                <span class="current-price">
                                                    <fmt:formatNumber value="${detail.salePrice}" pattern="#,###" />₫
                                                </span>
                                                <span class="old-price">
                                                    <fmt:formatNumber value="${detail.price}" pattern="#,###" />₫
                                                </span>
                                                <span class="discount-percent">
                                                    -
                                                    <fmt:formatNumber
                                                        value="${(detail.price - detail.salePrice)/detail.price * 100}"
                                                        maxFractionDigits="0" />%
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="current-price">
                                                    <fmt:formatNumber value="${detail.price}" pattern="#,###" />₫
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <c:choose>
                                        <c:when test="${detail.quantity == 0}">
                                            <div
                                                style="text-align: center; padding: 15px; background: #f8f9fa; border-radius: 5px; margin: 20px 0;">
                                                <span style="color: #999; font-size: 16px; font-weight: 600;">
                                                    <i class="fa-solid fa-ban"></i> Hết hàng
                                                </span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <hr class="product-divider">

                                            <form action="<c:url value='/add-to-cart'/>" method="post"
                                                class="product-actions-wrapper">
                                                <input type="hidden" name="pid" value="${detail.id}">

                                                <div class="qty-wrapper">
                                                    <button type="button" class="qty-btn"
                                                        onclick="decreaseQty()">-</button>
                                                    <input type="number" name="quantity" value="1" min="1" id="qtyInput"
                                                        class="qty-input">
                                                    <button type="button" class="qty-btn"
                                                        onclick="increaseQty()">+</button>
                                                </div>

                                                <div class="action-buttons">
                                                    <button type="submit" name="btAction" value="add"
                                                        class="btn btn-add-cart">
                                                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                                    </button>

                                                    <button type="submit" name="btAction" value="buy"
                                                        class="btn btn-buy-now">
                                                        Mua ngay
                                                    </button>
                                                </div>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="product-policies">
                                        <div class="policy-item">
                                            <i class="fa-solid fa-truck-fast"></i>
                                            <span>Giao hàng hỏa tốc trong 2H</span>
                                        </div>
                                        <div class="policy-item">
                                            <i class="fa-solid fa-rotate-left"></i>
                                            <span>Đổi trả trong 24H nếu hư hỏng</span>
                                        </div>
                                        <div class="policy-item">
                                            <i class="fa-solid fa-shield-halved"></i>
                                            <span>Cam kết 100% Sạch & An toàn</span>
                                        </div>
                                    </div>

                                    <div class="product-share">
                                        <span>Chia sẻ:</span>
                                        <a href="#"><i class="fa-brands fa-facebook"></i></a>
                                        <a href="#"><i class="fa-brands fa-twitter"></i></a>
                                        <a href="#"><i class="fa-brands fa-pinterest"></i></a>
                                    </div>

                                </div>
                            </div>

                            <div class="product-detail__bottom">
                                <div class="product-tabs">
                                    <button class="tab-btn active" onclick="openTab(event, 'desc')">Mô tả chi
                                        tiết</button>
                                    <button class="tab-btn" onclick="openTab(event, 'reviews')">Đánh giá (
                                        <c:out value="${listR.size()}" />)
                                    </button>
                                    <button class="tab-btn" onclick="openTab(event, 'shipping')">Chính sách giao
                                        hàng</button>
                                </div>

                                <div id="desc" class="tab-content">
                                    <div class="content-inner">
                                        <h3>Thông tin chi tiết</h3>
                                        <p>
                                            <c:out value="${detail.description}" escapeXml="false" />
                                        </p>
                                        <p><strong>Lưu ý:</strong> Bảo quản nơi khô ráo, thoáng mát.</p>
                                    </div>
                                </div>

                                <div id="reviews" class="tab-content">
                                    <div class="product-reviews">
                                        <h3>Đánh giá sản phẩm</h3>

                                        <div class="review-form-wrapper"
                                            style="background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
                                            <c:if test="${sessionScope.account == null}">
                                                <p>Vui lòng <a href="<c:url value='/login.jsp'/>"
                                                        style="color: var(--primary-color); font-weight: bold;">đăng
                                                        nhập</a> để viết đánh giá.</p>
                                            </c:if>

                                            <c:if test="${sessionScope.account != null}">
                                                <form action="<c:url value='/review'/>" method="post"
                                                    class="review-form">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${detail.id}">

                                                    <div class="form-group" style="margin-bottom: 15px;">
                                                        <label
                                                            style="font-weight: 600; display: block; margin-bottom: 5px;">Đánh
                                                            giá của bạn:</label>
                                                        <div class="rate">
                                                            <input type="radio" id="star5" name="rating" value="5"
                                                                checked />
                                                            <label for="star5" title="5 sao">5 stars</label>
                                                            <input type="radio" id="star4" name="rating" value="4" />
                                                            <label for="star4" title="4 sao">4 stars</label>
                                                            <input type="radio" id="star3" name="rating" value="3" />
                                                            <label for="star3" title="3 sao">3 stars</label>
                                                            <input type="radio" id="star2" name="rating" value="2" />
                                                            <label for="star2" title="2 sao">2 stars</label>
                                                            <input type="radio" id="star1" name="rating" value="1" />
                                                            <label for="star1" title="1 sao">1 star</label>
                                                        </div>
                                                    </div>

                                                    <div class="form-group" style="margin-bottom: 15px;">
                                                        <textarea name="comment" rows="4"
                                                            placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."
                                                            required
                                                            style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"></textarea>
                                                    </div>

                                                    <button type="submit" class="btn btn--primary">Gửi đánh giá</button>
                                                </form>
                                            </c:if>
                                        </div>

                                        <div class="review-list">
                                            <c:if test="${empty listR}">
                                                <p style="color: #666; font-style: italic;">Chưa có đánh giá nào cho sản
                                                    phẩm này.</p>
                                            </c:if>

                                            <c:forEach items="${listR}" var="r">
                                                <div class="review-item"
                                                    style="border-bottom: 1px solid #eee; padding: 15px 0; display: flex; gap: 15px;">
                                                    <div class="review-avatar">
                                                        <c:choose>
                                                            <c:when test="${not empty r.user.avatar}">
                                                                <c:set var="userAvatar" value="${r.user.avatar}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <%-- Kết hợp c:url cho ảnh mặc định --%>
                                                                    <c:set var="userAvatar">
                                                                        <c:url
                                                                            value="/assets/images/default-user.png" />
                                                                    </c:set>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <img src="<c:out value='${userAvatar}'/>"
                                                            alt="<c:out value='${r.user.fullname}'/>"
                                                            style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
                                                    </div>
                                                    <div class="review-content">
                                                        <div class="review-header" style="margin-bottom: 5px;">
                                                            <span
                                                                style="font-weight: bold; font-size: 1.1rem;">${r.user.fullname}</span>
                                                            <span
                                                                style="color: #999; font-size: 0.9rem; margin-left: 10px;">
                                                                <fmt:formatDate value="${r.createdAt}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </span>
                                                        </div>
                                                        <div class="review-rating"
                                                            style="color: #ffc107; font-size: 0.9rem; margin-bottom: 8px;">
                                                            <c:forEach begin="1" end="${r.rating}">
                                                                <i class="fas fa-star"></i>
                                                            </c:forEach>
                                                            <c:forEach begin="1" end="${5 - r.rating}">
                                                                <i class="far fa-star"></i>
                                                            </c:forEach>
                                                        </div>
                                                        <p class="review-text" style="color: #333; line-height: 1.5;">
                                                            ${r.comment}</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>

                                <div id="shipping" class="tab-content">
                                    <p>Nội dung chính sách giao hàng...</p>
                                </div>
                            </div>

                            <div class="related-products-section">
                                <h2 class="section-title">Sản phẩm liên quan</h2>
                                <div class="trending-grid" style="display: flex; gap: 20px; flex-wrap: wrap;">

                                    <c:forEach items="${relatedP}" var="rp">
                                        <c:if test="${rp.id != detail.id}">
                                            <div class="product-card" style="width: 250px;">
                                                <div class="product-image">
                                                    <img src="<c:out value='${rp.image}'/>"
                                                        alt="<c:out value='${rp.name}'/>"
                                                        style="width: 100%; height: 200px; object-fit: cover;">
                                                    <div class="product-actions">
                                                        <a href="<c:url value='/product-detail?pid=${rp.id}'/>"><button
                                                                class="action-btn"><i
                                                                    class="fas fa-eye"></i></button></a>
                                                    </div>
                                                </div>
                                                <div class="product-info">
                                                    <h3><a href="<c:url value='/product-detail?pid=${rp.id}'/>">
                                                            <c:out value="${rp.name}" />
                                                        </a></h3>
                                                    <div class="price">
                                                        <span class="current">
                                                            <fmt:formatNumber value="${rp.price}" pattern="#,###" />₫
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>

                        </div>
                    </div>

                </main>

                <jsp:include page="footer.jsp"></jsp:include>

                <script src="<c:url value='/assets/js/main.js'/>"></script>

                <script>
                    function changeImage(element) {
                        document.querySelectorAll('.thumb-item').forEach(el => el.classList.remove('active'));
                        element.classList.add('active');
                        const newSrc = element.querySelector('img').src;
                        const mainImage = document.getElementById('mainImage');
                        mainImage.src = newSrc;
                        mainImage.style.transform = 'scale(1)';
                        mainImage.style.transformOrigin = 'center center';
                        mainImage.dataset.zoom = '1';
                        mainImage.style.cursor = 'zoom-in';
                        const thumbAlt = element.querySelector('img').alt;
                        if (thumbAlt) {
                            mainImage.alt = thumbAlt;
                        }
                    }

                    const qtyInput = document.getElementById('qtyInput');
                    function increaseQty() {
                        qtyInput.value = parseInt(qtyInput.value) + 1;
                    }
                    function decreaseQty() {
                        if (parseInt(qtyInput.value) > 1) {
                            qtyInput.value = parseInt(qtyInput.value) - 1;
                        }
                    }

                    function openTab(evt, tabName) {
                        const tabcontents = document.getElementsByClassName("tab-content");
                        for (let i = 0; i < tabcontents.length; i++) {
                            tabcontents[i].style.display = "none";
                        }

                        const tablinks = document.getElementsByClassName("tab-btn");
                        for (let i = 0; i < tablinks.length; i++) {
                            tablinks[i].classList.remove("active");
                        }

                        const targetTab = document.getElementById(tabName);
                        if (targetTab) {
                            targetTab.style.display = "block";
                            evt.currentTarget.classList.add("active");
                        }
                    }

                    document.addEventListener("DOMContentLoaded", function () {
                        document.querySelectorAll(".tab-content").forEach(tab => {
                            tab.style.display = "none";
                        });

                        const defaultTab = document.getElementById("desc");
                        if (defaultTab) {
                            defaultTab.style.display = "block";
                        }

                        const firstTabBtn = document.querySelector(".tab-btn");
                        if (firstTabBtn) {
                            firstTabBtn.classList.add("active");
                        }

                        const mainImage = document.getElementById('mainImage');
                        const mainImageWrap = document.querySelector('.product-gallery__main');
                        let inlineZoom = 1;

                        function applyInlineZoom() {
                            mainImage.style.transform = 'scale(' + inlineZoom + ')';
                            mainImage.dataset.zoom = inlineZoom;
                            mainImage.style.cursor = inlineZoom > 1 ? 'zoom-out' : 'zoom-in';
                        }

                        function setInlineZoom(value) {
                            inlineZoom = Math.min(4, Math.max(1, value));
                            applyInlineZoom();
                            if (inlineZoom === 1) {
                                mainImage.style.transformOrigin = 'center center';
                            }
                        }

                        if (mainImage) {
                            applyInlineZoom();

                            mainImage.addEventListener('click', function () {
                                if (inlineZoom > 1) {
                                    setInlineZoom(1);
                                } else {
                                    setInlineZoom(2);
                                }
                            });

                            mainImageWrap.addEventListener('wheel', function (e) {
                                e.preventDefault();
                                const step = e.deltaY > 0 ? -0.2 : 0.2;
                                setInlineZoom(inlineZoom + step);
                            }, { passive: false });

                            mainImageWrap.addEventListener('mousemove', function (e) {
                                if (inlineZoom <= 1) {
                                    return;
                                }
                                const rect = mainImageWrap.getBoundingClientRect();
                                const x = ((e.clientX - rect.left) / rect.width) * 100;
                                const y = ((e.clientY - rect.top) / rect.height) * 100;
                                const cx = Math.max(0, Math.min(100, x));
                                const cy = Math.max(0, Math.min(100, y));
                                mainImage.style.transformOrigin = cx + '% ' + cy + '%';
                            });

                            mainImageWrap.addEventListener('mouseleave', function () {
                                if (inlineZoom <= 1) {
                                    mainImage.style.transformOrigin = 'center center';
                                }
                            });
                        }

                        document.querySelectorAll('.zoomable-thumb').forEach(function (thumb) {
                            thumb.addEventListener('dblclick', function (e) {
                                e.preventDefault();
                                e.stopPropagation();
                                const parent = thumb.closest('.thumb-item');
                                if (parent) {
                                    changeImage(parent);
                                    setInlineZoom(2);
                                }
                            });
                        });
                    });
                </script>
            </body>

            </html>