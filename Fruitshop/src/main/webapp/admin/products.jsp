<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Sản phẩm</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/products.css" />

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

</head>

<body>

<jsp:include page="/admin/sidebar.jsp">
    <jsp:param name="activePage" value="products" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/header.jsp" />

    <main>
        <div class="header">
            <div class="left">
                <h1>Quản lý sản phẩm</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Quản lý</a></li>
                    <li>/</li>
                    <li><a href="#" class="active">Sản phẩm</a></li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/admin/product-form" class="report">
                <i class="bx bx-plus"></i>
                <span>Thêm sản phẩm</span>
            </a>
        </div>

        <c:set var="activeCount" value="0" />
        <c:set var="hiddenCount" value="0" />
        <c:set var="lowStockCount" value="0" />
        <c:forEach items="${products}" var="p">
            <c:if test="${p.status == 1}">
                <c:set var="activeCount" value="${activeCount + 1}" />
            </c:if>
            <c:if test="${p.status != 1}">
                <c:set var="hiddenCount" value="${hiddenCount + 1}" />
            </c:if>
            <c:if test="${p.quantity < 10 && p.quantity >= 0}">
                <c:set var="lowStockCount" value="${lowStockCount + 1}" />
            </c:if>
        </c:forEach>

        <ul class="insights">
            <li>
                <i class="bx bx-box"></i>
                <span class="info">
                  <h3>${products.size()}</h3>
                  <p>Tổng sản phẩm</p>
                </span>
            </li>
            <li>
                <i class="bx bx-show"></i>
                <span class="info">
                  <h3>${activeCount}</h3>
                  <p>Đang hoạt động</p>
                </span>
            </li>
            <li>
                <i class="bx bx-hide"></i>
                <span class="info">
                  <h3>${hiddenCount}</h3>
                  <p>Sản phẩm ẩn</p>
                </span>
            </li>
            <li>
                <i class="bx bxs-error-circle"></i>
                <span class="info">
                  <h3>${lowStockCount}</h3>
                  <p>Sắp hết hàng</p>
                </span>
            </li>
        </ul>

        <div class="bottom-data">
            <div class="orders">
                <div class="header">
                    <h3>Danh sách sản phẩm</h3>
                </div>

                <table id="productTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá bán</th>
                        <th>Tồn kho</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${products}" var="p">
                        <tr>
                            <td>#${p.id}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.image}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(p.image, 'http')}">
                                                <img src="${p.image}" alt="${p.name}" class="product-img" />
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${p.image}" alt="${p.name}" class="product-img" />
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/50" alt="No Image" class="product-img" />
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${p.name}</td>
                            <td>
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="đ" />
                            </td>
                            <td>${p.quantity}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.quantity > 0}">
                                        <span class="status active">Còn hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status out-stock">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/product-form?id=${p.id}" class="action-btn edit" title="Sửa">
                                    <i class="bx bx-edit"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/product-delete?id=${p.id}" class="action-btn delete" title="Xóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm: ${p.name}?');">
                                    <i class="bx bx-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<script>
    $(document).ready(function () {
        $('#productTable').DataTable({
            "order": [[0, "desc"]],
            "pageLength": 10,
            "language": {
                "search": "Tìm kiếm:",
                "lengthMenu": "Hiển thị _MENU_ dòng",
                "info": "Trang _PAGE_ / _PAGES_",
                "paginate": { "first": "«", "last": "»", "next": ">", "previous": "<" },
                "zeroRecords": "Không tìm thấy sản phẩm nào"
            }
        });
    });
</script>

</body>

</html>