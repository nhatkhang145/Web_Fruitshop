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

   

   // them phieu nhap kho moi
    public int insertReceipt(InventoryReceipt receipt) {
        return DBContext.get().withHandle(handle ->
            handle.createUpdate(
                    "INSERT INTO inventory_receipts (code, supplier_id, receipt_date, total_amount, status, note, created_by) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)")
                    .bind(0, receipt.getCode())
                    .bind(1, receipt.getSupplierId())
                    .bind(2, receipt.getReceiptDate())
                    .bind(3, receipt.getTotalAmount())
                    .bind(4, receipt.getStatus())
                    .bind(5, receipt.getNote())
                    .bind(6, receipt.getCreatedBy())
                    .executeAndReturnGeneratedKeys()
                    .mapTo(Integer.class)
                    .first()
        );
    }

    
     // Thêm dòng hàng cho phiếu nhập kho
     
    public int insertReceiptItem(InventoryReceiptItem item) {
        return DBContext.get().withHandle(handle ->
            handle.createUpdate(
                    "INSERT INTO inventory_receipt_items (receipt_id, product_id, quantity, unit_price) " +
                    "VALUES (?, ?, ?, ?)")
                    .bind(0, item.getReceiptId())
                    .bind(1, item.getProductId())
                    .bind(2, item.getQuantity())
                    .bind(3, item.getUnitPrice())
                    .execute()
        );
    }

    
     // Thêm nhiều dòng hàng cùng lúc
     
    public void insertReceiptItems(int receiptId, List<InventoryReceiptItem> items) {
        DBContext.get().useTransaction(handle -> {
            for (InventoryReceiptItem item : items) {
                item.setReceiptId(receiptId);
                handle.createUpdate(
                        "INSERT INTO inventory_receipt_items (receipt_id, product_id, quantity, unit_price) " +
                        "VALUES (?, ?, ?, ?)")
                        .bind(0, item.getReceiptId())
                        .bind(1, item.getProductId())
                        .bind(2, item.getQuantity())
                        .bind(3, item.getUnitPrice())
                        .execute();
            }
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

   
     // Lấy tên nhà cung cấp theo ID
     
    public Optional<String> getSupplierName(int supplierId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT name FROM suppliers WHERE id = ?")
                    .bind(0, supplierId)
                    .mapTo(String.class)
                    .findFirst()
        );
    }

    
     // Lấy tên sản phẩm theo ID
     
    public Optional<String> getProductName(int productId) {
        return DBContext.get().withHandle(handle ->
            handle.createQuery("SELECT product_name FROM products WHERE id = ?")
                    .bind(0, productId)
                    .mapTo(String.class)
                    .findFirst()
        );
    }
}
