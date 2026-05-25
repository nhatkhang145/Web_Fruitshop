<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Tài Khoản Của Tôi — The Organic Harvest</title>

                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
                <link rel="stylesheet" href="<c:url value='/assets/css/main.css'/>" />
                <link rel="stylesheet" href="<c:url value='/assets/css/base.css'/>" />
                <link rel="stylesheet" href="<c:url value='/assets/css/profile.css'/>" />

            </head>

            <body>
                <div class="main">
                    <jsp:include page="header.jsp"></jsp:include>

                    <div class="breadcrumb">
                        <div class="container">
                            <a href="<c:url value='/'/>">Trang chủ</a> &gt; <span>Hồ sơ của tôi</span>
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
                                                <c:set var="avatarSrc"
                                                    value="https://cdn-icons-png.flaticon.com/512/149/149071.png" />
                                            </c:otherwise>
                                        </c:choose>

                                        <img src="<c:out value='${avatarSrc}'/>" alt="Avatar" class="brief-avatar"
                                            id="briefAvatar" />

                                        <div class="brief-info">
                                            <span class="brief-name">${sessionScope.account.fullName}</span>
                                            <a href="#" class="brief-edit"><i class="fa-solid fa-pen"></i> Sửa hồ sơ</a>
                                        </div>
                                    </div>

                                    <ul class="profile-menu">
                                        <li class="profile-menu-item active">
                                            <a href="<c:url value='/profile'/>"><i class="fa-regular fa-user"></i> Hồ sơ
                                                của tôi</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="<c:url value='/orders'/>"><i class="fa-solid fa-box-open"></i> Đơn
                                                mua</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="<c:url value='/addresses'/>"><i
                                                    class="fa-solid fa-location-dot"></i> Địa chỉ</a>
                                        </li>
                                        <li class="profile-menu-item ">
                                            <a href="<c:url value='/change-password.jsp'/>"><i
                                                    class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="<c:url value='/wishlist'/>"><i class="fa-regular fa-heart"></i> Yêu
                                                thích</a>
                                        </li>
                                        <li class="profile-menu-item">
                                            <a href="<c:url value='/logout'/>" style="color: red;"><i
                                                    class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                                        </li>
                                    </ul>
                                </aside>

                                <main class="profile-content">
                                    <div class="profile-header">
                                        <h3>Hồ sơ của tôi</h3>
                                        <p>Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                                    </div>

                                    <c:if test="${not empty message}">
                                        <div class="alert alert-success">
                                            <c:out value="${message}" />
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger">
                                            <c:out value="${error}" />
                                        </div>
                                    </c:if>

                                    <form class="profile-form" action="<c:url value='/profile'/>" method="post"
                                        enctype="multipart/form-data">
                                        <div class="profile-form-left">

                                            <div class="form-group">
                                                <label for="loginName">Tên đăng nhập</label>
                                                <div class="input-with-link">
                                                    <input type="text" id="loginName" class="form-input"
                                                        value="<c:out value='${sessionScope.account.email}'/>" readonly
                                                        style="background-color: #f9f9f9; color: #666;">
                                                </div>
                                            </div>

                                            <div class="form-group"> <label for="fullname">Họ và tên</label>
                                                <input type="text" id="fullname" name="fullname"
                                                    value="${sessionScope.account.fullName}" class="form-control"
                                                    required maxlength="50" ${sessionScope.account.nameChanged
                                                    ? 'readonly style="background-color: #e9ecef; cursor: not-allowed;"'
                                                    : '' } />

                                                <c:choose>
                                                    <c:when test="${sessionScope.account.nameChanged}">
                                                        <small
                                                            style="color: #dc3545; font-style: italic; display: block; margin-top: 5px;">
                                                            Tên của bạn đã được thay đổi trước đó và không thể đổi lại.
                                                        </small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small
                                                            style="color: #fd7e14; font-style: italic; display: block; margin-top: 5px;">
                                                            Lưu ý: Bạn chỉ được phép thay đổi tên 1 lần duy nhất.
                                                        </small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="form-group">
                                                <label for="phone">Số điện thoại</label>
                                                <input type="text" id="phone" name="phone" class="form-input"
                                                    value="<c:out value='${sessionScope.account.phone}'/>"
                                                    maxlength="12" inputmode="numeric"
                                                    placeholder="0912 345 678"
                                                    oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);" />
                                                <small
                                                    style="color: #fd7e14; font-style: italic; display: block; margin-top: 5px;">
                                                    Số điện thoại gồm 10 chữ số. Ví dụ: 0912345678
                                                </small>
                                            </div>


                                            <div class="form-group">
                                                <label>Giới tính</label>
                                                <div class="radio-group">
                                                    <label class="radio-label">
                                                        <input type="radio" name="gender" value="Nam" <c:if
                                                            test="${sessionScope.account.gender eq 'Nam'}">checked
                                                        </c:if> /> Nam
                                                    </label>
                                                    <label class="radio-label">
                                                        <input type="radio" name="gender" value="Nữ" <c:if
                                                            test="${sessionScope.account.gender eq 'Nữ'}">checked</c:if>
                                                        /> Nữ
                                                    </label>
                                                    <label class="radio-label">
                                                        <input type="radio" name="gender" value="Khác" <c:if
                                                            test="${sessionScope.account.gender eq 'Khác'}">checked
                                                        </c:if> /> Khác
                                                    </label>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label>Ngày sinh</label>
                                                <div class="date-dropdown-group">
                                                    <c:set var="currentDay" value="" />
                                                    <c:set var="currentMonth" value="" />
                                                    <c:set var="currentYear" value="" />
                                                    <c:if test="${sessionScope.account.birthDate != null}">
                                                        <fmt:formatDate value="${sessionScope.account.birthDate}"
                                                            pattern="d" var="currentDay" />
                                                        <fmt:formatDate value="${sessionScope.account.birthDate}"
                                                            pattern="M" var="currentMonth" />
                                                        <fmt:formatDate value="${sessionScope.account.birthDate}"
                                                            pattern="yyyy" var="currentYear" />
                                                    </c:if>

                                                    <div class="dropdown-wrapper">
                                                        <input type="hidden" name="birthDay" id="birthDayInput"
                                                            value="<c:out value='${currentDay}'/>" />
                                                        <div class="dropdown-trigger" id="dayTrigger">
                                                            <span id="dayLabel">
                                                                <c:choose>
                                                                    <c:when test="${not empty currentDay}">
                                                                        <c:out value="${currentDay}" />
                                                                    </c:when>
                                                                    <c:otherwise>Ngày</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="dropdown-menu" id="dayMenu">
                                                            <c:forEach begin="1" end="31" var="day">
                                                                <div class="dropdown-item <c:if test='${currentDay eq day}'>selected</c:if>"
                                                                    data-value="${day}">
                                                                    <c:out value="${day}" />
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <div class="dropdown-wrapper">
                                                        <input type="hidden" name="birthMonth" id="birthMonthInput"
                                                            value="<c:out value='${currentMonth}'/>" />
                                                        <div class="dropdown-trigger" id="monthTrigger">
                                                            <span id="monthLabel">
                                                                <c:choose>
                                                                    <c:when test="${not empty currentMonth}">Tháng
                                                                        <c:out value="${currentMonth}" />
                                                                    </c:when>
                                                                    <c:otherwise>Tháng</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="dropdown-menu" id="monthMenu">
                                                            <c:forEach begin="1" end="12" var="month">
                                                                <div class="dropdown-item <c:if test='${currentMonth eq month}'>selected</c:if>"
                                                                    data-value="${month}">
                                                                    Tháng
                                                                    <c:out value="${month}" />
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <!-- Dropdown Năm -->
                                                    <div class="dropdown-wrapper">
                                                        <input type="hidden" name="birthYear" id="birthYearInput"
                                                            value="<c:out value='${currentYear}'/>" />
                                                        <div class="dropdown-trigger" id="yearTrigger">
                                                            <span id="yearLabel">
                                                                <c:choose>
                                                                    <c:when test="${not empty currentYear}">
                                                                        <c:out value="${currentYear}" />
                                                                    </c:when>
                                                                    <c:otherwise>Năm</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="dropdown-menu" id="yearMenu">
                                                            <c:forEach begin="1950" end="2010" var="year">
                                                                <div class="dropdown-item <c:if test='${currentYear eq year}'>selected</c:if>"
                                                                    data-value="${year}">
                                                                    <c:out value="${year}" />
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <button type="submit" class="btn btn-save">Lưu thay đổi</button>
                                        </div>

                                        <div class="profile-form-right">
                                            <div class="avatar-uploader">
                                                <img src="<c:out value='${avatarSrc}'/>" alt="User Avatar"
                                                    id="profileAvatarPreview" />
                                                <label for="avatarFile" class="btn btn-outline-light">Chọn ảnh</label>
                                                <input type="file" name="avatarFile" id="avatarFile"
                                                    accept=".jpg,.jpeg,.png" hidden />
                                                <div class="avatar-note">
                                                    Dụng lượng file tối đa 1 MB<br />Định dạng:.JPEG, .PNG
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </main>
                            </div>
                        </div>
                    </section>

                    <jsp:include page="footer.jsp"></jsp:include>
                </div>

                <script>
                    function validateVietnamesePhone(phone) {
                        const phoneRegex = /^0[3578][0-9]{8}$/;
                        return phoneRegex.test(phone);
                    }

                    const phoneInput = document.getElementById('phone');

                    function formatPhoneNumber(value){
                        let cleaned = ('' + value).replace(/\D/g, '');

                        let match = cleaned.match(/^(\d{0,4})(\d{0,3})(\d{0,3})$/);
                        if (match) {
                            return !match[2] ? match[1] : match[1] + ' ' + match[2] + (match[3] ? ' ' + match[3] : '');
                        }
                        return cleaned;
                    }

                    if (phoneInput && phoneInput.value) {
                        phoneInput.value = formatPhoneNumber(phoneInput.value);
                    }

                    if (phoneInput){
                        phoneInput.addEventListener('input', function (e){
                            this.value = formatPhoneNumber(this.value);
                        });
                    }

                    document.querySelector('.profile-form').addEventListener('submit', function (e) {
                        const phoneValue = phoneInput.value.replace(/\s/g, '');

                        if (phoneValue && !validateVietnamesePhone(phoneValue)) {
                            e.preventDefault();
                            alert('Số điện thoại không hợp lệ.\n\nYêu cầu: 10 chữ số, bắt đầu từ 03, 05, 07, 08 hoặc 09.\nVí dụ: 0912 345 678');
                            phoneInput.focus();
                            return false;
                        }
                        phoneInput.value = phoneValue;
                    });

                    document.getElementById('avatarFile').addEventListener('change', function (e) {
                        const file = e.target.files[0];
                        if (file) {
                            const reader = new FileReader();
                            reader.onload = function (event) {
                                document.getElementById('profileAvatarPreview').src = event.target.result;
                                document.getElementById('briefAvatar').src = event.target.result;
                            };
                            reader.readAsDataURL(file);
                        }
                    });

                    document.addEventListener('DOMContentLoaded', function () {
                        setupDropdown('dayTrigger', 'dayMenu', 'birthDayInput', 'dayLabel', false);
                        setupDropdown('monthTrigger', 'monthMenu', 'birthMonthInput', 'monthLabel', true);
                        setupDropdown('yearTrigger', 'yearMenu', 'birthYearInput', 'yearLabel', false);

                        function setupDropdown(triggerId, menuId, inputId, labelId, isMonth) {
                            const trigger = document.getElementById(triggerId);
                            const menu = document.getElementById(menuId);
                            const input = document.getElementById(inputId);
                            const label = document.getElementById(labelId);

                            if (!trigger || !menu) return;

                            trigger.addEventListener('click', function (e) {
                                e.stopPropagation();
                                document.querySelectorAll('.dropdown-menu').forEach(m => {
                                    if (m !== menu) m.classList.remove('show');
                                });
                                document.querySelectorAll('.dropdown-trigger').forEach(t => {
                                    if (t !== trigger) t.classList.remove('active');
                                });
                                menu.classList.toggle('show');
                                trigger.classList.toggle('active');

                                const selected = menu.querySelector('.selected');
                                if (selected) selected.scrollIntoView({ block: 'center' });
                            });

                            menu.querySelectorAll('.dropdown-item').forEach(item => {
                                item.addEventListener('click', function () {
                                    const value = this.dataset.value;
                                    input.value = value;

                                    if (isMonth) {
                                        label.textContent = 'Tháng ' + value;
                                    } else {
                                        label.textContent = value;
                                    }

                                    menu.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('selected'));
                                    this.classList.add('selected');

                                    menu.classList.remove('show');
                                    trigger.classList.remove('active');

                                    try { input.dispatchEvent(new Event('input', { bubbles: true })); } catch (e) { }
                                });
                            });
                        }

                        document.addEventListener('click', function () {
                            document.querySelectorAll('.dropdown-menu').forEach(m => m.classList.remove('show'));
                            document.querySelectorAll('.dropdown-trigger').forEach(t => t.classList.remove('active'));
                        });

                        const dayMenu = document.getElementById('dayMenu');
                        const monthInput = document.getElementById('birthMonthInput');
                        const yearInput = document.getElementById('birthYearInput');
                        const dayInput = document.getElementById('birthDayInput');
                        const dayTrigger = document.getElementById('dayTrigger');
                        const dayLabel = document.getElementById('dayLabel');

                        function daysInMonth(month, year) {
                            const m = parseInt(month, 10);
                            const y = parseInt(year, 10) || new Date().getFullYear();
                            if (isNaN(m) || m < 1 || m > 12) return 31;
                            return new Date(y, m, 0).getDate();
                        }

                        function DayMenu() {
                            if (!dayMenu) return;
                            const month = monthInput ? monthInput.value : '';
                            const year = yearInput ? yearInput.value : '';
                            const maxDay = daysInMonth(month, year);
                            const prevSelected = parseInt(dayInput ? dayInput.value : '', 10) || null;

                            let html = '';
                            for (let d = 1; d <= maxDay; d++) {
                                const selectedClass = (prevSelected === d) ? ' selected' : '';
                                html += '<div class="dropdown-item' + selectedClass + '" data-value="' + d + '">' + d + '</div>';
                            }
                            dayMenu.innerHTML = html;

                            dayMenu.querySelectorAll('.dropdown-item').forEach(item => {
                                item.addEventListener('click', function () {
                                    const value = this.dataset.value;
                                    if (dayInput) dayInput.value = value;
                                    if (dayLabel) dayLabel.textContent = value;
                                    dayMenu.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('selected'));
                                    this.classList.add('selected');
                                    dayMenu.classList.remove('show');
                                    if (dayTrigger) dayTrigger.classList.remove('active');
                                });
                            });
                        }

                        if (monthInput) monthInput.addEventListener('input', DayMenu);
                        if (yearInput) yearInput.addEventListener('input', DayMenu);

                        DayMenu();
                    });
                </script>
            </body>

            </html>