<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Giỏ hàng</title>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css" />
            </head>

            <body>
                <div class="main">
                    <jsp:include page="header.jsp"></jsp:include>

                    <div class="breadcrumb">
                        <div class="grid">
                            <a href="index.jsp">Trang chủ</a>
                            <i class="fa-solid fa-angle-right"></i>
                            <span>Giỏ hàng</span>
                        </div>
                    </div>

                    <div class="page-container">
                        <form action="${pageContext.request.contextPath}/checkout" method="get" id="cartCheckoutForm">
                            <main class="cart-wrapper">
                                <div class="cart-main">

                                    <c:if test="${empty sessionScope.cart}">
                                        <div style="text-align: center; margin: 50px 0;">
                                            <i class="fa-solid fa-cart-arrow-down"
                                                style="font-size: 50px; color: #ccc;"></i>
                                            <p style="margin-top: 20px;">Giỏ hàng của bạn đang trống!</p>
                                            <a href="shop" class="btn"
                                                style="margin-top: 10px; display: inline-block; background: var(--primary-color); color: #fff; padding: 10px 20px; border-radius: 5px; text-decoration: none;">Tiếp
                                                tục mua sắm</a>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty sessionScope.cart}">
                                        <table class="cart-table">
                                            <thead>
                                                <tr>
                                                    <th class="checkbox-col">
                                                        <input type="checkbox" id="selectAllCart" checked />
                                                    </th>
                                                    <th class="product-col">Sản Phẩm</th>
                                                    <th class="price-col">Giá</th>
                                                    <th class="quantity-col">Số Lượng</th>
                                                    <th class="subtotal-col">Thành Tiền</th>
                                                    <th class="remove-col">&nbsp;</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                                <c:forEach items="${sessionScope.cart}" var="item">
                                                    <tr>
                                                        <td class="checkbox-cell">
                                                            <input type="checkbox" class="cart-item-check"
                                                                name="selectedPids" value="${item.product.id}"
                                                                data-total="${item.totalPrice}" checked />
                                                        </td>
                                                        <td class="product-cell">
                                                            <img src="${item.product.image}"
                                                                alt="${item.product.name}" />
                                                            <span>${item.product.name}</span>
                                                        </td>
                                                        <td class="price-cell">
                                                            <c:if test="${item.discountAmount > 0}">
                                                                <div class="price-group">
                                                                    <span class="price-original">
                                                                        <fmt:formatNumber value="${item.originalPrice}"
                                                                            pattern="#,###" />đ
                                                                    </span>
                                                                    <span class="price-sale">
                                                                        <fmt:formatNumber value="${item.finalPrice}"
                                                                            pattern="#,###" />đ
                                                                    </span>
                                                                    <span class="discount-badge">
                                                                        -
                                                                        <fmt:formatNumber
                                                                            value="${(item.discountAmount / item.originalPrice * 100)}"
                                                                            pattern="0" />%
                                                                    </span>
                                                                </div>
                                                            </c:if>
                                                            <c:if test="${item.discountAmount <= 0}">
                                                                <div class="price-group">
                                                                    <span class="price-normal">
                                                                        <fmt:formatNumber value="${item.finalPrice}"
                                                                            pattern="#,###" />đ
                                                                    </span>
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <div class="quantity-selector">
                                                                <button type="button" class="quantity-btn"
                                                                    onclick="location.href='update-cart?pid=${item.product.id}&mode=minus'">-</button>

                                                                <input type="number" value="${item.quantity}" min="1"
                                                                    readonly />

                                                                <button type="button" class="quantity-btn"
                                                                    onclick="location.href='update-cart?pid=${item.product.id}&mode=plus'">+</button>
                                                            </div>
                                                        </td>
                                                        <td class="subtotal-cell">
                                                            <c:if test="${item.discountAmount > 0}">
                                                                <div class="subtotal-group">
                                                                    <span class="subtotal-original">
                                                                        <fmt:formatNumber
                                                                            value="${item.originalPrice * item.quantity}"
                                                                            pattern="#,###" />đ
                                                                    </span>
                                                                    <strong class="subtotal-sale">
                                                                        <fmt:formatNumber value="${item.totalPrice}"
                                                                            pattern="#,###" />đ
                                                                    </strong>
                                                                </div>
                                                            </c:if>
                                                            <c:if test="${item.discountAmount <= 0}">
                                                                <strong class="subtotal-normal">
                                                                    <fmt:formatNumber value="${item.totalPrice}"
                                                                        pattern="#,###" />đ
                                                                </strong>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <a href="remove-cart?pid=${item.product.id}"
                                                                class="remove-btn"
                                                                onclick="return confirm('Bạn có chắc muốn xoá sản phẩm này?');">
                                                                <i class="fa-solid fa-trash-can"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <div class="cart-actions">
                                            <a href="shop" class="update-cart-btn"
                                                style="text-decoration: none; text-align: center;">TIẾP TỤC
                                                MUA HÀNG</a>
                                        </div>
                                    </c:if>
                                </div>

                                <c:if test="${not empty sessionScope.cart}">
                                    <aside class="cart-sidebar">
                                        <div class="cart-totals">
                                            <h2>THÀNH TIỀN ĐÃ CHỌN</h2>

                                            <div class="totals-row">
                                                <span>Tạm tính đã chọn</span>
                                                <span>
                                                    <span id="selectedCartTotal">
                                                        <fmt:formatNumber value="${sessionScope.totalMoney}"
                                                            pattern="#,###" />đ
                                                    </span>
                                                </span>
                                            </div>

                                            <div class="shipping-section">

                                                <p class="shipping-note">
                                                    Phí vận chuyển thực tế sẽ được tính tại trang thanh toán.
                                                </p>
                                            </div>

                                            <div class="totals-row final-total">
                                                <span>Tổng cộng đã chọn</span>
                                                <span>
                                                    <span id="selectedCartFinal">
                                                        <fmt:formatNumber value="${sessionScope.totalMoney}"
                                                            pattern="#,###" />đ
                                                    </span>
                                                </span>
                                            </div>
                                            <button type="submit" class="checkout-btn" id="checkoutSelectedBtn">THANH
                                                TOÁN ĐÃ CHỌN</button>
                                        </div>
                                    </aside>
                                </c:if>
                            </main>
                        </form>
                    </div>
                </div>

                <jsp:include page="footer.jsp"></jsp:include>

                <script src="./assets/js/main.js"></script>
                <script>
                    (function () {
                        const selectAll = document.getElementById('selectAllCart');
                        const checkboxes = Array.from(document.querySelectorAll('.cart-item-check'));
                        const totalLabel = document.getElementById('selectedCartTotal');
                        const finalLabel = document.getElementById('selectedCartFinal');
                        const checkoutBtn = document.getElementById('checkoutSelectedBtn');

                        if (!selectAll || checkboxes.length === 0) {
                            return;
                        }

                        function formatMoney(value) {
                            return new Intl.NumberFormat('vi-VN').format(value) + 'đ';
                        }

                        function updateSummary() {
                            let total = 0;
                            let checkedCount = 0;

                            checkboxes.forEach(function (checkbox) {
                                if (checkbox.checked) {
                                    checkedCount += 1;
                                    total += parseFloat(checkbox.dataset.total || '0');
                                }
                            });

                            const allChecked = checkedCount === checkboxes.length;
                            selectAll.checked = allChecked;
                            selectAll.indeterminate = checkedCount > 0 && !allChecked;

                            if (totalLabel) {
                                totalLabel.textContent = formatMoney(total);
                            }
                            if (finalLabel) {
                                finalLabel.textContent = formatMoney(total);
                            }
                            if (checkoutBtn) {
                                checkoutBtn.disabled = checkedCount === 0;
                            }
                        }

                        selectAll.addEventListener('change', function () {
                            checkboxes.forEach(function (checkbox) {
                                checkbox.checked = selectAll.checked;
                            });
                            updateSummary();
                        });

                        checkboxes.forEach(function (checkbox) {
                            checkbox.addEventListener('change', updateSummary);
                        });

                        document.getElementById('cartCheckoutForm').addEventListener('submit', function (event) {
                            const selected = checkboxes.some(function (checkbox) {
                                return checkbox.checked;
                            });
                            if (!selected) {
                                event.preventDefault();
                                alert('Vui lòng chọn ít nhất một sản phẩm để thanh toán.');
                            }
                        });

                        updateSummary();
                    })();
                </script>
            </body>

            </html>