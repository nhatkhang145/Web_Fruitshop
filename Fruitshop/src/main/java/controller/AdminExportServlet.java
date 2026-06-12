package controller;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.google.gson.Gson;

import dal.AdminExportDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.InventoryExportItem;
import model.InventoryExportReceipt;
import model.User;
import util.AdminPermissionHelper;

@WebServlet({"/admin/stock-export", "/admin/inventory-export-create", "/admin/inventory-export-detail", "/admin/inventory-export-approve", "/admin/inventory-export-reject"})
public class AdminExportServlet extends HttpServlet {
    private AdminExportDAO exportDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        exportDAO = new AdminExportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if (!isAdmin(request)) {
            response.sendRedirect("/Fruitshop_Web/");
            return;
        }

        try {
            if ("/admin/stock-export".equals(path)) {
                handleListPage(request, response);
            } else if ("/admin/inventory-export-create".equals(path)) {
                handleCreatePage(request, response);
            } else if ("/admin/inventory-export-detail".equals(path)) {
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
            if ("/admin/inventory-export-create".equals(path)) {
                handleCreateExport(request, response);
            } else if ("/admin/inventory-export-approve".equals(path)) {
                handleApproveExport(request, response);
            } else if ("/admin/inventory-export-reject".equals(path)) {
                handleRejectExport(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
        }
    }

    private void handleListPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String filter = request.getParameter("filter");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String search = request.getParameter("search");

            List<InventoryExportReceipt> exports;

            if ("date_range".equals(filter) && fromDate != null && !fromDate.isEmpty()
                && toDate != null && !toDate.isEmpty()) {
                exports = exportDAO.getExportsByDateRange(fromDate, toDate);
            } else if ("status".equals(filter)) {
                String status = request.getParameter("status");
                if (status != null && !status.isEmpty()) {
                    exports = exportDAO.getExportsByStatus(status);
                } else {
                    exports = exportDAO.getAllExports();
                }
            } else if (search != null && !search.isEmpty()) {
                Optional<InventoryExportReceipt> receipt = exportDAO.searchExportByCode(search);
                exports = receipt.map(List::of).orElse(List.of());
            } else {
                exports = exportDAO.getAllExports();
            }

            UserDAO userDAO = new UserDAO();
            List<Map<String, Object>> exportList = new ArrayList<>();
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            for (InventoryExportReceipt r : exports) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", r.getId());
                map.put("code", r.getCode());
                map.put("dateData", r.getExportDate() != null ? r.getExportDate().format(dateFormatter) : "");
                map.put("dateDisplay", r.getExportDate() != null ? r.getExportDate().format(timeFormatter) : "");
                map.put("totalValue", r.getTotalAmount());
                map.put("receiverName", r.getReceiverName());

                String exportTypeDisplay = r.getExportType();
                if ("SALES".equalsIgnoreCase(r.getExportType())) exportTypeDisplay = "Bán hàng";
                else if ("INTERNAL".equalsIgnoreCase(r.getExportType())) exportTypeDisplay = "Nội bộ";
                else if ("TRANSFER".equalsIgnoreCase(r.getExportType())) exportTypeDisplay = "Điều chuyển";
                else if ("WASTE".equalsIgnoreCase(r.getExportType())) exportTypeDisplay = "Sản phẩm hỏng";
                map.put("exportType", exportTypeDisplay);

                String statusDisplay = r.getStatus();
                if ("PENDING".equalsIgnoreCase(r.getStatus())) statusDisplay = "Chờ duyệt";
                else if ("APPROVED".equalsIgnoreCase(r.getStatus())) statusDisplay = "Đã xác nhận";
                else if ("CANCELLED".equalsIgnoreCase(r.getStatus())) statusDisplay = "Đã hủy";
                else if ("DRAFT".equalsIgnoreCase(r.getStatus())) statusDisplay = "Nháp";

                String statusClass = "draft";
                if ("PENDING".equalsIgnoreCase(r.getStatus())) statusClass = "pending";
                else if ("APPROVED".equalsIgnoreCase(r.getStatus())) statusClass = "approved";
                else if ("CANCELLED".equalsIgnoreCase(r.getStatus())) statusClass = "cancelled";

                map.put("statusDisplay", statusDisplay);
                map.put("statusClass", statusClass);
                map.put("note", r.getNote() != null ? r.getNote() : "");

                String creatorName = userDAO.getUserById(r.getCreatedBy()).map(User::getFullName).orElse("Admin");
                map.put("creatorName", creatorName);

                List<AdminExportDAO.ExportItemDetailDTO> items = exportDAO.getExportItemsDetail(r.getId());
                int totalQuantity = 0;
                for (AdminExportDAO.ExportItemDetailDTO item : items) {
                    totalQuantity += item.getQuantity();
                }
                map.put("totalItems", items.size());
                map.put("totalQuantity", totalQuantity);

                exportList.add(map);
            }

            request.setAttribute("exportList", exportList);
            request.setAttribute("totalExports", exports.size());
            request.setAttribute("totalExportItems", exportDAO.getTotalExportQuantity());
            request.setAttribute("totalExportValueThisMonth", exportDAO.getTotalExportValueThisMonth());
            request.setAttribute("approvedExports", exportDAO.getExportCountByStatus("APPROVED"));
            request.setAttribute("pendingExports", exportDAO.getExportCountByStatus("PENDING"));
            request.setAttribute("salesExports", exportDAO.getExportCountByType("SALES"));
            request.setAttribute("currentFilter", filter != null ? filter : "all");

            request.getRequestDispatcher("/admin/inventory-export-manager.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/admin/inventory-export-manager.jsp").forward(request, response);
        }
    }

    private void handleCreatePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("suppliers", exportDAO.getAllSuppliers());
            request.setAttribute("products", exportDAO.getAllProducts());
            request.getRequestDispatcher("/admin/inventory-export-create.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/admin/inventory-export-create.jsp").forward(request, response);
        }
    }

    private void handleCreateExport(HttpServletRequest request, HttpServletResponse response)
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
            String exportDate = request.getParameter("receipt_date");
            String note = request.getParameter("note");
            String itemsJson = request.getParameter("items");
            String exportType = request.getParameter("export_type");

            String receiverName = null;
            String wasteReason = request.getParameter("waste_reason");

            if (exportType != null && "WASTE".equalsIgnoreCase(exportType)) {
                if (wasteReason == null || wasteReason.trim().isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Vui lòng nhập lý do loại bỏ cho 'Sản phẩm hỏng'");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                receiverName = "";
            } else {
                if (supplierId > 0) {
                    receiverName = exportDAO.getSupplierName(supplierId).orElse(null);
                    if (receiverName == null) {
                        result.put("success", false);
                        result.put("message", "Đơn vị nhận không tồn tại");
                        response.getWriter().write(gson.toJson(result));
                        return;
                    }
                } else if (supplierName != null && !supplierName.trim().isEmpty()) {
                    receiverName = supplierName.trim();
                }

                if (receiverName == null || receiverName.isEmpty()) {
                    result.put("success", false);
                    result.put("message", "Đơn vị nhận không hợp lệ");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            }

            if (exportDate == null || exportDate.isEmpty()) {
                result.put("success", false);
                result.put("message", "Ngày xuất không hợp lệ");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (itemsJson == null || itemsJson.isEmpty()) {
                result.put("success", false);
                result.put("message", "Phiếu phải có ít nhất 1 dòng hàng");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (exportType == null || exportType.trim().isEmpty()) {
                exportType = "SALES";
            } else {
                exportType = exportType.trim().toUpperCase();
            }

            InventoryExportItem[] itemsArray = gson.fromJson(itemsJson, InventoryExportItem[].class);
            if (itemsArray == null || itemsArray.length == 0) {
                result.put("success", false);
                result.put("message", "Phiếu phải có ít nhất 1 dòng hàng");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            double totalAmount = 0;
            for (InventoryExportItem item : itemsArray) {
                if (item.getProductId() <= 0) {
                    result.put("success", false);
                    result.put("message", "Sản phẩm không hợp lệ");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                if (!exportDAO.productExists(item.getProductId())) {
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

            for (InventoryExportItem item : itemsArray) {
                Integer batchItemId = item.getBatchItemId();
                if (batchItemId != null && batchItemId > 0) {
                    Integer avail = exportDAO.getBatchAvailableQuantity(batchItemId);
                    if (avail == null) {
                        result.put("success", false);
                        result.put("message", "Không tìm thấy lô id " + batchItemId);
                        response.getWriter().write(gson.toJson(result));
                        return;
                    }
                    if (avail < item.getQuantity()) {
                        result.put("success", false);
                        result.put("message", "Số lượng yêu cầu vượt quá tồn lô (lô id " + batchItemId + ")");
                        response.getWriter().write(gson.toJson(result));
                        return;
                    }
                }
            }

            String exportCode = exportDAO.generateExportCode();

            InventoryExportReceipt receipt = new InventoryExportReceipt();
            receipt.setCode(exportCode);
            receipt.setReceiverName(receiverName);
            receipt.setExportType(exportType);
            receipt.setExportDate(java.time.LocalDateTime.parse(exportDate + "T00:00:00"));
            receipt.setTotalAmount(totalAmount);
            receipt.setStatus("PENDING");
            if (wasteReason != null && !wasteReason.trim().isEmpty()) {
                String combined = "Lý do loại bỏ: " + wasteReason.trim();
                if (note != null && !note.trim().isEmpty()) combined += " | " + note.trim();
                receipt.setNote(combined);
            } else {
                receipt.setNote(note);
            }
            receipt.setCreatedBy(getUserId(request));

            int exportId = exportDAO.createExportWithItems(receipt, java.util.Arrays.asList(itemsArray));

            result.put("success", true);
            result.put("message", "Thêm phiếu thành công");
            result.put("export_id", exportId);
            result.put("export_code", exportCode);
            result.put("receipt_code", exportCode);

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

    private void handleApproveExport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            String exportIdParam = request.getParameter("exportId");
            if (exportIdParam == null || exportIdParam.isEmpty()) {
                exportIdParam = request.getParameter("id");
            }
            if (exportIdParam == null || exportIdParam.isEmpty()) {
                result.put("success", false);
                result.put("message", "ID phiếu không hợp lệ");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int exportId = Integer.parseInt(exportIdParam);
            exportDAO.approveExport(exportId);

            result.put("success", true);
            result.put("message", "Xác nhận phiếu thành công");
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID phiếu không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    private void handleRejectExport(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            String exportIdParam = request.getParameter("exportId");
            if (exportIdParam == null || exportIdParam.isEmpty()) {
                exportIdParam = request.getParameter("id");
            }
            if (exportIdParam == null || exportIdParam.isEmpty()) {
                result.put("success", false);
                result.put("message", "ID phiếu không hợp lệ");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            int exportId = Integer.parseInt(exportIdParam);
            exportDAO.rejectExport(exportId);

            result.put("success", true);
            result.put("message", "Từ chối phiếu thành công");
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID phiếu không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        response.getWriter().write(gson.toJson(result));
    }

    private void handleGetDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String format = request.getParameter("format");
        String exportIdStr = request.getParameter("id");
        String exportCode = request.getParameter("code");

        if ((exportIdStr == null || exportIdStr.isEmpty()) && (exportCode == null || exportCode.isEmpty())) {
            if ("json".equals(format)) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"ID phiếu không hợp lệ\"}");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID phiếu không hợp lệ");
            }
            return;
        }

        try {
            int exportId;
            if (exportIdStr != null && !exportIdStr.isEmpty()) {
                exportId = Integer.parseInt(exportIdStr);
            } else {
                Optional<InventoryExportReceipt> byCode = exportDAO.getExportByCode(exportCode);
                if (byCode.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu");
                    return;
                }
                exportId = byCode.get().getId();
            }

            if ("json".equals(format)) {
                handleGetDetailJSON(exportId, response);
            } else {
                handleViewDetailPage(exportId, request, response);
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

    private void handleGetDetailJSON(int exportId, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            Optional<InventoryExportReceipt> receipt = exportDAO.getExportById(exportId);
            if (receipt.isEmpty()) {
                result.put("success", false);
                result.put("message", "Không tìm thấy phiếu");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            List<InventoryExportItem> items = exportDAO.getExportItemsByExportId(exportId);
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

    private void handleViewDetailPage(int exportId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Optional<AdminExportDAO.ExportDetailDTO> receiptDetail = exportDAO.getExportDetail(exportId);
            if (receiptDetail.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu");
                return;
            }

            AdminExportDAO.ExportDetailDTO detail = receiptDetail.get();
            List<AdminExportDAO.ExportItemDetailDTO> items = exportDAO.getExportItemsDetail(exportId);

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            String exportDateDisplay = detail.getExportDate() != null
                ? detail.getExportDate().format(dateFormatter)
                : "";
            String createdAtDisplay = detail.getCreatedAt() != null
                ? detail.getCreatedAt().format(dateTimeFormatter)
                : "";
            String updatedAtDisplay = detail.getUpdatedAt() != null
                ? detail.getUpdatedAt().format(dateTimeFormatter)
                : "";

            String exportTypeDisplay = detail.getExportType();
            if ("SALES".equalsIgnoreCase(detail.getExportType())) exportTypeDisplay = "Bán hàng";
            else if ("INTERNAL".equalsIgnoreCase(detail.getExportType())) exportTypeDisplay = "Nội bộ";
            else if ("TRANSFER".equalsIgnoreCase(detail.getExportType())) exportTypeDisplay = "Điều chuyển";
            else if ("WASTE".equalsIgnoreCase(detail.getExportType())) exportTypeDisplay = "Sản phẩm hỏng";

            request.setAttribute("receipt", detail);
            request.setAttribute("items", items);
            request.setAttribute("itemCount", items.size());
            request.setAttribute("exportDateDisplay", exportDateDisplay);
            request.setAttribute("createdAtDisplay", createdAtDisplay);
            request.setAttribute("updatedAtDisplay", updatedAtDisplay);
            request.setAttribute("exportTypeDisplay", exportTypeDisplay);

            request.getRequestDispatcher("/admin/inventory-export-detail.jsp").forward(request, response);

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
            return AdminPermissionHelper.isAdminAccount((User) accountObj);
        }
        return false;
    }
}
