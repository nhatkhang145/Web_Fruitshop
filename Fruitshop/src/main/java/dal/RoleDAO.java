package dal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Module;
import model.Role;
import model.RolePermission;

public class RoleDAO {

    public List<Role> getAllRolesWithStats() {
        String sql = """
                SELECT r.id, r.name, r.description, r.created_at,
                       COALESCE(SUM(
                           (CASE WHEN rp.can_read   = 1 THEN 1 ELSE 0 END) +
                           (CASE WHEN rp.can_create = 1 THEN 1 ELSE 0 END) +
                           (CASE WHEN rp.can_update = 1 THEN 1 ELSE 0 END) +
                           (CASE WHEN rp.can_delete = 1 THEN 1 ELSE 0 END)
                       ), 0) AS permission_count
                FROM roles r
                LEFT JOIN role_permissions rp ON rp.role_id = r.id
                GROUP BY r.id, r.name, r.description, r.created_at
                ORDER BY r.id
                """;
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> {
                    Role role = new Role();
                    role.setId(rs.getInt("id"));
                    role.setName(rs.getString("name"));
                    role.setDescription(rs.getString("description"));
                    role.setCreatedAt(rs.getTimestamp("created_at"));
                    role.setPermissionCount(rs.getInt("permission_count"));
                    return role;
                })
                .list());
    }

    public Role getRoleById(int id) {
        String sql = "SELECT id, name, description, created_at FROM roles WHERE id = :id";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> {
                    Role role = new Role();
                    role.setId(rs.getInt("id"));
                    role.setName(rs.getString("name"));
                    role.setDescription(rs.getString("description"));
                    role.setCreatedAt(rs.getTimestamp("created_at"));
                    return role;
                })
                .findFirst()
                .orElse(null));
    }

    public boolean roleNameExists(String name, Integer excludeId) {
        String sql = excludeId != null
                ? "SELECT COUNT(*) FROM roles WHERE name = :name AND id <> :excludeId"
                : "SELECT COUNT(*) FROM roles WHERE name = :name";
        return DBContext.get().withHandle(handle -> {
            var q = handle.createQuery(sql).bind("name", name);
            if (excludeId != null) q = q.bind("excludeId", excludeId);
            return q.mapTo(Integer.class).one() > 0;
        });
    }

    public int insertRole(String name, String description) {
        String sql = "INSERT INTO roles (name, description, created_at) VALUES (:name, :description, NOW())";
        return DBContext.get().withHandle(handle -> {
            handle.createUpdate(sql)
                    .bind("name", name)
                    .bind("description", description)
                    .execute();
            return handle.createQuery("SELECT LAST_INSERT_ID()").mapTo(Integer.class).one();
        });
    }

    public boolean updateRole(int id, String name, String description) {
        String sql = "UPDATE roles SET name = :name, description = :description WHERE id = :id";
        int rows = DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind("name", name)
                .bind("description", description)
                .bind("id", id)
                .execute());
        return rows > 0;
    }

    public boolean deleteRole(int id) {
        return DBContext.get().withHandle(handle -> {
            handle.createUpdate("DELETE FROM role_permissions WHERE role_id = :id").bind("id", id).execute();
            return handle.createUpdate("DELETE FROM roles WHERE id = :id").bind("id", id).execute() > 0;
        });
    }

    public List<Module> getAllModules() {
        String sql = "SELECT id, name, description, category FROM modules ORDER BY category, id";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> {
                    Module m = new Module();
                    m.setId(rs.getInt("id"));
                    m.setName(rs.getString("name"));
                    m.setDescription(rs.getString("description"));
                    m.setCategory(rs.getString("category"));
                    return m;
                })
                .list());
    }

    public Map<Integer, RolePermission> getPermissionsMapByRoleId(int roleId) {
        String sql = "SELECT id, role_id, module_id, can_read, can_create, can_update, can_delete " +
                "FROM role_permissions WHERE role_id = :roleId";
        List<RolePermission> list = DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind("roleId", roleId)
                .map((rs, ctx) -> {
                    RolePermission rp = new RolePermission();
                    rp.setId(rs.getInt("id"));
                    rp.setRoleId(rs.getInt("role_id"));
                    rp.setModuleId(rs.getInt("module_id"));
                    rp.setCanRead(rs.getBoolean("can_read"));
                    rp.setCanCreate(rs.getBoolean("can_create"));
                    rp.setCanUpdate(rs.getBoolean("can_update"));
                    rp.setCanDelete(rs.getBoolean("can_delete"));
                    return rp;
                })
                .list());

        Map<Integer, RolePermission> map = new HashMap<>();
        for (RolePermission rp : list) {
            map.put(rp.getModuleId(), rp);
        }
        return map;
    }

    public void savePermissions(int roleId, List<RolePermission> permissions) {
        DBContext.get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM role_permissions WHERE role_id = :roleId")
                    .bind("roleId", roleId)
                    .execute();

            String insertSql = """
                    INSERT INTO role_permissions (role_id, module_id, can_read, can_create, can_update, can_delete)
                    VALUES (:roleId, :moduleId, :canRead, :canCreate, :canUpdate, :canDelete)
                    """;
            for (RolePermission rp : permissions) {
                handle.createUpdate(insertSql)
                        .bind("roleId", roleId)
                        .bind("moduleId", rp.getModuleId())
                        .bind("canRead", rp.isCanRead())
                        .bind("canCreate", rp.isCanCreate())
                        .bind("canUpdate", rp.isCanUpdate())
                        .bind("canDelete", rp.isCanDelete())
                        .execute();
            }
        });
    }

    public int countRoles() {
        return DBContext.get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM roles").mapTo(Integer.class).one());
    }

    public int countActivePermissions() {
        String sql = """
                SELECT COALESCE(SUM(
                    (CASE WHEN can_read   = 1 THEN 1 ELSE 0 END) +
                    (CASE WHEN can_create = 1 THEN 1 ELSE 0 END) +
                    (CASE WHEN can_update = 1 THEN 1 ELSE 0 END) +
                    (CASE WHEN can_delete = 1 THEN 1 ELSE 0 END)
                ), 0) FROM role_permissions
                """;
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public int countUsersWithRole() {
        return DBContext.get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM users WHERE status = 1 AND (role = 1 OR (role_id IS NOT NULL AND role_id > 0))")
                        .mapTo(Integer.class).one());
    }
}