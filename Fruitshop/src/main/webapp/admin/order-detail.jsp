<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/order-detail.css"/>
    <title>Chi tiết Đơn hàng #${order.id}</title>
</head>

<body>

<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="orders"/>
</jsp:include>

<div class="content">

    <jsp:include page="/admin/layout/header.jsp"/>

    <main>
        <div class="header">
            <div class="left">
                <h1 id="pageTitle">Chi tiết Đơn hàng #${order.id}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
                    <li>/</li>
                    <li>
                        <a href="#" class="active" id="breadcrumbTitle">#${order.id}</a>
                    </li>
                </ul>
            </div>
            <a href="#" class="report" id="printInvoiceBtn" onclick="window.print()">
                <i class="bx bx-printer"></i>
                <span>In Hóa đơn</span>
            </a>
        </div>

        <div class="bottom-data">
            <div class="order-detail">
                <form id="orderDetailForm" action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="order-detail__form">
                    <input type="hidden" name="orderId" value="${order.id}">

                    <div class="order-detail__main">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Sản phẩm</legend>
                            <table class="order-detail__item-table">
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
                                                    <c:when test="${fn:startsWith(item.product.image, 'http')}">
                                                        <img src="${item.product.image}" alt="${item.productName}"
                                                             onerror="this.src='https://via.placeholder.com/40x40'"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/${item.product.image}"
                                                             alt="${item.productName}"
                                                             onerror="this.src='https://via.placeholder.com/40x40'"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="item-info">
                                                    <p>${item.productName}</p>
                                                    <small>ID: ${item.productId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><fmt:formatNumber value="${item.price}" pattern="#,###" /> VND</td>
                                        <td>x ${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.total}" pattern="#,###" /> VND</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">
                                Ghi chú của Khách hàng
                            </legend>
                            <p class="order-detail__customer-note">
                                ${not empty order.note ? order.note : "Không có ghi chú."}
                            </p>
                        </div>
                    </div>

                    <div class="order-detail__sidebar">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">
                                Trạng thái Đơn hàng
                            </legend>
                            <div class="order-detail__group">

                                <select id="orderStatus" name="status" class="order-detail__input">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chờ xử lý
                                    </option>
                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Đang xử
                                        lý
                                    </option>
                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Đang giao
                                    </option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Hoàn
                                        thành
                                    </option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Đã hủy
                                    </option>
                                </select>
                                <button type="submit" class="btn-submit order-detail__save-btn">
                                    Cập nhật
                                </button>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Khách hàng</legend>
                            <div class="order-detail__customer-info">
                                <p><strong>${order.fullname}</strong></p>
                                <p>${order.phone}</p>
                                <hr/>
                                <p>
                                    <strong>Địa chỉ Giao hàng:</strong><br/>
                                    ${order.address}
                                </p>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Thanh toán</legend>
                            <ul class="order-detail__financials">
                                <li>
                                    <span>Tổng tiền hàng:</span>
                                    <span><fmt:formatNumber value="${order.totalProductsMoney}" pattern="#,###" /> VND</span>
                                </li>
                                <li>
                                    <span>Vận chuyển:</span>
                                    <span><fmt:formatNumber value="${order.shippingFee}" pattern="#,###" /> VND</span>
                                </li>
                                <c:if test="${order.discountAmount > 0}">
                                    <li>
                                        <span>Giảm giá:</span>
                                        <span>-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> VND</span>
                                    </li>
                                </c:if>
                                <li class="total">
                                    <strong>Tổng cộng:</strong>
                                    <strong><fmt:formatNumber value="${order.finalAmount}" pattern="#,###" /> VND</strong>
                                </li>
                            </ul>
                            <hr/>
                            <p><strong>P.thức:</strong> ${order.paymentMethod}</p>
                            <p>
                                <strong>TT Thanh toán:</strong>
                                <span class="status ${order.paymentStatus == 1 ? 'completed' : 'pending'}">
                                    ${order.paymentStatus == 1 ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                </span>
                            </p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>


</body>
</html><%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/order-detail.css"/>
    <title>Chi tiết Đơn hàng #${order.id}</title>
</head>

<body>

<jsp:include page="/admin/sidebar.jsp">
    <jsp:param name="activePage" value="orders"/>
</jsp:include>

<div class="content">

    <jsp:include page="/admin/header.jsp"/>

    <main>
        <div class="header">
            <div class="left">
                <h1 id="pageTitle">Chi tiết Đơn hàng #${order.id}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
                    <li>/</li>
                    <li>
                        <a href="#" class="active" id="breadcrumbTitle">#${order.id}</a>
                    </li>
                </ul>
            </div>
            <a href="#" class="report" id="printInvoiceBtn" onclick="window.print()">
                <i class="bx bx-printer"></i>
                <span>In Hóa đơn</span>
            </a>
        </div>

        <div class="bottom-data">
            <div class="order-detail">
                <form id="orderDetailForm" action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="order-detail__form">
                    <input type="hidden" name="orderId" value="${order.id}">

                    <div class="order-detail__main">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Sản phẩm</legend>
                            <table class="order-detail__item-table">
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
                                                    <c:when test="${fn:startsWith(item.product.image, 'http')}">
                                                        <img src="${item.product.image}" alt="${item.productName}"
                                                             onerror="this.src='https://via.placeholder.com/40x40'"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/${item.product.image}"
                                                             alt="${item.productName}"
                                                             onerror="this.src='https://via.placeholder.com/40x40'"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="item-info">
                                                    <p>${item.productName}</p>
                                                    <small>ID: ${item.productId}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><fmt:formatNumber value="${item.price}" pattern="#,###" /> VND</td>
                                        <td>x ${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.total}" pattern="#,###" /> VND</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">
                                Ghi chú của Khách hàng
                            </legend>
                            <p class="order-detail__customer-note">
                                ${not empty order.note ? order.note : "Không có ghi chú."}
                            </p>
                        </div>
                    </div>

                    <div class="order-detail__sidebar">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">
                                Trạng thái Đơn hàng
                            </legend>
                            <div class="order-detail__group">

                                <select id="orderStatus" name="status" class="order-detail__input">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chờ xử lý
                                    </option>
                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Đang xử
                                        lý
                                    </option>
                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Đang giao
                                    </option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Hoàn
                                        thành
                                    </option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Đã hủy
                                    </option>
                                </select>
                                <button type="submit" class="btn-submit order-detail__save-btn">
                                    Cập nhật
                                </button>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Khách hàng</legend>
                            <div class="order-detail__customer-info">
                                <p><strong>${order.fullname}</strong></p>
                                <p>${order.phone}</p>
                                <hr/>
                                <p>
                                    <strong>Địa chỉ Giao hàng:</strong><br/>
                                    ${order.address}
                                </p>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Thanh toán</legend>
                            <ul class="order-detail__financials">
                                <li>
                                    <span>Tổng tiền hàng:</span>
                                    <span><fmt:formatNumber value="${order.totalProductsMoney}" pattern="#,###" /> VND</span>
                                </li>
                                <li>
                                    <span>Vận chuyển:</span>
                                    <span><fmt:formatNumber value="${order.shippingFee}" pattern="#,###" /> VND</span>
                                </li>
                                <c:if test="${order.discountAmount > 0}">
                                    <li>
                                        <span>Giảm giá:</span>
                                        <span>-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> VND</span>
                                    </li>
                                </c:if>
                                <li class="total">
                                    <strong>Tổng cộng:</strong>
                                    <strong><fmt:formatNumber value="${order.finalAmount}" pattern="#,###" /> VND</strong>
                                </li>
                            </ul>
                            <hr/>
                            <p><strong>P.thức:</strong> ${order.paymentMethod}</p>
                            <p>
                                <strong>TT Thanh toán:</strong>
                                <span class="status ${order.paymentStatus == 1 ? 'completed' : 'pending'}">
                                    ${order.paymentStatus == 1 ? 'Đã thanh toán' : 'Chưa thanh toán'}
                                </span>
                            </p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>

</body>
</html>