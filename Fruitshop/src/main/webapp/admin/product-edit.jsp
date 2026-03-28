<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="product" scope="request" class="model.Product" />

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${product.id > 0 ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/style.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/product-edit.css" />
</head>

<body data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/admin/sidebar.jsp">
    <jsp:param name="activePage" value="products" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/header.jsp" />

    <main>
        <div class="header">
            <div class="left">
                <h1 id="pageTitle">${product.id > 0 ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li>
                        <a href="#" class="active">${product.id > 0 ? 'Chỉnh sửa' : 'Tạo mới'}</a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="bottom-data">
            <div class="product-edit">
                <form id="productForm" action="${pageContext.request.contextPath}/admin/product-save" method="post"
                      enctype="multipart/form-data">

                    <input type="hidden" name="id" value="${product.id > 0 ? product.id : 0}">
                    <input type="hidden" name="currentImage" value="${product.image}">

                    <div class="product-edit__form-left">

                        <div class="form-input">
                            <label class="form-label" for="productName">Tên sản phẩm <span class="required-mark">*</span></label>
                            <input type="text" id="productName" name="name" class="form-control" value="${product.name}"
                                   placeholder="Nhập tên sản phẩm..." required autocomplete="off" />
                        </div>

                        <div class="form-input">
                            <label class="form-label" for="category">Danh mục <span class="required-mark">*</span></label>
                            <select id="category" name="categoryId" class="form-select" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.id}" ${product.categoryId==c.id ? 'selected' : '' }>
                                            ${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-input-row">
                            <div class="form-input">
                                <label class="form-label" for="regularPrice">Giá bán (VNĐ) <span
                                        class="required-mark">*</span></label>
                                <input type="number" id="regularPrice" name="price" class="form-control"
                                       value="<fmt:formatNumber value='${product.price}' pattern='#'/>" placeholder="0" required />
                            </div>
                            <div class="form-input">
                                <label class="form-label" for="salePrice">Giá khuyến mãi (VNĐ)</label>
                                <input type="number" id="salePrice" name="salePrice" class="form-control"
                                       value="<fmt:formatNumber value='${product.salePrice}' pattern='#'/>" placeholder="0" />
                            </div>
                        </div>

                        <div class="form-input-row">
                            <div class="form-input">
                                <label class="form-label" for="productCode">Mã SKU</label>
                                <input type="text" id="productCode" name="productCode" class="form-control"
                                       value="${product.productCode}" placeholder="VD: SP001" />
                            </div>
                            <div class="form-input">
                                <label class="form-label" for="productStock">Số lượng kho <span
                                        class="required-mark">*</span></label>
                                <input type="number" id="productStock" name="quantity" class="form-control"
                                       value="${product.quantity}" placeholder="0" required />
                            </div>
                        </div>

                        <div class="form-input">
                            <label class="form-label">Trạng thái hiển thị</label>
                            <div class="status-toggle-wrapper">
                                <span class="status-label-text">Cho phép hiển thị trên web</span>
                                <label class="status-toggle">
                                    <input type="checkbox" name="status" value="1" id="statusCheckbox" <c:if
                                            test="${product.status == 1}">checked</c:if> />
                                    <span class="status-slider"></span>
                                </label>
                            </div>
                            <div class="status-current-row">
                                Trạng thái hiện tại: <span id="statusText" class="status-current-text">
                                ${product.status == 1 ? 'Đang hiển thị' : 'Đang ẩn'}
                            </span>
                            </div>
                        </div>

                        <div class="form-input">
                            <label class="form-label" for="productDesc">Mô tả chi tiết</label>
                            <textarea id="productDesc" name="description"
                                      class="form-textarea">${product.description}</textarea>
                        </div>
                        <script src="${pageContext.request.contextPath}/assets/ckeditor/ckeditor.js"></script>
                        <script src="${pageContext.request.contextPath}/assets/ckfinder/ckfinder/ckfinder.js"></script>

                    </div>

                    <div class="product-edit__form-right">
                        <p class="section-title">Quản lý hình ảnh</p>

                        <div class="image-group">
                            <p class="image-group-title">Ảnh đại diện (Click để thay đổi)</p>

                            <input type="file" name="image" id="mainImageInput" accept="image/*" class="file-input-hidden" />

                            <div class="upload-area" id="mainImageTrigger">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(product.image, 'http')}">
                                                <img src="${product.image}" id="mainImagePreview" alt="Main Image" />
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${product.image}" id="mainImagePreview" alt="Main Image" />
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="upload-placeholder is-hidden" id="placeholderIcon">
                                            <i class='bx bx-cloud-upload'></i>
                                            <span>Nhấn để tải ảnh lên</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="upload-placeholder" id="placeholderIcon">
                                            <i class='bx bx-cloud-upload'></i>
                                            <span>Nhấn để tải ảnh lên</span>
                                        </div>
                                        <img src="" id="mainImagePreview" class="is-hidden" alt="Preview" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="image-group">
                            <p class="image-group-title">Ảnh chi tiết (Chọn nhiều ảnh)</p>

                            <input type="file" name="subImages" id="subImagesInput" multiple accept="image/*"
                                   class="file-input-hidden" />

                            <label for="subImagesInput" class="btn-upload-sub">
                                <i class='bx bx-images'></i> Thêm ảnh chi tiết
                            </label>

                            <div class="secondary-images-container" id="subImagesContainer">
                                <c:if test="${not empty product.productImages}">
                                    <c:forEach items="${product.productImages}" var="img">
                                        <div class="sub-image-item">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(img.imageUrl, 'http')}">
                                                    <img src="${img.imageUrl}" alt="Ảnh chi tiết" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${img.imageUrl}" alt="Ảnh chi tiết" />
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                    </div>

                </form>
                <div class="product-edit__bottom">
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn-cancel">
                        <i class='bx bx-arrow-back'></i> Quay lại
                    </a>
                    <button type="submit" form="productForm" class="btn-save">
                        <i class='bx bx-save'></i> ${product.id > 0 ? 'Lưu thay đổi' : 'Thêm sản phẩm'}
                    </button>
                </div>

            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/product-edit.js"></script>

</body>

</html>