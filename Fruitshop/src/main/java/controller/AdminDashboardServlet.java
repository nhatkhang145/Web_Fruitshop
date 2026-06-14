package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import java.io.OutputStream;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import dal.AdminReportDAO;
import model.ReportProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String exportType = request.getParameter("exportType");

        LocalDate endDate = parseDateOrDefault(endDateParam, LocalDate.now());
        LocalDate startDate = parseDateOrDefault(startDateParam, endDate.minusDays(6));
        if (startDate.isAfter(endDate)) {
            LocalDate temp = startDate;
            startDate = endDate;
            endDate = temp;
        }

        if (exportType == null || exportType.isBlank()) {
            exportType = "all";
        }

        String startDateStr = startDate.toString();
        String endDateStr = endDate.toString();

        AdminReportDAO reportDAO = new AdminReportDAO();

        double totalImportValue = reportDAO.getTotalImportValue(startDateStr, endDateStr);
        double totalExportValue = reportDAO.getTotalExportValue(startDateStr, endDateStr, exportType);
        double totalRevenue = reportDAO.getTotalRevenue(startDateStr, endDateStr);
        double totalCogs = reportDAO.getTotalCogs(startDateStr, endDateStr, exportType);
        double totalWasteCost = reportDAO.getTotalWasteCost(startDateStr, endDateStr, exportType);
        double totalProfit = totalRevenue - totalCogs - totalWasteCost;
        double totalInventoryValue = reportDAO.getTotalInventoryValue();

        Map<LocalDate, Double> revenueByDate = reportDAO.getRevenueByDate(startDateStr, endDateStr);
        Map<LocalDate, Double> cogsByDate = reportDAO.getCogsByDate(startDateStr, endDateStr, exportType);
        Map<LocalDate, Double> wasteByDate = reportDAO.getWasteCostByDate(startDateStr, endDateStr, exportType);

        List<LocalDate> dateRange = buildDateRange(startDate, endDate);
        DateTimeFormatter labelFormatter = DateTimeFormatter.ofPattern("dd/MM");
        List<String> reportLabels = new ArrayList<>();
        List<Double> revenueSeries = new ArrayList<>();
        List<Double> cogsSeries = new ArrayList<>();
        List<Double> profitSeries = new ArrayList<>();

        for (LocalDate date : dateRange) {
            reportLabels.add(date.format(labelFormatter));
            double revenue = revenueByDate.getOrDefault(date, 0.0);
            double cogs = cogsByDate.getOrDefault(date, 0.0);
            double waste = wasteByDate.getOrDefault(date, 0.0);
            revenueSeries.add(revenue);
            cogsSeries.add(cogs);
            profitSeries.add(revenue - cogs - waste);
        }

        Map<String, Double> exportValueByType = reportDAO.getExportValueByType(startDateStr, endDateStr);
        List<String> exportTypeLabels = List.of("SALES", "WASTE");
        List<Double> exportTypeSeries = new ArrayList<>();
        for (String label : exportTypeLabels) {
            exportTypeSeries.add(exportValueByType.getOrDefault(label, 0.0));
        }

        List<ReportProduct> topProfitProducts = List.of();
        List<ReportProduct> topLossProducts = List.of();
        if ("all".equalsIgnoreCase(exportType) || "SALES".equalsIgnoreCase(exportType)) {
            topProfitProducts = reportDAO.getTopProfitProducts(startDateStr, endDateStr, 5);
            topLossProducts = reportDAO.getTopLossProducts(startDateStr, endDateStr, 5);
        }

        double weekendDealRevenue = reportDAO.getWeekendDealRevenue(startDateStr, endDateStr);
        double salePriceRevenue   = reportDAO.getSalePriceRevenue(startDateStr, endDateStr);
        double totalDiscountAmt   = reportDAO.getTotalDiscountAmount(startDateStr, endDateStr);
        int activeWeekendDeals    = reportDAO.getActiveWeekendDeals();
        int activeSaleProducts    = reportDAO.getActiveSaleProducts();
        int totalOrders           = reportDAO.getTotalCompletedOrders(startDateStr, endDateStr);
        int promotionOrders       = reportDAO.getPromotionOrders(startDateStr, endDateStr);
        double promoRevenue       = weekendDealRevenue + salePriceRevenue;

        double pctRevenue  = (totalRevenue > 0) ? promoRevenue / totalRevenue * 100 : 0;
        double pctProfit   = (totalRevenue > 0) ? (totalRevenue - totalDiscountAmt) / totalRevenue * 100 : 0;
        double pctOrders   = (totalOrders  > 0) ? (double) promotionOrders / totalOrders * 100 : 0;

        Map<java.time.LocalDate, Double> wdByDate   = reportDAO.getWeekendDealRevenueByDate(startDateStr, endDateStr);
        Map<java.time.LocalDate, Double> saleByDate = reportDAO.getSalePriceRevenueByDate(startDateStr, endDateStr);

        List<Double> wdSeries   = new ArrayList<>();
        List<Double> saleSeries = new ArrayList<>();
        for (java.time.LocalDate date : dateRange) {
            wdSeries.add(wdByDate.getOrDefault(date, 0.0));
            saleSeries.add(saleByDate.getOrDefault(date, 0.0));
        }

        request.setAttribute("totalImportValue", totalImportValue);
        request.setAttribute("totalExportValue", totalExportValue);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalCogs", totalCogs);
        request.setAttribute("totalWasteCost", totalWasteCost);
        request.setAttribute("totalProfit", totalProfit);
        request.setAttribute("totalInventoryValue", totalInventoryValue);

        request.setAttribute("reportLabels", reportLabels);
        request.setAttribute("revenueSeries", revenueSeries);
        request.setAttribute("cogsSeries", cogsSeries);
        String action = request.getParameter("action");
        if ("export".equals(action)) {
            exportToExcel(response, startDateStr, endDateStr, totalImportValue, totalRevenue, totalCogs, totalWasteCost, totalProfit, totalInventoryValue, topProfitProducts, topLossProducts);
            return;
        }

        request.setAttribute("profitSeries", profitSeries);

        request.setAttribute("exportTypeLabels", exportTypeLabels);
        request.setAttribute("exportTypeSeries", exportTypeSeries);

        request.setAttribute("topProfitProducts", topProfitProducts);
        request.setAttribute("topLossProducts", topLossProducts);

        request.setAttribute("weekendDealRevenue",  weekendDealRevenue);
        request.setAttribute("salePriceRevenue",    salePriceRevenue);
        request.setAttribute("totalDiscountAmount", totalDiscountAmt);
        request.setAttribute("activeWeekendDeals",  activeWeekendDeals);
        request.setAttribute("activeSaleProducts",  activeSaleProducts);
        request.setAttribute("totalCompletedOrders",totalOrders);
        request.setAttribute("promotionOrders",     promotionOrders);
        request.setAttribute("pctPromoRevenue",     String.format("%.1f", pctRevenue));
        request.setAttribute("pctPromoProfit",      String.format("%.1f", pctProfit));
        request.setAttribute("pctPromoOrders",      String.format("%.1f", pctOrders));
        request.setAttribute("wdSeries",            wdSeries);
        request.setAttribute("saleSeries",          saleSeries);

        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("currentExportType", exportType);

        request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
    }

    private void exportToExcel(HttpServletResponse response, String startDate, String endDate, 
                               double totalImportValue, double totalRevenue, double totalCogs, 
                               double totalWasteCost, double totalProfit, double totalInventoryValue,
                               List<ReportProduct> topProfitProducts, List<ReportProduct> topLossProducts) throws IOException {
        
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Bao Cao Thong Ke");

            // Header Style
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);

            // Tieu de
            Row titleRow = sheet.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("BÁO CÁO THỐNG KÊ KINH DOANH");
            titleCell.setCellStyle(headerStyle);

            Row dateRow = sheet.createRow(1);
            dateRow.createCell(0).setCellValue("Từ ngày: " + startDate + "  Đến ngày: " + endDate);

            // KPI
            Row kpiHeaderRow = sheet.createRow(3);
            kpiHeaderRow.createCell(0).setCellValue("Chỉ số KPI");
            kpiHeaderRow.createCell(1).setCellValue("Giá trị (VND)");
            kpiHeaderRow.getCell(0).setCellStyle(headerStyle);
            kpiHeaderRow.getCell(1).setCellStyle(headerStyle);

            int r = 4;
            sheet.createRow(r).createCell(0).setCellValue("Tổng Nhập Kho");
            sheet.getRow(r++).createCell(1).setCellValue(totalImportValue);
            
            sheet.createRow(r).createCell(0).setCellValue("Doanh Thu");
            sheet.getRow(r++).createCell(1).setCellValue(totalRevenue);

            sheet.createRow(r).createCell(0).setCellValue("Giá Vốn Bán Hàng (COGS)");
            sheet.getRow(r++).createCell(1).setCellValue(totalCogs);

            sheet.createRow(r).createCell(0).setCellValue("Hư Hỏng (Waste)");
            sheet.getRow(r++).createCell(1).setCellValue(totalWasteCost);

            sheet.createRow(r).createCell(0).setCellValue("Lợi Nhuận Gộp");
            sheet.getRow(r++).createCell(1).setCellValue(totalProfit);

            sheet.createRow(r).createCell(0).setCellValue("Tồn Kho Hiện Tại");
            sheet.getRow(r++).createCell(1).setCellValue(totalInventoryValue);

            // Top san pham loi nhuan cao
            r += 2;
            Row topProRow = sheet.createRow(r++);
            topProRow.createCell(0).setCellValue("TOP SẢN PHẨM LỢI NHUẬN CAO");
            topProRow.getCell(0).setCellStyle(headerStyle);

            Row th1 = sheet.createRow(r++);
            th1.createCell(0).setCellValue("Tên SP");
            th1.createCell(1).setCellValue("Số Lượng");
            th1.createCell(2).setCellValue("Doanh Thu");
            th1.createCell(3).setCellValue("COGS");
            th1.createCell(4).setCellValue("Lợi Nhuận");
            for(int i=0; i<=4; i++) th1.getCell(i).setCellStyle(headerStyle);

            for (ReportProduct p : topProfitProducts) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(p.getProductName());
                row.createCell(1).setCellValue(p.getQuantity());
                row.createCell(2).setCellValue(p.getRevenue());
                row.createCell(3).setCellValue(p.getCogs());
                row.createCell(4).setCellValue(p.getProfit());
            }

            // Top san pham loi nhuan thap
            r += 2;
            Row topLossRow = sheet.createRow(r++);
            topLossRow.createCell(0).setCellValue("TOP SẢN PHẨM LỢI NHUẬN THẤP");
            topLossRow.getCell(0).setCellStyle(headerStyle);

            Row th2 = sheet.createRow(r++);
            th2.createCell(0).setCellValue("Tên SP");
            th2.createCell(1).setCellValue("Số Lượng");
            th2.createCell(2).setCellValue("Doanh Thu");
            th2.createCell(3).setCellValue("COGS");
            th2.createCell(4).setCellValue("Lợi Nhuận");
            for(int i=0; i<=4; i++) th2.getCell(i).setCellStyle(headerStyle);

            for (ReportProduct p : topLossProducts) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(p.getProductName());
                row.createCell(1).setCellValue(p.getQuantity());
                row.createCell(2).setCellValue(p.getRevenue());
                row.createCell(3).setCellValue(p.getCogs());
                row.createCell(4).setCellValue(p.getProfit());
            }

            sheet.autoSizeColumn(0);
            sheet.autoSizeColumn(1);
            sheet.autoSizeColumn(2);
            sheet.autoSizeColumn(3);
            sheet.autoSizeColumn(4);

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"Bao_Cao_Thong_Ke.xlsx\"");
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
        }
    }

    private LocalDate parseDateOrDefault(String rawValue, LocalDate defaultValue) {
        if (rawValue == null || rawValue.isBlank()) {
            return defaultValue;
        }
        try {
            return LocalDate.parse(rawValue);
        } catch (Exception ex) {
            return defaultValue;
        }
    }

    private List<LocalDate> buildDateRange(LocalDate start, LocalDate end) {
        List<LocalDate> dates = new ArrayList<>();
        LocalDate current = start;
        while (!current.isAfter(end)) {
            dates.add(current);
            current = current.plusDays(1);
        }
        return dates;
    }
}

