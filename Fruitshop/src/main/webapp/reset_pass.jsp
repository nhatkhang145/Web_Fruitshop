<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đặt lại mật khẩu - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link rel="stylesheet" href="<c:url value='/assets/css/base.css' />"  />
    <link rel="stylesheet" href="<c:url value='/assets/css/reset_pass.css' />" />
</head>
<body>
<div class="reset-container">
    <div class="reset-icon">
        <i class="fas fa-lock"></i>
    </div>

    <h2>Đặt lại mật khẩu</h2>
    <p class="subtitle">Tạo mật khẩu mới an toàn cho tài khoản của bạn</p>

    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <span><c:out value="${error}" /></span>
        </div>
    </c:if>

    <form action="<c:url value='/resetPassword' />" method="post" id="resetForm">
        <div class="form-group">
            <label class="form-label" for="password">
                <i class="fas fa-key"></i> Mật khẩu mới
            </label>
            <div class="input-wrapper">
                <i class="fas fa-lock input-icon"></i>
                <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-input"
                        placeholder="Nhập mật khẩu mới"
                        required
                        minlength="8"
                >
                <i class="fas fa-eye toggle-password" data-target="password"></i>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label" for="confirmPassword">
                <i class="fas fa-check-circle"></i> Xác nhận mật khẩu
            </label>
            <div class="input-wrapper">
                <i class="fas fa-lock input-icon"></i>
                <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="form-input"
                        placeholder="Nhập lại mật khẩu mới"
                        required
                        minlength="8"
                >
                <i class="fas fa-eye toggle-password" data-target="confirmPassword"></i>
            </div>
            <span class="password-match" id="matchMessage"></span>
        </div>

        <div class="password-requirements">
            <p class="requirements-title"><i class="fas fa-info-circle"></i> Yêu cầu mật khẩu:</p>
            <ul class="requirements-list">
                <li id="req-length"><i class="fas fa-circle"></i> Ít nhất 8 ký tự</li>
                <li id="req-uppercase"><i class="fas fa-circle"></i> Chứa chữ in hoa</li>
                <li id="req-letter"><i class="fas fa-circle"></i> Chứa chữ cái</li>
                <li id="req-number"><i class="fas fa-circle"></i> Chứa số</li>
                <li id="req-special"><i class="fas fa-circle"></i> Chứa ký tự đặc biệt (!@#$%^&*)</li>
            </ul>
        </div>

        <div class="btn-group">
            <a href="<c:url value='/login.jsp' />" class="btn btn-cancel">
                <i class="fas fa-times"></i> Hủy
            </a>
            <button type="submit" class="btn btn-submit" id="submitBtn">
                <i class="fas fa-check"></i> Đặt lại mật khẩu
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

<script>
    // Toggle password visibility
    document.querySelectorAll('.toggle-password').forEach(icon => {
        icon.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const input = document.getElementById(targetId);

            if (input.type === 'password') {
                input.type = 'text';
                this.classList.remove('fa-eye');
                this.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                this.classList.remove('fa-eye-slash');
                this.classList.add('fa-eye');
            }
        });
    });

    // Password match validation
    const passwordInput = document.getElementById('password');
    const confirmInput = document.getElementById('confirmPassword');
    const matchMessage = document.getElementById('matchMessage');

    function checkPasswordRequirements(password) {
        const requirements = {
            length: password.length >= 8,
            uppercase: /[A-Z]/.test(password),
            letter: /[a-zA-Z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[!@#$%^&*]/.test(password)
        };

        // Update requirements UI
        document.getElementById('req-length').className = requirements.length ? 'valid' : '';
        document.getElementById('req-uppercase').className = requirements.uppercase ? 'valid' : '';
        document.getElementById('req-letter').className = requirements.letter ? 'valid' : '';
        document.getElementById('req-number').className = requirements.number ? 'valid' : '';
        document.getElementById('req-special').className = requirements.special ? 'valid' : '';

        return requirements;
    }

    function checkPasswordMatch() {
        if (confirmInput.value.length === 0) {
            matchMessage.textContent = '';
            matchMessage.className = 'password-match';
            return;
        }

        if (passwordInput.value === confirmInput.value) {
            matchMessage.innerHTML = '<i class="fas fa-check-circle"></i> Mật khẩu khớp';
            matchMessage.className = 'password-match match';
        } else {
            matchMessage.innerHTML = '<i class="fas fa-times-circle"></i> Mật khẩu không khớp';
            matchMessage.className = 'password-match no-match';
        }
    }

    passwordInput.addEventListener('input', function() {
        checkPasswordRequirements(this.value);
        checkPasswordMatch();
    });
    confirmInput.addEventListener('input', checkPasswordMatch);

    // Form validation
    document.getElementById('resetForm').addEventListener('submit', function(e) {
        if (passwordInput.value !== confirmInput.value) {
            e.preventDefault();
            matchMessage.innerHTML = '<i class="fas fa-times-circle"></i> Mật khẩu không khớp';
            matchMessage.className = 'password-match no-match';
            confirmInput.focus();
            return false;
        }
    });
</script>
</body>

</html>