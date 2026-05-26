package model;

import java.time.LocalDateTime;

public class InventoryExportReceipt {
    private int id;
    private String code;
    private String receiverName;
    private String exportType;
    private LocalDateTime exportDate;
    private double totalAmount;
    private String status;
    private String note;
    private int createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public InventoryExportReceipt() {
    }

    public InventoryExportReceipt(String code, String receiverName, String exportType,
                                  LocalDateTime exportDate, double totalAmount,
                                  String status, String note, int createdBy) {
        this.code = code;
        this.receiverName = receiverName;
        this.exportType = exportType;
        this.exportDate = exportDate;
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

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getExportType() {
        return exportType;
    }

    public void setExportType(String exportType) {
        this.exportType = exportType;
    }

    public LocalDateTime getExportDate() {
        return exportDate;
    }

    public void setExportDate(LocalDateTime exportDate) {
        this.exportDate = exportDate;
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
