package controller;

import dal.AdminCategoryDAO;
import dal.AdminProductDAO;
import model.Category;
import model.Product;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminProductServlet", urlPatterns = { "/admin/products", "/admin/product-save",
        "/admin/product-delete", "/admin/product-form" })
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
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }


    private void listProducts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> list = productDAO.getAllProducts();
        req.setAttribute("products", list);
        req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
    }

    // hiển thị Form
    private void showForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Product product = new Product();

        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            product = productDAO.getProductByID(id);
        }
        List<Category> categories = categoryDAO.getAllCategories();
        req.setAttribute("product", product);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/admin/product-edit.jsp").forward(req, resp);
    }

    //  xóa sản phẩm
    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            productDAO.delete(Integer.parseInt(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    // thêm mới câp nhật sản phẩm
    private void saveProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String idStr = req.getParameter("id");
            String name = req.getParameter("name");
            String productCode = req.getParameter("productCode");
            double price = Double.parseDouble(req.getParameter("price"));
            String salePriceStr = req.getParameter("salePrice");
            double salePrice = (salePriceStr == null || salePriceStr.isEmpty()) ? 0 : Double.parseDouble(salePriceStr);
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String description = req.getParameter("description");
            String statusStr = req.getParameter("status");
            int status = (statusStr != null && statusStr.equals("1")) ? 1 : 0;

            // Xử lý upload ảnh
            Part filePart = req.getPart("image");
            String fileName = null;
            String uploadBasePath = req.getServletContext().getRealPath("") + File.separator + "assets" + File.separator
                    + "images";
            File uploadBaseDir = new File(uploadBasePath);
            if (!uploadBaseDir.exists())
                uploadBaseDir.mkdirs();

            if (filePart != null && filePart.getSize() > 0) {
                String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String storedName = System.currentTimeMillis() + "_" + originalName;
                filePart.write(uploadBasePath + File.separator + storedName);
                fileName = "assets/images/" + storedName;
            } else {
                fileName = req.getParameter("currentImage");
            }

            // Upload các ảnh phụ
            String subImageUploadPath = uploadBasePath + File.separator + "products";
            File subImageDir = new File(subImageUploadPath);
            if (!subImageDir.exists())
                subImageDir.mkdirs();

            List<String> subImageUrls = new ArrayList<>();
            int subIndex = 1;
            for (Part part : req.getParts()) {
                if (!"subImages".equals(part.getName()) || part.getSize() == 0) {
                    continue;
                }

                String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                if (submittedName == null || submittedName.trim().isEmpty()) {
                    continue;
                }

                String storedName = System.currentTimeMillis() + "_" + subIndex++ + "_" + submittedName;
                part.write(subImageUploadPath + File.separator + storedName);
                subImageUrls.add("assets/images/products/" + storedName);
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

            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi khi lưu sản phẩm: " + e.getMessage());
            try {
                req.getRequestDispatcher("/admin/product-edit.jsp").forward(req, resp);
            } catch (Exception ex) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
        }
    }
}
