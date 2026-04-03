<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:choose>
        <c:when test="${sessionScope.otpType == 'register'}">
            <title>Xác thực OTP - Đăng ký</title>
        </c:when>
        <c:when test="${sessionScope.otpType == 'forgot-password'}">
            <title>Xác thực OTP - Quên mật khẩu</title>
        </c:when>
        <c:otherwise>
            <title>Xác thực OTP</title>
        </c:otherwise>
    </c:choose>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/verify-otp.css" />

</head>
<body>
<div class="otp-container">
    <div class="otp-icon">
        <i class="fas fa-envelope-open-text"></i>
    </div>

    <c:choose>
        <c:when test="${sessionScope.otpType == 'register'}">
            <h2>Xác thực Email</h2>
            <p class="subtitle">Vui lòng nhập mã OTP để hoàn tất đăng ký tài khoản</p>
        </c:when>
        <c:when test="${sessionScope.otpType == 'forgot-password'}">
            <h2>Xác thực Email</h2>
            <p class="subtitle">Vui lòng nhập mã OTP để đặt lại mật khẩu</p>
        </c:when>
        <c:otherwise>
            <h2>Xác thực Email</h2>
            <p class="subtitle">Vui lòng nhập mã OTP đã được gửi đến email của bạn</p>
        </c:otherwise>
    </c:choose>

    <div class="email-sent">
        Mã OTP đã được gửi đến: <br>
        <strong>
            <c:choose>
                <c:when test="${not empty sessionScope.otpEmail}">${sessionScope.otpEmail}</c:when>
                <c:when test="${not empty sessionScope.registerEmail}">${sessionScope.registerEmail}</c:when>
                <c:when test="${not empty sessionScope.emailReset}">${sessionScope.emailReset}</c:when>
                <c:otherwise>Email của bạn</c:otherwise>
            </c:choose>
        </strong>
    </div>

    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="success-message">
            <i class="fas fa-check-circle"></i> ${success}
        </div>
    </c:if>

    <c:set var="formAction" value="${pageContext.request.contextPath}/verifyOTP" />
    <c:if test="${sessionScope.otpType == 'register'}">
        <c:set var="formAction" value="${pageContext.request.contextPath}/verify-register-otp" />
    </c:if>

    <form action="${formAction}" method="post" id="otpForm">
        <div class="otp-inputs">
            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autocomplete="off">
            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autocomplete="off">
            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autocomplete="off">
            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autocomplete="off">
            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autocomplete="off">
            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" required autocomplete="off">
        </div>

        <input type="hidden" name="otp" id="hiddenOTP">

        <button type="submit" class="btn-verify">
            <c:choose>
                <c:when test="${sessionScope.otpType == 'register'}">
                    <i class="fas fa-check-circle"></i> Xác thực & Hoàn tất đăng ký
                </c:when>
                <c:when test="${sessionScope.otpType == 'forgot-password'}">
                    <i class="fas fa-check-circle"></i> Xác thực & Tiếp tục
                </c:when>
                <c:otherwise>
                    <i class="fas fa-check-circle"></i> Xác thực OTP
                </c:otherwise>
            </c:choose>
        </button>

        <div class="loading" id="loadingSpinner">
           <div class="spinner"></div>
           <p style="margin-top: 10px; color: #666;">Đang xác thực...</p>
        </div>
    </form>

    <div class="resend-section">
        <p>Không nhận được mã?
            <c:choose>
                <c:when test="${sessionScope.otpType == 'register'}">
                    <a href="${pageContext.request.contextPath}/resend-register-otp" class="resend-link" id="resendLink">
                        Gửi lại OTP
                    </a>
                </c:when>
                <c:when test="${sessionScope.otpType == 'forgot-password'}">
                    <a href="${pageContext.request.contextPath}/forgotPassword" class="resend-link" id="resendLink">
                        Gửi lại OTP
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="#" class="resend-link" id="resendLink">
                        Gửi lại OTP
                    </a>
                </c:otherwise>
            </c:choose>
            <span id="timerSection" style="display: none;">
                (<span class="timer" id="timer">60</span>s)
            </span>
        </p>
    </div>

    <div class="back-login">
        <a href="${pageContext.request.contextPath}/login.jsp">
            <i class="fas fa-arrow-left"></i> Quay lại đăng nhập
        </a>
    </div>
</div>

<script>
    const inputs = document.querySelectorAll('.otp-input');

    inputs.forEach((input, index) => {
        input.addEventListener('input', (e) => {
            const value = e.target.value;

            const numericValue = value.replace(/\D/g, '');

            if (numericValue.length > 0) {

                e.target.value = numericValue.slice(-1);

                if (index < inputs.length - 1) {
                    setTimeout(() => {
                        inputs[index + 1].focus();
                    }, 10);
                }
            } else {
                e.target.value = '';
            }
        });

        input.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace') {
                if (e.target.value === '' && index > 0) {
                    e.preventDefault();
                    setTimeout(() => {
                        inputs[index - 1].focus();
                        inputs[index - 1].value = '';
                    }, 10);
                }
            }

            if (e.key === 'ArrowLeft' && index > 0) {
                e.preventDefault();
                inputs[index - 1].focus();
            }
            if (e.key === 'ArrowRight' && index < inputs.length - 1) {
                e.preventDefault();
                inputs[index + 1].focus();
            }
        });

        input.addEventListener('paste', (e) => {
            e.preventDefault();
            const pasteData = e.clipboardData.getData('text');
            const digits = pasteData.replace(/\D/g, '').slice(0, 6);

            digits.split('').forEach((digit, i) => {
                if (inputs[i]) {
                    inputs[i].value = digit;
                }
            });

            const lastIndex = Math.min(digits.length - 1, inputs.length - 1);
            if (inputs[lastIndex]) {
                setTimeout(() => {
                    inputs[lastIndex].focus();
                }, 10);
            }
        });

        input.addEventListener('focus', (e) => {
            e.target.select();
        });
    });

    document.getElementById('otpForm').addEventListener('submit', (e) => {
        e.preventDefault();

        let otp = '';
        inputs.forEach(input => otp += input.value);

        if (otp.length !== 6) {
            alert('Vui lòng nhập đầy đủ 6 số OTP!');
            inputs[0].focus();
            return;
        }

        document.getElementById('hiddenOTP').value = otp;

        document.querySelector('.btn-verify').style.display = 'none';
        document.getElementById('loadingSpinner').style.display = 'block';

        e.target.submit();
    });

    setTimeout(() => {
        inputs[0].focus();
    }, 100);

    let countdown = 60;
    const timerSection = document.getElementById('timerSection');
    const timerElement = document.getElementById('timer');
    const resendLink = document.getElementById('resendLink');

    function startTimer() {
        timerSection.style.display = 'inline';
        resendLink.style.pointerEvents = 'none';
        resendLink.style.opacity = '0.5';

        const interval = setInterval(() => {
            countdown--;
            timerElement.textContent = countdown;

            if (countdown <= 0) {
                clearInterval(interval);
                timerSection.style.display = 'none';
                resendLink.style.pointerEvents = 'auto';
                resendLink.style.opacity = '1';
                countdown = 60;
            }
        }, 1000);
    }

    startTimer();
</script>
</body>
</html>
