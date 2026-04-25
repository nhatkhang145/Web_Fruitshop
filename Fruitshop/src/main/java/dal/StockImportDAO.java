package dal;

import model.StockImport;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class StockImportDAO {

    private static final List<String> IMPORT_TABLE_CANDIDATES = Arrays.asList(
            "stock_imports",
            "stock_import_receipts",
            "import_receipts"
    );

    private static final List<String> IMPORT_DETAIL_TABLE_CANDIDATES = Arrays.asList(
            "stock_import_details",
            "stock_import_receipt_details",
            "import_receipt_details"
    );

    public String timBangNhapKho() {
        for (String table : IMPORT_TABLE_CANDIDATES) {
            if (tableExists(table)) {
                return table;
            }
        }
        return null;
    }

    public String resolveImportTableName() {
        return timBangNhapKho();
    }

    public List<StockImport> layDanhSachPhieuNhap(String keyword, String supplier, String sort, Date fromDate, Date toDate) {
        String importTable = timBangNhapKho();
        if (importTable == null) {
            return Collections.emptyList();
        }

        Set<String> importColumns = getColumns(importTable);
        String detailsTable = resolveDetailTableName();
        Set<String> detailColumns = detailsTable == null ? Collections.emptySet() : getColumns(detailsTable);
        boolean usersTableExists = tableExists("users");
        boolean suppliersTableExists = tableExists("suppliers");

        String importCodeExpr = getImportCodeExpr(importColumns);
        String createdAtExpr = getCreatedAtExpr(importColumns);
        String supplierExpr = getSupplierExpr(importColumns, suppliersTableExists);
        String totalQuantityExpr = getTotalQuantityExpr(importColumns, detailsTable, detailColumns);
        String totalAmountExpr = getTotalAmountExpr(importColumns, detailsTable, detailColumns);
        String createdByExpr = getCreatedByExpr(importColumns, usersTableExists);
        String statusExpr = getStatusExpr(importColumns);

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT si.id, ")
                .append(importCodeExpr).append(" AS importCode, ")
                .append(createdAtExpr).append(" AS createdAt, ")
                .append(supplierExpr).append(" AS supplierName, ")
                .append(totalQuantityExpr).append(" AS totalQuantity, ")
                .append(totalAmountExpr).append(" AS totalAmount, ")
                .append(createdByExpr).append(" AS createdBy, ")
                .append(statusExpr).append(" AS status ")
                .append("FROM ").append(importTable).append(" si ");

        if (usersTableExists && importColumns.contains("created_by")) {
            sql.append("LEFT JOIN users u ON si.created_by = u.id ");
        }
        if (suppliersTableExists && importColumns.contains("supplier_id")) {
            sql.append("LEFT JOIN suppliers s ON si.supplier_id = s.id ");
        }

        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND ").append(importCodeExpr).append(" LIKE :keyword ");
        }

        if (supplier != null && !supplier.trim().isEmpty()) {
            sql.append("AND ").append(supplierExpr).append(" LIKE :supplier ");
        }

        if (fromDate != null) {
            sql.append("AND DATE(").append(createdAtExpr).append(") >= :fromDate ");
        }

        if (toDate != null) {
            sql.append("AND DATE(").append(createdAtExpr).append(") <= :toDate ");
        }

        if ("oldest".equalsIgnoreCase(sort)) {
            sql.append("ORDER BY ").append(createdAtExpr).append(" ASC ");
        } else {
            sql.append("ORDER BY ").append(createdAtExpr).append(" DESC ");
        }

        return DBContext.get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }

            if (supplier != null && !supplier.trim().isEmpty()) {
                query.bind("supplier", "%" + supplier.trim() + "%");
            }

            if (fromDate != null) {
                query.bind("fromDate", fromDate);
            }

            if (toDate != null) {
                query.bind("toDate", toDate);
            }

            return query.map((rs, ctx) -> {
                StockImport item = new StockImport();
                item.setId(rs.getInt("id"));
                item.setImportCode(rs.getString("importCode"));
                item.setCreatedAt(rs.getTimestamp("createdAt"));
                item.setSupplierName(rs.getString("supplierName"));
                item.setTotalQuantity(rs.getInt("totalQuantity"));
                item.setTotalAmount(rs.getDouble("totalAmount"));
                item.setCreatedBy(rs.getString("createdBy"));
                item.setStatus(rs.getString("status"));
                return item;
            }).list();
        });
    }

    public List<StockImport> getStockImports(String keyword, String supplier, String sort, Date fromDate, Date toDate) {
        return layDanhSachPhieuNhap(keyword, supplier, sort, fromDate, toDate);
    }

    public List<String> layDanhSachNhaCungCap() {
        String importTable = timBangNhapKho();
        if (importTable == null) {
            return Collections.emptyList();
        }

        Set<String> importColumns = getColumns(importTable);
        LinkedHashSet<String> names = new LinkedHashSet<>();

        if (tableExists("suppliers") && importColumns.contains("supplier_id")) {
            String sql = "SELECT DISTINCT s.name FROM " + importTable + " si " +
                    "LEFT JOIN suppliers s ON si.supplier_id = s.id " +
                    "WHERE s.name IS NOT NULL AND s.name <> '' ORDER BY s.name";

            List<String> result = DBContext.get().withHandle(handle ->
                    handle.createQuery(sql).mapTo(String.class).list());
            names.addAll(result);
        }

        if (importColumns.contains("supplier_name")) {
            String sql = "SELECT DISTINCT supplier_name FROM " + importTable +
                    " WHERE supplier_name IS NOT NULL AND supplier_name <> '' ORDER BY supplier_name";
            List<String> result = DBContext.get().withHandle(handle ->
                    handle.createQuery(sql).mapTo(String.class).list());
            names.addAll(result);
        }

        return new ArrayList<>(names);
    }

    public List<String> getSupplierNames() {
        return layDanhSachNhaCungCap();
    }

    private String resolveDetailTableName() {
        for (String table : IMPORT_DETAIL_TABLE_CANDIDATES) {
            if (tableExists(table)) {
                return table;
            }
        }
        return null;
    }

    private String getImportCodeExpr(Set<String> cols) {
        if (cols.contains("import_code")) {
            return "si.import_code";
        }
        if (cols.contains("code")) {
            return "si.code";
        }
        return "CONCAT('PNK-', si.id)";
    }

    private String getCreatedAtExpr(Set<String> cols) {
        if (cols.contains("created_at")) {
            return "si.created_at";
        }
        if (cols.contains("import_date")) {
            return "si.import_date";
        }
        if (cols.contains("date_created")) {
            return "si.date_created";
        }
        return "NOW()";
    }

    private String getSupplierExpr(Set<String> cols, boolean suppliersTableExists) {
        if (cols.contains("supplier_name")) {
            return "si.supplier_name";
        }
        if (cols.contains("supplier_id") && suppliersTableExists) {
            return "COALESCE(s.name, CONCAT('NCC-', si.supplier_id))";
        }
        return "'-'";
    }

    private String getCreatedByExpr(Set<String> cols, boolean usersTableExists) {
        if (cols.contains("created_by_name")) {
            return "si.created_by_name";
        }
        if (cols.contains("created_by") && usersTableExists) {
            return "COALESCE(u.fullname, CONCAT('user-', si.created_by))";
        }
        return "'-'";
    }

    private String getStatusExpr(Set<String> cols) {
        if (cols.contains("status")) {
            return "si.status";
        }
        return "'draft'";
    }

    private String getTotalQuantityExpr(Set<String> importCols, String detailTable, Set<String> detailCols) {
        if (importCols.contains("total_quantity")) {
            return "si.total_quantity";
        }
        if (detailTable != null) {
            String qtyCol = detailCols.contains("quantity") ? "quantity" : null;
            String fkCol = resolveDetailForeignKey(detailCols);
            if (qtyCol != null && fkCol != null) {
                return "(SELECT COALESCE(SUM(d." + qtyCol + "), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
            }
        }
        return "0";
    }

    private String getTotalAmountExpr(Set<String> importCols, String detailTable, Set<String> detailCols) {
        if (importCols.contains("total_amount")) {
            return "si.total_amount";
        }
        if (detailTable != null) {
            String fkCol = resolveDetailForeignKey(detailCols);
            if (fkCol != null) {
                if (detailCols.contains("line_total")) {
                    return "(SELECT COALESCE(SUM(d.line_total), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
                }
                if (detailCols.contains("total")) {
                    return "(SELECT COALESCE(SUM(d.total), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
                }
                if (detailCols.contains("amount")) {
                    return "(SELECT COALESCE(SUM(d.amount), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
                }
                if (detailCols.contains("quantity") && detailCols.contains("import_price")) {
                    return "(SELECT COALESCE(SUM(d.quantity * d.import_price), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
                }
                if (detailCols.contains("quantity") && detailCols.contains("unit_price")) {
                    return "(SELECT COALESCE(SUM(d.quantity * d.unit_price), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
                }
                if (detailCols.contains("quantity") && detailCols.contains("price")) {
                    return "(SELECT COALESCE(SUM(d.quantity * d.price), 0) FROM " + detailTable + " d WHERE d." + fkCol + " = si.id)";
                }
            }
        }
        return "0";
    }

    private String resolveDetailForeignKey(Set<String> detailCols) {
        if (detailCols.contains("import_id")) {
            return "import_id";
        }
        if (detailCols.contains("receipt_id")) {
            return "receipt_id";
        }
        if (detailCols.contains("import_receipt_id")) {
            return "import_receipt_id";
        }
        if (detailCols.contains("stock_import_id")) {
            return "stock_import_id";
        }
        return null;
    }

    private boolean tableExists(String tableName) {
        String sql = "SELECT COUNT(*) FROM information_schema.tables " +
                "WHERE table_schema = DATABASE() AND table_name = :tableName";

        Integer count = DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("tableName", tableName)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0));

        return count != null && count > 0;
    }

    private Set<String> getColumns(String tableName) {
        String sql = "SELECT column_name FROM information_schema.columns " +
                "WHERE table_schema = DATABASE() AND table_name = :tableName";

        List<String> columns = DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("tableName", tableName)
                        .mapTo(String.class)
                        .list());

        Set<String> result = new HashSet<>();
        for (String col : columns) {
            if (col != null) {
                result.add(col.toLowerCase());
            }
        }
        return result;
    }
}
