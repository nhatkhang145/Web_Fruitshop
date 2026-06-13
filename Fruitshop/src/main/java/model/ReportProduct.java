package model;

public class ReportProduct {
    private final String productName;
    private final int quantity;
    private final double revenue;
    private final double cogs;
    private final double profit;

    public ReportProduct(String productName, int quantity, double revenue, double cogs, double profit) {
        this.productName = productName;
        this.quantity = quantity;
        this.revenue = revenue;
        this.cogs = cogs;
        this.profit = profit;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getRevenue() {
        return revenue;
    }

    public double getCogs() {
        return cogs;
    }

    public double getProfit() {
        return profit;
    }
}
