<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${empty sessionScope.account}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đổi mật khẩu - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="<c:url value='/assets/css/base.css'/>" />
    <link rel="stylesheet" href="<c:url value='/assets/css/main.css'/>" />
    <link rel="stylesheet" href="<c:url value='/assets/css/profile.css'/>" />
</head>
<body>
<jsp:include page="header.jsp"></jsp:include>

<div class="breadcrumb">
    <div class="container">
        <a href="<c:url value='/index.jsp'/>">Trang chủ</a> &gt; <span>Đổi mật khẩu</span>
    </div>
</div>

<section class="profile-section">
    <div class="container">
        <div class="profile-container">
            <aside class="profile-sidebar">
                <div class="profile-user-brief">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatar}">
                            <c:set var="avatarSrc" value="${sessionScope.account.avatar}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="avatarSrc" value="https://cdn-icons-png.flaticon.com/512/149/149071.png" />
                        </c:otherwise>
                    </c:choose>

                    <img src="<c:out value='${avatarSrc}' />" alt="Avatar" class="brief-avatar" id="briefAvatar" />

                    <div class="brief-info">
                        <span class="brief-name">${sessionScope.account.fullName}</span>
                        <a href="#" class="brief-edit"><i class="fa-solid fa-pen"></i> Sửa hồ sơ</a>
                    </div>
                </div>

                <ul class="profile-menu">
                    <li class="profile-menu-item ">
                        <a href="<c:url value='/profile'/>"><i class="fa-regular fa-user"></i> Hồ sơ của tôi</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="<c:url value='/orders'/>"><i class="fa-solid fa-box-open"></i> Đơn mua</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="<c:url value='/addresses'/>"><i class="fa-solid fa-location-dot"></i> Địa chỉ</a>
                    </li>
                    <li class="profile-menu-item active">
                        <a href="<c:url value='/change-password.jsp'/>"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="<c:url value='/wishlist'/>"><i class="fa-regular fa-heart"></i> Yêu thích</a>
                    </li>
                    <li class="profile-menu-item">
                        <a href="<c:url value='/logout'/>" style="color: red;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                    </li>
                </ul>
            </aside>

            <main class="profile-content">
                <div class="profile-header">
                    <h3>Đổi Mật Khẩu</h3>
                    <p>Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác</p>

                    <c:if test="${not empty requestScope.error}">
                        <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-top: 10px; border: 1px solid #f5c6cb;">
                            <i class="fa-solid fa-triangle-exclamation"></i> <c:out value="${requestScope.error}" />
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.mess}">
                        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-top: 10px; border: 1px solid #c3e6cb;">
                            <i class="fa-solid fa-check-circle"></i> <c:out value="${requestScope.mess}" />
                        </div>
                    </c:if>
                </div>

                <form class="profile-form password-change-form" action="<c:url value='/change-password'/>" method="post">
                    <div class="profile-form-left" style="padding-right: 0">

                        <div class="form-group">
                            <label>Mật khẩu hiện tại</label>
                            <div class="password-input-wrapper">
                                <input type="password" name="old_pass" class="form-input" placeholder="Nhập mật khẩu hiện tại" id="currentPass" required />
                                <i class="fa-regular fa-eye-slash toggle-password" toggle="#currentPass"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mật khẩu mới</label>
                            <div class="password-input-wrapper">
                                <input type="password" name="new_pass" class="form-input" placeholder="Nhập mật khẩu mới" id="newPass" required minlength="8"/>
                                <i class="fa-regular fa-eye-slash toggle-password" toggle="#newPass"></i>
                            </div>

                        </div>

                        <div class="form-group">
                            <label>Xác nhận mật khẩu</label>
                            <div class="password-input-wrapper">
                                <input type="password" name="renew_pass" class="form-input" placeholder="Nhập lại mật khẩu mới" id="confirmPass" required />
                                <i class="fa-regular fa-eye-slash toggle-password" toggle="#confirmPass"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label></label>
                            <ul class="password-hints">

                                <li> Tối thiểu 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%...)</li>
                            </ul>
                        </div>

                        <button type="submit" class="btn btn-save">Xác nhận thay đổi</button>
                    </div>
                </form>
            </main>
        </div>
    </div>
</section>

<jsp:include page="footer.jsp"></jsp:include>

<script src="<c:url value='/assets/js/main.js'/>"></script>
<script>
    const toggleIcons = document.querySelectorAll(".toggle-password");
    toggleIcons.forEach((icon) => {
        icon.addEventListener("click", function () {
            const inputSelector = this.getAttribute("toggle");
            const input = document.querySelector(inputSelector);
            if (input.getAttribute("type") === "password") {
                input.setAttribute("type", "text");
                this.classList.remove("fa-eye-slash");
                this.classList.add("fa-eye");
            } else {
                input.setAttribute("type", "password");
                this.classList.remove("fa-eye");
                this.classList.add("fa-eye-slash");
            }
        });
    });
</script>
</body>
</html>