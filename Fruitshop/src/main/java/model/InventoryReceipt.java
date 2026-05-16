package model;

import java.time.LocalDateTime;

public class InventoryReceipt {
    private int id;
    private String code;
    private int supplierId;
    private LocalDateTime receiptDate;
    private double totalAmount;
    private String status;
    private String note;
    private int createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;


    public InventoryReceipt() {
    }

    public InventoryReceipt(String code, int supplierId, LocalDateTime receiptDate,
                            double totalAmount, String status, String note, int createdBy) {
        this.code = code;
        this.supplierId = supplierId;
        this.receiptDate = receiptDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.note = note;
        this.createdBy = createdBy;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public LocalDateTime getReceiptDate() {
        return receiptDate;
    }

    public void setReceiptDate(LocalDateTime receiptDate) {
        this.receiptDate = receiptDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}