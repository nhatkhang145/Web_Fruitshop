<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty deal ? 'Thêm' : 'Sửa'} Weekend Deal - Admin</title>

    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/weekend-deal-edit.css">
</head>

<body data-context-path="${pageContext.request.contextPath}" data-has-deal="${not empty deal}">
<jsp:include page="/admin/sidebar.jsp">
    <jsp:param name="activePage" value="weekend-deals" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/header.jsp" />

    <main>
        <div class="header">
            <div class="left">
                <h1>${empty deal ? ' Thêm' : ' Sửa'} Weekend Deal</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li>/</li>
                    <li><a href="${pageContext.request.contextPath}/admin/weekend-deals">Weekend
                        Deals</a></li>
                    <li>/</li>
                    <c:choose>
                        <c:when test="${not empty deal}">
                            <li><a class="active" href="${pageContext.request.contextPath}/admin/weekend-deal-edit?id=${deal.id}">Chỉnh sửa</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a class="active" href="${pageContext.request.contextPath}/admin/weekend-deal-edit">Thêm mới</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <div class="bottom-data">
            <div class="deal-form-container">
                <c:set var="startDateValue" value="" />
                <c:set var="endDateValue" value="" />
                <c:if test="${not empty deal.startDate}">
                    <fmt:formatDate value="${deal.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="startDateValue" />
                </c:if>
                <c:if test="${not empty deal.endDate}">
                    <fmt:formatDate value="${deal.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="endDateValue" />
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/weekend-deal-edit" method="POST"
                      id="dealForm">
                    <input type="hidden" name="dealId" value="${deal.id}">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="productId">
                                <i class='bx bx-package'></i>
                                Sản phẩm <span class="required">*</span>
                            </label>
                            <select name="productId" id="productId" class="form-control" required
                            >
                                <option value="">-- Chọn sản phẩm --</option>
                                <c:forEach items="${products}" var="product">
                                    <option value="${product.id}" data-name="${product.name}"
                                            data-price="${product.price}" data-image="${product.image}"
                                        ${deal.productId==product.id ? 'selected' : '' }>
                                            ${product.name} -
                                        <fmt:formatNumber value="${product.price}" type="number"
                                                          groupingUsed="true" />đ
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="form-help">Chọn sản phẩm muốn áp dụng deal</small>
                        </div>


                        <div class="form-group">
                            <label for="tag">
                                <i class='bx bx-purchase-tag'></i>
                                Tag <span class="required">*</span>
                            </label>
                            <input type="text" name="tag" id="tag" class="form-control"
                                   value="${deal.tag}" placeholder="VD: Mùa Xuân, Mùa Hạ, Black Friday"
                                   required maxlength="100">
                            <small class="form-help">Tag ngắn gọn để hiển thị trên sản phẩm</small>
                        </div>


                        <div class="form-group">
                            <label for="subtitle">
                                <i class='bx bx-detail'></i>
                                Phụ đề
                            </label>
                            <input type="text" name="subtitle" id="subtitle" class="form-control"
                                   value="${deal.subtitle}" placeholder="VD: Giảm giá đặc biệt"
                                   maxlength="255">
                        </div>


                        <div class="form-group">
                            <label for="discountPercent">
                                <i class='bx bx-purchase-tag'></i>
                                Giảm giá (%) <span class="required">*</span>
                            </label>
                            <input type="number" name="discountPercent" id="discountPercent"
                                   class="form-control" value="${deal.discountPercent}" placeholder="0"
                                   required min="1" max="99">
                            <small class="form-help">Từ 1% đến 99%</small>
                        </div>


                        <div class="form-group">
                            <label for="sortOrder">
                                <i class='bx bx-sort'></i>
                                Thứ tự hiển thị
                            </label>
                            <input type="number" name="sortOrder" id="sortOrder" class="form-control"
                                   value="${empty deal.sortOrder ? 0 : deal.sortOrder}" min="0"
                                   placeholder="0">
                            <small class="form-help">Số càng nhỏ ưu tiên càng cao</small>
                        </div>


                        <div class="form-group">
                            <label for="startDate">
                                <i class='bx bx-calendar-check'></i>
                                Ngày bắt đầu <span class="required">*</span>
                            </label>
                            <input type="datetime-local" name="startDate" id="startDate"
                                   class="form-control"
                                   value="${startDateValue}"
                                   required>
                        </div>


                        <div class="form-group">
                            <label for="endDate">
                                <i class='bx bx-calendar-x'></i>
                                Ngày kết thúc <span class="required">*</span>
                            </label>
                            <input type="datetime-local" name="endDate" id="endDate"
                                   class="form-control"
                                   value="${endDateValue}"
                                   required>
                        </div>


                        <div class="form-group">
                            <label>
                                <i class='bx bx-toggle-left'></i>
                                Trạng thái
                            </label>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <label class="toggle-switch">
                                    <input type="checkbox" name="status" value="1" ${empty deal ||
                                            deal.status==1 ? 'checked' : '' }>
                                    <span class="toggle-slider"></span>
                                </label>
                                <span id="statusText">${empty deal || deal.status == 1 ? 'Bật' :
                                        'Tắt'}</span>
                            </div>
                            <small class="form-help">Tắt để ẩn deal khỏi trang chủ</small>
                        </div>
                    </div>


                    <div class="preview-card" id="previewCard" style="display: none;">
                        <h3><i class='bx bx-show'></i> Xem trước Deal</h3>
                        <div class="preview-content">
                            <div class="preview-image">
                                <img id="previewImg" src="" alt="Product">
                            </div>
                            <div class="preview-info">
                                <div class="preview-badges">
                                    <span class="preview-badge" id="previewDiscount">-0%</span>
                                    <span class="preview-tag" id="previewTag">Tag</span>
                                </div>
                                <h4 id="previewTitle">Tên sản phẩm</h4>
                                <p id="previewSubtitle">Phụ đề</p>
                                <div class="preview-prices">
                                    <span class="preview-price" id="previewSalePrice">0đ</span>
                                    <span class="preview-original" id="previewOriginalPrice">0đ</span>
                                </div>
                                <div class="preview-timer">
                                    <i class='bx bx-time-five'></i>
                                    <span id="previewTime">Chọn thời gian để xem</span>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            <i class='bx bx-save'></i>
                            ${empty deal ? 'Thêm Deal' : 'Cập nhật'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/weekend-deals"
                           class="btn btn-secondary">
                            <i class='bx bx-x'></i>
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/script.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/weekend-deal-edit.js"></script>
</body>

</html>