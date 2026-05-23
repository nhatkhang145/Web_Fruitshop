package dal;

import model.CartItem;
import model.Product;
import model.WeekendDeal;
import org.jdbi.v3.core.Handle;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getCartItemsByUserId(int userId) {
        String query = "SELECT product_id, quantity FROM user_cart_items WHERE user_id = ? ORDER BY product_id";
        try {
            return DBContext.get().withHandle(handle -> loadCartItems(handle, query, userId));
        } catch (Exception e) {
            System.err.println("Error getting cart items: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public void replaceCartItems(int userId, List<CartItem> cart) {
        try {
            DBContext.get().useHandle(handle -> {
                handle.createUpdate("DELETE FROM user_cart_items WHERE user_id = ?")
                        .bind(0, userId)
                        .execute();

                if (cart == null || cart.isEmpty()) {
                    return;
                }

                String insert = "INSERT INTO user_cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
                for (CartItem item : cart) {
                    if (item == null || item.getProduct() == null) {
                        continue;
                    }
                    int finalQty = limitQuantityStock(item.getQuantity(), item.getProduct().getQuantity());
                    if (finalQty <= 0) {
                        continue;
                    }
                    handle.createUpdate(insert)
                            .bind(0, userId)
                            .bind(1, item.getProduct().getId())
                            .bind(2, finalQty)
                            .execute();
                }
            });
        } catch (Exception e) {
            System.err.println("Error replacing cart items: " + e.getMessage());
        }
    }

    private List<CartItem> loadCartItems(Handle handle, String query, int userId) {
        List<CartItem> result = new ArrayList<>();
        ProductDAO productDAO = new ProductDAO();
        WeekendDealDAO dealDAO = new WeekendDealDAO();

        handle.createQuery(query)
                .bind(0, userId)
                .map((rs, ctx) -> {
                    int productId = rs.getInt("product_id");
                    int quantity = rs.getInt("quantity");
                    Product product = productDAO.getProductByID(productId);
                    if (product == null) {
                        return null;
                    }

                    int stockQuantity = product.getQuantity();
                    int finalQty = limitQuantityStock(quantity, stockQuantity);
                    if (finalQty <= 0) {
                        return null;
                    }

                    CartItem item = new CartItem(product, finalQty);
                    BigDecimal originalPrice = BigDecimal.valueOf(product.getPrice());
                    BigDecimal finalPrice = originalPrice;
                    BigDecimal discountAmount = BigDecimal.ZERO;
                    String dealType = null;
                    Integer dealId = null;

                    WeekendDeal weekendDeal = dealDAO.getActiveDealByProductId(productId);
                    if (weekendDeal != null && weekendDeal.isActive()) {
                        dealType = "weekend";
                        dealId = weekendDeal.getId();
                        finalPrice = BigDecimal.valueOf(weekendDeal.getDiscountedPrice());
                        discountAmount = originalPrice.subtract(finalPrice);
                    } else if (product.getSalePrice() > 0) {
                        dealType = "sale";
                        finalPrice = BigDecimal.valueOf(product.getSalePrice());
                        discountAmount = originalPrice.subtract(finalPrice);
                    }

                    item.setOriginalPrice(originalPrice);
                    item.setFinalPrice(finalPrice);
                    item.setDiscountAmount(discountAmount);
                    item.setDealType(dealType);
                    item.setDealId(dealId);

                    return item;
                })
                .list()
                .forEach(item -> {
                    if (item != null) {
                        result.add(item);
                    }
                });

        return result;
    }

    private int limitQuantityStock(int requestedQuantity, int stockQuantity) {
        if (stockQuantity <= 0) {
            return 0;
        }
        if (requestedQuantity < 1) {
            return 1;
        }
        return Math.min(requestedQuantity, stockQuantity);
    }
}
