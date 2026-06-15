<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <nav>
            <c:if test="${not empty param.permMsg}">
                <div data-flash-message class="perm-notification perm-notification-danger">
                    <i class="bx bx-check-circle"></i>
                    <span>${param.permMsg}</span>
                </div>
            </c:if>
            <i class="bx bx-menu"></i>
            <form action="#">
                <div class="form-input">
                    <input type="search" placeholder="Search..." />
                    <button class="search-btn" type="submit">
                        <i class="bx bx-search"></i>
                    </button>
                </div>
            </form>

            <div class="notification-wrapper">
                <a href="#" class="notif" id="notifBtn">
                    <!-- <i class="bx bx-bell"></i>
                    <span class="count">12</span> -->
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
                    <img src="${not empty sessionScope.account.avatar ? sessionScope.account.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}"
                        alt=""
                        style="width: 36px !important; height: 36px !important; min-width: 36px; min-height: 36px; object-fit: cover; border-radius: 50%; color: transparent;" />
                </a>
                <div class="profile-dropdown" id="profileDropdown">
                    <h3 class="dropdown-header">Tài khoản</h3>
                    <ul class="profile-menu">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/profile">
                                <i class="bx bxs-user-circle"></i><span>Hồ sơ của tôi</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/profile#changepassword">
                                <i class="bx bxs-lock-alt"></i><span>Đổi mật khẩu</span>
                            </a>
                        </li>
                        <li class="profile-menu-toggle">
                            <i class="bx bx-moon"></i><span>Chế độ Tối</span>
                            <input type="checkbox" id="theme-toggle" hidden />
                            <label for="theme-toggle" class="theme-toggle-dropdown"></label>
                        </li>
                        <hr />
                        <li>
                            <a href="${pageContext.request.contextPath}/home">
                                <i class="bx bx-store-alt"></i><span>Trang khách hàng</span>
                            </a>
                        </li>
                        <hr />
                        <li>
                            <a href="${pageContext.request.contextPath}/logout" class="logout">
                                <i class="bx bx-log-out-circle"></i><span>Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <script src="${pageContext.request.contextPath}/assets/js/admin/flash-message.js"></script>