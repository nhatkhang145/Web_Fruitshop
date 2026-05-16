<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Sổ địa chỉ - Organic Harvest</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.min.css" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
            <link rel="stylesheet" href="<c:url value='/assets/css/base.css'/>" />
            <link rel="stylesheet" href="<c:url value='/assets/css/main.css'/>" />
            <link rel="stylesheet" href="<c:url value='/assets/css/profile.css'/>" />
            <link rel="stylesheet" href="<c:url value='/assets/css/addresses.css'/>" />
            <style>
                .alert {
                    padding: 10px 15px;
                    margin-bottom: 15px;
                    border-radius: 4px;
                }

                .alert-success {
                    background-color: #d4edda;
                    color: #155724;
                    border: 1px solid #c3e6cb;
                }

                .alert-danger {
                    background-color: #f8d7da;
                    color: #721c24;
                    border: 1px solid #f5c6cb;
                }

                .empty-addresses {
                    text-align: center;
                    padding: 40px;
                    color: #888;
                }

                .empty-addresses i {
                    font-size: 48px;
                    margin-bottom: 15px;
                    color: #ccc;
                }
            </style>
        </head>

        <body>
            <!-- HEADER -->
            <jsp:include page="header.jsp"></jsp:include>
            <div class="breadcrumb">
                <div class="container">
                    <a href="<c:url value='/'/>">Trang chủ</a> &gt;
                    <a href="<c:url value='/profile'/>">Tài khoản</a> &gt; <span>Địa chỉ</span>
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

                                <img src="<c:out value='${avatarSrc}'/>" alt="Avatar" class="brief-avatar" />

                                <div class="brief-info">
                                    <span class="brief-name">
                                        <c:out value="${sessionScope.account.fullName}" />
                                    </span>
                                    <a href="<c:url value='/profile'/>" class="brief-edit">
                                        <i class="fa-solid fa-pen"></i> Sửa hồ sơ
                                    </a>
                                </div>
                            </div>

                            <ul class="profile-menu">
                                <li class="profile-menu-item ">
                                    <a href="<c:url value='/profile'/>"><i class="fa-regular fa-user"></i> Hồ sơ của
                                        tôi</a>
                                </li>
                                <li class="profile-menu-item">
                                    <a href="<c:url value='/orders'/>"><i class="fa-solid fa-box-open"></i> Đơn mua</a>
                                </li>
                                <li class="profile-menu-item active">
                                    <a href="<c:url value='/addresses'/>"><i class="fa-solid fa-location-dot"></i> Địa
                                        chỉ</a>
                                </li>
                                <li class="profile-menu-item ">
                                    <a href="<c:url value='/change-password.jsp'/>"><i class="fa-solid fa-key"></i> Đổi
                                        mật khẩu</a>
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
                            <div class="address-header">
                                <h3>Địa chỉ của tôi</h3>
                                <button class="btn btn-primary" id="btnAddAddress">
                                    <i class="fa-solid fa-plus"></i> Thêm địa chỉ mới
                                </button>
                            </div>

                            <c:if test="${not empty sessionScope.checkoutMessage}">
                                <div class="alert alert-success">
                                    <c:out value="${sessionScope.checkoutMessage}" />
                                    <c:remove var="checkoutMessage" scope="session" />
                                </div>
                            </c:if>
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

                            <div class="address-list">
                                <c:if test="${empty addresses}">
                                    <div class="empty-addresses">
                                        <i class="fa-solid fa-location-dot"></i>
                                        <p>Bạn chưa có địa chỉ nào</p>
                                        <p>Hãy thêm địa chỉ để thuận tiện cho việc giao hàng</p>
                                    </div>
                                </c:if>

                                <c:forEach var="addr" items="${addresses}">
                                    <div class="address-card <c:if test='${addr.defaultAddress}'>default</c:if>">
                                        <div class="address-info">
                                            <div class="info-row">
                                                <span class="info-name">
                                                    <c:out value="${addr.receiverName}" />
                                                </span>
                                                <span class="info-divider">|</span>
                                                <span class="info-phone">
                                                    <c:out value="${addr.phoneNumber}" />
                                                </span>
                                            </div>
                                            <div class="info-address">
                                                <p>
                                                    <c:out value="${addr.address}" />
                                                </p>
                                                <p>
                                                    <c:out value="${addr.city}" />
                                                </p>
                                            </div>
                                            <div class="info-tags">
                                                <c:if test="${addr.defaultAddress}">
                                                    <span class="tag tag-default">Mặc định</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="address-actions">
                                            <div class="action-links">
                                                <button class="btn-text btn-edit" data-id="${addr.id}"
                                                    data-name="<c:out value='${addr.receiverName}'/>"
                                                    data-phone="<c:out value='${addr.phoneNumber}'/>"
                                                    data-address="<c:out value='${addr.address}'/>"
                                                    data-city="<c:out value='${addr.city}'/>"
                                                    data-default="${addr.defaultAddress}">Cập nhật
                                                </button>
                                                <c:choose>
                                                    <c:when test="${addr.defaultAddress}">
                                                        <button class="btn-text disabled" disabled>Xóa</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="<c:url value='/addresses'/>" method="post"
                                                            style="display:inline;">
                                                            <input type="hidden" name="action" value="delete" />
                                                            <input type="hidden" name="addressId" value="${addr.id}" />
                                                            <button type="submit" class="btn-text text-danger"
                                                                onclick="return confirm('Bạn có chắc muốn xóa địa chỉ này?')">Xóa</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <c:if test="${!addr.defaultAddress}">
                                                <form action="<c:url value='/addresses'/>" method="post"
                                                    style="display:inline;">
                                                    <input type="hidden" name="action" value="setDefault" />
                                                    <input type="hidden" name="addressId" value="${addr.id}" />
                                                    <button type="submit" class="btn btn-outline btn-sm">Thiết lập mặc
                                                        định</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${addr.defaultAddress}">
                                                <button class="btn btn-outline btn-sm disabled" disabled>Thiết lập mặc
                                                    định</button>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </main>
                    </div>
                </div>
            </section>

            <div class="modal" id="addressModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modalTitle">Địa chỉ mới</h3>
                        <span class="close-modal">&times;</span>
                    </div>
                    <div class="modal-body">
                        <form class="address-form" action="<c:url value='/addresses'/>" method="post">
                            <input type="hidden" name="action" id="formAction" value="add" />
                            <input type="hidden" name="addressId" id="addressId" value="" />

                            <div class="form-row">
                                <input type="text" name="receiverName" id="receiverName" class="form-input"
                                    placeholder="Họ và tên" required />
                                <input type="tel" name="phoneNumber" id="phoneNumber" class="form-input"
                                    placeholder="Số điện thoại" pattern="0[3578][0-9]{8}" inputmode="numeric"
                                    maxlength="10" title="Số điện thoại phải có 10 chữ số. Ví dụ: 0912345678"
                                    required />
                            </div>
                            <div class="form-group">
                                <input type="text" name="city" id="city" class="form-input"
                                    placeholder="Tỉnh/Thành phố, Quận/Huyện, Phường/Xã" required />
                            </div>
                            <div class="form-group">
                                <textarea name="address" id="address" class="form-input"
                                    placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)" rows="2" required></textarea>
                            </div>

                            <c:if test="${not empty addresses}">
                                <div class="form-group">
                                    <label class="checkbox-label">
                                        <input type="checkbox" name="isDefault" id="isDefault" /> Đặt làm địa chỉ mặc
                                        định
                                    </label>
                                </div>
                            </c:if>
                            <c:if test="${empty addresses}">
                                <input type="hidden" name="isDefault" value="1" />
                                <p style="color: #666; font-size: 14px; margin-bottom: 15px;">
                                    <i class="fa-solid fa-info-circle"></i> Địa chỉ đầu tiên sẽ tự động là mặc định
                                </p>
                            </c:if>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline close-modal-btn">Trở lại</button>
                                <button type="submit" class="btn btn-primary">Hoàn thành</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- FOOTER -->
            <jsp:include page="footer.jsp"></jsp:include>

            <script>
                const modal = document.getElementById("addressModal");
                const btnAdd = document.getElementById("btnAddAddress");
                const spanClose = document.getElementsByClassName("close-modal")[0];
                const btnClose = document.getElementsByClassName("close-modal-btn")[0];
                const phoneInput = document.getElementById("phoneNumber");

                // Validate input số điện thoại - chỉ cho phép số
                phoneInput.addEventListener('input', function (e) {
                    this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);
                });

                // Validate Vietnamese phone format on form submit
                document.querySelector('.address-form').addEventListener('submit', function (e) {
                    const phoneValue = phoneInput.value.trim();
                    const phoneRegex = /^0[3578][0-9]{8}$/;

                    if (phoneValue && !phoneRegex.test(phoneValue)) {
                        e.preventDefault();
                        alert('Số điện thoại không hợp lệ.\n\nYêu cầu: 10 chữ số, bắt đầu từ 03, 05, 07, 08 hoặc 09.\nVí dụ: 0912345678');
                        phoneInput.focus();
                        return false;
                    }
                });

                // Reset form
                function resetForm() {
                    document.getElementById("modalTitle").textContent = "Địa chỉ mới";
                    document.getElementById("formAction").value = "add";
                    document.getElementById("addressId").value = "";
                    document.getElementById("receiverName").value = "";
                    document.getElementById("phoneNumber").value = "";
                    document.getElementById("city").value = "";
                    document.getElementById("address").value = "";

                    // Chỉ reset checkbox nếu nó tồn tại
                    const isDefaultCheckbox = document.getElementById("isDefault");
                    if (isDefaultCheckbox) {
                        isDefaultCheckbox.checked = false;
                    }
                }

                // Mở modal thêm mới
                btnAdd.onclick = function () {
                    resetForm();
                    modal.style.display = "flex";
                };

                // Đóng modal
                const closeModal = () => {
                    modal.style.display = "none";
                };
                spanClose.onclick = closeModal;
                btnClose.onclick = closeModal;

                // Click ra ngoài thì đóng
                window.onclick = function (event) {
                    if (event.target == modal) {
                        closeModal();
                    }
                };

                // Xử lý nút Cập nhật
                document.querySelectorAll('.btn-edit').forEach(btn => {
                    btn.onclick = function () {
                        document.getElementById("modalTitle").textContent = "Cập nhật địa chỉ";
                        document.getElementById("formAction").value = "update";
                        document.getElementById("addressId").value = this.dataset.id;
                        document.getElementById("receiverName").value = this.dataset.name;
                        document.getElementById("phoneNumber").value = this.dataset.phone;
                        document.getElementById("city").value = this.dataset.city;
                        document.getElementById("address").value = this.dataset.address;

                        const isDefaultCheckbox = document.getElementById("isDefault");
                        if (isDefaultCheckbox) {
                            isDefaultCheckbox.checked = this.dataset.default === "true";
                        }

                        modal.style.display = "flex";
                    };
                });
            </script>
        </body>

        </html>