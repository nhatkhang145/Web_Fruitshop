
package controller;

import dal.AdminCategoryDAO;
import dal.AdminProductDAO;
import model.Category;
import model.Product;
import util.CloudinaryUploadHelper;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProductServlet", urlPatterns = { "/admin/products", "/admin/product-save",
        "/admin/product-delete", "/admin/product-form", "/admin/product-image-delete" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminProductServlet extends HttpServlet {
    private AdminProductDAO productDAO = new AdminProductDAO();
    private AdminCategoryDAO categoryDAO = new AdminCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        switch (action) {
            case "/admin/product-delete":
                deleteProduct(req, resp);
                break;
            case "/admin/product-form":
                showForm(req, resp);
                break;
            case "/admin/products":
            default:
                listProducts(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();
        if ("/admin/product-save".equals(action)) {
            saveProduct(req, resp);
        } else if ("/admin/product-image-delete".equals(action)) {
            deleteProductImage(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }


    private void listProducts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> list = productDAO.getAllProducts();
        req.setAttribute("products", list);
        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
    }

   
    private void showForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String categoryIdStr = req.getParameter("categoryId");
        String fromCategoryId = req.getParameter("fromCategoryId");
        Product product = new Product();

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            product = productDAO.getProductByID(id);
        } else {
            Integer categoryId = tryParsePositiveInt(categoryIdStr);
            if (categoryId != null) {
                Category selectedCategory = categoryDAO.getCategoryById(categoryId);
                if (selectedCategory == null || selectedCategory.getParentId() == 0) {
                    resp.sendRedirect(req.getContextPath() + "/admin/categories?error=root_category_not_allowed");
                    return;
                }
                product.setCategoryId(categoryId);
                if (fromCategoryId == null || fromCategoryId.isBlank()) {
                    fromCategoryId = String.valueOf(categoryId);
                }
            }
        }
        List<Category> categories = categoryDAO.getNonRootCategories();
        req.setAttribute("product", product);
        req.setAttribute("categories", categories);
        req.setAttribute("fromCategoryId", fromCategoryId);
        req.getRequestDispatcher("/admin/product-edit.jsp").forward(req, resp);
    }

   
    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            productDAO.delete(Integer.parseInt(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    
    private void saveProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String idStr = req.getParameter("id");
            Integer fromCategoryId = tryParsePositiveInt(req.getParameter("fromCategoryId"));
            String name = req.getParameter("name");
            String productCode = req.getParameter("productCode");
            double price = Double.parseDouble(req.getParameter("price"));
            String salePriceStr = req.getParameter("salePrice");
            double salePrice = (salePriceStr == null || salePriceStr.isEmpty()) ? 0 : Double.parseDouble(salePriceStr);
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String description = req.getParameter("description");
            String statusStr = req.getParameter("status");
            int status = (statusStr != null && statusStr.equals("1")) ? 1 : 0;

            int quantity = 0;
            if (idStr != null && !idStr.isEmpty() && !"0".equals(idStr)) {
                Product existing = productDAO.getProductByID(Integer.parseInt(idStr));
                if (existing != null) {
                    quantity = existing.getQuantity();
                }
            }

            Category selectedCategory = categoryDAO.getCategoryById(categoryId);
            if (selectedCategory == null || selectedCategory.getParentId() == 0) {
                throw new IllegalArgumentException("Danh mục gốc không thể chứa sản phẩm.");
            }

            String productFolder = "fruitshop/products/" + CloudinaryUploadHelper.toSlug(name);

            Part filePart = req.getPart("image");
            String fileName;
            String uploadedMain = CloudinaryUploadHelper.upload(filePart, productFolder);
            if (uploadedMain != null) {
                fileName = uploadedMain;
            } else {
                fileName = req.getParameter("currentImage");
            }

            List<String> subImageUrls = new ArrayList<>();
            for (Part part : req.getParts()) {
                if (!"subImages".equals(part.getName()) || part.getSize() == 0) {
                    continue;
                }
                String subUrl = CloudinaryUploadHelper.upload(part, productFolder);
                if (subUrl != null) {
                    subImageUrls.add(subUrl);
                }
            }

            Product p = new Product();
            p.setName(name);
            p.setProductCode(productCode);
            p.setPrice(price);
            p.setSalePrice(salePrice);
            p.setQuantity(quantity);
            p.setCategoryId(categoryId);
            p.setDescription(description);
            p.setImage(fileName);
            p.setStatus(status);

            int productId;
            if (idStr == null || idStr.isEmpty() || idStr.equals("0")) {
                productId = productDAO.insert(p);
            } else {
                p.setId(Integer.parseInt(idStr));
                productDAO.update(p);
                productId = p.getId();
            }


            if (!subImageUrls.isEmpty()) {
                int startOrder = 1;
                if (productId > 0 && (idStr != null && !idStr.isEmpty() && !idStr.equals("0"))) {
                    startOrder = productDAO.getMaxProductImageOrder(productId) + 1;
                }
                productDAO.insertProductImages(productId, subImageUrls, startOrder);
            }

            if (fromCategoryId != null) {
                resp.sendRedirect(req.getContextPath() + "/admin/category-products?categoryId=" + fromCategoryId + "&success=created");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi khi lưu sản phẩm: " + e.getMessage());
            req.setAttribute("categories", categoryDAO.getNonRootCategories());
            req.setAttribute("fromCategoryId", req.getParameter("fromCategoryId"));
            try {
                req.getRequestDispatcher("/admin/product-edit.jsp").forward(req, resp);
            } catch (Exception ex) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
        }
    }

    private Integer tryParsePositiveInt(String rawValue) {
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

    private void deleteProductImage(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        try {
            int imageId = Integer.parseInt(req.getParameter("imageId"));
            boolean deleted = productDAO.deleteProductImageById(imageId);
            out.print(deleted ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Kh\u00f4ng t\u00ecm th\u1ea5y \u1ea3nh\"}");
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
}
