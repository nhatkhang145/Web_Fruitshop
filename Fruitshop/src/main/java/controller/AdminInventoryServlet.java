package controller;

import dal.AdminInventoryDAO;
import model.InventoryReceipt;
import model.InventoryReceiptItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.ArrayList;
import java.time.format.DateTimeFormatter;


@WebServlet({"/admin/inventory-management", "/admin/inventory-receipt-detail", "/admin/inventory-receipt-create"})
public class AdminInventoryServlet extends HttpServlet {
    private AdminInventoryDAO inventoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        inventoryDAO = new AdminInventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        String action = request.getParameter("action");

    
        if (!isAdmin(request)) {
            response.sendRedirect("/Fruitshop_Web/");
            return;
        }

        try {
            if ("/admin/inventory-management".equals(path)) {  
                handleListPage(request, response);
            } 
            else if ("/admin/inventory-receipt-detail".equals(path)) {
                handleGetDetail(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();

        if (!isAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"Không có quyền\"}");
            return;
        }

        try {
            if ("/admin/inventory-receipt-create".equals(path)) {
                handleCreateReceipt(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
        }
    }

    
     // Tạo phiếu nhập kho mới
    private void handleCreateReceipt(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            String supplierIdParam = request.getParameter("supplier_id");
            int supplierId = 0;
            if (supplierIdParam != null && !supplierIdParam.isEmpty()) {
                supplierId = Integer.parseInt(supplierIdParam);
            }
            String supplierName = request.getParameter("supplier_name");
            String receiptDate = request.getParameter("receipt_date");
            String note = request.getParameter("note");
            String itemsJson = request.getParameter("items");

            if (supplierId > 0) {
                if (!inventoryDAO.supplierExists(supplierId)) {
                    result.put("success", false);
                    result.put("message", "Nhà cung cấp không tồn tại");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            } else {
                if (supplierName == null || supplierName.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Nhà cung cấp không hợp lệ");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                Optional<Integer> existingSupplierId = inventoryDAO.getSupplierIdByName(supplierName.trim());
                if (existingSupplierId.isPresent()) {
                    supplierId = existingSupplierId.get();
                } else {
                    supplierId = inventoryDAO.insertSupplier(supplierName.trim());
                }
            }

            if (receiptDate == null || receiptDate.isEmpty()) {
                result.put("success", false);
                result.put("message", "Ngày nhập không hợp lệ");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (itemsJson == null || itemsJson.isEmpty()) {
                result.put("success", false);
                result.put("message", "Phiếu phải có ít nhất 1 dòng hàng");
                response.getWriter().write(gson.toJson(result));
                return;
            }

        
            InventoryReceiptItem[] itemsArray = gson.fromJson(itemsJson, InventoryReceiptItem[].class);
            if (itemsArray == null || itemsArray.length == 0) {
                result.put("success", false);
                result.put("message", "Phiếu phải có ít nhất 1 dòng hàng");
                response.getWriter().write(gson.toJson(result));
                return;
            }

          
            double totalAmount = 0;
            for (InventoryReceiptItem item : itemsArray) {
                if (item.getProductId() <= 0) {
                    result.put("success", false);
                    result.put("message", "Sản phẩm không hợp lệ");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                if (!inventoryDAO.productExists(item.getProductId())) {
                    result.put("success", false);
                    result.put("message", "Sản phẩm ID " + item.getProductId() + " không tồn tại");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                if (item.getQuantity() <= 0) {
                    result.put("success", false);
                    result.put("message", "Số lượng phải lớn hơn 0");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                if (item.getUnitPrice() <= 0) {
                    result.put("success", false);
                    result.put("message", "Giá đơn vị phải lớn hơn 0");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                totalAmount += item.getQuantity() * item.getUnitPrice();
            }

          
            String receiptCode = inventoryDAO.generateReceiptCode();

           
            InventoryReceipt receipt = new InventoryReceipt();
            receipt.setCode(receiptCode);
            receipt.setSupplierId(supplierId);
            receipt.setReceiptDate(java.time.LocalDateTime.parse(receiptDate + "T00:00:00"));
            receipt.setTotalAmount(totalAmount);
            receipt.setStatus("PENDING");
            receipt.setNote(note);
            receipt.setCreatedBy(getUserId(request));

            int receiptId = inventoryDAO.insertReceipt(receipt);

          
            inventoryDAO.insertReceiptItems(receiptId, java.util.Arrays.asList(itemsArray));

            result.put("success", true);
            result.put("message", "Thêm phiếu thành công");
            result.put("receipt_id", receiptId);
            result.put("receipt_code", receiptCode);

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    
     // Hiển thị trang danh sách phiếu nhập kho
    private void handleListPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            
            String filter = request.getParameter("filter");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String search = request.getParameter("search");

            List<InventoryReceipt> receipts;

            if ("date_range".equals(filter) && fromDate != null && !fromDate.isEmpty() && 
                toDate != null && !toDate.isEmpty()) {
                
                receipts = inventoryDAO.getReceiptsByDateRange(fromDate, toDate);
            } 
            else if ("status".equals(filter)) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    receipts = inventoryDAO.getReceiptsByStatus(status);
                } else {
                    receipts = inventoryDAO.getAllReceipts();
                }
            }
            else if (search != null && !search.isEmpty()) {
                
                Optional<InventoryReceipt> receipt = inventoryDAO.searchReceiptByCode(search);
                receipts = receipt.map(List::of).orElse(List.of());
            }
            else {
                
                receipts = inventoryDAO.getAllReceipts();
            }

            dal.UserDAO userDAO = new dal.UserDAO();
            List<Map<String, Object>> receiptList = new ArrayList<>();
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            for (InventoryReceipt r : receipts) {
                Map<String, Object> map = new HashMap<>();
                map.put("code", r.getCode());
                map.put("dateData", r.getReceiptDate() != null ? r.getReceiptDate().format(dateFormatter) : "");
                map.put("dateDisplay", r.getReceiptDate() != null ? r.getReceiptDate().format(timeFormatter) : "");
                map.put("totalValue", r.getTotalAmount());
                
                String statusDisplay = r.getStatus();
                if ("PENDING".equalsIgnoreCase(r.getStatus())) statusDisplay = "Chờ duyệt";
                else if ("APPROVED".equalsIgnoreCase(r.getStatus())) statusDisplay = "Đã duyệt";
                else if ("DRAFT".equalsIgnoreCase(r.getStatus())) statusDisplay = "Tạm lưu";
                
                String statusClass = "draft";
                if ("PENDING".equalsIgnoreCase(r.getStatus())) statusClass = "pending";
                else if ("APPROVED".equalsIgnoreCase(r.getStatus())) statusClass = "approved";
                
                map.put("statusDisplay", statusDisplay);
                map.put("statusClass", statusClass);
                map.put("note", r.getNote() != null ? r.getNote() : "");

                String supplierName = inventoryDAO.getSupplierName(r.getSupplierId()).orElse("Không rõ");
                map.put("supplierName", supplierName);
                
                String creatorName = userDAO.getUserById(r.getCreatedBy()).map(User::getFullName).orElse("Admin");
                map.put("creatorName", creatorName);

                List<AdminInventoryDAO.ReceiptItemDetailDTO> items = inventoryDAO.getReceiptItemsDetail(r.getId());
                map.put("totalItems", items.size());
                
                StringBuilder lines = new StringBuilder();
                for (int i = 0; i < items.size(); i++) {
                    lines.append(items.get(i).getProductName()).append(" x").append(items.get(i).getQuantity());
                    if (i < items.size() - 1) lines.append(";");
                }
                map.put("lines", lines.toString());
                
                receiptList.add(map);
            }

            request.setAttribute("receiptList", receiptList);
            request.setAttribute("totalReceipts", receipts.size());
            request.setAttribute("currentFilter", filter != null ? filter : "all");
            request.setAttribute("suppliers", inventoryDAO.getAllSuppliers());
            request.setAttribute("products", inventoryDAO.getAllProducts());
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/admin/inventory-management.jsp").forward(request, response);
        }
    }

    
     //  Lấy chi tiết phiếu nhập kho theo id
    private void handleGetDetail(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String format = request.getParameter("format");
        String receiptIdStr = request.getParameter("id");

       
        if (receiptIdStr == null || receiptIdStr.isEmpty()) {
            if ("json".equals(format)) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"ID phiếu không hợp lệ\"}");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID phiếu không hợp lệ");
            }
            return;
        }

        try {
            int receiptId = Integer.parseInt(receiptIdStr);

            if ("json".equals(format)) {
                handleGetDetailJSON(receiptId, response);
            } else {
                
                handleViewDetailPage(receiptId, request, response);
            }

        } catch (NumberFormatException e) {
            if ("json".equals(format)) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            }
        }
    }

    private void handleGetDetailJSON(int receiptId, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            Optional<InventoryReceipt> receipt = inventoryDAO.getReceiptById(receiptId);
            
            if (receipt.isEmpty()) {
                result.put("success", false);
                result.put("message", "Không tìm thấy phiếu");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            List<InventoryReceiptItem> items = inventoryDAO.getReceiptItemsByReceiptId(receiptId);
            result.put("success", true);
            result.put("receipt", receipt.get());
            result.put("items", items);
            result.put("itemCount", items.size());
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

   
    private void handleViewDetailPage(int receiptId, HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Optional<AdminInventoryDAO.ReceiptDetailDTO> receiptDetail = inventoryDAO.getReceiptDetail(receiptId);
            
            if (receiptDetail.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu");
                return;
            }

            List<AdminInventoryDAO.ReceiptItemDetailDTO> items = inventoryDAO.getReceiptItemsDetail(receiptId);

            // Set attributes cho JSP
            request.setAttribute("receipt", receiptDetail.get());
            request.setAttribute("items", items);
            request.setAttribute("itemCount", items.size());

            // Forward tới JSP
            request.getRequestDispatcher("/admin/inventory-receipt-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
        }
    }

    
  
    private int getUserId(HttpServletRequest request) {
        Object accountObj = request.getSession().getAttribute("account");
        if (accountObj instanceof User) {
            return ((User) accountObj).getId();
        }
        return 0;
    }

    private boolean isAdmin(HttpServletRequest request) { 
        Object accountObj = request.getSession().getAttribute("account");
        if (accountObj instanceof User) {
            return ((User) accountObj).getRole() == 1; // Assuming role 1 is Admin
        }
        return false; 
    }
}
