<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Weekend Deals - Admin</title>

    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/weekend-deals.css">
</head>
<body data-context-path="${pageContext.request.contextPath}">
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="weekend-deals" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main>
        <div class="header">
            <div class="left">
                <h1> Quản lý Weekend Deals</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li>/</li>
                    <li><a class="active" href="${pageContext.request.contextPath}/admin/weekend-deals">Weekend Deals</a></li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/admin/weekend-deal-edit" class="report">
                <i class='bx bx-plus-circle'></i>
                <span>Thêm Deal Mới</span>
            </a>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
            <i class='bx bx-check-circle'></i>
                ${sessionScope.successMessage}
        </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">
            <i class='bx bx-error-circle'></i>
                ${sessionScope.errorMessage}
        </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <div class="bottom-data">
            <div class="orders">
                <div class="header">
                    <h3>Danh sách Weekend Deals</h3>
                    <select id="dealStatusFilter" class="filter-select">
                        <option value="all">Tất cả trạng thái</option>
                        <option value="active">Đang hoạt động</option>
                        <option value="upcoming">Sắp diễn ra</option>
                        <option value="expired">Đã hết hạn</option>
                    </select>
                </div>

                <table>
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Sản phẩm</th>
                        <th>Tiêu đề</th>
                        <th>Giảm giá</th>
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty deals}">
                            <c:forEach items="${deals}" var="deal">
                                <c:set var="isExpired" value="${deal.endDate.time < now}" />
                                <c:set var="isUpcoming" value="${deal.startDate.time > now}" />
                                <c:set var="isActive" value="${!isExpired && !isUpcoming && deal.status == 1}" />

                                <tr class="deal-row" data-status="${isActive ? 'active' : (isUpcoming ? 'upcoming' : 'expired')}">
                                    <td>${deal.id}</td>
                                    <td>
                                        <div class="product-info">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(deal.product.image, 'http')}">
                                                    <img src="${deal.product.image}" alt="${deal.product.name}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${deal.product.image}" alt="${deal.product.name}">
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <p class="product-name">${deal.product.name}</p>
                                                <p class="product-code">${deal.product.productCode}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="deal-title-cell">
                                            <span class="tag-badge">${deal.tag}</span>
                                            <p class="subtitle">${deal.subtitle}</p>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="discount-cell">
                                            <span class="discount-badge">-${deal.discountPercent}%</span>
                                            <p class="price-original">
                                                <fmt:formatNumber value="${deal.product.price}" type="number" groupingUsed="true" />đ
                                            </p>
                                            <p class="price-sale">
                                                <fmt:formatNumber value="${deal.discountedPrice}" type="number" groupingUsed="true" />đ
                                            </p>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="datetime-cell">
                                            <p><i class='bx bx-time-five'></i>
                                                <fmt:formatDate value="${deal.startDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </p>
                                            <p><i class='bx bx-timer'></i>
                                                <fmt:formatDate value="${deal.endDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </p>
                                            <c:if test="${isActive}">
                                                <p class="countdown" data-end-time="${deal.endDate.time}">
                                                    <i class='bx bx-hourglass'></i>
                                                    <span class="countdown-text">Đang tính...</span>
                                                </p>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${deal.status == 0}">
                                                        <span class="status inactive">
                                                            <i class='bx bx-x-circle'></i> Tắt
                                                        </span>
                                            </c:when>
                                            <c:when test="${isActive}">
                                                        <span class="status active">
                                                            <i class='bx bx-check-circle'></i> Đang chạy
                                                        </span>
                                            </c:when>
                                            <c:when test="${isUpcoming}">
                                                        <span class="status upcoming">
                                                            <i class='bx bx-time'></i> Sắp diễn ra
                                                        </span>
                                            </c:when>
                                            <c:otherwise>
                                                        <span class="status expired">
                                                            <i class='bx bx-x'></i> Đã hết hạn
                                                        </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/admin/weekend-deal-edit?id=${deal.id}"
                                               class="btn-action btn-edit" title="Chỉnh sửa">
                                                <i class='bx bx-edit'></i>
                                            </a>
                                            <button type="button"
                                                    class="btn-action btn-toggle"
                                                    data-deal-id="${deal.id}"
                                                    data-current-status="${deal.status}"
                                                    title="${deal.status == 1 ? 'Tắt' : 'Bật'}">
                                                <i class='bx ${deal.status == 1 ? "bx-toggle-right" : "bx-toggle-left"}'></i>
                                            </button>
                                            <button type="button"
                                                    class="btn-action btn-delete"
                                                    data-deal-id="${deal.id}"
                                                    title="Xóa">
                                                <i class='bx bx-trash'></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="no-data">
                                    <i class='bx bx-error-circle'></i>
                                    <p>Chưa có deal nào</p>
                                    <a href="${pageContext.request.contextPath}/admin/weekend-deal-edit" class="report">
                                        <i class='bx bx-plus-circle'></i>
                                        <span>Thêm deal đầu tiên</span>
                                    </a>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
        </section>

        <script src="${pageContext.request.contextPath}/assets/js/admin/script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/admin/weekend-deals.js"></script>
</body>
</html>
