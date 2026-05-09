<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý phân quyền | Admin</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/roles.css" />
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="roles" />
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp" />

    <main>
        <div class="page-hero">
            <div class="hero-copy">
                <div class="eyebrow">Role management</div>
                <h1>Quản lý phân quyền</h1>
                <p>Thiết lập và quản lý quyền hạn truy cập của các nhóm tài khoản trong hệ thống.</p>
            </div>
            <div class="hero-actions">
                <button type="button" class="btn btn-primary" id="openCreateRoleBtn">
                    <i class='bx bx-plus-circle'></i>
                    <span>Thêm vai trò mới</span>
                </button>
            </div>
        </div>

        <div class="roles-layout">
            <section class="panel role-list-panel">
                <div class="panel-header">
                    <div>
                        <h2>Nhóm quyền (Roles)</h2>
                    </div>
                </div>
                <div class="role-list">
                    <div class="role-card active">
                        <div class="role-info">
                            <h3>Admin</h3>
                            <p>Toàn quyền hệ thống</p>
                        </div>
                        <div class="role-users">
                            <i class='bx bx-user'></i> 2
                        </div>
                    </div>
                    <div class="role-card">
                        <div class="role-info">
                            <h3>Nhân viên kho</h3>
                            <p>Quản lý nhập xuất, tồn kho</p>
                        </div>
                        <div class="role-users">
                            <i class='bx bx-user'></i> 5
                        </div>
                    </div>
                    <div class="role-card">
                        <div class="role-info">
                            <h3>Chăm sóc khách hàng</h3>
                            <p>Quản lý đơn hàng, khách hàng</p>
                        </div>
                        <div class="role-users">
                            <i class='bx bx-user'></i> 8
                        </div>
                    </div>
                </div>
            </section>

            <section class="panel role-matrix-panel">
                <div class="panel-header">
                    <div>
                        <h2>Chi tiết phân quyền: <span class="highlight-role">Admin</span></h2>
                        <p>Thiết lập quyền truy cập cho từng chức năng trong hệ thống.</p>
                    </div>
                </div>
                
                <div class="matrix-wrap">
                    <table class="matrix-table">
                        <thead>
                            <tr>
                                <th>Chức năng / Module</th>
                                <th class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-col" data-col="read">
                                        <span class="checkmark"></span>
                                        Xem (Read)
                                    </label>
                                </th>
                                <th class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-col" data-col="create">
                                        <span class="checkmark"></span>
                                        Thêm (Create)
                                    </label>
                                </th>
                                <th class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-col" data-col="update">
                                        <span class="checkmark"></span>
                                        Sửa (Update)
                                    </label>
                                </th>
                                <th class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-col" data-col="delete">
                                        <span class="checkmark"></span>
                                        Xóa (Delete)
                                    </label>
                                </th>
                                <th class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-row-global">
                                        <span class="checkmark"></span>
                                        Tất cả
                                    </label>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Quản lý sản phẩm</td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check read-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check create-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check update-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check delete-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-row" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Quản lý kho / Inventory</td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check read-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check create-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check update-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check delete-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-row" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Quản lý đơn hàng</td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check read-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check create-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check update-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check delete-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-row" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Quản lý khách hàng</td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check read-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check create-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check update-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check delete-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-row" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                            </tr>
                            
                            <tr>
                                <td>Báo cáo thống kê</td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check read-check" checked>
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check create-check" disabled>
                                        <span class="checkmark disabled"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check update-check" disabled>
                                        <span class="checkmark disabled"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="perm-check delete-check" disabled>
                                        <span class="checkmark disabled"></span>
                                    </label>
                                </td>
                                <td class="text-center">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" class="check-all-row" disabled>
                                        <span class="checkmark disabled"></span>
                                    </label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="action-bar">
                    <button type="button" class="btn btn-primary" id="savePermissionsBtn">
                        <i class='bx bx-save'></i>
                        <span>Lưu thay đổi phân quyền</span>
                    </button>
                </div>
            </section>
        </div>
    </main>
</div>

</body>
</html>
