package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import dal.AdminWarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BatchStockView;
import model.ProductStockView;
import model.User;
import model.WarehouseBatchRow;
import util.AdminPermissionHelper;

@WebServlet({"/admin/inventory-warehouse"})
public class AdminWarehouseServlet extends HttpServlet {
    private AdminWarehouseDAO warehouseDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        warehouseDAO = new AdminWarehouseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("/Fruitshop_Web/");
            return;
        }

        try {
            handleWarehousePage(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
        }
    }

    private void handleWarehousePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<WarehouseBatchRow> rows = warehouseDAO.getWarehouseBatchRows();
        Map<Integer, ProductStockView> productMap = new LinkedHashMap<>();

        for (WarehouseBatchRow row : rows) {
            ProductStockView product = productMap.get(row.getProductId());
            if (product == null) {
                product = createProductView(row);
                productMap.put(row.getProductId(), product);
            }

            product.getBatches().add(createBatchView(row));
        }

        LocalDate today = LocalDate.now();
        List<ProductStockView> productStocks = new ArrayList<>();
        int lowStockCount = 0;
        int oldBatchCount = 0;

        for (ProductStockView product : productMap.values()) {
            buildProductSummary(product, today);
            if (product.getQuantity() <= 0) {
                continue;
            }

            productStocks.add(product);

            if (product.getQuantity() < 10) {
                lowStockCount += 1;
            }
            oldBatchCount += product.getOldBatchCount();
        }

        request.setAttribute("productStocks", productStocks);
        request.setAttribute("totalProductTypes", productStocks.size());
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("oldBatchCount", oldBatchCount);
        request.getRequestDispatcher("/admin/inventory-warehouse.jsp").forward(request, response);
    }

    private ProductStockView createProductView(WarehouseBatchRow row) {
        ProductStockView product = new ProductStockView();
        product.setProductId(row.getProductId());
        product.setProductName(row.getProductName());
        product.setProductCode(row.getProductCode());
        product.setPrice(row.getProductPrice());
        product.setQuantity(row.getProductQuantity());
        product.setImage(row.getProductImage());
        product.setGroupKey("product-" + row.getProductId());
        product.setOldestDateDisplay("-");
        product.setOldestAgeDays(-1);
        product.setFreshnessKey("fresh");
        product.setStatusBadgeClass("safe");
        product.setOldBatchCount(0);
        return product;
    }

    private BatchStockView createBatchView(WarehouseBatchRow row) {
        BatchStockView batch = new BatchStockView();
        batch.setItemId(row.getItemId());
        batch.setReceiptId(row.getReceiptId());
        batch.setReceiptCode(row.getReceiptCode());
        batch.setReceiptDate(row.getReceiptDate());
        batch.setQuantity(row.getItemQuantity());
        batch.setReceiptDateDisplay("-");
        batch.setAgeDays(-1);
        batch.setFreshnessKey("fresh");
        batch.setStatusBadgeClass("safe");
        batch.setBatchCode("LO-" + row.getReceiptId() + "-" + row.getItemId());
        return batch;
    }

    private void buildProductSummary(ProductStockView product, LocalDate today) {
        List<BatchStockView> sortedBatches = new ArrayList<>(product.getBatches());
        sortedBatches.sort(Comparator
                .comparing(BatchStockView::getReceiptDate, Comparator.nullsLast(Comparator.naturalOrder()))
                .thenComparing(BatchStockView::getItemId)
                .reversed());

        int remaining = product.getQuantity();
        List<BatchStockView> remainingBatches = new ArrayList<>();
        for (BatchStockView batch : sortedBatches) {
            if (remaining <= 0) {
                break;
            }

            int kept = Math.min(batch.getQuantity(), remaining);
            if (kept <= 0) {
                continue;
            }

            remaining -= kept;
            batch.setQuantity(kept);
            applyBatchAge(batch, today);
            remainingBatches.add(batch);
        }

        product.setBatches(remainingBatches);
        updateProductSummary(product);
    }

    private void applyBatchAge(BatchStockView batch, LocalDate today) {
        LocalDateTime receiptDate = batch.getReceiptDate();
        int ageDays = -1;
        if (receiptDate != null) {
            ageDays = (int) ChronoUnit.DAYS.between(receiptDate.toLocalDate(), today);
            if (ageDays < 0) {
                ageDays = 0;
            }
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            batch.setReceiptDateDisplay(receiptDate.format(dateFormatter));
        }
        batch.setAgeDays(ageDays);
        batch.setFreshnessKey(resolveFreshnessKey(ageDays));
        batch.setStatusBadgeClass(resolveBadgeClass(batch.getFreshnessKey()));
    }

    private void updateProductSummary(ProductStockView product) {
        int oldBatchCount = 0;
        int maxAge = -1;
        LocalDateTime oldestDate = null;

        for (BatchStockView batch : product.getBatches()) {
            if (batch.getAgeDays() > 3) {
                oldBatchCount += 1;
            }
            if (batch.getAgeDays() > maxAge) {
                maxAge = batch.getAgeDays();
                oldestDate = batch.getReceiptDate();
            }
        }

        product.setOldBatchCount(oldBatchCount);
        product.setOldestAgeDays(maxAge);
        if (oldestDate != null) {
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            product.setOldestDateDisplay(oldestDate.format(dateFormatter));
        } else {
            product.setOldestDateDisplay("-");
        }

        product.setFreshnessKey(resolveFreshnessKey(maxAge));
        product.setStatusBadgeClass(resolveBadgeClass(product.getFreshnessKey()));
    }

    private String resolveFreshnessKey(int ageDays) {
        if (ageDays <= 2 && ageDays >= 0) {
            return "fresh";
        }
        if (ageDays <= 4) {
            return "near";
        }
        return "critical";
    }

    private String resolveBadgeClass(String key) {
        if ("critical".equals(key)) {
            return "critical";
        }
        if ("near".equals(key)) {
            return "near";
        }
        return "safe";
    }

    private boolean isAdmin(HttpServletRequest request) {
        Object accountObj = request.getSession().getAttribute("account");
        if (accountObj instanceof User) {
            return AdminPermissionHelper.isAdminAccount((User) accountObj);
        }
        return false;
    }
}
