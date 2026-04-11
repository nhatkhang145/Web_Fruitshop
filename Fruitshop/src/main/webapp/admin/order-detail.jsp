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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/order-detail.css"/>
    <title>Chi tiáº¿t ÄÆ¡n hÃ ng #${order.id}</title>
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
                <h1 id="pageTitle">Chi tiáº¿t ÄÆ¡n hÃ ng #${order.id}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/orders">ÄÆ¡n hÃ ng</a></li>
                    <li>/</li>
                    <li>
                        <a href="#" class="active" id="breadcrumbTitle">#${order.id}</a>
                    </li>
                </ul>
            </div>
            <a href="#" class="report" id="printInvoiceBtn" onclick="window.print()">
                <i class="bx bx-printer"></i>
                <span>In HÃ³a Ä‘Æ¡n</span>
            </a>
        </div>

        <div class="bottom-data">
            <div class="order-detail">
                <form id="orderDetailForm" action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="order-detail__form">
                    <input type="hidden" name="orderId" value="${order.id}">

                    <div class="order-detail__main">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Sáº£n pháº©m</legend>
                            <table class="order-detail__item-table">
                                <thead>
                                <tr>
                                    <th>Sáº£n pháº©m</th>
                                    <th>GiÃ¡</th>
                                    <th>Sá»‘ lÆ°á»£ng</th>
                                    <th>Tá»•ng</th>
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
                                Ghi chÃº cá»§a KhÃ¡ch hÃ ng
                            </legend>
                            <p class="order-detail__customer-note">
                                ${not empty order.note ? order.note : "KhÃ´ng cÃ³ ghi chÃº."}
                            </p>
                        </div>
                    </div>

                    <div class="order-detail__sidebar">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">
                                Tráº¡ng thÃ¡i ÄÆ¡n hÃ ng
                            </legend>
                            <div class="order-detail__group">

                                <select id="orderStatus" name="status" class="order-detail__input">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chá» xá»­ lÃ½
                                    </option>
                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Äang xá»­
                                        lÃ½
                                    </option>
                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Äang giao
                                    </option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>HoÃ n
                                        thÃ nh
                                    </option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>ÄÃ£ há»§y
                                    </option>
                                </select>
                                <button type="submit" class="btn-submit order-detail__save-btn">
                                    Cáº­p nháº­t
                                </button>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">KhÃ¡ch hÃ ng</legend>
                            <div class="order-detail__customer-info">
                                <p><strong>${order.fullname}</strong></p>
                                <p>${order.phone}</p>
                                <hr/>
                                <p>
                                    <strong>Äá»‹a chá»‰ Giao hÃ ng:</strong><br/>
                                    ${order.address}
                                </p>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Thanh toÃ¡n</legend>
                            <ul class="order-detail__financials">
                                <li>
                                    <span>Tá»•ng tiá»n hÃ ng:</span>
                                    <span><fmt:formatNumber value="${order.totalProductsMoney}" pattern="#,###" /> VND</span>
                                </li>
                                <li>
                                    <span>Váº­n chuyá»ƒn:</span>
                                    <span><fmt:formatNumber value="${order.shippingFee}" pattern="#,###" /> VND</span>
                                </li>
                                <c:if test="${order.discountAmount > 0}">
                                    <li>
                                        <span>Giáº£m giÃ¡:</span>
                                        <span>-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> VND</span>
                                    </li>
                                </c:if>
                                <li class="total">
                                    <strong>Tá»•ng cá»™ng:</strong>
                                    <strong><fmt:formatNumber value="${order.finalAmount}" pattern="#,###" /> VND</strong>
                                </li>
                            </ul>
                            <hr/>
                            <p><strong>P.thá»©c:</strong> ${order.paymentMethod}</p>
                            <p>
                                <strong>TT Thanh toÃ¡n:</strong>
                                <span class="status ${order.paymentStatus == 1 ? 'completed' : 'pending'}">
                                    ${order.paymentStatus == 1 ? 'ÄÃ£ thanh toÃ¡n' : 'ChÆ°a thanh toÃ¡n'}
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/order-detail.css"/>
    <title>Chi tiáº¿t ÄÆ¡n hÃ ng #${order.id}</title>
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
                <h1 id="pageTitle">Chi tiáº¿t ÄÆ¡n hÃ ng #${order.id}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/orders">ÄÆ¡n hÃ ng</a></li>
                    <li>/</li>
                    <li>
                        <a href="#" class="active" id="breadcrumbTitle">#${order.id}</a>
                    </li>
                </ul>
            </div>
            <a href="#" class="report" id="printInvoiceBtn" onclick="window.print()">
                <i class="bx bx-printer"></i>
                <span>In HÃ³a Ä‘Æ¡n</span>
            </a>
        </div>

        <div class="bottom-data">
            <div class="order-detail">
                <form id="orderDetailForm" action="${pageContext.request.contextPath}/admin/order-update-status" method="post" class="order-detail__form">
                    <input type="hidden" name="orderId" value="${order.id}">

                    <div class="order-detail__main">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Sáº£n pháº©m</legend>
                            <table class="order-detail__item-table">
                                <thead>
                                <tr>
                                    <th>Sáº£n pháº©m</th>
                                    <th>GiÃ¡</th>
                                    <th>Sá»‘ lÆ°á»£ng</th>
                                    <th>Tá»•ng</th>
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
                                Ghi chÃº cá»§a KhÃ¡ch hÃ ng
                            </legend>
                            <p class="order-detail__customer-note">
                                ${not empty order.note ? order.note : "KhÃ´ng cÃ³ ghi chÃº."}
                            </p>
                        </div>
                    </div>

                    <div class="order-detail__sidebar">
                        <div class="order-detail__card">
                            <legend class="order-detail__legend">
                                Tráº¡ng thÃ¡i ÄÆ¡n hÃ ng
                            </legend>
                            <div class="order-detail__group">

                                <select id="orderStatus" name="status" class="order-detail__input">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chá» xá»­ lÃ½
                                    </option>
                                    <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>Äang xá»­
                                        lÃ½
                                    </option>
                                    <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>Äang giao
                                    </option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>HoÃ n
                                        thÃ nh
                                    </option>
                                    <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>ÄÃ£ há»§y
                                    </option>
                                </select>
                                <button type="submit" class="btn-submit order-detail__save-btn">
                                    Cáº­p nháº­t
                                </button>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">KhÃ¡ch hÃ ng</legend>
                            <div class="order-detail__customer-info">
                                <p><strong>${order.fullname}</strong></p>
                                <p>${order.phone}</p>
                                <hr/>
                                <p>
                                    <strong>Äá»‹a chá»‰ Giao hÃ ng:</strong><br/>
                                    ${order.address}
                                </p>
                            </div>
                        </div>

                        <div class="order-detail__card">
                            <legend class="order-detail__legend">Thanh toÃ¡n</legend>
                            <ul class="order-detail__financials">
                                <li>
                                    <span>Tá»•ng tiá»n hÃ ng:</span>
                                    <span><fmt:formatNumber value="${order.totalProductsMoney}" pattern="#,###" /> VND</span>
                                </li>
                                <li>
                                    <span>Váº­n chuyá»ƒn:</span>
                                    <span><fmt:formatNumber value="${order.shippingFee}" pattern="#,###" /> VND</span>
                                </li>
                                <c:if test="${order.discountAmount > 0}">
                                    <li>
                                        <span>Giáº£m giÃ¡:</span>
                                        <span>-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###" /> VND</span>
                                    </li>
                                </c:if>
                                <li class="total">
                                    <strong>Tá»•ng cá»™ng:</strong>
                                    <strong><fmt:formatNumber value="${order.finalAmount}" pattern="#,###" /> VND</strong>
                                </li>
                            </ul>
                            <hr/>
                            <p><strong>P.thá»©c:</strong> ${order.paymentMethod}</p>
                            <p>
                                <strong>TT Thanh toÃ¡n:</strong>
                                <span class="status ${order.paymentStatus == 1 ? 'completed' : 'pending'}">
                                    ${order.paymentStatus == 1 ? 'ÄÃ£ thanh toÃ¡n' : 'ChÆ°a thanh toÃ¡n'}
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
