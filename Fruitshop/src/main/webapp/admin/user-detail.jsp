<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ người dùng | Admin Dashboard</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/user-detail.css">
</head>

<body>

<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="users" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main class="user-detail-container">

        <div class="page-header">
            <div>
                <h1 class="page-title">Chi tiết người dùng</h1>
                <ul class="breadcrumb">
                    <li><a href="${pageContext.request.contextPath}/admin/users">Danh sách</a></li>
                    <li>/</li>
                    <li><span class="active">Hồ sơ #${user.id}</span></li>
                </ul>
            </div>
            <div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/user-detail" method="post">
            <input type="hidden" name="id" value="${user.id}">

            <div class="detail-grid">

                <div class="left-col">
                    <div class="card profile-card">
                        <div class="profile-summary">
                            <img
                                    src="${user.avatar != null ? user.avatar : pageContext.request.contextPath.concat('/assets/images/logo.jpg')}"
                                    alt="Avatar" class="profile-avatar">
                            <h2 class="profile-name">${user.fullName}</h2>
                            <span class="profile-role ${user.role == 1 ? 'role-admin' : 'role-user'}">
                                ${user.role == 1 ? 'Quản trị viên' : 'Khách hàng'}
                            </span>

                            <div class="profile-meta">
                                <span><i class='bx bx-id-card'></i> ID: #${user.id}</span>
                                <span><i class='bx bx-calendar'></i> Tham gia:
                          <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                        </span>
                                <span><i class='bx bx-log-in-circle'></i> Kiểu đăng nhập:
                          ${user.loginType != null ? user.loginType : 'Hệ thống'}
                        </span>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <h3 class="card-title"><i class='bx bx-cog'></i> Cài đặt tài khoản</h3>

                        <div class="form-group">
                            <label for="role">Vai trò hệ thống</label>
                            <select name="role" id="role" class="form-control">
                                <option value="0" ${user.role==0 ? 'selected' : '' }>Khách hàng (User)</option>
                                <option value="1" ${user.role==1 ? 'selected' : '' }>Quản trị viên (Admin)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="status">Trạng thái</label>
                            <select name="status" id="status" class="form-control">
                                <option value="active" ${user.status !=0 ? 'selected' : '' }>Hoạt động</option>
                                <option value="banned" ${user.status==0 ? 'selected' : '' }>Đã khóa (Banned)</option>
                            </select>
                        </div>

                        <div class="action-bar action-bar--center action-bar--tight">
                            <button type="submit" class="btn btn-save btn-full">
                                <i class='bx bx-save'></i> Cập nhật trạng thái
                            </button>
                        </div>
                    </div>
                </div>

                <div class="right-col">

                    <div class="card">
                        <h3 class="card-title">Thông tin cá nhân</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Họ và Tên</label>
                                <input type="text" name="fullName" class="form-control" value="${user.fullName}">
                            </div>
                            <div class="form-group">
                                <label>Email (Tên đăng nhập)</label>
                                <input type="email" class="form-control" value="${user.email}" readonly>
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại</label>
                                <input type="text" name="phone" class="form-control"
                                       value="${user.phone != null ? user.phone : ''}">
                            </div>
                            <div class="form-group">
                                <label>Giới tính</label>
                                <select name="gender" class="form-control">
                                    <option value="">-- Chọn giới tính --</option>
                                    <option value="Nam" ${user.gender=='Nam' ? 'selected' : '' }>Nam</option>
                                    <option value="Nữ" ${user.gender=='Nữ' ? 'selected' : '' }>Nữ</option>
                                    <option value="Khác" ${user.gender=='Khác' ? 'selected' : '' }>Khác</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Ngày sinh</label>
                                <input type="date" name="birthDate" class="form-control"
                                       value="<fmt:formatDate value='${user.birthDate}' pattern='yyyy-MM-dd'/>">
                            </div>
                            <div class="form-group">
                                <label>Social ID</label>
                                <input type="text" class="form-control"
                                       value="${user.socialId != null ? user.socialId : 'Không'}" readonly>
                            </div>
                        </div>
                        <div class="action-bar action-bar--center action-bar--tight">
                            <button type="submit" class="btn btn-save btn-full">
                                <i class='bx bx-save'></i> Cập nhật thông tin cá nhân
                            </button>
                        </div>
                    </div>

                    <div class="card">
                        <h3 class="card-title">Sổ địa chỉ (${addresses != null ? addresses.size() : 0})</h3>

                        <c:choose>
                            <c:when test="${not empty addresses}">
                                <div class="address-grid">
                                    <c:forEach items="${addresses}" var="addr">
                                        <div class="address-item address-card ${addr.isDefault ? 'default' : ''}">
                                            <c:if test="${addr.isDefault}">
                                                <span class="badge-default"><i class='bx bx-check'></i> Mặc định</span>
                                            </c:if>

                                            <span class="addr-name">${addr.receiverName}</span>
                                            <div class="addr-phone">
                                                <i class='bx bx-phone'></i> ${addr.phoneNumber}
                                            </div>
                                            <div class="addr-detail">
                                                <i class='bx bx-map'></i> ${addr.address}, ${addr.city}
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class='bx bx-map-pin empty-state-icon'></i>
                                    <p>Người dùng này chưa lưu địa chỉ giao hàng nào.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="action-bar">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-cancel">Quay lại danh sách</a>
                    </div>
                </div>
            </div>
        </form>

    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/main.js"></script>
</body>

</html>