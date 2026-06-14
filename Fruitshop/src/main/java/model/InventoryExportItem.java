package model;

public class InventoryExportItem {
    private int id;
    private int exportId;
    private int productId;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private Integer batchItemId; 

    public InventoryExportItem() {
    }
    
    public InventoryExportItem(int exportId, int productId, int quantity, double unitPrice) {
        this.exportId = exportId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = quantity * unitPrice;
    }

    public Integer getBatchItemId() {
        return batchItemId;
    }

    public void setBatchItemId(Integer batchItemId) {
        this.batchItemId = batchItemId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getExportId() {
        return exportId;
    }

    public void setExportId(int exportId) {
        this.exportId = exportId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        this.totalPrice = quantity * unitPrice;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        this.totalPrice = quantity * unitPrice;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
