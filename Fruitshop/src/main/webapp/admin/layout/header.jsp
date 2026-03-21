<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav>
    <i class="bx bx-menu"></i>
    <form action="#">
        <div class="form-input">
            <input type="search" placeholder="Search..."/>
            <button class="search-btn" type="submit">
                <i class="bx bx-search"></i>
            </button>
        </div>
    </form>

    <div class="notification-wrapper">
        <a href="#" class="notif" id="notifBtn">
            <i class="bx bx-bell"></i>
            <span class="count">12</span>
        </a>
        <div class="notification-dropdown" id="notifDropdown">
            <h3 class="dropdown-header">Thông báo mới</h3>
            <ul class="notification-list">
                <li class="notification-item unread">
                    <i class="bx bx-cart-add item-icon"></i>
                    <div class="item-content">
                        <p><strong>Đơn hàng mới</strong></p>
                        <span>Bạn có đơn hàng #12350 từ Nguyễn Văn A.</span>
                        <small>2 phút trước</small>
                    </div>
                </li>
            </ul>
            <div class="dropdown-footer">
                <a href="${pageContext.request.contextPath}/admin/notifications.jsp">Xem tất cả thông báo</a>
            </div>
        </div>
    </div>

    <div class="profile-wrapper">
        <a href="#" class="profile" id="profileBtn">
            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="Admin Avatar"/>
        </a>
        <div class="profile-dropdown" id="profileDropdown">
            <h3 class="dropdown-header">Tài khoản</h3>
            <ul class="profile-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/admin/profile.jsp">
                        <i class="bx bxs-user-circle"></i><span>Hồ sơ của tôi</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/profile.jsp#changepassword">
                        <i class="bx bxs-lock-alt"></i><span>Đổi mật khẩu</span>
                    </a>
                </li>
                <li class="profile-menu-toggle">
                    <i class="bx bx-moon"></i><span>Chế độ Tối</span>
                    <input type="checkbox" id="theme-toggle" hidden/>
                    <label for="theme-toggle" class="theme-toggle-dropdown"></label>
                </li>
                <hr/>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="logout">
                        <i class="bx bx-log-out-circle"></i><span>Đăng xuất</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>