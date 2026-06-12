<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Quản lý phân quyền | Admin</title>

    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin_style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/roles.css"/>
</head>

<body>
<jsp:include page="/admin/layout/sidebar.jsp">
    <jsp:param name="activePage" value="roles"/>
</jsp:include>

<div class="content">
    <jsp:include page="/admin/layout/header.jsp"/>

    <main class="roles-page">
     
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success" id="alertMsg">
                <c:choose>
                    <c:when test="${successMsg eq 'created'}"><i
                            class='bx bx-check-circle'></i> Tạo vai trò mới thành công!</c:when>
                    <c:when test="${successMsg eq 'saved'}"><i
                            class='bx bx-check-circle'></i> Lưu phân quyền thành công!</c:when>
                    <c:when test="${successMsg eq 'deleted'}"><i
                            class='bx bx-check-circle'></i> Đã xóa vai trò thành công!</c:when>
                    <c:otherwise><i class='bx bx-check-circle'></i> Thao tác thành công!</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error" id="alertMsg">
                <c:choose>
                    <c:when test="${errorMsg eq 'missing_name'}"><i
                            class='bx bx-error-circle'></i> Vui lòng nhập tên vai trò!</c:when>
                    <c:when test="${errorMsg eq 'duplicate_name'}"><i
                            class='bx bx-error-circle'></i> Tên vai trò đã tồn tại!</c:when>
                    <c:when test="${errorMsg eq 'role_not_found'}"><i
                            class='bx bx-error-circle'></i> Không tìm thấy vai trò!</c:when>
                    <c:when test="${errorMsg eq 'delete_failed'}"><i
                            class='bx bx-error-circle'></i> Không thể xóa vai trò!</c:when>
                    <c:otherwise><i class='bx bx-error-circle'></i> Đã có lỗi xảy ra!</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <section class="page-hero roles-hero">
            <div class="hero-copy">
                <h1>Phân quyền hệ thống</h1>
            </div>
            <div class="hero-actions">
                <button type="button" class="btn btn-primary" id="openCreateRoleBtn" aria-controls="create-role-panel"
                        aria-expanded="false">
                    <i class='bx bx-plus-circle'></i>
                    <span>Thêm vai trò mới</span>
                </button>
            </div>
        </section>

        <%-- ─── Thống kê ─── --%>
        <section class="roles-overview">
            <article class="role-metric accent-teal">
                <div class="metric-icon"><i class='bx bx-user-check'></i></div>
                <div>
                    <span class="metric-label">Tổng vai trò</span>
                    <strong class="metric-value">${totalRoles}</strong>
                </div>
            </article>
            <article class="role-metric accent-amber">
                <div class="metric-icon"><i class='bx bx-lock-open'></i></div>
                <div>
                    <span class="metric-label">Quyền đang mở</span>
                    <strong class="metric-value">${activePermissions}</strong>
                </div>
            </article>
            <article class="role-metric accent-slate">
                <div class="metric-icon"><i class='bx bx-user'></i></div>
                <div>
                    <span class="metric-label">Tài khoản áp dụng</span>
                    <strong class="metric-value">${usersWithRole}</strong>
                </div>
            </article>
        </section>

        <%-- ─── Modal tạo role ─── --%>
        <div class="create-role-overlay is-hidden" id="create-role-panel" aria-hidden="true">
            <div class="create-role-backdrop" id="createRoleBackdrop"></div>
            <section class="panel create-role-modal" role="dialog" aria-modal="true" aria-labelledby="createRoleTitle">
                <div class="panel-header create-role-header">
                    <div>
                        <h2 id="createRoleTitle">Thêm vai trò</h2>
                        <p>Nhập thông tin vai trò và chọn quyền cơ bản.</p>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/roles">
                    <input type="hidden" name="action" value="create"/>
                    <div class="create-role-grid">
                        <div class="create-role-form">
                            <div class="form-field">
                                <label for="roleName">Tên vai trò <span class="required-mark">*</span></label>
                                <input id="roleName" name="roleName" type="text" placeholder="VD: NV Quản lý sản phẩm"
                                       required/>
                            </div>

                            <div class="form-field">
                                <label for="roleDescription">Mô tả</label>
                                <textarea id="roleDescription" name="roleDescription" rows="4"
                                          placeholder="Mô tả vai trò..."></textarea>
                            </div>
                        </div>

                        <div class="create-role-actions">
                            <button type="button" class="btn btn-ghost" id="closeCreateRoleBtn">Hủy</button>
                            <button type="submit" class="btn btn-primary">
                                <i class='bx bx-check'></i>
                                <span>Tạo</span>
                            </button>
                        </div>
                    </div>
                </form>
            </section>
        </div>

        <%-- ─── Shell: Danh sách + Ma trận ─── --%>
        <div class="roles-shell">
            <%-- Sidebar danh sách role --%>
            <aside class="panel role-list-panel">
                <div class="panel-header role-list-header">
                    <div>
                        <h2>Danh sách vai trò</h2>
                    </div>
                </div>
                <div class="role-search">
                    <i class='bx bx-search'></i>
                    <input type="text" id="roleSearchInput" placeholder="Tìm vai trò hoặc mô tả..."/>
                </div>
                <div class="role-list" id="roleList">
                    <c:forEach var="role" items="${roles}">
                        <div class="role-card ${role.id == selectedRoleId ? 'active' : ''}"
                             data-role-id="${role.id}"
                             data-role-name="${role.name}"
                             onclick="selectRole(${role.id})">
                            <div class="role-info">
                                <h3>${role.name}</h3>
                                <p>${not empty role.description ? role.description : 'Chưa có mô tả'}</p>
                            </div>
                            <div class="role-stats">
                                <div class="role-users">
                                    <i class='bx bx-user'></i> ${role.userCount}
                                </div>
                                    <%-- Nút xóa (không xóa role đầu tiên - Admin) --%>
                                <c:if test="${role.id > 1}">
                                    <button type="button" class="btn-icon-danger"
                                            title="Xóa vai trò"
                                            onclick="confirmDeleteRole(event, ${role.id}, '${role.name}')">
                                        <i class='bx bx-trash'></i>
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty roles}">
                        <div class="empty-state">Chưa có vai trò nào.</div>
                    </c:if>
                </div>
            </aside>

            <%-- Ma trận phân quyền --%>
            <section class="panel role-matrix-panel">
                <c:choose>
                    <c:when test="${selectedRole != null}">
                        <div class="panel-header role-detail-header">
                            <div>
                                <div class="role-title">
                                    <h2>Phân quyền: <span class="highlight-role">${selectedRole.name}</span></h2>
                                    <span class="role-badge solid">Role #${selectedRole.id}</span>
                                </div>
                                <c:if test="${not empty selectedRole.description}">
                                    <p class="role-desc-text">${selectedRole.description}</p>
                                </c:if>
                            </div>
                        </div>

                        <%-- Pills lọc theo nhóm module --%>
                        <div class="matrix-toolbar">
                            <div class="matrix-pills">
                                <button type="button" class="pill active" data-filter="all">Tất cả</button>
                                <button type="button" class="pill" data-filter="mac_dinh">Mặc định</button>
                                <button type="button" class="pill" data-filter="kho">Kho</button>
                                <button type="button" class="pill" data-filter="ban_hang">Bán hàng</button>
                                <button type="button" class="pill" data-filter="he_thong">Hệ thống</button>
                            </div>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/roles"
                              id="permissionsForm">
                            <input type="hidden" name="action" value="save-permissions"/>
                            <input type="hidden" name="roleId" value="${selectedRole.id}"/>

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
                                    <c:forEach var="module" items="${modules}">
                                        <c:set var="perm" value="${permMap[module.id]}"/>
                                        <tr data-category="${module.category}">
                                            <td>
                                                <span class="module-name">${module.name}</span>
                                                <c:if test="${not empty module.description}">
                                                    <small class="module-desc">${module.description}</small>
                                                </c:if>
                                            </td>
                                            <td class="text-center">
                                                <label class="custom-checkbox">
                                                    <input type="checkbox"
                                                           name="perm_${module.id}_read"
                                                           class="perm-check read-check"
                                                        ${perm != null && perm.canRead ? 'checked' : ''}>
                                                    <span class="checkmark"></span>
                                                </label>
                                            </td>
                                            <td class="text-center">
                                                <label class="custom-checkbox">
                                                    <input type="checkbox"
                                                           name="perm_${module.id}_create"
                                                           class="perm-check create-check"
                                                        ${perm != null && perm.canCreate ? 'checked' : ''}>
                                                    <span class="checkmark"></span>
                                                </label>
                                            </td>
                                            <td class="text-center">
                                                <label class="custom-checkbox">
                                                    <input type="checkbox"
                                                           name="perm_${module.id}_update"
                                                           class="perm-check update-check"
                                                        ${perm != null && perm.canUpdate ? 'checked' : ''}>
                                                    <span class="checkmark"></span>
                                                </label>
                                            </td>
                                            <td class="text-center">
                                                <label class="custom-checkbox">
                                                    <input type="checkbox"
                                                           name="perm_${module.id}_delete"
                                                           class="perm-check delete-check"
                                                        ${perm != null && perm.canDelete ? 'checked' : ''}>
                                                    <span class="checkmark"></span>
                                                </label>
                                            </td>
                                            <td class="text-center">
                                                <label class="custom-checkbox">
                                                    <input type="checkbox" class="check-all-row"
                                                        ${perm != null && perm.canRead && perm.canCreate && perm.canUpdate && perm.canDelete ? 'checked' : ''}>
                                                    <span class="checkmark"></span>
                                                </label>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty modules}">
                                        <tr>
                                            <td colspan="6" class="empty-state">Chưa có module nào trong hệ thống.</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <div class="action-bar">
                                <div class="action-note"></div>
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-ghost" id="resetPermissionsBtn">Hoàn tác
                                    </button>
                                    <button type="submit" class="btn btn-primary" id="savePermissionsBtn">
                                        <i class='bx bx-save'></i>
                                        <span>Lưu thay đổi phân quyền</span>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-matrix">
                            <i class='bx bx-shield-quarter'></i>
                            <p>Chọn một vai trò bên trái để xem và chỉnh sửa phân quyền.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
