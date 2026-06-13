package model;

import java.time.LocalDateTime;

public class BatchStockView {
    private int itemId;
    private int receiptId;
    private String receiptCode;
    private LocalDateTime receiptDate;
    private int quantity;
    private String receiptDateDisplay;
    private int ageDays;
    private String freshnessKey;
    private String statusBadgeClass;
    private String batchCode;

    public BatchStockView() {
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public LocalDateTime getReceiptDate() {
        return receiptDate;
    }

    public void setReceiptDate(LocalDateTime receiptDate) {
        this.receiptDate = receiptDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getReceiptDateDisplay() {
        return receiptDateDisplay;
    }

    public void setReceiptDateDisplay(String receiptDateDisplay) {
        this.receiptDateDisplay = receiptDateDisplay;
    }

    public int getAgeDays() {
        return ageDays;
    }

    public void setAgeDays(int ageDays) {
        this.ageDays = ageDays;
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

    public String getBatchCode() {
        return batchCode;
    }

    public void setBatchCode(String batchCode) {
        this.batchCode = batchCode;
    }
}
