package model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int userId;
    private int productId;
    private int rating; // 1 đến 5 sao
    private String comment;
    private String adminReply;
    private String status; // 'approved', 'hidden'
    private Timestamp createdAt;
    private Product product;

    private User user;

    public Review() {
    }

    public Review(int id, int userId, int productId, int rating, String comment, String adminReply, String status, Timestamp createdAt, Product product) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.rating = rating;
        this.comment = comment;
        this.adminReply = adminReply;
        this.status = status;
        this.createdAt = createdAt;
        this.product = product;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getRating() {
        return rating;
    }
    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }
    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getAdminReply() {
        return adminReply;
    }
    public void setAdminReply(String adminReply) {
        this.adminReply = adminReply;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }
    public void setUser(User user) {
        this.user = user;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}