</div>

<%-- Modal xác nhận xóa --%>
<div class="delete-confirm-overlay is-hidden" id="deleteConfirmModal">
    <div class="delete-confirm-backdrop"></div>
    <div class="delete-confirm-box">
        <i class='bx bx-error-circle'></i>
        <h3>Xác nhận xóa vai trò</h3>
        <p>Bạn có chắc muốn xóa vai trò <strong id="deleteRoleName"></strong>?<br/>
            Tất cả phân quyền của vai trò này sẽ bị xóa.</p>
        <div class="confirm-actions">
            <button class="btn btn-ghost" onclick="closeDeleteModal()">Hủy</button>
            <form method="post" action="${pageContext.request.contextPath}/admin/roles" id="deleteRoleForm">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="roleId" id="deleteRoleId"/>
                <button type="submit" class="btn btn-danger">Xóa</button>
            </form>
        </div>
    </div>
</div>

<script>
    
    function selectRole(roleId) {
        window.location.href = '${pageContext.request.contextPath}/admin/roles?roleId=' + roleId;
    }

    
    function confirmDeleteRole(event, roleId, roleName) {
        event.stopPropagation();
        document.getElementById('deleteRoleId').value = roleId;
        document.getElementById('deleteRoleName').textContent = roleName;
        document.getElementById('deleteConfirmModal').classList.remove('is-hidden');
    }

    function closeDeleteModal() {
        document.getElementById('deleteConfirmModal').classList.add('is-hidden');
    }

    document.querySelector('.delete-confirm-backdrop') &&
    document.querySelector('.delete-confirm-backdrop').addEventListener('click', closeDeleteModal);

    
    (function () {
        const openButton = document.getElementById('openCreateRoleBtn');
        const closeButton = document.getElementById('closeCreateRoleBtn');
        const createPanel = document.getElementById('create-role-panel');
        const backdrop = document.getElementById('createRoleBackdrop');

        if (!openButton || !closeButton || !createPanel) return;

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
        backdrop && backdrop.addEventListener('click', hidePanel);
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && !createPanel.classList.contains('is-hidden')) hidePanel();
        });
    }());

   
    document.getElementById('roleSearchInput') && document.getElementById('roleSearchInput').addEventListener('input', function () {
        const q = this.value.toLowerCase();
        document.querySelectorAll('.role-card').forEach(card => {
            const name = card.querySelector('h3')?.textContent.toLowerCase() || '';
            const desc = card.querySelector('p')?.textContent.toLowerCase() || '';
            card.style.display = (name.includes(q) || desc.includes(q)) ? '' : 'none';
        });
    });

    
    document.querySelectorAll('.pill').forEach(pill => {
        pill.addEventListener('click', function () {
            document.querySelectorAll('.pill').forEach(p => p.classList.remove('active'));
            this.classList.add('active');
            const filter = this.dataset.filter;
            document.querySelectorAll('.matrix-table tbody tr').forEach(row => {
                row.style.display = (filter === 'all' || row.dataset.category === filter) ? '' : 'none';
            });
        });
    });

    document.querySelectorAll('.check-all-col').forEach(colCheck => {
        colCheck.addEventListener('change', function () {
            const col = this.dataset.col;
            document.querySelectorAll('.matrix-table tbody tr').forEach(row => {
                if (row.style.display !== 'none') {
                    const cb = row.querySelector('.' + col + '-check');
                    if (cb && !cb.disabled) cb.checked = this.checked;
                }
            });
            syncRowChecks();
        });
    });

    
    const globalCheck = document.querySelector('.check-all-row-global');
    globalCheck && globalCheck.addEventListener('change', function () {
        document.querySelectorAll('.perm-check:not([disabled])').forEach(cb => cb.checked = this.checked);
        document.querySelectorAll('.check-all-row').forEach(cb => {
            if (!cb.disabled) cb.checked = this.checked;
        });
        document.querySelectorAll('.check-all-col').forEach(cb => cb.checked = this.checked);
    });

   
    document.querySelectorAll('.check-all-row').forEach(rowCheck => {
        rowCheck.addEventListener('change', function () {
            const row = this.closest('tr');
            row.querySelectorAll('.perm-check:not([disabled])').forEach(cb => cb.checked = this.checked);
            syncColChecks();
        });
    });

    
    document.querySelectorAll('.perm-check').forEach(cb => {
        cb.addEventListener('change', () => syncRowChecks());
    });

    function syncRowChecks() {
        document.querySelectorAll('.matrix-table tbody tr').forEach(row => {
            const perms = row.querySelectorAll('.perm-check:not([disabled])');
            const allChecked = [...perms].every(cb => cb.checked);
            const rowAll = row.querySelector('.check-all-row');
            if (rowAll && !rowAll.disabled) rowAll.checked = allChecked;
        });
        syncColChecks();
    }

    function syncColChecks() {
        ['read', 'create', 'update', 'delete'].forEach(col => {
            const colCbs = [...document.querySelectorAll('.' + col + '-check:not([disabled])')];
            const colHeader = document.querySelector('.check-all-col[data-col="' + col + '"]');
            if (colHeader) colHeader.checked = colCbs.length > 0 && colCbs.every(cb => cb.checked);
        });
    }

    document.getElementById('resetPermissionsBtn') &&
    document.getElementById('resetPermissionsBtn').addEventListener('click', () => {
        window.location.reload();
    });

   
    const alertEl = document.getElementById('alertMsg');
    if (alertEl) {
        setTimeout(() => {
            alertEl.style.opacity = '0';
            alertEl.style.transition = 'opacity 0.5s';
            setTimeout(() => alertEl.remove(), 500);
        }, 4000);
    }
</script>

</body>
</html>
