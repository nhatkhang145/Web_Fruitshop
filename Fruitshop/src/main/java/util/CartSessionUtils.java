package util;

import jakarta.servlet.http.HttpSession;
import model.CartItem;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class CartSessionUtils {

    public static List<CartItem> mergeCarts(List<CartItem> base, List<CartItem> extra) {
        Map<Integer, CartItem> merged = new LinkedHashMap<>();
        addItems(merged, base);
        addItems(merged, extra);
        return new ArrayList<>(merged.values());
    }

    public static void updateSessionCart(HttpSession session, List<CartItem> cart) {
        if (cart == null || cart.isEmpty()) {
            session.removeAttribute("cart");
            session.removeAttribute("size");
            session.removeAttribute("totalMoney");
            return;
        }

        BigDecimal totalMoney = BigDecimal.ZERO;
        for (CartItem item : cart) {
            totalMoney = totalMoney.add(item.getTotalPrice());
        }

        session.setAttribute("cart", cart);
        session.setAttribute("size", cart.size());
        session.setAttribute("totalMoney", totalMoney.doubleValue());
    }

    private static void addItems(Map<Integer, CartItem> merged, List<CartItem> items) {
        if (items == null) {
            return;
        }
        for (CartItem item : items) {
            if (item == null || item.getProduct() == null) {
                continue;
            }
            int productId = item.getProduct().getId();
            CartItem existing = merged.get(productId);
            if (existing == null) {
                merged.put(productId, item);
            } else {
                int newQty = existing.getQuantity() + item.getQuantity();
                int stock = existing.getProduct().getQuantity();
                existing.setQuantity(limitQuantityStock(newQty, stock));
            }
        }
    }

    private static int limitQuantityStock(int requestedQuantity, int stockQuantity) {
        if (stockQuantity <= 0) {
            return 0;
        }
        if (requestedQuantity < 1) {
            return 1;
        }
        return Math.min(requestedQuantity, stockQuantity);
    }
}
