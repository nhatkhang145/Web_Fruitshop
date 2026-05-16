<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Trang chủ - Organic Harvest</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css" />

</head>

<body>
<jsp:include page="header.jsp"></jsp:include>
<div class="main">

    <main class="fm-auth" style="margin-top: 40px; margin-bottom: 60px;">
        <div class="fm-card">
            <aside class="fm-left">
                <a href="" style="text-decoration: none;">
                    <img class="fm-logo-img"
                         src="https://ik.imagekit.io/8tm3umulk/image/logonew_fG_70DXF8?updatedAt=1762866381508"
                         alt="Organic Harvest Logo" style="height: 70px; width: auto; margin-bottom: 30px;" />
                </a>
                <h2>Chào mừng đến với Organic Harvest</h2>
                <p>Mua trái cây tươi sạch — giao tận nhà nhanh chóng.</p>
                <div class="fm-illustration" aria-hidden="true"></div>
            </aside>

            <section class="fm-right">
                <div class="fm-form-wrap">
                    <div class="fm-tabs" role="tablist" aria-label="Auth tabs">
                        <button id="tab-login" class="fm-tab active" role="tab" aria-selected="true"
                                aria-controls="loginPanel">
                            Đăng nhập
                        </button>

                        <button id="tab-register" class="fm-tab" role="tab" aria-selected="false"
                                aria-controls="registerPanel">
                            Đăng ký
                        </button>
                    </div>

                    <div id="loginPanel" class="fm-panel" role="tabpanel" aria-labelledby="tab-login">
                        <form action="login" method="post">

                            <c:if test="${not empty sessionScope.registerSuccess}">
                                <div class="fm-message success" style="background: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 15px; border-left: 4px solid #28a745; display: flex; align-items: center; gap: 10px;">
                                    <i class="fas fa-check-circle" style="font-size: 20px;"></i>
                                    <span>${sessionScope.registerSuccess}</span>
                                </div>
                                <c:remove var="registerSuccess" scope="session" />
                            </c:if>

                            <c:if test="${not empty error}">
                                <p style="color: red; text-align: center">${error}</p>
                            </c:if>

                            <label class="fm-label">Email
                                <input name="user" type="text" required placeholder="Nhập Email của bạn" />
                            </label>

                            <label class="fm-label">Mật khẩu
                                <div class="password-input-wrapper">
                                    <input name="pass" type="password" id="loginPassword" required placeholder="Vui lòng nhập mật khẩu" />
                                    <i class="fas fa-eye toggle-password-icon" data-target="loginPassword"></i>
                                </div>
                            </label>

                            <div class="fm-row">
                                <label class="fm-check">
                                    <input name="remember" type="checkbox" /> Ghi nhớ tôi
                                </label>
                                <a class="fm-link" href="forget_pass.jsp">Quên mật khẩu?</a>
                            </div>

                            <button type="submit" class="fm-btn">Đăng nhập</button>
                            <div class="social-login">
                                <p style="text-align: center; margin: 15px 0; color: #666;">Hoặc đăng nhập bằng
                                </p>
                                <div style="display: flex; gap: 10px; justify-content: center;">
                                    <a href="${pageContext.request.contextPath}/login-facebook-redirect" class="btn-social facebook"
                                       style="background: #3b5998; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                                        <i class="fa-brands fa-facebook-f"></i> Facebook
                                    </a>
                                    <a href="${pageContext.request.contextPath}/login-google-redirect" class="btn-social google"
                                       style="background: #db4437; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">
                                        <i class="fa-brands fa-google"></i> Google
                                    </a>
                                </div>
                            </div>
                            <div id="loginMessage" class="fm-message" role="status" aria-live="polite"></div>

                            <p class="fm-or">
                                Bạn chưa có tài khoản?
                                <a href="#register" id="gotoRegister">Tạo tài khoản</a>
                            </p>
                        </form>
                    </div>

                    <div id="registerPanel" class="fm-panel hidden" role="tabpanel" aria-labelledby="tab-register">
                        <form action="register" method="post">

                            <c:if test="${not empty registerError}">
                                <div class="fm-message error" style="color: red; text-align: center; margin-bottom: 10px;">
                                        ${registerError}
                                </div>
                            </c:if>

                            <label class="fm-label">Tên đăng nhập
                                <input name="user" type="text" required placeholder="Nhập tên đăng nhập của bạn"
                                       value="${not empty regFullname ? regFullname : ''}" />
                            </label>

                            <label class="fm-label">Email
                                <input name="email" type="email" required placeholder="Email"
                                       pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$"
                                       oninvalid="this.setCustomValidity('Định dạng email không hợp lệ (ví dụ: abc@gmail.com)')"
                                       oninput="this.setCustomValidity('')"
                                       value="${not empty regEmail ? regEmail : ' '}"/>
                            </label>

                            <label class="fm-label">Mật khẩu
                                <div class="password-input-wrapper">
                                    <input name="pass" type="password" id="registerPassword" placeholder="Mật khẩu" />
                                    <i class="fas fa-eye toggle-password-icon" data-target="registerPassword"></i>
                                </div>
                                <small style="color: #666; font-size: 12px; display: block; margin-top: 5px;">
                                    Mật khẩu từ 8 đến 16 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%...)
                                </small>
                            </label>

                            <label class="fm-label">Xác nhận mật khẩu
                                <div class="password-input-wrapper">
                                    <input name="re_pass" type="password" id="confirmPassword" required placeholder="Xác nhận mật khẩu" />
                                    <i class="fas fa-eye toggle-password-icon" data-target="confirmPassword"></i>
                                </div>
                            </label>

                            <button type="submit" class="fm-btn">Tạo tài khoản</button>

                            <p class="fm-or">
                                Đã có tài khoản? <a href="#login" id="gotoLogin">Đăng nhập</a>
                            </p>
                        </form>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <script>

        document.querySelectorAll('.toggle-password-icon').forEach(icon => {
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

        const loginTab = document.getElementById('tab-login');
        const registerTab = document.getElementById('tab-register');
        const loginPanel = document.getElementById('loginPanel');
        const registerPanel = document.getElementById('registerPanel');

        loginTab.addEventListener('click', () => {
            loginTab.classList.add('active');
            registerTab.classList.remove('active');
            loginPanel.classList.remove('hidden');
            registerPanel.classList.add('hidden');
        });

        registerTab.addEventListener('click', () => {
            registerTab.classList.add('active');
            loginTab.classList.remove('active');
            registerPanel.classList.remove('hidden');
            loginPanel.classList.add('hidden');
        });

        document.getElementById('gotoRegister').addEventListener('click', (e) => {
            e.preventDefault();
            registerTab.click();
        });
        document.getElementById('gotoLogin').addEventListener('click', (e) => {
            e.preventDefault();
            loginTab.click();
        });

        <c:if test="${not empty registerError}">
        registerTab.click();
        </c:if>

        if (window.location.hash === '#register') {
                    registerTab.click();
        }
    </script>
</div>
<jsp:include page="footer.jsp"></jsp:include>
</body>

</html>