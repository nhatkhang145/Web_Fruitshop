package dal;

import model.Product;
import model.Review;
import model.User;

import java.util.List;

public class ReviewDAO {


    public boolean insertReview(Review review) {
        String query = """
                INSERT INTO reviews (user_id, product_id, order_detail_id, rating, comment, images, video, status, created_at)
                VALUES (:userId, :productId, :orderDetailId, :rating, :comment, :images, :video, 'approved', NOW())
                """;

        return DBContext.get().withHandle(handle ->
                handle.createUpdate(query)
                        .bind("userId", review.getUserId())
                        .bind("productId", review.getProductId())
                        .bind("orderDetailId", review.getOrderDetailId())
                        .bind("rating", review.getRating())
                        .bind("comment", review.getComment())
                        .bind("images", review.getImages())
                        .bind("video", review.getVideo())
                        .execute() > 0);
    }

    // Lấy đánh giá theo Product ID (kèm thông tin User)
    public List<Review> getReviewsByProductId(int productId) {
        String query = """
                SELECT r.id, r.user_id, r.product_id, r.rating, r.comment, r.admin_reply, r.created_at,
                       u.fullname AS u_fullname, u.avatar AS u_avatar
                FROM reviews r
                LEFT JOIN users u ON r.user_id = u.id
                WHERE r.product_id = :pid AND r.status = 'approved'
                ORDER BY r.created_at DESC
                """;

        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .bind("pid", productId)
                        .map((rs, ctx) -> {
                            Review r = new Review();
                            r.setId(rs.getInt("id"));
                            r.setUserId(rs.getInt("user_id"));
                            r.setProductId(rs.getInt("product_id"));
                            r.setRating(rs.getInt("rating"));
                            r.setComment(rs.getString("comment"));
                            r.setAdminReply(rs.getString("admin_reply"));
                            r.setCreatedAt(rs.getTimestamp("created_at"));

                            User u = new User();
                            String name = rs.getString("u_fullname");
                            String avatar = rs.getString("u_avatar");

                            u.setFullName(name != null ? name : "Người dùng ẩn danh");
                            u.setAvatar(avatar != null ? avatar : "assets/images/default-user.png");
                            r.setUser(u);
                            return r;

                        }).list());
    }

    // Kiểm tra đã mua hàng chưa
    public boolean hasBought(int userId, int productId) {
        String query = """
                SELECT COUNT(*) FROM orders o
                JOIN order_details od ON o.id = od.order_id
                WHERE o.user_id = :uid AND od.product_id = :pid AND o.status = 'completed'
                """;
        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .mapTo(Integer.class)
                        .one() > 0);
    }

    // Lấy tất cả đánh giá (Admin)
    public List<Review> getAllReviews() {
        String query = """
                SELECT r.*, u.fullname, u.email, u.avatar, p.name AS product_name
                FROM reviews r
                LEFT JOIN users u ON r.user_id = u.id
                LEFT JOIN products p ON r.product_id = p.id
                ORDER BY r.created_at DESC
                """;

        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .map((rs, ctx) -> {
                            Review r = new Review();
                            r.setId(rs.getInt("id"));
                            r.setUserId(rs.getInt("user_id"));
                            r.setProductId(rs.getInt("product_id"));
                            r.setRating(rs.getInt("rating"));
                            r.setComment(rs.getString("comment"));
                            r.setAdminReply(rs.getString("admin_reply"));
                            r.setStatus(rs.getString("status"));
                            r.setCreatedAt(rs.getTimestamp("created_at"));

                            User u = new User();
                            u.setFullName(rs.getString("fullname"));
                            u.setEmail(rs.getString("email"));
                            u.setAvatar(rs.getString("avatar"));
                            r.setUser(u);

                            Product p = new Product();
                            p.setName(rs.getString("product_name"));
                            r.setProduct(p);

                            return r;
                        }).list());
    }

    // Admin trả lời đánh giá
    public void replyReview(int reviewId, String replyContent) {
        String query = "UPDATE reviews SET admin_reply = :reply WHERE id = :id";
        DBContext.get().withHandle(handle ->
                handle.createUpdate(query)
                        .bind("reply", replyContent)
                        .bind("id", reviewId)
                        .execute() > 0);
    }

    // Admin ẩn/hiện đánh giá
    public void updateStatus(int reviewId, String status) {
        String query = "UPDATE reviews SET status = :status WHERE id = :id";
        DBContext.get().withHandle(handle ->
                handle.createUpdate(query)
                        .bind("status", status)
                        .bind("id", reviewId)
                        .execute() > 0);
    }

    // Xóa đánh giá (Admin)
    public boolean deleteReview(int reviewId) {
        String query = "DELETE FROM reviews WHERE id = :id";
        return DBContext.get().withHandle(handle ->
                handle.createUpdate(query)
                        .bind("id", reviewId)
                        .execute() > 0);
    }

    // Lấy tổng số lượng đánh giá
    public int getTotalReviews() {
        String query = "SELECT COUNT(*) FROM reviews";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0));
    }

    // Lấy số lượng đánh giá chưa được admin trả lời
    public int getUnrepliedReviews() {
        String query = "SELECT COUNT(*) FROM reviews WHERE admin_reply IS NULL OR admin_reply = ''";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0));
    }

    // Tính điểm đánh giá trung bình
    public double getAverageRating() {
        String query = "SELECT AVG(CAST(rating AS DECIMAL(10,2))) FROM reviews";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .mapTo(Double.class)
                        .findFirst()
                        .orElse(0.0));
    }

    // Tìm Order Detail ID hợp lệ (đã mua & chưa đánh giá)
    public Integer getEligibleOrderDetailId(int userId, int productId) {
        String query = """
                SELECT od.id FROM order_details od 
                JOIN orders o ON o.id = od.order_id
                WHERE o.user_id = :userId
                  AND od.product_id = :productId
                  AND o.status = 'completed'
                  AND od.id NOT IN (SELECT order_detail_id FROM reviews WHERE order_detail_id IS NOT NULL)
                LIMIT 1""";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(query)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(null));
    }
}
