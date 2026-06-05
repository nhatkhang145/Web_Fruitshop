package controller;

import dal.RoleDAO;
import model.Module;
import model.Role;
import model.RolePermission;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminRoleServlet", urlPatterns = {"/admin/roles"})
public class AdminRoleServlet extends HttpServlet {

    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int selectedRoleId = parseIntOrDefault(req.getParameter("roleId"), 0);

        List<Role> roles = roleDAO.getAllRolesWithStats();
        List<Module> modules = roleDAO.getAllModules();

        if (selectedRoleId == 0 && !roles.isEmpty()) {
            selectedRoleId = roles.get(0).getId();
        }

        Map<Integer, RolePermission> permMap = null;
        Role selectedRole = null;

        if (selectedRoleId > 0) {
            selectedRole = roleDAO.getRoleById(selectedRoleId);
            permMap = roleDAO.getPermissionsMapByRoleId(selectedRoleId);
        }

        int totalRoles = roleDAO.countRoles();
        int activePermissions = roleDAO.countActivePermissions();
        int usersWithRole = roleDAO.countUsersWithRole();

        req.setAttribute("roles", roles);
        req.setAttribute("modules", modules);
        req.setAttribute("selectedRole", selectedRole);
        req.setAttribute("selectedRoleId", selectedRoleId);
        req.setAttribute("permMap", permMap);
        req.setAttribute("totalRoles", totalRoles);
        req.setAttribute("activePermissions", activePermissions);
        req.setAttribute("usersWithRole", usersWithRole);
        req.setAttribute("successMsg", req.getParameter("success"));
        req.setAttribute("errorMsg", req.getParameter("error"));

        req.getRequestDispatcher("/admin/roles.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if (action == null) action = "";

        switch (action) {
            case "create":
                handleCreateRole(req, resp);
                break;
            case "save-permissions":
                handleSavePermissions(req, resp);
                break;
            case "delete":
                handleDeleteRole(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/roles");
        }
    }

    private void handleCreateRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("roleName");
        String desc = req.getParameter("roleDescription");

        if (name == null || name.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/roles?error=missing_name");
            return;
        }

        if (roleDAO.roleNameExists(name.trim(), null)) {
            resp.sendRedirect(req.getContextPath() + "/admin/roles?error=duplicate_name");
            return;
        }

        int newId = roleDAO.insertRole(name.trim(), desc != null ? desc.trim() : "");
        resp.sendRedirect(req.getContextPath() + "/admin/roles?roleId=" + newId + "&success=created");
    }

    private void handleSavePermissions(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int roleId = parseIntOrDefault(req.getParameter("roleId"), 0);

        if (roleId <= 0 || roleDAO.getRoleById(roleId) == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/roles?error=role_not_found");
            return;
        }

        List<Module> modules = roleDAO.getAllModules();
        List<RolePermission> permissions = new ArrayList<>();

        for (Module module : modules) {
            int moduleId = module.getId();
            String prefix = "perm_" + moduleId + "_";

            boolean canRead   = "on".equals(req.getParameter(prefix + "read"));
            boolean canCreate = "on".equals(req.getParameter(prefix + "create"));
            boolean canUpdate = "on".equals(req.getParameter(prefix + "update"));
            boolean canDelete = "on".equals(req.getParameter(prefix + "delete"));

            if (canRead || canCreate || canUpdate || canDelete) {
                permissions.add(new RolePermission(roleId, moduleId, canRead, canCreate, canUpdate, canDelete));
            }
        }

        roleDAO.savePermissions(roleId, permissions);
        resp.sendRedirect(req.getContextPath() + "/admin/roles?roleId=" + roleId + "&success=saved");
    }

    private void handleDeleteRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int roleId = parseIntOrDefault(req.getParameter("roleId"), 0);

        if (roleId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/roles?error=invalid_id");
            return;
        }

        boolean deleted = roleDAO.deleteRole(roleId);
        if (deleted) {
            resp.sendRedirect(req.getContextPath() + "/admin/roles?success=deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/roles?error=delete_failed");
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
