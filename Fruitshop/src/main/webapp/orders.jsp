<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đơn mua - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css" />
</head>

<body>
<jsp:include page="header.jsp"></jsp:include>

<div class="breadcrumb">
    <div class="container">
        <a href="${pageContext.request.contextPath}/">Trang chủ</a> &gt;
        <a href="${pageContext.request.contextPath}/profile">Tài khoản</a> &gt; <span>Đơn mua</span>
    </div>
</div>

<section class="profile-section">
    <div class="container">
        <div class="profile-container">
            <aside class="profile-sidebar">
                <div class="profile-user-brief">
                    <img src="${sessionScope.account.avatar != null ? sessionScope.account.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}" alt="Avatar" class="brief-avatar"
                         id="briefAvatar" />
                    <div class="brief-info">
                        <span class="brief-name">${sessionScope.account.fullName}</span>
                        <a href="#" class="brief-edit"><i class="fa-solid fa-pen"></i> Sửa hồ sơ</a>
                    </div>
                </div>

                <ul class="profile-menu">
                    <li class="profile-menu-item ">
                        <a href="profile"><i class="fa-regular fa-user"></i> Hồ sơ của tôi</a>
                    </li>
                    <li class="profile-menu-item active ">
                        <a href="orders"><i class="fa-solid fa-box-open"></i> Đơn mua</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="addresses"><i class="fa-solid fa-location-dot"></i> Địa chỉ</a>
                    </li>
                    <li class="profile-menu-item ">
                        <a href="change-password.jsp"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="wishlist"><i class="fa-regular fa-heart"></i> Yêu thích</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="logout" style="color: red;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                    </li>
                </ul>
            </aside>

            <main class="profile-content orders-content">
                <div class="orders-header">
                    <h2>Đơn mua của tôi</h2>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success"
                         style="background: #d4edda; color: #155724; padding: 12px; margin-bottom: 15px; border-radius: 5px;">
                            ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger"
                         style="background: #f8d7da; color: #721c24; padding: 12px; margin-bottom: 15px; border-radius: 5px;">
                            ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <div class="orders-tabs">
                    <a href="${pageContext.request.contextPath}/orders?status=all"
                       class="tab-item ${empty filterStatus || filterStatus == 'all' ? 'active' : ''}">
                        Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/orders?status=pending"
                       class="tab-item ${filterStatus == 'pending' ? 'active' : ''}">
                        Chờ xác nhận
                        <c:if test="${pendingCount > 0}">
                            <span class="badge">${pendingCount}</span>
                        </c:if>
                    </a>
                    <a href="${pageContext.request.contextPath}/orders?status=processing"
                       class="tab-item ${filterStatus == 'processing' ? 'active' : ''}">
                        Đã xác nhận
                        <c:if test="${processingCount > 0}">
                            <span class="badge">${processingCount}</span>
                        </c:if>
                    </a>
                    <a href="${pageContext.request.contextPath}/orders?status=shipped"
                       class="tab-item ${filterStatus == 'shipped' ? 'active' : ''}">
                        Đang giao
                        <c:if test="${shippedCount > 0}">
                            <span class="badge">${shippedCount}</span>
                        </c:if>
                    </a>
                    <a href="${pageContext.request.contextPath}/orders?status=completed"
                       class="tab-item ${filterStatus == 'completed' ? 'active' : ''}">
                        Hoàn thành
                    </a>
                    <a href="${pageContext.request.contextPath}/orders?status=cancelled"
                       class="tab-item ${filterStatus == 'cancelled' ? 'active' : ''}">
                        Đã hủy
                    </a>
                </div>

                <div class="orders-list">
                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="empty-state" style="text-align: center; padding: 50px 0;">
                                <i class="fa-solid fa-box-open" style="font-size: 50px; color: #ccc;"></i>
                                <p style="margin-top: 20px;">Chưa có đơn hàng nào</p>
                                <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary"
                                   style="margin-top: 15px; display: inline-block; padding: 10px 30px; background: var(--primary-color); color: #fff; border-radius: 5px; text-decoration: none;">
                                    Mua sắm ngay
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${orders}" var="order">
                                <div class="order-card"
                                     style="border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px;">
                                    <div class="order-card__header"
                                         style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee;">
                                        <div class="order-info">
                                            <span class="order-id" style="font-weight: 600;">Mã đơn: #${order.id}</span>
                                            <span class="order-date" style="color: #666; margin-left: 15px;">
                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                              </span>
                                        </div>
                                        <span class="order-status status-${order.status}"
                                              style="padding: 5px 15px; border-radius: 20px; background: #f0f0f0; font-size: 13px;">
                                                ${order.statusDisplay}
                                        </span>
                                    </div>

                                    <div class="order-card__body" style="margin-bottom: 15px;">
                                        <div class="order-address" style="display: flex; gap: 10px; color: #555; font-size: 14px;">
                                            <i class="fa-solid fa-location-dot" style="margin-top: 3px;"></i>
                                            <div>
                                                <strong>${order.fullname}</strong> - ${order.phone}<br />
                                                    ${order.address}
                                            </div>
                                        </div>
                                    </div>

                                    <div class="order-card__footer"
                                         style="display: flex; justify-content: space-between; align-items: center;">
                                        <div class="order-total">
                                            <span style="color: #666;">Tổng tiền:</span>
                                            <strong class="price"
                                                    style="color: var(--primary-color); font-size: 18px; margin-left: 10px;">
                                                <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true" />₫
                                            </strong>
                                        </div>
                                        <div class="order-actions" style="display: flex; gap: 10px;">
                                            <a href="${pageContext.request.contextPath}/order-detail?id=${order.id}"
                                               class="btn btn-outline"
                                               style="padding: 8px 20px; border: 1px solid var(--primary-color); color: var(--primary-color); border-radius: 5px; text-decoration: none;">
                                                Xem chi tiết
                                            </a>
                                            <c:if test="${order.status == 'pending' || order.status == 'processing'}">
                                                <form action="${pageContext.request.contextPath}/orders" method="post"
                                                      style="display: inline;"
                                                      onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?');">
                                                    <input type="hidden" name="action" value="cancel" />
                                                    <input type="hidden" name="orderId" value="${order.id}" />
                                                    <button type="submit" class="btn btn-danger"
                                                            style="padding: 8px 20px; background: #dc3545; color: #fff; border: none; border-radius: 5px; cursor: pointer;">Hủy
                                                        đơn</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${order.status == 'completed' || order.status == 'cancelled'}">
                                                <form action="${pageContext.request.contextPath}/repurchase" method="POST"
                                                      style="display: inline;">
                                                    <input type="hidden" name="orderId" value="${order.id}" />
                                                    <button type="submit" class="btn btn-primary"
                                                            style="padding: 8px 20px; background: var(--primary-color); color: #fff; border: none; border-radius: 5px; cursor: pointer;">
                                                        Mua lại
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp"></jsp:include>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>

</html>