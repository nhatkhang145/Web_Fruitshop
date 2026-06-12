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

    <main class="roles-page">
        <section class="page-hero roles-hero">
            <div class="hero-copy">
                <h1>Phân quyền hệ thống</h1>
                
            </div>
            <div class="hero-actions">
                <button type="button" class="btn btn-primary" id="openCreateRoleBtn" aria-controls="create-role-panel" aria-expanded="false">
                    <i class='bx bx-plus-circle'></i>
                    <span>Thêm vai trò mới</span>
                </button>
            </div>
        </section>

        <section class="roles-overview">
            <article class="role-metric accent-teal">
                <div class="metric-icon"><i class='bx bx-user-check'></i></div>
                <div>
                    <span class="metric-label">Tổng vai trò</span>
                    <strong class="metric-value">3</strong>
                    
                </div>
            </article>
            <article class="role-metric accent-amber">
                <div class="metric-icon"><i class='bx bx-lock-open'></i></div>
                <div>
                    <span class="metric-label">Quyền đang mở</span>
                    <strong class="metric-value">42</strong>
                    
                </div>
            </article>
            <article class="role-metric accent-slate">
                <div class="metric-icon"><i class='bx bx-user'></i></div>
                <div>
                    <span class="metric-label">Tài khoản áp dụng</span>
                    <strong class="metric-value">15</strong>
                    
                </div>
            </article>
        </section>

        <div class="create-role-overlay is-hidden" id="create-role-panel" aria-hidden="true">
            <div class="create-role-backdrop" id="createRoleBackdrop"></div>
            <section class="panel create-role-modal" role="dialog" aria-modal="true" aria-labelledby="createRoleTitle">
                <div class="panel-header create-role-header">
                    <div>
                        <h2 id="createRoleTitle">Thêm vai trò</h2>
                        <p>Nhập thông tin vai trò và chọn quyền cơ bản.</p>
                    </div>
                </div>

                <div class="create-role-grid">
                    <div class="create-role-form">
                        <div class="form-field">
                            <label for="roleName">Tên vai trò <span class="required-mark">*</span></label>
                            <input id="roleName" type="text" placeholder="VD: NV Quản lý sản phẩm" />
                        </div>

                        <div class="form-field">
                            <label for="roleDescription">Mô tả</label>
                            <textarea id="roleDescription" rows="4" placeholder="Mô tả vai trò..."></textarea>
                        </div>
                    </div>

                    <div class="create-role-actions">
                        <button type="button" class="btn btn-ghost" id="closeCreateRoleBtn">Hủy</button>
                        <button type="button" class="btn btn-primary">
                            <i class='bx bx-check'></i>
                            <span>Tạo</span>
                        </button>
                    </div>
                </div>
            </section>
        </div>

        <div class="roles-shell">
            <aside class="panel role-list-panel">
                <div class="panel-header role-list-header">
                    <div>
                        <h2>Danh sách vai trò</h2>
                        
                    </div>
                    <button type="button" class="btn btn-ghost btn-sm">
                        <i class='bx bx-filter-alt'></i>
                        <span>Lọc</span>
                    </button>
                </div>
                <div class="role-search">
                    <i class='bx bx-search'></i>
                    <input type="text" placeholder="Tìm vai trò hoặc mô tả..." />
                </div>
                <div class="role-list">
                    <div class="role-card active">
                        <div class="role-info">
                            <h3>Admin</h3>
                            <p>Toàn quyền hệ thống, quản trị cấu hình.</p>
                            
                        </div>
                        <div class="role-stats">
                            <div class="role-users">
                                <i class='bx bx-user'></i> 2
                            </div>
                            
                        </div>
                    </div>
                    <div class="role-card">
                        <div class="role-info">
                            <h3>Nhân viên kho</h3>
                            <p>Quản lý nhập xuất, tồn kho và kiểm kê.</p>
                            
                        </div>
                        <div class="role-stats">
                            <div class="role-users">
                                <i class='bx bx-user'></i> 5
                            </div>
                            
                        </div>
                    </div>
                    <div class="role-card">
                        <div class="role-info">
                            <h3>Chăm sóc khách hàng</h3>
                            <p>Quản lý đơn hàng, khách hàng và phản hồi.</p>
                            
                        </div>
                        <div class="role-stats">
                            <div class="role-users">
                                <i class='bx bx-user'></i> 8
                            </div>
                           
                        </div>
                    </div>
                </div>
            </aside>

            <section class="panel role-matrix-panel">
                <div class="panel-header role-detail-header">
                    <div>
                        <div class="role-title">
                            <h2>Phân quyền: <span class="highlight-role">Admin</span></h2>
                            <span class="role-badge solid">System</span>
                        </div>
                        
                    </div>
                </div>

                <div class="matrix-toolbar">
                    <div class="matrix-pills">
                        <button type="button" class="pill active">Mặc định</button>
                        <button type="button" class="pill">Kho</button>
                        <button type="button" class="pill">Bán hàng</button>
                        <button type="button" class="pill">Hệ thống</button>
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
                    <div class="action-note">                                     
                    </div>
                    <div class="action-buttons">
                        <button type="button" class="btn btn-ghost">Hoàn tác</button>
                        <button type="button" class="btn btn-primary" id="savePermissionsBtn">
                            <i class='bx bx-save'></i>
                            <span>Lưu thay đổi phân quyền</span>
                        </button>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>

    <script>
        (function () {
            const openButton = document.getElementById('openCreateRoleBtn');
            const closeButton = document.getElementById('closeCreateRoleBtn');
            const createPanel = document.getElementById('create-role-panel');
            const backdrop = document.getElementById('createRoleBackdrop');

            if (!openButton || !closeButton || !createPanel || !backdrop) {
                return;
            }

            const showPanel = () => {
                createPanel.classList.remove('is-hidden');
                createPanel.setAttribute('aria-hidden', 'false');
                openButton.setAttribute('aria-expanded', 'true');
                document.body.classList.add('modal-open');
            };

            const hidePanel = () => {
                createPanel.classList.add('is-hidden');
                createPanel.setAttribute('aria-hidden', 'true');
                openButton.setAttribute('aria-expanded', 'false');
                document.body.classList.remove('modal-open');
                openButton.focus();
            };

            openButton.addEventListener('click', showPanel);
            closeButton.addEventListener('click', hidePanel);
            backdrop.addEventListener('click', hidePanel);
            document.addEventListener('keydown', (event) => {
                if (event.key === 'Escape' && !createPanel.classList.contains('is-hidden')) {
                    hidePanel();
                }
            });
        }());
    </script>

</body>
</html>
