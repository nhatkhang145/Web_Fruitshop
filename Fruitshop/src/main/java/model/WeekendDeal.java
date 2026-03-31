package model;

import java.sql.Timestamp;

public class WeekendDeal {
    private int id;
    private int productId;
    private String tag;
    private String subtitle;
    private int discountPercent;
    private Timestamp startDate;
    private Timestamp endDate;
    private int status;
    private int sortOrder;
    private Timestamp createdAt;
    private Product product;

    public WeekendDeal() {}

    public WeekendDeal(int id, int productId, String tag, String subtitle, int discountPercent,
                       Timestamp startDate, Timestamp endDate, int status) {
        this.id = id;
        this.productId = productId;
        this.tag = tag;
        this.subtitle = subtitle;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }


    public double getDiscountedPrice() {
        if (product == null) return 0;
        double discount = product.getPrice() * discountPercent / 100.0;
        return product.getPrice() - discount;
    }


    public boolean isActive() {
        if (status == 0) return false;
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return now.after(startDate) && now.before(endDate);
    }


    public long getTimeRemaining() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return endDate.getTime() - now.getTime();
    }
}
