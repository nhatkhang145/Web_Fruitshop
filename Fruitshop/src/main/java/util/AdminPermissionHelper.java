package util;

import java.util.List;
import java.util.Map;

import dal.RoleDAO;
import jakarta.servlet.http.HttpServletRequest;
import model.RolePermission;
import model.User;

public final class AdminPermissionHelper {

    private AdminPermissionHelper() {
    }

    public static boolean isAdminAccount(User user) {
        if (user == null) {
            return false;
        }
        if (user.getRole() == 1) {
            return true;
        }
        return user.getRoleId() != null && user.getRoleId() > 0;
    }

    public static boolean canAccess(User user, HttpServletRequest request) {
        if (user == null) {
            return false;
        }
        if (user.getRole() == 1) {
            return true;
        }

        Integer roleId = user.getRoleId();
        if (roleId == null || roleId <= 0) {
            return false;
        }

        PermissionRequirement requirement = resolveRequirement(request);
        if (requirement == null) {
            return true;
        }

        Map<Integer, RolePermission> permissions = new RoleDAO().getPermissionsMapByRoleId(roleId);
        RolePermission permission = permissions.get(requirement.moduleId);
        if (permission == null) {
            return false;
        }

        return switch (requirement.action) {
            case CREATE -> permission.isCanCreate();
            case UPDATE -> permission.isCanUpdate();
            case DELETE -> permission.isCanDelete();
            case READ -> permission.isCanRead();
        };
    }

    public static String resolveAdminLandingPath(User user) {
        if (user == null) {
            return "/";
        }
        if (user.getRole() == 1) {
            return "/admin/dashboard";
        }

        Integer roleId = user.getRoleId();
        if (roleId == null || roleId <= 0) {
            return "/";
        }

        RoleDAO roleDAO = new RoleDAO();
        String roleName = roleDAO.getRoleById(roleId) != null ? roleDAO.getRoleById(roleId).getName() : null;
        String normalized = roleName == null ? "" : roleName.toLowerCase();
        if (normalized.contains("kho")) {
            return "/admin/inventory-warehouse";
        }
        if (normalized.contains("bán") || normalized.contains("ban hang") || normalized.contains("bán hàng")) {
            return "/admin/stock-export";
        }
        if (normalized.contains("đơn") || normalized.contains("don hang") || normalized.contains("order")) {
            return "/admin/orders";
        }
        if (normalized.contains("khách") || normalized.contains("khach") || normalized.contains("customer")) {
            return "/admin/users";
        }
        if (normalized.contains("banner")) {
            return "/admin/banners";
        }
        if (normalized.contains("weekend")) {
            return "/admin/weekend-deals";
        }
        if (normalized.contains("phân quyền") || normalized.contains("phan quyen") || normalized.contains("role")) {
            return "/admin/roles";
        }
        if (normalized.contains("review") || normalized.contains("đánh giá") || normalized.contains("danh gia")) {
            return "/admin/reviews";
        }

        Map<Integer, RolePermission> permissions = roleDAO.getPermissionsMapByRoleId(roleId);
        List<Integer> landingPriority = List.of(8, 6, 7, 3, 4, 5, 1, 2, 11, 12, 13, 10);
        for (Integer moduleId : landingPriority) {
            RolePermission permission = permissions.get(moduleId);
            if (permission != null && permission.isCanRead()) {
                return moduleIdToPath(moduleId);
            }
        }

        return "/";
    }

