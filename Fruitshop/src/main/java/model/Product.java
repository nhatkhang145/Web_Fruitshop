package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product {
    private int id;
    private String name;
    private double price;
    private double salePrice;
    private Timestamp salePriceExpiresAt;
    private Integer saleBatchItemId;
    private int quantity;
    private String description;
    private String image;
    private int categoryId;
    private String productCode;
    private int status;
    private List<ProductImage> productImages;
    private double averageRating;
    private int reviewCount;


    public Product() {
        this.productImages = new ArrayList<>();
    }


    public Product(int id, String name, double price, double salePrice, int quantity, String description, String image, int categoryId, String productCode, int status) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.salePrice = salePrice;
        this.quantity = quantity;
        this.description = description;
        this.image = image;
        this.categoryId = categoryId;
        this.productCode = productCode;
        this.status = status;
    }


    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public double getPrice() {
        return price;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public void setPrice(double price) {
        this.price = price;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getImage() {
        return image;
    }
    public void setImage(String image) {
        this.image = image;
    }
    public int getCategoryId() {
        return categoryId;
    }
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public List<ProductImage> getProductImages() {
        return productImages;
    }

    public void setProductImages(List<ProductImage> productImages) {
        this.productImages = productImages;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public Timestamp getSalePriceExpiresAt() {
        return salePriceExpiresAt;
    }

    public void setSalePriceExpiresAt(Timestamp salePriceExpiresAt) {
        this.salePriceExpiresAt = salePriceExpiresAt;
    }

    public Integer getSaleBatchItemId() {
        return saleBatchItemId;
    }

    public void setSaleBatchItemId(Integer saleBatchItemId) {
        this.saleBatchItemId = saleBatchItemId;
    }
}