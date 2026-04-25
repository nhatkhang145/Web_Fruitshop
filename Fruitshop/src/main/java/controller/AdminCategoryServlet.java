package controller;

import dal.AdminCategoryDAO;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebServlet(name = "AdminCategoryServlet", urlPatterns = { "/admin/categories", "/admin/category-servlet",
        "/admin/delete-category" })
public class AdminCategoryServlet extends HttpServlet {

    private AdminCategoryDAO categoryDAO = new AdminCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        switch (action) {
            case "/admin/delete-category":
                deleteCategory(req, resp);
                break;
            case "/admin/categories":
            default:
                listCategories(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addCategory(req, resp);
        } else if ("edit".equals(action)) {
            updateCategory(req, resp);
        } else {
            resp.sendRedirect("categories");
        }
    }


    private void listCategories(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> list = categoryDAO.getAllCategories();
        List<Category> parentCategories = categoryDAO.getParentCategories();
        Map<Integer, Integer> productCountMap = buildProductCountBySubtree(list);
        req.setAttribute("listC", list);
        req.setAttribute("parentC", parentCategories);
        req.setAttribute("productCountMap", productCountMap);
        req.setAttribute("detachedCount", parseIntOrDefault(req.getParameter("detached"), 0));
        req.setAttribute("errorCode", req.getParameter("error"));
        req.setAttribute("successCode", req.getParameter("success"));
        req.getRequestDispatcher("/admin/Categories.jsp").forward(req, resp);
    }


    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = parseIntOrDefault(idStr, 0);
            if (id <= 0 || !categoryDAO.categoryExists(id)) {
                redirectWithError(resp, req, "category_not_found");
                return;
            }
            int detachedCount = categoryDAO.countProductsInCategoryTree(id);
            categoryDAO.deleteCategoryAndChildren(id);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=deleted&detached=" + detachedCount);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories?success=deleted");
    }


    private void addCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String name = req.getParameter("name");
            String desc = req.getParameter("description");

            int parentId = parseIntOrDefault(req.getParameter("parentId"), 0);
            int status = parseIntOrDefault(req.getParameter("status"), 1);

            if (name == null || name.trim().isEmpty()) {
                redirectWithError(resp, req, "missing_name");
                return;
            }
            if (categoryDAO.categoryNameExists(name, null)) {
                redirectWithError(resp, req, "duplicate_name");
                return;
            }
            if (!isValidParentCategory(parentId)) {
                redirectWithError(resp, req, "parent_not_found");
                return;
            }

            Category c = new Category();
            c.setName(name.trim());
            c.setDescription(desc);
            c.setParentId(parentId);
            c.setStatus(status);

            categoryDAO.insert(c);

            resp.sendRedirect(req.getContextPath() + "/admin/categories?success=added");
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(resp, req, "general");
        }
    }


    private void updateCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = parseIntOrDefault(req.getParameter("id"), 0);
        String name = req.getParameter("name");
        String desc = req.getParameter("description");
        int parentId = parseIntOrDefault(req.getParameter("parentId"), 0);
        int status = parseIntOrDefault(req.getParameter("status"), 1);
        Category currentCategory = categoryDAO.getCategoryById(id);

        if (id <= 0 || currentCategory == null) {
            redirectWithError(resp, req, "category_not_found");
            return;
        }
        if (name == null || name.trim().isEmpty()) {
            redirectWithError(resp, req, "missing_name");
            return;
        }
        if (categoryDAO.categoryNameExists(name, id)) {
            redirectWithError(resp, req, "duplicate_name");
            return;
        }
        if (!isValidParentCategory(parentId)) {
            redirectWithError(resp, req, "parent_not_found");
            return;
        }
        if (parentId == id) {
            redirectWithError(resp, req, "self_parent");
            return;
        }
        if (currentCategory.getParentId() == 0 && parentId != 0) {
            redirectWithError(resp, req, "root_to_child_not_allowed");
            return;
        }
        if (currentCategory.getParentId() != 0 && parentId == 0) {
            redirectWithError(resp, req, "child_to_root_not_allowed");
            return;
        }
        if (categoryDAO.wouldCreateCycle(id, parentId)) {
            redirectWithError(resp, req, "invalid_hierarchy");
            return;
        }

        Category c = new Category();
        c.setId(id);
        c.setName(name.trim());
        c.setDescription(desc);
        c.setParentId(parentId);
        c.setStatus(status);

        categoryDAO.update(c);
        resp.sendRedirect(req.getContextPath() + "/admin/categories?success=updated");
    }

    private boolean isValidParentCategory(int parentId) {
        return parentId == 0 || categoryDAO.categoryExists(parentId);
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception ex) {
            return defaultValue;
        }
    }

    private void redirectWithError(HttpServletResponse resp, HttpServletRequest req, String code) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/admin/categories?error=" + code);
    }

    private Map<Integer, Integer> buildProductCountBySubtree(List<Category> categories) {
        Map<Integer, Integer> directCounts = categoryDAO.getDirectProductCountByCategoryId();
        Map<Integer, List<Integer>> childrenByParent = new HashMap<>();

        for (Category category : categories) {
            childrenByParent.computeIfAbsent(category.getParentId(), k -> new ArrayList<>()).add(category.getId());
        }

        Map<Integer, Integer> memo = new HashMap<>();
        for (Category category : categories) {
            countProductsRecursively(category.getId(), directCounts, childrenByParent, memo);
        }
        return memo;
    }

    private int countProductsRecursively(int categoryId,
                                         Map<Integer, Integer> directCounts,
                                         Map<Integer, List<Integer>> childrenByParent,
                                         Map<Integer, Integer> memo) {
        Integer cached = memo.get(categoryId);
        if (cached != null) {
            return cached;
        }

        int total = directCounts.getOrDefault(categoryId, 0);
        List<Integer> children = childrenByParent.getOrDefault(categoryId, List.of());
        for (Integer childId : children) {
            total += countProductsRecursively(childId, directCounts, childrenByParent, memo);
        }

        memo.put(categoryId, total);
        return total;
    }
}
