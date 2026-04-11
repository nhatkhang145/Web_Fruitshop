<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Danh mục | Admin</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/Categories.css" />
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="categories" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp"></jsp:include>

    <main>
        <div class="header-title">
            <div class="left">
                <h1>Danh Mục Sản Phẩm</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Quản lý</a></li>
                    <li><i class='bx bx-chevron-right'></i></li>
                    <li><a href="#" class="active">Danh mục</a></li>
                </ul>
            </div>

            <a href="#" class="btn-create" onclick="openModal('add')">
                <i class='bx bx-plus'></i>
                <span>Tạo danh mục</span>
            </a>
        </div>

        <div class="toolbar-section">
            <div class="search-box">
                <i class='bx bx-search'></i>
                <input type="text" id="searchInput" onkeyup="searchCategory()" placeholder="Tìm kiếm danh mục...">
            </div>

            <div class="stats-badge">
                <span class="label">Tổng số danh mục:</span>
                <span class="count">${listC.size()}</span>
            </div>
        </div>

        <div class="category-list-container" id="categoryContainer">


            <c:forEach items="${parentC}" var="parent">
                <div class="category-card root-card">
                    <div class="card-info">
                        <div class="icon-box">
                            <i class='bx bxs-folder-open'></i>
                        </div>
                        <div class="text-content">
                            <h3 class="cate-name">
                                <a class="cate-link" href="${pageContext.request.contextPath}/admin/category-products?categoryId=${parent.id}">${parent.name}</a>
                            </h3>
                            <p class="cate-desc">${parent.description != null && !parent.description.isEmpty() ?
                                    parent.description : '...'}</p>
                        </div>
                    </div>

                    <div class="card-meta">
                        <span class="meta-badge">ID: #${parent.id}</span>
                    </div>

                    <div class="card-status">
                        <c:choose>
                            <c:when test="${parent.status == 1}">
                                <span class="status-pill active">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-pill inactive">Đang ẩn</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="card-actions">
                        <a href="${pageContext.request.contextPath}/admin/category-products?categoryId=${parent.id}"
                           class="btn-icon view" title="Quan ly san pham">
                            <i class='bx bx-list-ul'></i>
                        </a>
                        <button type="button"
                                class="btn-icon edit js-edit-category"
                                data-id="${parent.id}"
                                data-name="${fn:escapeXml(parent.name)}"
                                data-desc="${fn:escapeXml(parent.description)}"
                                data-status="${parent.status}"
                                data-parent-id="${parent.parentId}"
                                title="Sửa">
                            <i class='bx bx-edit-alt'></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/delete-category?id=${parent.id}" onclick="return confirm('Bạn chắc chắn muốn xóa?')"
                           class="btn-icon delete" title="Xóa">
                            <i class='bx bx-trash'></i>
                        </a>
                    </div>
                </div>


                <c:forEach items="${listC}" var="child">
                    <c:if test="${child.parentId == parent.id}">
                        <div class="category-card sub-card">
                            <div class="card-info">
                                <div class="icon-box">
                                    <i class='bx bx-subdirectory-right'></i>
                                </div>
                                <div class="text-content">
                                    <h3 class="cate-name">
                                        <a class="cate-link" href="${pageContext.request.contextPath}/admin/category-products?categoryId=${child.id}">${child.name}</a>
                                    </h3>
                                    <p class="cate-desc">${child.description != null && !child.description.isEmpty() ?
                                            child.description : '...'}</p>
                                </div>
                            </div>

                            <div class="card-meta">
                                <span class="meta-badge">ID: #${child.id}</span>
                                <span class="meta-badge parent-badge">Cha: ID #${child.parentId}</span>
                            </div>

                            <div class="card-status">
                                <c:choose>
                                    <c:when test="${child.status == 1}">
                                        <span class="status-pill active">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill inactive">Đang ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="card-actions">
                                <a href="${pageContext.request.contextPath}/admin/category-products?categoryId=${child.id}"
                                   class="btn-icon view" title="Quan ly san pham">
                                    <i class='bx bx-list-ul'></i>
                                </a>
                                <button type="button"
                                        class="btn-icon edit js-edit-category"
                                        data-id="${child.id}"
                                        data-name="${fn:escapeXml(child.name)}"
                                        data-desc="${fn:escapeXml(child.description)}"
                                        data-status="${child.status}"
                                        data-parent-id="${child.parentId}"
                                        title="Sửa">
                                    <i class='bx bx-edit-alt'></i>
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/delete-category?id=${child.id}" onclick="return confirm('Bạn chắc chắn muốn xóa?')"
                                   class="btn-icon delete" title="Xóa">
                                    <i class='bx bx-trash'></i>
                                </a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </c:forEach>

            <c:if test="${empty listC}">
                <div class="empty-state">
                    <p>Chưa có danh mục nào. Hãy tạo mới ngay!</p>
                </div>
            </c:if>

        </div>
        <div id="pagination" class="pagination-container"></div>
    </main>
</div>

<div id="categoryModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Thêm Danh Mục</h2>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form action="${pageContext.request.contextPath}/admin/category-servlet" method="POST" id="categoryForm">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="catId" value="">

                <div class="form-group">
                    <label>Tên danh mục <span class="required-mark">*</span></label>
                    <input type="text" name="name" id="catName" required placeholder="Nhập tên...">
                </div>

                <div class="form-group">
                    <label>Danh mục cha</label>
                    <select name="parentId" id="catParent">
                        <option value="0">-- Là Danh Mục Gốc --</option>
                        <c:forEach items="${listC}" var="parent">

                            <c:if test="${parent.parentId == 0}">
                                <option value="${parent.id}">${parent.name}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description" id="catDesc" rows="3"></textarea>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="catStatus">
                        <option value="1">Hiển thị</option>
                        <option value="0">Ẩn</option>
                    </select>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                    <button type="submit" class="btn-save">Lưu lại</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin/categories.js"></script>
</body>

</html>