package dal;

import model.InventoryExportItem;
import model.InventoryExportReceipt;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class AdminExportDAO {
    public List<InventoryExportReceipt> getAllExports() {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_export_receipts ORDER BY created_at DESC")
                .mapToBean(InventoryExportReceipt.class)
                .list()
        );
    }

    public Optional<InventoryExportReceipt> getExportById(int exportId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_export_receipts WHERE id = ?")
                .bind(0, exportId)
                .mapToBean(InventoryExportReceipt.class)
                .findFirst()
        );
    }

    public Optional<InventoryExportReceipt> getExportByCode(String code) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_export_receipts WHERE code = ?")
                .bind(0, code)
                .mapToBean(InventoryExportReceipt.class)
                .findFirst()
        );
    }

    public List<InventoryExportItem> getExportItemsByExportId(int exportId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_export_items WHERE export_id = ?")
                .bind(0, exportId)
                .mapToBean(InventoryExportItem.class)
                .list()
        );
    }

    public List<InventoryExportReceipt> getExportsByDateRange(String fromDate, String toDate) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT * FROM inventory_export_receipts WHERE DATE(export_date) >= ? AND DATE(export_date) <= ? ORDER BY created_at DESC")
                .bind(0, fromDate)
                .bind(1, toDate)
                .mapToBean(InventoryExportReceipt.class)
                .list()
        );
    }

    public List<InventoryExportReceipt> getExportsByStatus(String status) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_export_receipts WHERE status = ? ORDER BY created_at DESC")
                .bind(0, status)
                .mapToBean(InventoryExportReceipt.class)
                .list()
        );
    }

    public Optional<InventoryExportReceipt> searchExportByCode(String code) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_export_receipts WHERE code LIKE ?")
                .bind(0, "%" + code + "%")
                .mapToBean(InventoryExportReceipt.class)
                .findFirst()
        );
    }

    public int getExportCountByStatus(String status) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT COUNT(*) FROM inventory_export_receipts WHERE status = ?")
                .bind(0, status)
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L)
        );
        return count != null ? count.intValue() : 0;
    }

    public int getExportCountByType(String exportType) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT COUNT(*) FROM inventory_export_receipts WHERE export_type = ?")
                .bind(0, exportType)
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L)
        );
        return count != null ? count.intValue() : 0;
    }

    public long getTotalExportQuantity() {
        Long total = DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT COALESCE(SUM(i.quantity), 0) " +
                "FROM inventory_export_items i " +
                "JOIN inventory_export_receipts r ON i.export_id = r.id " +
                "WHERE r.status = 'APPROVED'")
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L)
        );
        return total != null ? total : 0L;
    }

    public double getTotalExportValueThisMonth() {
        Double total = DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT COALESCE(SUM(r.total_amount), 0) " +
                "FROM inventory_export_receipts r " +
                "WHERE r.status = 'APPROVED' " +
                "AND YEAR(r.export_date) = YEAR(CURRENT_DATE()) " +
                "AND MONTH(r.export_date) = MONTH(CURRENT_DATE())")
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0)
        );
        return total != null ? total : 0.0;
    }

    public int createExportWithItems(InventoryExportReceipt receipt, List<InventoryExportItem> items) {
        return DBContext.get().inTransaction(handle -> {
            int exportId = handle.createUpdate(
                    "INSERT INTO inventory_export_receipts (code, receiver_name, export_type, export_date, total_amount, status, note, created_by) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)")
                .bind(0, receipt.getCode())
                .bind(1, receipt.getReceiverName())
                .bind(2, receipt.getExportType())
                .bind(3, receipt.getExportDate())
                .bind(4, receipt.getTotalAmount())
                .bind(5, receipt.getStatus())
                .bind(6, receipt.getNote())
                .bind(7, receipt.getCreatedBy())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one();

            for (InventoryExportItem item : items) {
                double lineTotal = item.getQuantity() * item.getUnitPrice();
                handle.createUpdate(
                        "INSERT INTO inventory_export_items (export_id, product_id, quantity, unit_price, total_price) " +
                        "VALUES (?, ?, ?, ?, ?)")
                    .bind(0, exportId)
                    .bind(1, item.getProductId())
                    .bind(2, item.getQuantity())
                    .bind(3, item.getUnitPrice())
                    .bind(4, lineTotal)
                    .execute();
            }

            return exportId;
        });
    }

    public void approveExport(int exportId) {
        DBContext.get().inTransaction(handle -> {
            String currentStatus = handle.createQuery(
                    "SELECT status FROM inventory_export_receipts WHERE id = ? FOR UPDATE")
                .bind(0, exportId)
                .mapTo(String.class)
                .findFirst()
                .orElse(null);

            if (currentStatus == null) {
                throw new IllegalArgumentException("Không tìm thấy phiếu xuất kho");
            }

            if ("APPROVED".equalsIgnoreCase(currentStatus)) {
                throw new IllegalStateException("Phiếu đã được xác nhận trước đó");
            }

            List<InventoryExportItem> items = handle.createQuery(
                    "SELECT id, export_id, product_id, quantity, unit_price, total_price FROM inventory_export_items WHERE export_id = ?")
                .bind(0, exportId)
                .mapToBean(InventoryExportItem.class)
                .list();

            for (InventoryExportItem item : items) {
                Integer stock = handle.createQuery(
                        "SELECT stock FROM products WHERE id = ? FOR UPDATE")
                    .bind(0, item.getProductId())
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(null);

                if (stock == null) {
                    throw new IllegalStateException("Không tìm thấy sản phẩm ID " + item.getProductId());
                }

                if (stock < item.getQuantity()) {
                    throw new IllegalStateException("Tồn kho không đủ cho sản phẩm ID " + item.getProductId());
                }

                handle.createUpdate("UPDATE products SET stock = stock - ? WHERE id = ?")
                    .bind(0, item.getQuantity())
                    .bind(1, item.getProductId())
                    .execute();
            }

            handle.createUpdate("UPDATE inventory_export_receipts SET status = 'APPROVED' WHERE id = ?")
                .bind(0, exportId)
                .execute();

            return null;
        });
    }

    public String generateExportCode() {
        return DBContext.get().withHandle(handle -> {
            LocalDateTime now = LocalDateTime.now();
            int year = now.getYear();
            int month = now.getMonthValue();
            int day = now.getDayOfMonth();

            String datePrefix = String.format("PXK-%04d%02d%02d", year, month, day);

            Long count = handle.createQuery(
                    "SELECT COUNT(*) FROM inventory_export_receipts WHERE code LIKE ?")
                .bind(0, datePrefix + "%")
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L);

            long sequence = (count != null ? count : 0) + 1;
            return String.format("%s-%04d", datePrefix, sequence);
        });
    }

    public boolean exportCodeExists(String code) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT COUNT(*) FROM inventory_export_receipts WHERE code = ?")
                .bind(0, code)
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L)
        );
        return count != null && count > 0;
    }

    public boolean productExists(int productId) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT COUNT(*) FROM products WHERE id = ?")
                .bind(0, productId)
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L)
        );
        return count != null && count > 0;
    }

    public List<java.util.Map<String, Object>> getAllSuppliers() {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT id, name FROM suppliers ORDER BY name")
                .mapToMap()
                .list()
        );
    }

    public List<java.util.Map<String, Object>> getAllProducts() {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT id, name FROM products ORDER BY name")
                .mapToMap()
                .list()
        );
    }

    public Optional<String> getSupplierName(int supplierId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT name FROM suppliers WHERE id = ?")
                .bind(0, supplierId)
                .mapTo(String.class)
                .findFirst()
        );
    }

    public Optional<ExportDetailDTO> getExportDetail(int exportId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("""
                SELECT r.id, r.code, r.receiver_name, r.export_type, r.export_date,
                       r.total_amount, r.status, r.note, r.created_by, r.created_at, r.updated_at
                FROM inventory_export_receipts r
                WHERE r.id = ?
                """)
                .bind(0, exportId)
                .map((rs, ctx) -> new ExportDetailDTO(
                    rs.getInt("id"),
                    rs.getString("code"),
                    rs.getString("receiver_name"),
                    rs.getString("export_type"),
                    rs.getObject("export_date", LocalDateTime.class),
                    rs.getDouble("total_amount"),
                    rs.getString("status"),
                    rs.getString("note"),
                    rs.getInt("created_by"),
                    rs.getObject("created_at", LocalDateTime.class),
                    rs.getObject("updated_at", LocalDateTime.class)
                ))
                .findFirst()
        );
    }

    public List<ExportItemDetailDTO> getExportItemsDetail(int exportId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("""
                SELECT i.id, i.export_id, i.product_id, i.quantity, i.unit_price,
                       i.total_price, p.name as product_name
                FROM inventory_export_items i
                LEFT JOIN products p ON i.product_id = p.id
                WHERE i.export_id = ?
                """)
                .bind(0, exportId)
                .map((rs, ctx) -> new ExportItemDetailDTO(
                    rs.getInt("id"),
                    rs.getInt("export_id"),
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getInt("quantity"),
                    rs.getDouble("unit_price"),
                    rs.getDouble("total_price")
                ))
                .list()
        );
    }

    public static class ExportDetailDTO {
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

        public ExportDetailDTO(int id, String code, String receiverName, String exportType,
                               LocalDateTime exportDate, double totalAmount, String status,
                               String note, int createdBy, LocalDateTime createdAt, LocalDateTime updatedAt) {
            this.id = id;
            this.code = code;
            this.receiverName = receiverName;
            this.exportType = exportType;
            this.exportDate = exportDate;
            this.totalAmount = totalAmount;
            this.status = status;
            this.note = note;
            this.createdBy = createdBy;
            this.createdAt = createdAt;
            this.updatedAt = updatedAt;
        }

        public int getId() { return id; }
        public String getCode() { return code; }
        public String getReceiverName() { return receiverName; }
        public String getExportType() { return exportType; }
        public LocalDateTime getExportDate() { return exportDate; }
        public double getTotalAmount() { return totalAmount; }
        public String getStatus() { return status; }
        public String getNote() { return note; }
        public int getCreatedBy() { return createdBy; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public LocalDateTime getUpdatedAt() { return updatedAt; }
    }

    public static class ExportItemDetailDTO {
        private int id;
        private int exportId;
        private int productId;
        private String productName;
        private int quantity;
        private double unitPrice;
        private double totalPrice;

        public ExportItemDetailDTO(int id, int exportId, int productId, String productName,
                                   int quantity, double unitPrice, double totalPrice) {
            this.id = id;
            this.exportId = exportId;
            this.productId = productId;
            this.productName = productName;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.totalPrice = totalPrice;
        }

        public int getId() { return id; }
        public int getExportId() { return exportId; }
        public int getProductId() { return productId; }
        public String getProductName() { return productName; }
        public int getQuantity() { return quantity; }
        public double getUnitPrice() { return unitPrice; }
        public double getTotalPrice() { return totalPrice; }
    }
}
