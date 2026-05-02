package dal;

import model.InventoryReceipt;
import model.InventoryReceiptItem;

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
}
