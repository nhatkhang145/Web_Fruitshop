<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="sidebar">
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="logo">
                <img class="navbar__menu-logo-img"
                    src="https://ik.imagekit.io/8tm3umulk/image/logonew_fG_70DXF8?updatedAt=1762866381508"
                    alt="Organic Harvest Logo" />
            </a>
            <ul class="side-menu">
                <li class="${param.activePage == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i class='bx bxs-dashboard'></i>Tổng
                        quan</a>
                </li>
                <li class="${param.activePage == 'products' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/products"><i class='bx bx-basket'></i>Quản lý sản
                        phẩm</a>
                </li>
                <li class="${param.activePage == 'categories' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/categories"><i class='bx bx-category'></i>Quản lý
                        danh mục</a>
                </li>
                <li class="${param.activePage == 'orders' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/orders"><i class='bx bx-receipt'></i>Quản lý đơn
                        hàng</a>
                </li>
                <li class="${param.activePage == 'stock-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/inventory-warehouse.jsp"><i
                            class='bx bx-box'></i>Quản lý tồn kho</a>
                </li>
                <li class="${param.activePage == 'inventory' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/inventory-management"><i
                            class='bx bx-archive-in'></i>Phiếu nhập/xuất kho</a>
                </li>
                <li class="${param.activePage == 'stock-export' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/stock-export.jsp"><i
                            class='bx bx-archive-out'></i>Phiếu xuất kho</a>
                </li>
                <li class="${param.activePage == 'weekend-deals' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/weekend-deals"><i
                            class='bx bxs-discount'></i>Weekend Deals</a>
                </li>
                <li class="${param.activePage == 'users' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/users"><i class='bx bx-group'></i>Quản lý khách
                        hàng</a>
                </li>
                <li class="${param.activePage == 'roles' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/roles.jsp"><i
                            class='bx bx-shield-quarter'></i>Phân quyền</a>
                </li>
                <li class="${param.activePage == 'banners' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/banners"><i class='bx bx-images'></i>Quản lý
                        Banner</a>
                </li>
                <li class="${param.activePage == 'reviews' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/reviews"><i class='bx bx-star'></i>Đánh giá</a>
                </li>
                <li class="${param.activePage == 'notifications' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/notifications"><i class='bx bx-bell'></i>Lịch sử
                        Thông báo</a>
                </li>
                <li class="${param.activePage == 'reports' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/reports"><i class='bx bx-line-chart'></i>Thống
                        kê</a>
                </li>
            </ul>
        </div>