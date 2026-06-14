package dal;

import java.time.LocalDate;
import java.util.AbstractMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import model.ReportProduct;

public class AdminReportDAO {
    public double getTotalImportValue(String startDate, String endDate) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) " +
                "FROM inventory_receipts " +
                "WHERE status = 'APPROVED' " +
                "AND DATE(receipt_date) >= :startDate " +
                "AND DATE(receipt_date) <= :endDate";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0)
        );
    }

    public double getTotalExportValue(String startDate, String endDate, String exportType) {
        StringBuilder sql = new StringBuilder("SELECT COALESCE(SUM(total_amount), 0) " +
                "FROM inventory_export_receipts " +
                "WHERE status = 'APPROVED' " +
                "AND DATE(export_date) >= :startDate " +
                "AND DATE(export_date) <= :endDate");

        boolean filterType = exportType != null && !exportType.isBlank() && !"all".equalsIgnoreCase(exportType);
        if (filterType) {
            sql.append(" AND export_type = :exportType");
        }

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString())
                .bind("startDate", startDate)
                .bind("endDate", endDate);
            if (filterType) {
                query.bind("exportType", exportType);
            }
            return query.mapTo(Double.class).findFirst().orElse(0.0);
        });
    }

    public double getTotalRevenue(String startDate, String endDate) {
        String sql = "SELECT COALESCE(SUM(final_amount), 0) " +
                "FROM orders " +
                "WHERE status = 'completed' " +
                "AND DATE(created_at) >= :startDate " +
                "AND DATE(created_at) <= :endDate";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0)
        );
    }

    public double getTotalCogs(String startDate, String endDate, String exportType) {
        if (exportType != null && !exportType.isBlank() && !"all".equalsIgnoreCase(exportType)
                && !"SALES".equalsIgnoreCase(exportType)) {
            return 0.0;
        }

        String sql = "SELECT COALESCE(SUM(e.quantity * COALESCE(ri.unit_price, 0)), 0) " +
                "FROM inventory_export_items e " +
                "JOIN inventory_export_receipts r ON e.export_id = r.id " +
                "LEFT JOIN inventory_receipt_items ri ON e.batch_item_id = ri.id " +
                "WHERE r.status = 'APPROVED' " +
                "AND r.export_type = 'SALES' " +
                "AND DATE(r.export_date) >= :startDate " +
                "AND DATE(r.export_date) <= :endDate";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0)
        );
    }

    public double getTotalWasteCost(String startDate, String endDate, String exportType) {
        if (exportType != null && !exportType.isBlank() && !"all".equalsIgnoreCase(exportType)
                && !"WASTE".equalsIgnoreCase(exportType)) {
            return 0.0;
        }

        String sql = "SELECT COALESCE(SUM(e.quantity * COALESCE(ri.unit_price, 0)), 0) " +
                "FROM inventory_export_items e " +
                "JOIN inventory_export_receipts r ON e.export_id = r.id " +
                "LEFT JOIN inventory_receipt_items ri ON e.batch_item_id = ri.id " +
                "WHERE r.status = 'APPROVED' " +
                "AND r.export_type = 'WASTE' " +
                "AND DATE(r.export_date) >= :startDate " +
                "AND DATE(r.export_date) <= :endDate";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0)
        );
    }

    public double getTotalInventoryValue() {
        String sql = "SELECT COALESCE(SUM(available_quantity * unit_price), 0) " +
                "FROM inventory_receipt_items " +
                "WHERE available_quantity > 0";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0)
        );
    }

    public Map<LocalDate, Double> getRevenueByDate(String startDate, String endDate) {
        String sql = "SELECT DATE(created_at) AS day, COALESCE(SUM(final_amount), 0) AS total " +
                "FROM orders " +
                "WHERE status = 'completed' " +
                "AND DATE(created_at) >= :startDate " +
                "AND DATE(created_at) <= :endDate " +
                "GROUP BY DATE(created_at)";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .map((rs, ctx) -> new AbstractMap.SimpleEntry<>(
                    rs.getDate("day").toLocalDate(),
                    rs.getDouble("total")
                ))
                .list()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }

    public Map<LocalDate, Double> getCogsByDate(String startDate, String endDate, String exportType) {
        if (exportType != null && !exportType.isBlank() && !"all".equalsIgnoreCase(exportType)
                && !"SALES".equalsIgnoreCase(exportType)) {
            return Map.of();
        }

        String sql = "SELECT DATE(r.export_date) AS day, COALESCE(SUM(e.quantity * COALESCE(ri.unit_price, 0)), 0) AS total " +
                "FROM inventory_export_items e " +
                "JOIN inventory_export_receipts r ON e.export_id = r.id " +
                "LEFT JOIN inventory_receipt_items ri ON e.batch_item_id = ri.id " +
                "WHERE r.status = 'APPROVED' " +
                "AND r.export_type = 'SALES' " +
                "AND DATE(r.export_date) >= :startDate " +
                "AND DATE(r.export_date) <= :endDate " +
                "GROUP BY DATE(r.export_date)";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .map((rs, ctx) -> new AbstractMap.SimpleEntry<>(
                    rs.getDate("day").toLocalDate(),
                    rs.getDouble("total")
                ))
                .list()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }

    public Map<LocalDate, Double> getWasteCostByDate(String startDate, String endDate, String exportType) {
        if (exportType != null && !exportType.isBlank() && !"all".equalsIgnoreCase(exportType)
                && !"WASTE".equalsIgnoreCase(exportType)) {
            return Map.of();
        }

        String sql = "SELECT DATE(r.export_date) AS day, COALESCE(SUM(e.quantity * COALESCE(ri.unit_price, 0)), 0) AS total " +
                "FROM inventory_export_items e " +
                "JOIN inventory_export_receipts r ON e.export_id = r.id " +
                "LEFT JOIN inventory_receipt_items ri ON e.batch_item_id = ri.id " +
                "WHERE r.status = 'APPROVED' " +
                "AND r.export_type = 'WASTE' " +
                "AND DATE(r.export_date) >= :startDate " +
                "AND DATE(r.export_date) <= :endDate " +
                "GROUP BY DATE(r.export_date)";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .map((rs, ctx) -> new AbstractMap.SimpleEntry<>(
                    rs.getDate("day").toLocalDate(),
                    rs.getDouble("total")
                ))
                .list()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }

    public Map<String, Double> getExportValueByType(String startDate, String endDate) {
        String sql = "SELECT export_type, COALESCE(SUM(total_amount), 0) AS total " +
                "FROM inventory_export_receipts " +
                "WHERE status = 'APPROVED' " +
                "AND DATE(export_date) >= :startDate " +
                "AND DATE(export_date) <= :endDate " +
                "GROUP BY export_type";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .map((rs, ctx) -> new AbstractMap.SimpleEntry<>(
                    rs.getString("export_type"),
                    rs.getDouble("total")
                ))
                .list()
                .stream()
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }

    public List<ReportProduct> getTopProfitProducts(String startDate, String endDate, int limit) {
        return getTopProductProfit(startDate, endDate, limit, true);
    }

    public List<ReportProduct> getTopLossProducts(String startDate, String endDate, int limit) {
        return getTopProductProfit(startDate, endDate, limit, false);
    }

    private List<ReportProduct> getTopProductProfit(String startDate, String endDate, int limit, boolean descending) {
        String sql = "SELECT p.name AS product_name, " +
                "COALESCE(SUM(e.quantity), 0) AS total_qty, " +
                "COALESCE(SUM(e.total_price), 0) AS revenue, " +
                "COALESCE(SUM(e.quantity * COALESCE(ri.unit_price, 0)), 0) AS cogs, " +
                "COALESCE(SUM(e.total_price), 0) - COALESCE(SUM(e.quantity * COALESCE(ri.unit_price, 0)), 0) AS profit " +
                "FROM inventory_export_items e " +
                "JOIN inventory_export_receipts r ON e.export_id = r.id " +
                "LEFT JOIN inventory_receipt_items ri ON e.batch_item_id = ri.id " +
                "LEFT JOIN products p ON e.product_id = p.id " +
                "WHERE r.status = 'APPROVED' " +
                "AND r.export_type = 'SALES' " +
                "AND DATE(r.export_date) >= :startDate " +
                "AND DATE(r.export_date) <= :endDate " +
                "GROUP BY p.id, p.name " +
                "ORDER BY profit " + (descending ? "DESC " : "ASC ") +
                "LIMIT :limit";

        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .bind("limit", limit)
                .map((rs, ctx) -> new ReportProduct(
                    rs.getString("product_name"),
                    rs.getInt("total_qty"),
                    rs.getDouble("revenue"),
                    rs.getDouble("cogs"),
                    rs.getDouble("profit")
                ))
                .list()
        );
    }

    public double getWeekendDealRevenue(String startDate, String endDate) {
        String sql = "SELECT COALESCE(SUM(od.total), 0) " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' " +
                "AND od.deal_type = 'WEEKEND' " +
                "AND DATE(o.created_at) >= :startDate " +
                "AND DATE(o.created_at) <= :endDate";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class).findFirst().orElse(0.0)
        );
    }

    public double getSalePriceRevenue(String startDate, String endDate) {
        String sql = "SELECT COALESCE(SUM(od.total), 0) " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' " +
                "AND od.deal_type = 'SALE' " +
                "AND DATE(o.created_at) >= :startDate " +
                "AND DATE(o.created_at) <= :endDate";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class).findFirst().orElse(0.0)
        );
    }

    public double getTotalDiscountAmount(String startDate, String endDate) {
        String sql = "SELECT COALESCE(SUM(od.discount_amount), 0) " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' " +
                "AND od.deal_type IS NOT NULL AND od.deal_type != '' " +
                "AND DATE(o.created_at) >= :startDate " +
                "AND DATE(o.created_at) <= :endDate";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Double.class).findFirst().orElse(0.0)
        );
    }

    public int getActiveWeekendDeals() {
        String sql = "SELECT COUNT(*) FROM weekend_deals " +
                "WHERE status = 1 AND NOW() BETWEEN start_date AND end_date";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql).mapTo(Integer.class).findFirst().orElse(0)
        );
    }

    public int getActiveSaleProducts() {
        String sql = "SELECT COUNT(*) FROM products " +
                "WHERE sale_price > 0 AND status = 1 " +
                "AND (sale_price_expires_at IS NULL OR sale_price_expires_at > NOW())";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql).mapTo(Integer.class).findFirst().orElse(0)
        );
    }

    public int getTotalCompletedOrders(String startDate, String endDate) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'completed' " +
                "AND DATE(created_at) >= :startDate AND DATE(created_at) <= :endDate";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Integer.class).findFirst().orElse(0)
        );
    }

    public int getPromotionOrders(String startDate, String endDate) {
        String sql = "SELECT COUNT(DISTINCT od.order_id) " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' " +
                "AND od.deal_type IS NOT NULL AND od.deal_type != '' " +
                "AND DATE(o.created_at) >= :startDate " +
                "AND DATE(o.created_at) <= :endDate";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .mapTo(Integer.class).findFirst().orElse(0)
        );
    }

    public Map<java.time.LocalDate, Double> getWeekendDealRevenueByDate(String startDate, String endDate) {
        String sql = "SELECT DATE(o.created_at) AS day, COALESCE(SUM(od.total), 0) AS total " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' AND od.deal_type = 'WEEKEND' " +
                "AND DATE(o.created_at) >= :startDate AND DATE(o.created_at) <= :endDate " +
                "GROUP BY DATE(o.created_at)";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate).bind("endDate", endDate)
                .map((rs, ctx) -> new java.util.AbstractMap.SimpleEntry<>(
                    rs.getDate("day").toLocalDate(), rs.getDouble("total")))
                .list().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }

    public Map<java.time.LocalDate, Double> getSalePriceRevenueByDate(String startDate, String endDate) {
        String sql = "SELECT DATE(o.created_at) AS day, COALESCE(SUM(od.total), 0) AS total " +
                "FROM order_details od " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' AND od.deal_type = 'SALE' " +
                "AND DATE(o.created_at) >= :startDate AND DATE(o.created_at) <= :endDate " +
                "GROUP BY DATE(o.created_at)";
        return DBContext.get().withHandle(handle ->
            handle.createQuery(sql)
                .bind("startDate", startDate).bind("endDate", endDate)
                .map((rs, ctx) -> new java.util.AbstractMap.SimpleEntry<>(
                    rs.getDate("day").toLocalDate(), rs.getDouble("total")))
                .list().stream()
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }
}