    private static PermissionRequirement resolveRequirement(HttpServletRequest request) {
        String path = request.getServletPath();
        String method = request.getMethod();
        String action = request.getParameter("action");

        if (path == null) {
            return null;
        }

        return switch (path) {
            case "/admin/dashboard" -> new PermissionRequirement(10, PermissionAction.READ);

            case "/admin/products" -> new PermissionRequirement(1, PermissionAction.READ);
            case "/admin/product-form" -> new PermissionRequirement(1,
                    hasPositiveId(request.getParameter("id")) ? PermissionAction.UPDATE : PermissionAction.CREATE);
            case "/admin/product-save" -> new PermissionRequirement(1,
                    hasPositiveId(request.getParameter("id")) ? PermissionAction.UPDATE : PermissionAction.CREATE);
            case "/admin/product-delete" -> new PermissionRequirement(1, PermissionAction.DELETE);

            case "/admin/categories", "/admin/category-servlet" -> new PermissionRequirement(2, PermissionAction.READ);
            case "/admin/delete-category" -> new PermissionRequirement(2, PermissionAction.DELETE);

            case "/admin/category-products" -> new PermissionRequirement(2, PermissionAction.READ);
            case "/admin/category-products-assign" -> new PermissionRequirement(2, PermissionAction.UPDATE);
            case "/admin/category-products-remove" -> new PermissionRequirement(2, PermissionAction.DELETE);

            case "/admin/orders" -> new PermissionRequirement(3, PermissionAction.READ);
            case "/admin/order-detail" -> new PermissionRequirement(3, PermissionAction.READ);
            case "/admin/order-update-status" -> new PermissionRequirement(3, PermissionAction.UPDATE);

            case "/admin/users" -> new PermissionRequirement(4, PermissionAction.READ);
            case "/admin/user-detail" -> new PermissionRequirement(4,
                    "POST".equalsIgnoreCase(method) ? PermissionAction.UPDATE : PermissionAction.READ);

            case "/admin/reviews" -> new PermissionRequirement(5, PermissionAction.READ);
            case "/admin/review-action" -> resolveReviewAction(action);

            case "/admin/banners" -> resolveBannerAction(method, action);

            case "/admin/weekend-deals" -> resolveWeekendDealsAction(method, action, request);
            case "/admin/weekend-deal-edit" -> new PermissionRequirement(12,
                    hasPositiveId(request.getParameter("id")) ? PermissionAction.UPDATE : PermissionAction.CREATE);

            case "/admin/inventory-management" -> new PermissionRequirement(6, PermissionAction.READ);
            case "/admin/inventory-receipt-new" -> new PermissionRequirement(6, PermissionAction.CREATE);
            case "/admin/inventory-receipt-detail" -> new PermissionRequirement(6, PermissionAction.READ);
            case "/admin/inventory-receipt-create" -> new PermissionRequirement(6, PermissionAction.CREATE);
            case "/admin/inventory-receipt-approve", "/admin/inventory-receipt-reject" -> new PermissionRequirement(6, PermissionAction.UPDATE);
            case "/admin/inventory-warehouse" -> new PermissionRequirement(8, PermissionAction.READ);

            case "/admin/stock-export" -> new PermissionRequirement(7, PermissionAction.READ);
            case "/admin/inventory-export-create" -> new PermissionRequirement(7, PermissionAction.CREATE);
            case "/admin/inventory-export-detail" -> new PermissionRequirement(7, PermissionAction.READ);
            case "/admin/inventory-export-approve", "/admin/inventory-export-reject" -> new PermissionRequirement(7, PermissionAction.UPDATE);

            case "/admin/roles" -> resolveRoleAction(method, action);

            default -> null;
        };
    }

    private static PermissionRequirement resolveRoleAction(String method, String action) {
        if (!"POST".equalsIgnoreCase(method)) {
            return new PermissionRequirement(13, PermissionAction.READ);
        }
        if ("delete".equalsIgnoreCase(action)) {
            return new PermissionRequirement(13, PermissionAction.DELETE);
        }
        if ("save-permissions".equalsIgnoreCase(action)) {
            return new PermissionRequirement(13, PermissionAction.UPDATE);
        }
        return new PermissionRequirement(13, PermissionAction.CREATE);
    }

    private static PermissionRequirement resolveBannerAction(String method, String action) {
        if ("POST".equalsIgnoreCase(method)) {
            if ("add".equalsIgnoreCase(action)) {
                return new PermissionRequirement(11, PermissionAction.CREATE);
            }
            if ("update".equalsIgnoreCase(action)) {
                return new PermissionRequirement(11, PermissionAction.UPDATE);
            }
            return new PermissionRequirement(11, PermissionAction.UPDATE);
        }
        if ("delete".equalsIgnoreCase(action)) {
            return new PermissionRequirement(11, PermissionAction.DELETE);
        }
        return new PermissionRequirement(11, PermissionAction.READ);
    }

    private static PermissionRequirement resolveWeekendDealsAction(String method, String action, HttpServletRequest request) {
        if ("delete".equalsIgnoreCase(action)) {
            return new PermissionRequirement(12, PermissionAction.DELETE);
        }
        if ("toggle".equalsIgnoreCase(action)) {
            return new PermissionRequirement(12, PermissionAction.UPDATE);
        }
        if ("POST".equalsIgnoreCase(method)) {
            return new PermissionRequirement(12,
                    hasPositiveId(request.getParameter("dealId")) ? PermissionAction.UPDATE : PermissionAction.CREATE);
        }
        return new PermissionRequirement(12, PermissionAction.READ);
    }

    private static PermissionRequirement resolveReviewAction(String action) {
        if ("delete".equalsIgnoreCase(action)) {
            return new PermissionRequirement(5, PermissionAction.DELETE);
        }
        return new PermissionRequirement(5, PermissionAction.UPDATE);
    }

    private static boolean hasPositiveId(String rawValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return false;
        }
        try {
            return Integer.parseInt(rawValue) > 0;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    private enum PermissionAction {
        READ,
        CREATE,
        UPDATE,
        DELETE
    }

    private static String moduleIdToPath(int moduleId) {
        return switch (moduleId) {
            case 1 -> "/admin/products";
            case 2 -> "/admin/categories";
            case 3 -> "/admin/orders";
            case 4 -> "/admin/users";
            case 5 -> "/admin/reviews";
            case 6 -> "/admin/inventory-management";
            case 7 -> "/admin/stock-export";
            case 8 -> "/admin/inventory-warehouse";
            case 10 -> "/admin/dashboard";
            case 11 -> "/admin/banners";
            case 12 -> "/admin/weekend-deals";
            case 13 -> "/admin/roles";
            default -> "/admin/dashboard";
        };
    }

    private record PermissionRequirement(int moduleId, PermissionAction action) {
    }
}