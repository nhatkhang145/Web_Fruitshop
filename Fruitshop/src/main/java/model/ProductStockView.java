package model;

import java.util.ArrayList;
import java.util.List;

public class ProductStockView {
    private int productId;
    private String productName;
    private String productCode;
    private double price;
    private int quantity;
    private String image;
    private List<BatchStockView> batches = new ArrayList<>();
    private String groupKey;
    private String oldestDateDisplay;
    private int oldestAgeDays;
    private String freshnessKey;
    private String statusBadgeClass;
    private int oldBatchCount;

    public ProductStockView() {
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCode() {
        return productCode == null || productCode.isBlank() ? "-" : productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    

    public double getPrice() {
        return price;
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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public List<BatchStockView> getBatches() {
        return batches;
    }

    public void setBatches(List<BatchStockView> batches) {
        this.batches = batches;
    }

    public String getGroupKey() {
        return groupKey;
    }

    public void setGroupKey(String groupKey) {
        this.groupKey = groupKey;
    }

    public String getOldestDateDisplay() {
        return oldestDateDisplay;
    }

    public void setOldestDateDisplay(String oldestDateDisplay) {
        this.oldestDateDisplay = oldestDateDisplay;
    }

    public int getOldestAgeDays() {
        return oldestAgeDays;
    }

    public void setOldestAgeDays(int oldestAgeDays) {
        this.oldestAgeDays = oldestAgeDays;
    }

    public String getFreshnessKey() {
        return freshnessKey;
    }

    public void setFreshnessKey(String freshnessKey) {
        this.freshnessKey = freshnessKey;
    }

    public String getStatusBadgeClass() {
        return statusBadgeClass;
    }

    public void setStatusBadgeClass(String statusBadgeClass) {
        this.statusBadgeClass = statusBadgeClass;
    }

    public int getOldBatchCount() {
        return oldBatchCount;
    }

    public void setOldBatchCount(int oldBatchCount) {
        this.oldBatchCount = oldBatchCount;
    }
}
