<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Thanh toán - Organic Harvest</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
            </head>

            <body>
                <jsp:include page="header.jsp"></jsp:include>

                <c:choose>
                    <c:when test="${not empty sessionScope.checkoutCart}">
                        <c:set var="checkoutCart" value="${sessionScope.checkoutCart}" />
                    </c:when>
                    <c:when test="${sessionScope.isBuyNow and not empty sessionScope.buyNowCart}">
                        <c:set var="checkoutCart" value="${sessionScope.buyNowCart}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="checkoutCart" value="${sessionScope.cart}" />
                    </c:otherwise>
                </c:choose>

                <div class="breadcrumb">
                    <div class="grid">
                        <a href="${pageContext.request.contextPath}/cart.jsp">Giỏ hàng</a>
                        <i class="fa-solid fa-angle-right"></i>
                        <span>Thanh toán</span>
                    </div>
                </div>

                <div class="container-checkout">
                    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                        <div class="checkout-layout">
                            <div class="checkout-layout__form-wrapper">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger"
                                        style="background: #fee; color: #c00; padding: 12px; margin-bottom: 15px; border-radius: 5px;">
                                        ${error}
                                    </div>
                                </c:if>

                                <div class="checkout-section">
                                    <h2 class="billing-form__title">
                                        <i class="fa-solid fa-location-dot"></i> Địa chỉ nhận hàng
                                    </h2>

                                    <c:choose>
                                        <c:when test="${not empty addresses}">
                                            <div class="address-card" id="addressCard">
                                                <div class="address-card-content" id="selectedAddressDisplay">
                                                    <c:set var="defaultAddr" value="${null}" />
                                                    <c:forEach var="addr" items="${addresses}">
                                                        <c:if test="${addr.defaultAddress}">
                                                            <c:set var="defaultAddr" value="${addr}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${not empty defaultAddr}">
                                                        <div class="address-info">
                                                            <span
                                                                class="address-name">${defaultAddr.receiverName}</span>
                                                            <span
                                                                class="address-phone">${defaultAddr.phoneNumber}</span>
                                                        </div>
                                                        <div class="address-detail">${defaultAddr.address},
                                                            ${defaultAddr.city}</div>
                                                        <input type="hidden" name="addressId" id="selectedAddressId"
                                                            value="${defaultAddr.id}">
                                                    </c:if>
                                                </div>
                                                <button type="button" class="btn-change"
                                                    onclick="openAddressModal()">Thay đổi</button>
                                            </div>

                                            <div class="address-modal" id="addressModal">
                                                <div class="modal-overlay" onclick="closeAddressModal()"></div>
                                                <div class="modal-container">
                                                    <div class="modal-header">
                                                        <h3>Chọn địa chỉ giao hàng</h3>
                                                        <button type="button" class="btn-close"
                                                            onclick="closeAddressModal()">&times;</button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <c:forEach var="addr" items="${addresses}">
                                                            <div class="address-option" data-id="${addr.id}"
                                                                data-name="${addr.receiverName}"
                                                                data-phone="${addr.phoneNumber}"
                                                                data-address="${addr.address}, ${addr.city}"
                                                                onclick="selectAddress(this)">
                                                                <div class="address-option-content">
                                                                    <div class="address-option-header">
                                                                        <span
                                                                            class="address-option-name">${addr.receiverName}</span>
                                                                        <span
                                                                            class="address-option-phone">${addr.phoneNumber}</span>
                                                                    </div>
                                                                    <div class="address-option-detail">${addr.address},
                                                                        ${addr.city}</div>
                                                                    <c:if test="${addr.defaultAddress}">
                                                                        <span class="badge-default">Mặc định</span>
                                                                    </c:if>
                                                                </div>
                                                                <div class="radio-wrapper">
                                                                    <input type="radio" name="selectedAddr"
                                                                        value="${addr.id}" ${addr.defaultAddress
                                                                        ? 'checked' : '' }>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <a href="${pageContext.request.contextPath}/addresses"
                                                            class="btn-add-new">
                                                            <i class="fa-solid fa-plus"></i> Thêm địa chỉ mới
                                                        </a>
                                                        <button type="button" class="btn-confirm"
                                                            onclick="confirmAddress()">Xác nhận</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>

                                        </c:otherwise>
                                    </c:choose>

                                    <div class="billing-form__group" style="margin-top: 20px">
                                        <label class="billing-form__label" for="note">Ghi chú đơn hàng (tùy
                                            chọn)</label>
                                        <textarea class="billing-form__input billing-form__input--textarea" id="note"
                                            name="note"
                                            placeholder="Ví dụ: Giao hàng trong giờ hành chính..."></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="checkout-layout__summary-wrapper">
                                <div class="order-summary">
                                    <h2 class="order-summary__title">Đơn hàng của bạn</h2>
                                    <table class="order-summary__table">
                                        <thead class="thead-border">
                                            <tr class="order-summary__row order-summary__row--header">
                                                <th class="order-summary__cell order-summary__cell--header">Sản phẩm
                                                </th>
                                                <th class="order-summary__cell order-summary__cell--header">Tạm tính
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${checkoutCart}" var="item">
                                                <tr class="order-summary__row__item">
                                                    <td class="order-summary__cell">
                                                        <div style="display: flex; align-items: center; gap: 10px;">
                                                            <c:choose>
                                                                <c:when test="${not empty item.product.image}">
                                                                    <img src="${item.product.image}"
                                                                        alt="${item.product.name}"
                                                                        style="width: 56px; height: 56px; object-fit: cover; border-radius: 8px; border: 1px solid #e5e7eb; flex: 0 0 auto;" />
                                                                </c:when>
                                                                <c:when
                                                                    test="${not empty item.product.productImages and not empty item.product.productImages[0].imageUrl}">
                                                                    <img src="${item.product.productImages[0].imageUrl}"
                                                                        alt="${item.product.name}"
                                                                        style="width: 56px; height: 56px; object-fit: cover; border-radius: 8px; border: 1px solid #e5e7eb; flex: 0 0 auto;" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div
                                                                        style="width: 56px; height: 56px; border-radius: 8px; border: 1px solid #e5e7eb; background: #f3f4f6; flex: 0 0 auto;">
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div>
                                                                <span
                                                                    class="order-summary__product-name">${item.product.name}</span>
                                                                <div
                                                                    style="margin-top: 4px; color: #6b7280; font-size: 12px;">
                                                                    × ${item.quantity}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="order-summary__cell">
                                                        <span class="order-summary__price">
                                                            <fmt:formatNumber value="${item.totalPrice}" type="number"
                                                                groupingUsed="true" /> ₫
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr class="order-summary__row order-summary__row--footer">
                                                <th class="order-summary__cell order-summary__cell--label">Giá gốc</th>
                                                <td class="order-summary__cell">
                                                    <span class="order-summary__price"
                                                        style="color: #999; text-decoration: line-through;">
                                                        <fmt:formatNumber value="${totalOriginalPrice}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </span>
                                                </td>
                                            </tr>
                                            <c:if test="${totalOriginalPrice > totalProducts}">
                                                <tr class="order-summary__row order-summary__row--footer">
                                                    <th class="order-summary__cell order-summary__cell--label">Tiền giảm
                                                    </th>
                                                    <td class="order-summary__cell">
                                                        <span class="order-summary__price" style="color: #e74c3c;">
                                                            -
                                                            <fmt:formatNumber
                                                                value="${totalOriginalPrice - totalProducts}"
                                                                type="number" groupingUsed="true" /> ₫
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <tr class="order-summary__row order-summary__row--footer">
                                                <th class="order-summary__cell order-summary__cell--label">Tạm tính</th>
                                                <td class="order-summary__cell">
                                                    <span class="order-summary__price">
                                                        <fmt:formatNumber value="${totalProducts}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr class="order-summary__row order-summary__row--footer">
                                                <th class="order-summary__cell order-summary__cell--label">Phí vận
                                                    chuyển</th>
                                                <td class="order-summary__cell">
                                                    <span class="order-summary__price--shipping">
                                                        <fmt:formatNumber value="${shippingFee}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </span>
                                                </td>
                                            </tr>
                                            <c:if test="${discount > 0}">
                                                <tr class="order-summary__row order-summary__row--footer">
                                                    <th class="order-summary__cell order-summary__cell--label">Giảm giá
                                                    </th>
                                                    <td class="order-summary__cell">
                                                        <span class="order-summary__price" style="color: #d9534f;">
                                                            -
                                                            <fmt:formatNumber value="${discount}" type="number"
                                                                groupingUsed="true" /> ₫
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <tr class="order-summary__row order-summary__row--footer">
                                                <th class="order-summary__cell order-summary__cell--label">Tổng cộng
                                                </th>
                                                <td class="order-summary__cell">
                                                    <span class="order-summary__price order-summary__price--total">
                                                        <fmt:formatNumber value="${finalAmount}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </span>
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>

                                    <div class="payment">
                                        <ul class="payment__list">
                                            <li class="payment__option">
                                                <input class="payment__radio" type="radio" name="paymentMethod"
                                                    id="payment-cod" value="COD" checked>
                                                <label class="payment__label" for="payment-cod">Trả tiền mặt khi nhận
                                                    hàng (COD)</label>
                                                <div class="payment__description">Thanh toán bằng tiền mặt khi giao
                                                    hàng.</div>
                                            </li>
                                            <li class="payment__option">
                                                <input class="payment__radio" type="radio" name="paymentMethod"
                                                    id="payment-bank" value="bank_transfer">
                                                <label class="payment__label" for="payment-bank">Chuyển khoản ngân
                                                    hàng</label>
                                                <div class="payment__description">Nội dung: [Tên] + [Mã đơn hàng] STK:
                                                    123456789 Ngân hàng: Vietcombank</div>
                                            </li>
                                        </ul>
                                        <p class="payment__privacy-text">
                                            Thông tin cá nhân của bạn sẽ được sử dụng để xử lý đơn hàng, hỗ trợ trải
                                            nghiệm của bạn trên trang web này và cho các mục đích khác được mô tả trong
                                            chính sách riêng tư của chúng tôi.
                                        </p>
                                        <button type="submit" class="button button--primary button--fullwidth">Đặt
                                            hàng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <jsp:include page="footer.jsp"></jsp:include>
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                <script>
                    function openAddressModal() {
                        document.getElementById('addressModal').style.display = 'flex';
                    }

                    function closeAddressModal() {
                        document.getElementById('addressModal').style.display = 'none';
                    }

                    function selectAddress(element) {
                        document.querySelectorAll('.address-option').forEach(opt => opt.classList.remove('selected'));
                        element.classList.add('selected');
                        element.querySelector('input[type="radio"]').checked = true;
                    }

                    function confirmAddress() {
                        var selected = document.querySelector('.address-option.selected') || document.querySelector('.address-option input:checked').closest('.address-option');
                        if (selected) {
                            var id = selected.getAttribute('data-id');
                            var name = selected.getAttribute('data-name');
                            var phone = selected.getAttribute('data-phone');
                            var address = selected.getAttribute('data-address');

                            document.getElementById('selectedAddressDisplay').innerHTML =
                                '<div class="address-info"><span class="address-name">' + name + '</span><span class="address-phone">' + phone + '</span></div>' +
                                '<div class="address-detail">' + address + '</div>';
                            document.getElementById('selectedAddressId').value = id;

                            closeAddressModal();
                        }
                    }
                </script>
                <style>
                    .address-card {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 15px 20px;
                        border: 1px solid #e8e8e8;
                        border-radius: 8px;
                        background: #fff;
                        margin-bottom: 20px;
                    }

                    .address-card-content {
                        flex: 1;
                    }

                    .address-info {
                        margin-bottom: 8px;
                    }

                    .address-name {
                        font-weight: 600;
                        margin-right: 15px;
                    }

                    .address-phone {
                        color: #666;
                    }

                    .address-detail {
                        color: #555;
                        font-size: 14px;
                    }

                    .btn-change {
                        padding: 8px 20px;
                        border: 1px solid #5a9a5a;
                        background: #fff;
                        color: #5a9a5a;
                        border-radius: 4px;
                        cursor: pointer;
                        font-size: 14px;
                        transition: all 0.2s;
                    }

                    .btn-change:hover {
                        background: #5a9a5a;
                        color: #fff;
                    }

                    /* Modal */
                    .address-modal {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        z-index: 9999;
                        align-items: center;
                        justify-content: center;
                    }

                    .modal-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.5);
                    }

                    .modal-container {
                        position: relative;
                        background: #fff;
                        border-radius: 8px;
                        width: 90%;
                        max-width: 600px;
                        max-height: 80vh;
                        display: flex;
                        flex-direction: column;
                    }

                    .modal-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 20px;
                        border-bottom: 1px solid #e8e8e8;
                    }

                    .modal-header h3 {
                        margin: 0;
                        font-size: 18px;
                    }

                    .btn-close {
                        background: none;
                        border: none;
                        font-size: 28px;
                        cursor: pointer;
                        color: #666;
                        padding: 0;
                        width: 30px;
                        height: 30px;
                        line-height: 1;
                    }

                    .modal-body {
                        padding: 20px;
                        overflow-y: auto;
                        flex: 1;
                    }

                    .address-option {
                        display: flex;
                        align-items: center;
                        padding: 15px;
                        border: 2px solid #e8e8e8;
                        border-radius: 8px;
                        margin-bottom: 12px;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .address-option:hover,
                    .address-option.selected {
                        border-color: #5a9a5a;
                        background: #f9fff9;
                    }

                    .address-option-content {
                        flex: 1;
                    }

                    .address-option-header {
                        margin-bottom: 5px;
                    }

                    .address-option-name {
                        font-weight: 600;
                        margin-right: 15px;
                    }

                    .address-option-phone {
                        color: #666;
                    }

                    .address-option-detail {
                        color: #555;
                        font-size: 14px;
                    }

                    .badge-default {
                        display: inline-block;
                        padding: 2px 8px;
                        background: #e8f5e9;
                        color: #2e7d32;
                        font-size: 11px;
                        border-radius: 3px;
                        margin-top: 5px;
                    }

                    .radio-wrapper input {
                        width: 20px;
                        height: 20px;
                        cursor: pointer;
                    }

                    .modal-footer {
                        padding: 15px 20px;
                        border-top: 1px solid #e8e8e8;
                        display: flex;
                        gap: 10px;
                        justify-content: space-between;
                    }

                    .btn-add-new {
                        padding: 10px 20px;
                        border: 1px solid #5a9a5a;
                        background: #fff;
                        color: #5a9a5a;
                        border-radius: 4px;
                        text-decoration: none;
                        font-size: 14px;
                        transition: all 0.2s;
                    }

                    .btn-add-new:hover {
                        background: #f0fff0;
                    }

                    .btn-confirm {
                        padding: 10px 30px;
                        background: #5a9a5a;
                        color: #fff;
                        border: none;
                        border-radius: 4px;
                        cursor: pointer;
                        font-size: 14px;
                        transition: all 0.2s;
                    }

                    .btn-confirm:hover {
                        background: #4a8a4a;
                    }
                </style>
            </body>

            </html>