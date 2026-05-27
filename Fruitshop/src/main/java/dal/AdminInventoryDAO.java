package dal;

import model.InventoryReceipt;
import model.InventoryReceiptItem;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;


public class AdminInventoryDAO {
     // Lấy tất cả phiếu nhập kho
    public List<InventoryReceipt> getAllReceipts() {
        return DBContext.get().withHandle(handle -> 
            handle.createQuery("SELECT * FROM inventory_receipts ORDER BY created_at DESC")
                    .mapToBean(InventoryReceipt.class)
                    .list()
        );
    }

    
     // Lấy chi tiết 1 phiếu nhập kho theo id
    public Optional<InventoryReceipt> getReceiptById(int receiptId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_receipts WHERE id = ?")
                    .bind(0, receiptId)
                    .mapToBean(InventoryReceipt.class)
                    .findFirst()
        );
    }

    
     // Lấy tất cả dòng hàng của một phieu
    public List<InventoryReceiptItem> getReceiptItemsByReceiptId(int receiptId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_receipt_items WHERE receipt_id = ?")
                    .bind(0, receiptId)
                    .mapToBean(InventoryReceiptItem.class)
                    .list()
        );
    }

    
     // Lọc phiếu theo khoảng ngày
    public List<InventoryReceipt> getReceiptsByDateRange(String fromDate, String toDate) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery(
                    "SELECT * FROM inventory_receipts WHERE DATE(receipt_date) >= ? AND DATE(receipt_date) <= ? ORDER BY created_at DESC")
                    .bind(0, fromDate)
                    .bind(1, toDate)
                    .mapToBean(InventoryReceipt.class)
                    .list()
        );
    }

    
     // Tìm phiếu theo mã 
    public Optional<InventoryReceipt> searchReceiptByCode(String code) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_receipts WHERE code LIKE ?")
                    .bind(0, "%" + code + "%")
                    .mapToBean(InventoryReceipt.class)
                    .findFirst()
        );
    }

    
     // Lấy danh sách phiếu theo trạng thái
    public List<InventoryReceipt> getReceiptsByStatus(String status) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT * FROM inventory_receipts WHERE status = ? ORDER BY created_at DESC")
                    .bind(0, status)
                    .mapToBean(InventoryReceipt.class)
                    .list()
        );
    }

    public int getReceiptCountByStatus(String status) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT COUNT(*) FROM inventory_receipts WHERE status = ?")
                    .bind(0, status)
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(0L)
        );
        return count != null ? count.intValue() : 0;
    }

    public long getTotalImportedQuantity() {
        Long total = DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT COALESCE(SUM(i.quantity), 0) " +
                "FROM inventory_receipt_items i " +
                "JOIN inventory_receipts r ON i.receipt_id = r.id " +
                "WHERE r.status = 'APPROVED'")
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(0L)
        );
        return total != null ? total : 0L;
    }

    public double getTotalImportedValueThisMonth() {
        Double total = DBContext.get().withHandle(handle ->
            handle.createQuery(
                "SELECT COALESCE(SUM(r.total_amount), 0) " +
                "FROM inventory_receipts r " +
                "WHERE r.status = 'APPROVED' " +
                "AND YEAR(r.receipt_date) = YEAR(CURRENT_DATE()) " +
                "AND MONTH(r.receipt_date) = MONTH(CURRENT_DATE())")
                    .mapTo(Double.class)
                    .findFirst()
                    .orElse(0.0)
        );
        return total != null ? total : 0.0;
    }

   

   // them phieu nhap kho moi va cac dong hang trong 1 transaction
    public int createReceiptWithItems(InventoryReceipt receipt, List<InventoryReceiptItem> items) {
        return DBContext.get().inTransaction(handle -> {
            int receiptId = handle.createUpdate(
                    "INSERT INTO inventory_receipts (code, supplier_id, receipt_date, total_amount, status, note, created_by) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)")
                    .bind(0, receipt.getCode())
                    .bind(1, receipt.getSupplierId())
                    .bind(2, receipt.getReceiptDate())
                    .bind(3, receipt.getTotalAmount())
                    .bind(4, receipt.getStatus())
                    .bind(5, receipt.getNote())
                    .bind(6, receipt.getCreatedBy())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            for (InventoryReceiptItem item : items) {
                handle.createUpdate(
                        "INSERT INTO inventory_receipt_items (receipt_id, product_id, quantity, unit_price) " +
                        "VALUES (?, ?, ?, ?)")
                        .bind(0, receiptId)
                        .bind(1, item.getProductId())
                        .bind(2, item.getQuantity())
                        .bind(3, item.getUnitPrice())
                        .execute();
            }

            return receiptId;
        });
    }

    // Duyệt phiếu nhập kho va cap nhat ton kho
    public void approveReceipt(int receiptId) {
        DBContext.get().inTransaction(handle -> {
            String currentStatus = handle.createQuery(
                    "SELECT status FROM inventory_receipts WHERE id = ? FOR UPDATE")
                    .bind(0, receiptId)
                    .mapTo(String.class)
                    .findFirst()
                    .orElse(null);

            if (currentStatus == null) {
                throw new IllegalArgumentException("Không tìm thấy phiếu nhập kho");
            }

            if ("APPROVED".equalsIgnoreCase(currentStatus)) {
                throw new IllegalStateException("Phiếu đã được duyệt trước đó");
            }

            handle.createUpdate(
                    "UPDATE inventory_receipts SET status = 'APPROVED' WHERE id = ?")
                    .bind(0, receiptId)
                    .execute();

            List<InventoryReceiptItem> items = handle.createQuery(
                    "SELECT id, receipt_id, product_id, quantity, unit_price FROM inventory_receipt_items WHERE receipt_id = ?")
                    .bind(0, receiptId)
                    .mapToBean(InventoryReceiptItem.class)
                    .list();

            for (InventoryReceiptItem item : items) {
                int updatedRows = handle.createUpdate(
                    "UPDATE products SET quantity = quantity + ? WHERE id = ?")
                        .bind(0, item.getQuantity())
                        .bind(1, item.getProductId())
                        .execute();

                if (updatedRows == 0) {
                    throw new IllegalStateException("Không tìm thấy sản phẩm ID " + item.getProductId());
                }
            }

            return null;
        });
    }

    public void rejectReceipt(int receiptId) {
        DBContext.get().inTransaction(handle -> {
            String currentStatus = handle.createQuery(
                    "SELECT status FROM inventory_receipts WHERE id = ? FOR UPDATE")
                    .bind(0, receiptId)
                    .mapTo(String.class)
                    .findFirst()
                    .orElse(null);

            if (currentStatus == null) {
                throw new IllegalArgumentException("Không tìm thấy phiếu nhập kho");
            }

            if ("APPROVED".equalsIgnoreCase(currentStatus)) {
                throw new IllegalStateException("Phiếu đã được duyệt, không thể từ chối");
            }

            if ("REJECTED".equalsIgnoreCase(currentStatus)) {
                throw new IllegalStateException("Phiếu đã bị từ chối trước đó");
            }

            handle.createUpdate(
                    "UPDATE inventory_receipts SET status = 'REJECTED' WHERE id = ?")
                    .bind(0, receiptId)
                    .execute();

            return null;
        });
    }

   
     //  Lấy mã phiếu tiếp theo tự động
    
    public String generateReceiptCode() {
        return DBContext.get().withHandle(handle -> {
            LocalDateTime now = LocalDateTime.now();
            int year = now.getYear();
            int month = now.getMonthValue();
            int day = now.getDayOfMonth();

            String datePrefix = String.format("RCP-%04d%02d%02d", year, month, day);

            Long count = handle.createQuery(
                    "SELECT COUNT(*) FROM inventory_receipts WHERE code LIKE ?")
                    .bind(0, datePrefix + "%")
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(0L);

            long sequence = (count != null ? count : 0) + 1;
            return String.format("%s-%04d", datePrefix, sequence);
        });
    }

    
     // Kiểm tra mã phiếu đã tồn tại
     
    public boolean receiptCodeExists(String code) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery(
                    "SELECT COUNT(*) FROM inventory_receipts WHERE code = ?")
                    .bind(0, code)
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(0L)
        );
        return count != null && count > 0;
    }

        // Kiểm tra  ID có hợp lệ k
    public boolean supplierExists(int supplierId) {
        Long count = DBContext.get().withHandle(handle ->
            handle.createQuery(
                    "SELECT COUNT(*) FROM suppliers WHERE id = ?")
                    .bind(0, supplierId)
                    .mapTo(Long.class)
                    .findFirst()
                    .orElse(0L)
        );
        return count != null && count > 0;
    }

    
     // Kiểm tra product ID có hợp lệ k
     
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

    // Lấy tất cả nhà cung cấp
    public List<java.util.Map<String, Object>> getAllSuppliers() {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT id, name FROM suppliers ORDER BY name")
                    .mapToMap()
                    .list()
        );
    }

    // Lấy tất cả sản phẩm
    public List<java.util.Map<String, Object>> getAllProducts() {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT id, name FROM products ORDER BY name")
                    .mapToMap()
                    .list()
        );
    }


   
     // Lấy tên nhà cung cấp theo ID
     
    public Optional<String> getSupplierName(int supplierId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT name FROM suppliers WHERE id = ?")
                    .bind(0, supplierId)
                    .mapTo(String.class)
                    .findFirst()
        );
    }

    public Optional<Integer> getSupplierIdByName(String name) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT id FROM suppliers WHERE LOWER(name) = LOWER(?)")
                    .bind(0, name)
                    .mapTo(Integer.class)
                    .findFirst()
        );
    }

    public int insertSupplier(String name) {
        return DBContext.get().withHandle(handle ->
            handle.createUpdate("INSERT INTO suppliers (name) VALUES (?)")
                    .bind(0, name)
                    .executeAndReturnGeneratedKeys()
                    .mapTo(Integer.class)
                    .first()
        );
    }

    
     // Lấy tên sản phẩm theo ID
     
    public Optional<String> getProductName(int productId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT name FROM products WHERE id = ?")
                    .bind(0, productId)
                    .mapTo(String.class)
                    .findFirst()
        );
    }

    
     // Lấy chi tiết phiếu nhập kho với tên nhà cung cấp
    
    public Optional<ReceiptDetailDTO> getReceiptDetail(int receiptId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("""
                SELECT r.id, r.code, r.supplier_id, r.receipt_date, r.total_amount, r.status, 
                       r.note, r.created_by, r.created_at, r.updated_at, s.name as supplier_name
                FROM inventory_receipts r
                LEFT JOIN suppliers s ON r.supplier_id = s.id
                WHERE r.id = ?
                """)
                    .bind(0, receiptId)
                    .map((rs, ctx) -> new ReceiptDetailDTO(
                        rs.getInt("id"),
                        rs.getString("code"),
                        rs.getInt("supplier_id"),
                        rs.getString("supplier_name"),
                        rs.getObject("receipt_date", LocalDateTime.class),
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

    
     // Lấy danh sách dòng hàng của phiếu với tên sản phẩm
    
    public List<ReceiptItemDetailDTO> getReceiptItemsDetail(int receiptId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("""
                SELECT i.id, i.receipt_id, i.product_id, i.quantity, i.unit_price, 
                       i.total_price, p.name as product_name
                FROM inventory_receipt_items i
                LEFT JOIN products p ON i.product_id = p.id
                WHERE i.receipt_id = ?
                """)
                    .bind(0, receiptId)
                    .map((rs, ctx) -> new ReceiptItemDetailDTO(
                        rs.getInt("id"),
                        rs.getInt("receipt_id"),
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getInt("quantity"),
                        rs.getDouble("unit_price"),
                        rs.getDouble("total_price")
                    ))
                    .list()
        );
    }

    
     
     
    public static class ReceiptDetailDTO {
        private int id;
        private String code;
        private int supplierId;
        private String supplierName;
        private LocalDateTime receiptDate;
        private double totalAmount;
        private String status;
        private String note;
        private int createdBy;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;

        public ReceiptDetailDTO(int id, String code, int supplierId, String supplierName, 
                                LocalDateTime receiptDate, double totalAmount, String status, 
                                String note, int createdBy, LocalDateTime createdAt, LocalDateTime updatedAt) {
            this.id = id;
            this.code = code;
            this.supplierId = supplierId;
            this.supplierName = supplierName;
            this.receiptDate = receiptDate;
            this.totalAmount = totalAmount;
            this.status = status;
            this.note = note;
            this.createdBy = createdBy;
            this.createdAt = createdAt;
            this.updatedAt = updatedAt;
        }

        public int getId() { return id; }
        public String getCode() { return code; }
        public int getSupplierId() { return supplierId; }
        public String getSupplierName() { return supplierName; }
        public LocalDateTime getReceiptDate() { return receiptDate; }
        public double getTotalAmount() { return totalAmount; }
        public String getStatus() { return status; }
        public String getNote() { return note; }
        public int getCreatedBy() { return createdBy; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public LocalDateTime getUpdatedAt() { return updatedAt; }
    }

    
     
     
    public static class ReceiptItemDetailDTO {
        private int id;
        private int receiptId;
        private int productId;
        private String productName;
        private int quantity;
        private double unitPrice;
        private double totalPrice;

        public ReceiptItemDetailDTO(int id, int receiptId, int productId, String productName,
                                    int quantity, double unitPrice, double totalPrice) {
            this.id = id;
            this.receiptId = receiptId;
            this.productId = productId;
            this.productName = productName;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.totalPrice = totalPrice;
        }

        public int getId() { return id; }
        public int getReceiptId() { return receiptId; }
        public int getProductId() { return productId; }
        public String getProductName() { return productName; }
        public int getQuantity() { return quantity; }
        public double getUnitPrice() { return unitPrice; }
        public double getTotalPrice() { return totalPrice; }
    }
}
