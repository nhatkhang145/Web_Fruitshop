<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forget_pass.css" />
</head>
<body>
<div class="forgot-container">
    <div class="forgot-icon">
        <i class="fas fa-key"></i>
    </div>

    <h2>Quên mật khẩu?</h2>
    <p class="subtitle">Đừng lo lắng! Nhập email của bạn và chúng tôi sẽ gửi mã OTP để đặt lại mật khẩu.</p>

    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <span><c:out value="${error}" /></span>
        </div>
    </c:if>

    <div class="info-box">
        <div class="info-box-title">
            <i class="fas fa-info-circle"></i>
            <span>Cách thức hoạt động</span>
        </div>
        <div class="info-box-text">
            1. Nhập email đăng ký của bạn<br>
            2. Nhận mã OTP qua email (có hiệu lực 5 phút)<br>
            3. Nhập mã OTP và đặt mật khẩu mới
        </div>
    </div>

    <form action="<c:url value='/forgotPassword' />" method="post">
        <div class="form-group">
            <label class="form-label" for="email">
                <i class="fas fa-envelope"></i> Email của bạn
            </label>
            <div class="input-wrapper">
                <i class="fas fa-envelope input-icon"></i>
                <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-input"
                        placeholder="example@gmail.com"
                        required
                        autocomplete="email"
                >
            </div>
        </div>

        <div class="btn-group">
            <a href="<c:url value='/login.jsp' />" class="btn btn-cancel">
                <i class="fas fa-times"></i> Hủy
            </a>
            <button type="submit" class="btn btn-submit">
                <i class="fas fa-paper-plane"></i> Gửi mã OTP
            </button>
        </div>
    </form>

    <div class="divider">
        <span>hoặc</span>
    </div>

    <div class="back-login">
        <a href="<c:url value='/login.jsp' />">
            <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
        </a>
    </div>
</div>
</body>
</html>