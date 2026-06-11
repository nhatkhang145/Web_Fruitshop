package model;

import java.time.LocalDateTime;

public class WarehouseBatchRow {
    private final int itemId;
    private final int itemQuantity;
    private final double unitPrice;
    private final int receiptId;
    private final String receiptCode;
    private final LocalDateTime receiptDate;
    private final int productId;
    private final String productName;
    private final String productCode;
    private final double productPrice;
    private final double salePrice;
    private final int productQuantity;
    private final String productImage;
    
    public WarehouseBatchRow(int itemId, int itemQuantity, double unitPrice,
                             int receiptId, String receiptCode, LocalDateTime receiptDate,
                             int productId, String productName, String productCode,
                             double productPrice, double salePrice, int productQuantity,
                             String productImage) {
        this.itemId = itemId;
        this.itemQuantity = itemQuantity;
        this.unitPrice = unitPrice;
        this.receiptId = receiptId;
        this.receiptCode = receiptCode;
        this.receiptDate = receiptDate;
        this.productId = productId;
        this.productName = productName;
        this.productCode = productCode;
        this.productPrice = productPrice;
        this.salePrice = salePrice;
        this.productQuantity = productQuantity;
        this.productImage = productImage;
    }

    public int getItemId() {
        return itemId;
    }

    public int getItemQuantity() {
        return itemQuantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public LocalDateTime getReceiptDate() {
        return receiptDate;
    }

    public int getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public String getProductCode() {
        return productCode;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public int getProductQuantity() {
        return productQuantity;
    }

    public String getProductImage() {
        return productImage;
    }

    
}
