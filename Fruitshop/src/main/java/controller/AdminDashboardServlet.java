package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import dal.AdminReportDAO;
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

        List<?> topProfitProducts = List.of();
        List<?> topLossProducts = List.of();
        if ("all".equalsIgnoreCase(exportType) || "SALES".equalsIgnoreCase(exportType)) {
            topProfitProducts = reportDAO.getTopProfitProducts(startDateStr, endDateStr, 5);
            topLossProducts = reportDAO.getTopLossProducts(startDateStr, endDateStr, 5);
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
        request.setAttribute("profitSeries", profitSeries);

        request.setAttribute("exportTypeLabels", exportTypeLabels);
        request.setAttribute("exportTypeSeries", exportTypeSeries);

        request.setAttribute("topProfitProducts", topProfitProducts);
        request.setAttribute("topLossProducts", topLossProducts);

        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("currentExportType", exportType);

        request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
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

