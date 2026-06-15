<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Hồ sơ Admin | Fruitshop</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-profile.css"/>
</head>
<body>

<c:set var="u" value="${adminUser != null ? adminUser : sessionScope.account}"/>

<jsp:include page="layout/sidebar.jsp">
    <jsp:param name="activePage" value="profile"/>
</jsp:include>

<div class="content">
    <jsp:include page="layout/header.jsp"/>

    <main>
        <div class="profile-page">

            <div class="header" style="margin-bottom:24px;">
                <div class="left">
                    <h1 style="font-size:24px;">Hồ Sơ Cá Nhân</h1>
                    <ul class="breadcrumb">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li><a class="active">Hồ sơ</a></li>
                    </ul>
                </div>
            </div>

            <div class="profile-hero">
                <form id="avatarForm" action="${pageContext.request.contextPath}/admin/profile"
                      method="post" enctype="multipart/form-data" style="display:none;">
                    <input type="file" id="avatarInput" name="avatarFile" accept="image/*"/>
                </form>
                <div class="hero-avatar-wrap">
                    <img id="heroAvatar"
                         src="${not empty u.avatar ? u.avatar : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}"
                         alt="Avatar" class="hero-avatar"/>
                    <div class="avatar-edit-btn" onclick="document.getElementById('avatarInput').click();"
                         title="Đổi ảnh đại diện">
                        <i class="bx bx-camera"></i>
                    </div>
                </div>
                <div class="hero-info">
                    <h2>${not empty u.fullName ? u.fullName : 'Admin'}</h2>
                    <p><i class="bx bx-envelope" style="font-size:14px;"></i> ${u.email}</p>
                    <c:if test="${not empty u.phone}">
                        <p><i class="bx bx-phone" style="font-size:14px;"></i> ${u.phone}</p>
                    </c:if>
                    <span class="hero-badge">
                        <c:choose>
                            <c:when test="${u.role == 1}"><i class="bx bxs-shield"></i> Quản trị viên</c:when>
                            <c:otherwise><i class="bx bx-user-check"></i> Nhân viên</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <div class="tab-nav">
                <button class="tab-btn active" onclick="switchTab('info', this)">
                    <i class="bx bx-user"></i> Thông tin cá nhân
                </button>
                <c:if test="${empty u.loginType or u.loginType == 'local'}">
                    <button class="tab-btn" onclick="switchTab('password', this)">
                        <i class="bx bx-lock-alt"></i> Đổi mật khẩu
                    </button>
                </c:if>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="bx bx-check-circle"></i> ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bx bx-error-circle"></i> ${error}
                </div>
            </c:if>

            <div id="tab-info" class="tab-content active">
                <div class="profile-card">
                    <div class="card-section-title">Chỉnh sửa thông tin</div>
                    <form action="${pageContext.request.contextPath}/admin/profile"
                          method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="updateProfile"/>
                        <div class="form-grid">

                            <div class="form-group">
                                <label>Họ và tên *</label>
                                <input type="text" name="fullname" value="${u.fullName}"
                                       placeholder="Nhập họ và tên" maxlength="50" required/>
                            </div>

                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" value="${u.email}" readonly/>
                            </div>

                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input type="tel" name="phone" value="${u.phone}"
                                       placeholder="0912345678" maxlength="10"/>
                            </div>

                            <div class="form-group">
                                <label>Giới tính</label>
                                <select name="gender">
                                    <option value="">-- Chọn --</option>
                                    <option value="Nam"    ${u.gender == 'Nam'    ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ"     ${u.gender == 'Nữ'     ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác"   ${u.gender == 'Khác'   ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>

                            <div class="form-group full">
                                <label>Ngày sinh</label>
                                <div class="dob-row">
                                    <%-- Day --%>
                                    <select name="birthDay">
                                        <option value="">Ngày</option>
                                        <c:forEach begin="1" end="31" var="d">
                                            <fmt:parseDate value="${u.birthDate}" pattern="yyyy-MM-dd" var="bd" type="date"/>
                                            <fmt:formatDate value="${bd}" pattern="d" var="bDay"/>
                                            <option value="${d}" ${bDay == d ? 'selected' : ''}>${d}</option>
                                        </c:forEach>
                                    </select>
                                    <select name="birthMonth">
                                        <option value="">Tháng</option>
                                        <c:forEach begin="1" end="12" var="m">
                                            <fmt:parseDate value="${u.birthDate}" pattern="yyyy-MM-dd" var="bd2" type="date"/>
                                            <fmt:formatDate value="${bd2}" pattern="M" var="bMon"/>
                                            <option value="${m}" ${bMon == m ? 'selected' : ''}>${m}</option>
                                        </c:forEach>
                                    </select>
                                    <select name="birthYear">
                                        <option value="">Năm</option>
                                        <c:forEach begin="1950" end="2010" var="y">
                                            <fmt:parseDate value="${u.birthDate}" pattern="yyyy-MM-dd" var="bd3" type="date"/>
                                            <fmt:formatDate value="${bd3}" pattern="yyyy" var="bYr"/>
                                            <option value="${y}" ${bYr == y ? 'selected' : ''}>${y}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                        </div>
                        <button type="submit" class="btn-save">
                            <i class="bx bx-save"></i> Lưu thay đổi
                        </button>
                    </form>
                </div>
            </div>

            <c:if test="${empty u.loginType or u.loginType == 'local'}">
            <div id="tab-password" class="tab-content">
                <div class="profile-card">
                    <div class="card-section-title">Đổi mật khẩu</div>
                    <form action="${pageContext.request.contextPath}/admin/profile" method="post">
                        <input type="hidden" name="action" value="changePassword"/>
                        <div class="form-grid">

                            <div class="form-group full">
                                <label>Mật khẩu cũ *</label>
                                <input type="password" name="old_pass" placeholder="Nhập mật khẩu hiện tại" required/>
                            </div>

                            <div class="form-group">
                                <label>Mật khẩu mới *</label>
                                <input type="password" name="new_pass" id="newPass"
                                       placeholder="Tối thiểu 8 ký tự" required
                                       oninput="checkStrength(this.value)"/>
                                <div class="strength-bar-wrap"><div class="strength-bar" id="strengthBar"></div></div>
                            </div>

                            <div class="form-group">
                                <label>Xác nhận mật khẩu *</label>
                                <input type="password" name="renew_pass" placeholder="Nhập lại mật khẩu mới" required/>
                            </div>

                        </div>
                        <button type="submit" class="btn-save">
                            <i class="bx bx-lock-open-alt"></i> Cập nhật mật khẩu
                        </button>
                    </form>
                </div>
            </div>
            </c:if>

        </div>
    </main>
</div>

<script>
    function switchTab(name, btn) {
        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + name).classList.add('active');
        btn.classList.add('active');
    }
    <c:if test="${not empty error and param.action == 'changePassword'}">
    switchTab('password', document.querySelectorAll('.tab-btn')[1]);
    </c:if>

    document.getElementById('avatarInput').addEventListener('change', function () {
        const file = this.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = e => document.getElementById('heroAvatar').src = e.target.result;
        reader.readAsDataURL(file);
        document.getElementById('avatarForm').submit();
    });

    function checkStrength(val) {
        const bar = document.getElementById('strengthBar');
        let score = 0;
        if (val.length >= 8)  score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;
        const colors = ['#ef4444','#f97316','#eab308','#22c55e'];
        const widths = ['25%','50%','75%','100%'];
        bar.style.width  = score > 0 ? widths[score - 1] : '0';
        bar.style.background = score > 0 ? colors[score - 1] : '';
    }
</script>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
</body>
</html>
