package dal;

import model.Product;
import model.ProductImage;
import java.sql.Timestamp;
import java.util.List;

public class AdminProductDAO {

    private final AdminReviewDAO reviewDAO = new AdminReviewDAO();
    private void enrichProductWithRating(Product product) {
        if (product != null && product.getId() > 0) {
            product.setAverageRating(reviewDAO.getAverageRatingByProductId(product.getId()));
            product.setReviewCount(reviewDAO.getReviewCountByProductId(product.getId()));
        }
    }

    public List<Product> getAllProducts() {
        String sql = "SELECT id, name, price, sale_price, quantity, short_description AS description, image, category_id AS categoryId, status FROM products";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Product.class)
                .list());
    }

    public Product getProductByID(int id) {
        String sql = "SELECT id, " + " name," + " product_code AS productCode, " + " price, " + " sale_price AS salePrice, " + " quantity, " + " short_description AS description, " + " image, " + " category_id AS categoryId, " + " status " + "FROM products WHERE id = ?";

        Product product = DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, id)
                .mapToBean(Product.class)
                .findFirst()
                .orElse(null));

        if (product != null) {
            List<ProductImage> images = getProductImages(id);
            product.setProductImages(images);
            enrichProductWithRating(product);
        }
        return product;
    }

    public List<ProductImage> getProductImages(int productId) {
        String sql = "SELECT id, product_id AS productId, image_url AS imageUrl, sort_order AS sortOrder " +
                "FROM product_images WHERE product_id = ? ORDER BY sort_order ASC";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, productId)
                .mapToBean(ProductImage.class)
                .list());
    }




    public int insert(Product p) {
        String sql = "INSERT INTO products (name, product_code, price, sale_price, quantity, short_description, image, category_id, status) "
                +
                "VALUES (:name, :productCode, :price, :salePrice, :quantity, :description, :image, :categoryId, :status)";

        return DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bindBean(p)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }


    public int update(Product p) {
        String sql = "UPDATE products SET name = :name, product_code = :productCode, price = :price, sale_price = :salePrice, "
            +
            "short_description = :description, image = :image, category_id = :categoryId, status = :status "
            +
            "WHERE id = :id";

        return DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bindBean(p)
                .execute());
    }


    public int delete(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        return DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, id)
                .execute());
    }

    public void deleteProductImages(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = ?";
        DBContext.get().useHandle(handle -> handle.createUpdate(sql)
                .bind(0, productId)
                .execute());
    }

    public int getMaxProductImageOrder(int productId) {
        String sql = "SELECT COALESCE(MAX(sort_order), 0) FROM product_images WHERE product_id = ?";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, productId)
                .mapTo(Integer.class)
                .one());
    }

    public void insertProductImages(int productId, List<String> imageUrls, int startOrder) {
        if (imageUrls == null || imageUrls.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO product_images (product_id, image_url, sort_order) VALUES (:productId, :imageUrl, :sortOrder)";

        DBContext.get().useHandle(handle -> {
            var batch = handle.prepareBatch(sql);
            int order = startOrder;
            for (String url : imageUrls) {
                batch.bind("productId", productId)
                        .bind("imageUrl", url)
                        .bind("sortOrder", order++)
                        .add();
            }
            batch.execute();
        });
    }


    public int countTotalProducts() {
        return DBContext.get()
                .withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM products").mapTo(Integer.class).one());
    }

    public List<Product> getLowStockProducts(int threshold) {
        String sql = "SELECT * FROM products WHERE quantity <= :threshold AND status = 1 ORDER BY quantity ASC LIMIT 5";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind("threshold", threshold)
                .mapToBean(Product.class)
                .list());
    }


   // --------------------------------------------------------------------------------------------------------------------------------

  public List<Product> getProductsByCategoryId(int categoryId) {
        String sql = "SELECT id, name, product_code AS productCode, price, sale_price AS salePrice, quantity, "
                + "short_description AS description, image, category_id AS categoryId, status "
                + "FROM products WHERE category_id = ? ORDER BY id DESC";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, categoryId)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> getProductsWithoutCategory() {
        String sql = "SELECT id, name, product_code AS productCode, price, sale_price AS salePrice, quantity, "
                + "short_description AS description, image, category_id AS categoryId, status "
                + "FROM products WHERE category_id IS NULL OR category_id = 0 ORDER BY id DESC";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Product.class)
                .list());
    }

    public int assignProductToCategory(int productId, int categoryId) {
        String sql = "UPDATE products SET category_id = ? WHERE id = ?";
        return DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, categoryId)
                .bind(1, productId)
                .execute());
    }

    public int removeProductFromCategory(int productId, int categoryId) {
        String sql = "UPDATE products SET category_id = NULL WHERE id = ? AND category_id = ?";
        return DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, productId)
                .bind(1, categoryId)
                .execute());
    }

    public int updatePushSale(int productId, double salePrice, Timestamp expiresAt) {
        String sql = "UPDATE products SET sale_price = ?, sale_price_expires_at = ? WHERE id = ?";
        return DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind(0, salePrice)
                .bind(1, expiresAt)
                .bind(2, productId)
                .execute());
    }
}