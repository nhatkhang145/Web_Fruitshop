package model;

import java.math.BigDecimal;

public class CartItem {
    private Product product;
    private int quantity;
    private String dealType;
    private Integer dealId;
    private BigDecimal originalPrice;
    private BigDecimal discountAmount;
    private BigDecimal finalPrice;

    public CartItem() {
    }

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.originalPrice = BigDecimal.valueOf(product.getPrice());
        this.finalPrice = BigDecimal.valueOf(product.getSalePrice() > 0 ? product.getSalePrice() : product.getPrice());
        this.discountAmount = this.originalPrice.subtract(this.finalPrice);
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDealType() {
        return dealType;
    }

    public void setDealType(String dealType) {
        this.dealType = dealType;
    }

    public Integer getDealId() {
        return dealId;
    }

    public void setDealId(Integer dealId) {
        this.dealId = dealId;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(BigDecimal finalPrice) {
        this.finalPrice = finalPrice;
    }

    // Tính tổng tiền của item này
    public BigDecimal getTotalPrice() {
        return finalPrice.multiply(BigDecimal.valueOf(quantity));
    }

    // Tương thích với code cũ
    public double getTotalPriceDouble() {
        return getTotalPrice().doubleValue();
    }

    // Check có deal không
    public boolean hasDeal() {
        return dealType != null && discountAmount != null && discountAmount.compareTo(BigDecimal.ZERO) > 0;
    }
}
