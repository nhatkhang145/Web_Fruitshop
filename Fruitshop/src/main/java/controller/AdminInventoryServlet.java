package controller;

import dal.AdminInventoryDAO;
import model.InventoryReceipt;
import model.InventoryReceiptItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@WebServlet({"/admin/inventory-management", "/admin/inventory-receipt-detail"})
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

       
            request.setAttribute("receipts", receipts);
            request.setAttribute("currentFilter", filter != null ? filter : "all");
            request.getRequestDispatcher("/inventory-management.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/inventory-management.jsp").forward(request, response);
        }
    }

    
     //  Lấy chi tiết phiếu nhập kho theo id
    private void handleGetDetail(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            String receiptIdStr = request.getParameter("id");
            if (receiptIdStr == null || receiptIdStr.isEmpty()) {
                result.put("success", false);
                result.put("message", "ID phiếu không hợp lệ");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int receiptId = Integer.parseInt(receiptIdStr);
            
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
            
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    
    private boolean isAdmin(HttpServletRequest request) { 
        Object user = request.getSession().getAttribute("user");
        return user != null; 
    }
}
