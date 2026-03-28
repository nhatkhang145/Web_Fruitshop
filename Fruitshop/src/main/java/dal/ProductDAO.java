package dal;

import model.Product;
import model.ProductImage;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        String sql = "SELECT id, name, price, sale_price, quantity, short_description AS description, image, category_id AS categoryId, status FROM products";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> getProductsByCategoryID(int cid) {
        String sql = "SELECT id, name, price, sale_price AS salePrice, quantity, short_description AS description, image, category_id AS categoryId FROM products WHERE category_id = ?";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, cid)
                .mapToBean(Product.class)
                .list());
    }

    public Product getProductByID(int id) {
        String sql = "SELECT id, " +
                "       name, " +
                "       product_code AS productCode, " +
                "       price, " +
                "       sale_price AS salePrice, " +
                "       quantity, " +
                "       short_description AS description, " +
                "       image, " +
                "       category_id AS categoryId, " +
                "       status " +
                "FROM products WHERE id = ?";

        Product product = DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, id)
                .mapToBean(Product.class)
                .findFirst()
                .orElse(null));

        if (product != null) {
            List<ProductImage> images = getProductImages(id);
            product.setProductImages(images);
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

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM products";
        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public List<Product> pagingProduct(int index) {
        String sql = "SELECT id, name, price, sale_price AS salePrice, quantity, short_description AS description, image, category_id AS categoryId FROM products ORDER BY id LIMIT ?, 16";
        int offset = (index - 1) * 16;

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, offset)
                .mapToBean(Product.class)
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
                "quantity = :quantity, short_description = :description, image = :image, category_id = :categoryId, status = :status "
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

    public int countProductsByFilter(Integer cid, Double minPrice, Double maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products p WHERE p.status = 1 ");

        if (cid != null) {
            sql.append(" AND p.category_id = :cid ");
        }
        if (minPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) >= :min ");
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) <= :max ");
        }

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (cid != null)
                query.bind("cid", cid);
            if (minPrice != null)
                query.bind("min", minPrice);
            if (maxPrice != null)
                query.bind("max", maxPrice);
            return query.mapTo(Integer.class).one();
        });
    }

    public List<Product> filterProducts(Integer cid, Double minPrice, Double maxPrice, String sortType, int index) {
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT p.id, p.name, p.product_code AS productCode, p.price, ")
                .append("p.sale_price AS salePrice, p.quantity, p.short_description AS description, ")
                .append("p.image, p.category_id AS categoryId, p.status, p.created_at, p.views ")
                .append("FROM products p ");

        if ("best_sell".equals(sortType)) {
            sql.append("LEFT JOIN order_details od ON p.id = od.product_id ");
        }

        sql.append("WHERE p.status = 1 ");

        if (cid != null) {
            sql.append(" AND p.category_id = :cid ");
        }

        if (minPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) >= :min ");
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) <= :max ");
        }

        if ("best_sell".equals(sortType)) {
            sql.append(
                    " GROUP BY p.id, p.name, p.product_code, p.price, p.sale_price, p.quantity, p.short_description, p.image, p.category_id, p.status, p.created_at, p.views ");
        }

        if (sortType != null) {
            switch (sortType) {
                case "best_sell":
                    sql.append(" ORDER BY SUM(od.quantity) DESC ");
                    break;
                case "new":
                    sql.append(" ORDER BY p.created_at DESC ");
                    break;
                case "old":
                    sql.append(" ORDER BY p.created_at ASC ");
                    break;
                case "popular":
                    sql.append(" ORDER BY p.views DESC ");
                    break;
                case "price_asc":
                    sql.append(" ORDER BY COALESCE(NULLIF(p.sale_price, 0), p.price) ASC ");
                    break;
                case "price_desc":
                    sql.append(" ORDER BY COALESCE(NULLIF(p.sale_price, 0), p.price) DESC ");
                    break;
                case "name_asc":
                    sql.append(" ORDER BY p.name ASC ");
                    break;
                default:
                    sql.append(" ORDER BY p.id DESC ");
                    break;
            }
        } else {
            sql.append(" ORDER BY p.id DESC ");
        }

        sql.append(" LIMIT 16 OFFSET :offset ");

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (cid != null)
                query.bind("cid", cid);
            if (minPrice != null)
                query.bind("min", minPrice);
            if (maxPrice != null)
                query.bind("max", maxPrice);

            query.bind("offset", (index - 1) * 16);

            return query.mapToBean(Product.class).list();
        });
    }

    public List<Product> searchProducts(String keyword, String category) {
        StringBuilder sql = new StringBuilder(
                "SELECT id, name, price, sale_price AS salePrice, quantity, short_description AS description, image, category_id AS categoryId "
                        +
                        "FROM products WHERE status = 1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE :keyword OR short_description LIKE :keyword)");
        }
        if (category != null && !category.equals("all")) {
            sql.append(" AND category_id = :categoryId");
        }

        sql.append(" ORDER BY id DESC");

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }

            if (category != null && !category.equals("all")) {
                try {
                    int catId = Integer.parseInt(category);
                    query.bind("categoryId", catId);
                } catch (NumberFormatException e) {
                }
            }

            return query.mapToBean(Product.class).list();
        });
    }

    public List<Product> getNewestProducts(int limit) {
        String sql = "SELECT id, name, price, sale_price AS salePrice, quantity, short_description AS description, image, category_id AS categoryId "
                +
                "FROM products WHERE status = 1 ORDER BY id DESC LIMIT ?";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, limit)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> getBestSellingProducts(int limit) {
        String sql = "SELECT p.id, p.name, p.price, p.sale_price AS salePrice, p.quantity, " +
                "p.short_description AS description, p.image, p.category_id AS categoryId " +
                "FROM products p " +
                "WHERE p.status = 1 " +
                "ORDER BY RAND() " +
                "LIMIT ?";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, limit)
                .mapToBean(Product.class)
                .list());
    }

    public List<Product> getDiscountProducts(int limit) {
        String sql = "SELECT id, name, price, sale_price AS salePrice, quantity, short_description AS description, image, category_id AS categoryId "
                +
                "FROM products " +
                "WHERE status = 1 AND sale_price > 0 AND sale_price < price " +
                "ORDER BY (price - sale_price) / price DESC " +
                "LIMIT ?";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, limit)
                .mapToBean(Product.class)
                .list());
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

    public int countProductsByFilterWithCategoryList(List<Integer> categoryIds, Double minPrice, Double maxPrice) {
        if (categoryIds == null || categoryIds.isEmpty()) {
            return countProductsByFilter(null, minPrice, maxPrice);
        }

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products p WHERE p.status = 1 ");

        sql.append(" AND p.category_id IN (");
        for (int i = 0; i < categoryIds.size(); i++) {
            if (i > 0)
                sql.append(", ");
            sql.append("?");
        }
        sql.append(") ");

        if (minPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) >= ? ");
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) <= ? ");
        }

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            int paramIndex = 0;
            for (Integer cid : categoryIds) {
                query.bind(paramIndex++, cid);
            }

            if (minPrice != null) {
                query.bind(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                query.bind(paramIndex++, maxPrice);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public List<Product> filterProductsWithCategoryList(List<Integer> categoryIds, Double minPrice, Double maxPrice,
            String sortType, int index) {
        if (categoryIds == null || categoryIds.isEmpty()) {
            return filterProducts(null, minPrice, maxPrice, sortType, index);
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.id, p.name, p.product_code AS productCode, p.price, ")
                .append("p.sale_price AS salePrice, p.quantity, p.short_description AS description, ")
                .append("p.image, p.category_id AS categoryId, p.status, p.created_at, p.views ")
                .append("FROM products p ");

        if ("best_sell".equals(sortType)) {
            sql.append("LEFT JOIN order_details od ON p.id = od.product_id ");
        }

        sql.append("WHERE p.status = 1 ");

        sql.append(" AND p.category_id IN (");
        for (int i = 0; i < categoryIds.size(); i++) {
            if (i > 0)
                sql.append(", ");
            sql.append("?");
        }
        sql.append(") ");

        if (minPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) >= ? ");
        }
        if (maxPrice != null) {
            sql.append(" AND COALESCE(NULLIF(p.sale_price, 0), p.price) <= ? ");
        }

        if ("best_sell".equals(sortType)) {
            sql.append(
                    " GROUP BY p.id, p.name, p.product_code, p.price, p.sale_price, p.quantity, p.short_description, p.image, p.category_id, p.status, p.created_at, p.views ");
        }

        if (sortType != null) {
            switch (sortType) {
                case "best_sell":
                    sql.append(" ORDER BY SUM(od.quantity) DESC ");
                    break;
                case "new":
                    sql.append(" ORDER BY p.created_at DESC ");
                    break;
                case "old":
                    sql.append(" ORDER BY p.created_at ASC ");
                    break;
                case "popular":
                    sql.append(" ORDER BY p.views DESC ");
                    break;
                case "price_asc":
                    sql.append(" ORDER BY COALESCE(NULLIF(p.sale_price, 0), p.price) ASC ");
                    break;
                case "price_desc":
                    sql.append(" ORDER BY COALESCE(NULLIF(p.sale_price, 0), p.price) DESC ");
                    break;
                case "name_asc":
                    sql.append(" ORDER BY p.name ASC ");
                    break;
                default:
                    sql.append(" ORDER BY p.id DESC ");
                    break;
            }
        } else {
            sql.append(" ORDER BY p.id DESC ");
        }

        sql.append(" LIMIT 16 OFFSET ? ");

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            int paramIndex = 0;
            for (Integer cid : categoryIds) {
                query.bind(paramIndex++, cid);
            }
            if (minPrice != null) {
                query.bind(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                query.bind(paramIndex++, maxPrice);
            }
            query.bind(paramIndex++, (index - 1) * 16);

            return query.mapToBean(Product.class).list();
        });
    }
}
