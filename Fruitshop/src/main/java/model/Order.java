package model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private Integer couponId;
    private String fullname;
    private String phone;
    private String address;
    private String note;
    private double totalProductsMoney;
    private double shippingFee;
    private double discountAmount;
    private double finalAmount;
    private String paymentMethod;
    private int paymentStatus; // 0: Chưa thanh toán, 1: Đã thanh toán
    private String status; // pending, processing, shipped, completed, cancelled
    private Timestamp createdAt;

    // For display
    private User user;
    private List<OrderItem> orderDetails;

    public Order() {
    }

    public Order(int id, int userId, Integer couponId, String fullname, String phone, String address,
                 String note, double totalProductsMoney, double shippingFee, double discountAmount,
                 double finalAmount, String paymentMethod, int paymentStatus, String status, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.couponId = couponId;
        this.fullname = fullname;
        this.phone = phone;
        this.address = address;
        this.note = note;
        this.totalProductsMoney = totalProductsMoney;
        this.shippingFee = shippingFee;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getCouponId() {
        return couponId;
    }

    public void setCouponId(Integer couponId) {
        this.couponId = couponId;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public double getTotalProductsMoney() {
        return totalProductsMoney;
    }

    public void setTotalProductsMoney(double totalProductsMoney) {
        this.totalProductsMoney = totalProductsMoney;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public int getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(int paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderItem> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderItem> orderDetails) {
        this.orderDetails = orderDetails;
    }


    public String getStatusDisplay() {
        switch (status) {
            case "pending": return "Chờ xác nhận";
            case "processing": return "Đã xác nhận";
            case "shipped": return "Đang giao";
            case "completed": return "Hoàn thành";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }

    public String getPaymentMethodDisplay() {
        switch (paymentMethod) {
            case "COD": return "Thanh toán khi nhận hàng";
            case "bank_transfer": return "Chuyển khoản ngân hàng";
            case "momo": return "Ví MoMo";
            case "zalopay": return "Ví ZaloPay";
            default: return paymentMethod;
        }
    }

    public String getPaymentStatusDisplay() {
        return paymentStatus == 1 ? "Đã thanh toán" : "Chưa thanh toán";
    }
}
