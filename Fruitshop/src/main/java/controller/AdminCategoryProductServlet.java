
package controller;

import dal.AdminCategoryDAO;
import dal.AdminProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryProductServlet", urlPatterns = {
        "/admin/category-products",
        "/admin/category-products-assign",
        "/admin/category-products-remove"
})
public class AdminCategoryProductServlet extends HttpServlet {

    private final AdminCategoryDAO categoryDAO = new AdminCategoryDAO();
    private final AdminProductDAO productDAO = new AdminProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("/admin/category-products".equals(req.getServletPath())) {
            showCategoryProducts(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getServletPath();
        if ("/admin/category-products-assign".equals(path)) {
            assignProductToCategory(req, resp);
            return;
        }
        if ("/admin/category-products-remove".equals(path)) {
            removeProductFromCategory(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void showCategoryProducts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer categoryId = parsePositiveInt(req.getParameter("categoryId"));
        if (categoryId == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=missing-category");
            return;
        }

        Category category = categoryDAO.getCategoryById(categoryId);
        if (category == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=category-not-found");
            return;
        }

        if (category.getParentId() == 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=root_category_not_allowed");
            return;
        }

        List<Product> productsInCategory = productDAO.getProductsByCategoryId(categoryId);
        List<Product> unassignedProducts = productDAO.getProductsWithoutCategory();

        req.setAttribute("category", category);
        req.setAttribute("productsInCategory", productsInCategory);
        req.setAttribute("unassignedProducts", unassignedProducts);

        req.getRequestDispatcher("/admin/category-products.jsp").forward(req, resp);
    }

    private void assignProductToCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer categoryId = parsePositiveInt(req.getParameter("categoryId"));
        Integer productId = parsePositiveInt(req.getParameter("productId"));

        if (categoryId == null || productId == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=invalid-request");
            return;
        }

        Category category = categoryDAO.getCategoryById(categoryId);
        if (category == null || category.getParentId() == 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=root_category_not_allowed");
            return;
        }

        productDAO.assignProductToCategory(productId, categoryId);
        resp.sendRedirect(req.getContextPath() + "/admin/category-products?categoryId=" + categoryId + "&success=assigned");
    }

    private void removeProductFromCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Integer categoryId = parsePositiveInt(req.getParameter("categoryId"));
        Integer productId = parsePositiveInt(req.getParameter("productId"));

        if (categoryId == null || productId == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=invalid-request");
            return;
        }

        Category category = categoryDAO.getCategoryById(categoryId);
        if (category == null || category.getParentId() == 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=root_category_not_allowed");
            return;
        }

        productDAO.removeProductFromCategory(productId, categoryId);
        resp.sendRedirect(req.getContextPath() + "/admin/category-products?categoryId=" + categoryId + "&success=removed");
    }

    private Integer parsePositiveInt(String rawValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return null;
        }
        try {
            int value = Integer.parseInt(rawValue);
            return value > 0 ? value : null;
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
