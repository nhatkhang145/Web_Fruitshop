<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sản phẩm theo danh mục | Admin</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/category-products.css" />
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="categories" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main>
        <div class="header">
            <div class="left">
                <h1>Sản phẩm thuộc danh mục: ${category.name}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Quản lý</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a href="#" class="active">${category.name}</a></li>
                </ul>
            </div>
        </div>

        <c:if test="${param.success == 'assigned'}">
            <div class="alert success">Đã thêm sản phẩm vào danh mục thành công.</div>
        </c:if>
        <c:if test="${param.success == 'removed'}">
            <div class="alert success">Đã bỏ sản phẩm khỏi danh mục thành công.</div>
        </c:if>
        <c:if test="${param.success == 'created'}">
            <div class="alert success">Đã lưu sản phẩm và cập nhật danh mục thành công.</div>
        </c:if>

        <div class="action-row">
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/categories">
                <i class='bx bx-arrow-back'></i>
                <span>Quay lại danh mục</span>
            </a>

            <button type="button" class="btn btn-primary" id="openAssignModalBtn">
                <i class='bx bx-plus-circle'></i>
                <span>Thêm sản phẩm vào danh mục này</span>
            </button>

            <a class="btn btn-dark" href="${pageContext.request.contextPath}/admin/product-form?categoryId=${category.id}&fromCategoryId=${category.id}">
                <i class='bx bx-package'></i>
                <span>Tạo sản phẩm mới trong danh mục</span>
            </a>
        </div>

        <div class="card">
            <div class="card-header">
                <h3>Danh sách sản phẩm (${productsInCategory.size()})</h3>
            </div>

            <c:choose>
                <c:when test="${not empty productsInCategory}">
                    <div class="table-wrap">
                        <table class="product-table">
                            <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Giá</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${productsInCategory}" var="p">
                                <tr>
                                    <td>
                                        <div class="product-cell">
                                            <a class="product-thumb-link" href="${pageContext.request.contextPath}/admin/product-form?id=${p.id}&fromCategoryId=${category.id}">
                                                <c:choose>
                                                    <c:when test="${not empty p.image}">
                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(p.image, 'http')}">
                                                                <img src="${p.image}" alt="${p.name}" class="product-thumb" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}" class="product-thumb" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/48x48?text=N/A" alt="${p.name}" class="product-thumb" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                            <div class="product-text">
                                                <a class="product-name" href="${pageContext.request.contextPath}/admin/product-form?id=${p.id}&fromCategoryId=${category.id}">${p.name}</a>
                                                <span class="product-code">SKU: ${empty p.productCode ? 'N/A' : p.productCode}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="price-col">
                                            <strong><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" /> VND</strong>
                                            <c:if test="${p.salePrice > 0}">
                                                <small>KM: <fmt:formatNumber value="${p.salePrice}" type="number" groupingUsed="true" /> VND</small>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>${p.quantity}</td>
                                    <td>
                                        <span class="status ${p.status == 1 ? 'active' : 'inactive'}">
                                                ${p.status == 1 ? 'Hiển thị' : 'Ẩn'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="row-actions">
                                            <a class="btn-mini edit" href="${pageContext.request.contextPath}/admin/product-form?id=${p.id}&fromCategoryId=${category.id}">Sửa</a>
                                            <form action="${pageContext.request.contextPath}/admin/category-products-remove" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm khỏi danh mục?');">
                                                <input type="hidden" name="categoryId" value="${category.id}" />
                                                <input type="hidden" name="productId" value="${p.id}" />
                                                <button type="submit" class="btn-mini remove">Xóa</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        Danh mục này chưa có sản phẩm.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<div class="modal" id="assignProductModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Thêm sản phẩm vào danh mục: ${category.name}</h3>
            <button type="button" class="modal-close" id="closeAssignModalBtn">&times;</button>
        </div>

        <div class="modal-body">
            <c:choose>
                <c:when test="${not empty unassignedProducts}">
                    <form action="${pageContext.request.contextPath}/admin/category-products-assign" method="post">
                        <input type="hidden" name="categoryId" value="${category.id}" />

                        <label for="productSelect">Chọn sản phẩm chưa thuộc danh mục</label>
                        <select id="productSelect" name="productId" required>
                            <option value="">-- Chọn sản phẩm --</option>
                            <c:forEach items="${unassignedProducts}" var="u">
                                <option value="${u.id}">#${u.id} - ${u.name}</option>
                            </c:forEach>
                        </select>

                        <div class="modal-actions">
                            <button type="button" class="btn btn-secondary" id="cancelAssignBtn">ủy</button>
                            <button type="submit" class="btn btn-primary">Thêm vào danh mục</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        Không có sản phẩm nào đang ở trạng thái chưa gán danh mục.
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn btn-secondary" id="cancelAssignOnlyBtn">Đóng</button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/category-products.js"></script>
</body>

</html>
