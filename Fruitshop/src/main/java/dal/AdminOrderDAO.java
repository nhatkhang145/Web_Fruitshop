package dal;

import model.Order;
import model.OrderItem;
import model.Product;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminOrderDAO {

    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, fullname, phone, address, note, " +
                "total_products_money, shipping_fee, final_amount, " +
                "payment_method, payment_status, status) " +
                "VALUES (:userId, :fullname, :phone, :address, :note, " +
                ":totalProductsMoney, :shippingFee, :finalAmount, " +
                ":paymentMethod, :paymentStatus, :status)";

        return DBContext.get().withHandle(handle -> {
            int orderId = handle.createUpdate(sql)
                    .bind("userId", order.getUserId())
                    .bind("fullname", order.getFullname())
                    .bind("phone", order.getPhone())
                    .bind("address", order.getAddress())
                    .bind("note", order.getNote())
                    .bind("totalProductsMoney", order.getTotalProductsMoney())
                    .bind("shippingFee", order.getShippingFee())
                    .bind("finalAmount", order.getFinalAmount())
                    .bind("paymentMethod", order.getPaymentMethod())
                    .bind("paymentStatus", order.getPaymentStatus())
                    .bind("status", order.getStatus())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();
            return orderId;
        });
    }


    public void addOrderDetails(int orderId, List<OrderItem> items) {
        String sql = "INSERT INTO order_details (order_id, product_id, product_name, " +
                "deal_type, deal_id, original_price, discount_amount, final_price, quantity, total) " +
                "VALUES (:orderId, :productId, :productName, " +
                ":dealType, :dealId, :originalPrice, :discountAmount, :finalPrice, :quantity, :total)";

        DBContext.get().useHandle(handle -> {
            var batch = handle.prepareBatch(sql);
            for (OrderItem item : items) {
                batch.bind("orderId", orderId)
                        .bind("productId", item.getProductId())
                        .bind("productName", item.getProductName())
                        .bind("dealType", item.getDealType())
                        .bind("dealId", item.getDealId())
                        .bind("originalPrice", item.getOriginalPrice())
                        .bind("discountAmount", item.getDiscountAmount())
                        .bind("finalPrice", item.getFinalPrice())
                        .bind("quantity", item.getQuantity())
                        .bind("total", item.getTotal())
                        .add();
            }
            batch.execute();
        });
    }


    public List<Order> getOrdersByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY created_at DESC";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            Order order = new Order();
                            order.setId(rs.getInt("id"));
                            order.setUserId(rs.getInt("user_id"));
                            order.setFullname(rs.getString("fullname"));
                            order.setPhone(rs.getString("phone"));
                            order.setAddress(rs.getString("address"));
                            order.setNote(rs.getString("note"));
                            order.setTotalProductsMoney(rs.getDouble("total_products_money"));
                            order.setShippingFee(rs.getDouble("shipping_fee"));
                            order.setFinalAmount(rs.getDouble("final_amount"));
                            order.setPaymentMethod(rs.getString("payment_method"));
                            order.setPaymentStatus(rs.getInt("payment_status"));
                            order.setStatus(rs.getString("status"));
                            order.setCreatedAt(rs.getTimestamp("created_at"));
                            return order;
                        })
                        .list()
        );
    }


    public List<Order> getOrdersByStatus(int userId, String status) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId AND status = :status ORDER BY created_at DESC";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("status", status)
                        .map((rs, ctx) -> {
                            Order order = new Order();
                            order.setId(rs.getInt("id"));
                            order.setUserId(rs.getInt("user_id"));
                            order.setFullname(rs.getString("fullname"));
                            order.setPhone(rs.getString("phone"));
                            order.setAddress(rs.getString("address"));
                            order.setNote(rs.getString("note"));
                            order.setTotalProductsMoney(rs.getDouble("total_products_money"));
                            order.setShippingFee(rs.getDouble("shipping_fee"));
                            order.setFinalAmount(rs.getDouble("final_amount"));
                            order.setPaymentMethod(rs.getString("payment_method"));
                            order.setPaymentStatus(rs.getInt("payment_status"));
                            order.setStatus(rs.getString("status"));
                            order.setCreatedAt(rs.getTimestamp("created_at"));
                            return order;
                        })
                        .list()
        );
    }


    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = :orderId";

        return DBContext.get().withHandle(handle -> {
            Order order = handle.createQuery(sql)
                    .bind("orderId", orderId)
                    .map((rs, ctx) -> {
                        Order o = new Order();
                        o.setId(rs.getInt("id"));
                        o.setUserId(rs.getInt("user_id"));
                        o.setFullname(rs.getString("fullname"));
                        o.setPhone(rs.getString("phone"));
                        o.setAddress(rs.getString("address"));
                        o.setNote(rs.getString("note"));
                        o.setTotalProductsMoney(rs.getDouble("total_products_money"));
                        o.setShippingFee(rs.getDouble("shipping_fee"));
                        o.setFinalAmount(rs.getDouble("final_amount"));
                        o.setPaymentMethod(rs.getString("payment_method"));
                        o.setPaymentStatus(rs.getInt("payment_status"));
                        o.setStatus(rs.getString("status"));
                        o.setCreatedAt(rs.getTimestamp("created_at"));
                        return o;
                    })
                    .findFirst()
                    .orElse(null);

            if (order != null) {
                List<OrderItem> items = getOrderDetails(orderId);
                order.setOrderDetails(items);
            }

            return order;
        });
    }


    public List<OrderItem> getOrderDetails(int orderId) {
        String sql = "SELECT od.*, p.image, p.sale_price " +
                "FROM order_details od " +
                "LEFT JOIN products p ON od.product_id = p.id " +
                "WHERE od.order_id = :orderId";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderId", orderId)
                        .map((rs, ctx) -> {
                            OrderItem item = new OrderItem();
                            item.setId(rs.getInt("id"));
                            item.setOrderId(rs.getInt("order_id"));
                            item.setProductId((Integer) rs.getObject("product_id"));
                            item.setProductName(rs.getString("product_name"));
                            item.setPrice(rs.getDouble("final_price"));
                            item.setQuantity(rs.getInt("quantity"));
                            item.setTotal(java.math.BigDecimal.valueOf(rs.getDouble("total")));


                            if (item.getProductId() != null) {
                                Product product = new Product();
                                product.setId(item.getProductId());
                                product.setName(item.getProductName());
                                product.setImage(rs.getString("image"));
                                product.setSalePrice(rs.getDouble("sale_price"));
                                item.setProduct(product);
                            }

                            return item;
                        })
                        .list()
        );
    }


    public boolean cancelOrder(int orderId, int userId) {
        String sql = "UPDATE orders SET status = 'cancelled' " +
                "WHERE id = :orderId AND user_id = :userId AND status IN ('pending', 'processing')";

        return DBContext.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("orderId", orderId)
                        .bind("userId", userId)
                        .execute() > 0
        );
    }


    public int countOrdersByStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId AND status = :status";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("status", status)
                        .mapTo(Integer.class)
                        .one()
        );
    }
    //  lấy tất cả đơn hàng
    public List<Order> getAllOrders() {
        String sql = "SELECT * FROM orders ORDER BY id DESC";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Order.class)
                        .list()
        );
    }



    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = :status WHERE id = :id";
        return DBContext.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("id", orderId)
                        .execute() > 0 // Trả về true nếu có ít nhất 1 dòng bị thay đổi
        );
    }

    // lấy danh sách đơn hàng theo trạng thái
    public List<Order> getOrdersByStatus(String status) {
        String sql = "SELECT * FROM orders WHERE status = :status ORDER BY created_at DESC";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("status", status)
                        .mapToBean(Order.class)
                        .list()
        );
    }

    //  tính tổng doanh thu
    public double getTotalRevenue() {
        String sql = "SELECT SUM(final_amount) FROM orders WHERE status = 'completed'";
        return DBContext.get().withHandle(handle -> {
            Double total = handle.createQuery(sql).mapTo(Double.class).findFirst().orElse(0.0);
            return total != null ? total : 0.0;
        });
    }

    // đếm tổng số đơn hàng
    public int countTotalOrders() {
        return DBContext.get().withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM orders").mapTo(Integer.class).one()
        );
    }

    public List<Double> getRevenueByMonth(int year) {
        List<Double> list = new ArrayList<>();
        // Khởi tạo mảng 12 số 0.0
        for (int i = 0; i < 12; i++) list.add(0.0);

        String sql = "SELECT MONTH(created_at) as month, SUM(final_amount) as total " +
                "FROM orders " +
                "WHERE status = 'completed' AND YEAR(created_at) = :year " +
                "GROUP BY MONTH(created_at)";

        DBContext.get().useHandle(handle -> {
            handle.createQuery(sql)
                    .bind("year", year)
                    .map((rs, ctx) -> {
                        int month = rs.getInt("month"); // Tháng 1-12
                        double total = rs.getDouble("total");
                        // Cập nhật vào list (index = month - 1)
                        if (month >= 1 && month <= 12) {
                            list.set(month - 1, total);
                        }
                        return null;
                    }).list();
        });
        return list;
    }

    // lấy tổng doanh thu theo Danh mục

    public java.util.Map<String, Double> getRevenueByCategory() {
        String sql = "SELECT c.name, SUM(od.total) as revenue " +
                "FROM order_details od " +
                "JOIN products p ON od.product_id = p.id " +
                "JOIN categories c ON p.category_id = c.id " +
                "JOIN orders o ON od.order_id = o.id " +
                "WHERE o.status = 'completed' " +
                "GROUP BY c.name";

        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> new java.util.AbstractMap.SimpleEntry<>(
                                rs.getString("name"),
                                rs.getDouble("revenue")
                        ))
                        .list()
                        .stream()
                        .collect(java.util.stream.Collectors.toMap(
                                java.util.Map.Entry::getKey,
                                java.util.Map.Entry::getValue
                        ))
        );
    }

    // lấy 5 đơn hàng gần nhất
    public List<Order> getTop5RecentOrders() {
        String sql = "SELECT * FROM orders ORDER BY created_at DESC LIMIT 5";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> {
                            Order o = new Order();
                            o.setId(rs.getInt("id"));
                            o.setFullname(rs.getString("fullname"));
                            o.setFinalAmount(rs.getDouble("final_amount"));
                            o.setStatus(rs.getString("status"));
                            o.setCreatedAt(rs.getTimestamp("created_at"));
                            return o;
                        }).list()
        );
    }

    // đếm khách hàng
    public int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 0";
        return DBContext.get().withHandle(handle ->
                handle.createQuery(sql).mapTo(Integer.class).one()
        );
    }

    // lấy doanh thu theo thời gian
    public List<Double> getRevenueByPeriod(String startDate, String endDate) {
        List<Double> revenues = new ArrayList<>();
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);


        long daysBetween = ChronoUnit.DAYS.between(start, end);

        for (int i = 0; i <= daysBetween; i++) {
            LocalDate current = start.plusDays(i);
            String sql = "SELECT SUM(final_amount) FROM orders " +
                    "WHERE status = 'completed' AND DATE(created_at) = :date";

            Double dayTotal = DBContext.get().withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("date", current.toString())
                            .mapTo(Double.class)
                            .findFirst().orElse(0.0));

            revenues.add(dayTotal != null ? dayTotal : 0.0);
        }
        return revenues;
    }

    public List<String> getLabelsByPeriod(String startDate, String endDate) {
        List<String> labels = new ArrayList<>();
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);
        long daysBetween = ChronoUnit.DAYS.between(start, end);

        for (int i = 0; i <= daysBetween; i++) {
            labels.add(start.plusDays(i).format(java.time.format.DateTimeFormatter.ofPattern("dd/MM")));
        }
        return labels;
    }


}
