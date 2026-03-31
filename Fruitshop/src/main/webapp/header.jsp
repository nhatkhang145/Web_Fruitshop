<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="header">
    <nav class="navbar">
        <div class="navbar__wrapper">
            <div class="navbar__content">
                <ul class="navbar-list">
                    <li class="navbar-item navbar-item--no-click">
                        Kết nối:
                        <a href="#" class="navbar-icon__link"><i class="navbar-icon fa-brands fa-facebook"></i></a>
                        <a href="#" class="navbar-icon__link"><i class="navbar-icon fa-brands fa-instagram"></i></a>
                    </li>
                </ul>

                <ul class="navbar-list">
                    <li class="navbar-item">
                        <a href="${pageContext.request.contextPath}/faqs.jsp" class="navbar-item__link">
                            <span class="navbar-icon__link"><i class="navbar-icon fa-regular fa-circle-question"></i></span> Hỗ trợ
                        </a>
                    </li>

                    <c:choose>
                        <c:when test="${empty sessionScope.account}">
                            <li class="navbar-item">
                                <a href="${pageContext.request.contextPath}/register.jsp" class="navbar-item__link">Đăng ký</a>
                            </li>
                            <li class="navbar-item">
                                <a href="${pageContext.request.contextPath}/login.jsp" class="navbar-item__link">Đăng nhập</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="navbar-item">
                                <span class="navbar-item__link" style="cursor: default;">
                                    <i class="fa-regular fa-user"></i> ${sessionScope.account.fullName}
                                </span>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <div class="navbar__menu">
            <div class="navbar__menu-inner">
                <div class="navbar__menu-logo">
                    <a href="${pageContext.request.contextPath}/">
                        <img class="navbar__menu-logo-img"
                             src="https://ik.imagekit.io/8tm3umulk/image/logonew_fG_70DXF8?updatedAt=1762866381508"
                             alt="Organic Harvest Logo" />
                    </a>
                </div>

                <ul class="main-nav-links subnav-links">
                    <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop">Sản Phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/about.jsp">Giới thiệu</a></li>
                    <li><a href="${pageContext.request.contextPath}/blog.jsp">Bài viết</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a></li>
                </ul>

                <div class="navbar__menu-search">
                    <form class="search-form" action="${pageContext.request.contextPath}/shop" method="get">
                        <input name="q" class="search-input" type="search" placeholder="Tìm kiếm sản phẩm..." value="${param.q}" style="width: 100%; border-radius: 25px 0 0 25px;" />
                        <button type="submit" class="search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
                    </form>
                </div>

                <div class="navbar__menu-actions">
                    <a href="wishlist" class="icon-btn wishlist-btn">
                        <i class="fa-solid fa-heart"></i>

                        <span class="badge">
                            ${sessionScope.wishlistCount != null ? sessionScope.wishlistCount : 0}
                        </span>
                    </a>
                    <a href="${pageContext.request.contextPath}/cart.jsp" class="icon-btn cart-btn">
                        <i class="fa-solid fa-basket-shopping"></i>
                        <span class="badge">
                            ${sessionScope.size != null ? sessionScope.size : 0}
                        </span>
                    </a>

                    <div class="header__account">
                        <div class="header__account-user" style="display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 10px 0;">
                            <i class="fa-solid fa-user" style="font-size: 20px;"></i>
                        </div>
                        <div class="account-dropdown">
                            <c:if test="${empty sessionScope.account}">
                                <div class="account-auth">
                                    <span class="auth-text">Chào khách, vui lòng:</span>
                                    <div class="auth-buttons">
                                        <a href="login.jsp" class="btn--primary" style="display: block; text-align: center; margin-bottom: 8px;">Đăng nhập</a>
                                        <a href="register.jsp" class="btn--outline" style="display: block; text-align: center;">Đăng ký</a>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${not empty sessionScope.account}">
                                <div class="account-user">
                                    <div class="user-info">
                                        <img src="${sessionScope.account.avatar != null ? sessionScope.account.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}" alt="Avatar" class="user-avatar">
                                        <div class="user-details">
                                            <span class="user-name">${sessionScope.account.fullName}</span>
                                            <span class="user-email">${sessionScope.account.email}</span>
                                        </div>
                                    </div>
                                    <ul class="account-menu">
                                        <li><a href="profile"><i class="fa-solid fa-id-card"></i> Hồ sơ cá nhân</a></li>
                                        <li><a href="orders"><i class="fa-solid fa-box-open"></i> Đơn hàng</a></li>

                                            <%-- Chỉ hiển thị đổi mật khẩu nếu là tài khoản local --%>
                                        <c:if test="${empty sessionScope.account.loginType or sessionScope.account.loginType == 'local'}">
                                            <li><a href="change-password.jsp"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a></li>
                                        </c:if>

                                        <c:if test="${sessionScope.account.role == 1}">
                                            <li><a href="${pageContext.request.contextPath}/admin/index.jsp" style="color: #007bff;"><i class="fa-solid fa-user-shield"></i> Trang quản trị</a></li>
                                        </c:if>
                                        <li class="border-top">
                                            <a href="${pageContext.request.contextPath}/logout" class="text-danger"><i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất</a>
                                        </li>
                                    </ul>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</header>