package controller;

import dal.ProductDAO;
import dal.WeekendDealDAO;
import model.CartItem;
import model.Product;
import model.WeekendDeal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/add-to-cart"})
public class AddToCartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String pidRaw = request.getParameter("pid");
        String quantityRaw = request.getParameter("quantity");
        String action = request.getParameter("btAction");

        int quantity = 1;
        try {
            if (quantityRaw != null && !quantityRaw.isEmpty()) {
                quantity = Integer.parseInt(quantityRaw);
                if(quantity < 1) quantity = 1;
            }

            int pid = Integer.parseInt(pidRaw);
            ProductDAO pDao = new ProductDAO();
            WeekendDealDAO dealDAO = new WeekendDealDAO();

            Product product = pDao.getProductByID(pid);

            if (product != null) {
                BigDecimal originalPrice = BigDecimal.valueOf(product.getPrice());
                BigDecimal finalPrice = originalPrice;
                BigDecimal discountAmount = BigDecimal.ZERO;
                String dealType = null;
                Integer dealId = null;
                WeekendDeal weekendDeal = dealDAO.getActiveDealByProductId(pid);
                if (weekendDeal != null && weekendDeal.isActive()) {
                    dealType = "weekend";
                    dealId = weekendDeal.getId();
                    finalPrice = java.math.BigDecimal.valueOf(weekendDeal.getDiscountedPrice());
                    discountAmount = originalPrice.subtract(finalPrice);
                }
                else if (product.getSalePrice() > 0) {
                    dealType = "sale";
                    finalPrice = java.math.BigDecimal.valueOf(product.getSalePrice());
                    discountAmount = originalPrice.subtract(finalPrice);
                }
                HttpSession session = request.getSession();

                if ("buy".equals(action)) {
                    List<CartItem> buyNowCart = new ArrayList<>();
                    CartItem buyNowItem = new CartItem(product, quantity);
                    buyNowItem.setOriginalPrice(originalPrice);
                    buyNowItem.setDiscountAmount(discountAmount);
                    buyNowItem.setFinalPrice(finalPrice);
                    buyNowItem.setDealType(dealType);
                    buyNowItem.setDealId(dealId);
                    buyNowCart.add(buyNowItem);

                    session.setAttribute("buyNowCart", buyNowCart);
                    session.setAttribute("isBuyNow", true);

                    BigDecimal buyNowTotal = buyNowItem.getTotalPrice();
                    session.setAttribute("totalMoney", buyNowTotal.doubleValue());

                    System.out.println("=== Buy Now ===");
                    System.out.println("Product: " + product.getName() + " x " + quantity);
                    System.out.println("Total: " + buyNowTotal);

                    response.sendRedirect("checkout");
                    return;
                }
                session.removeAttribute("isBuyNow");
                session.removeAttribute("buyNowCart");

                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new ArrayList<>(); // Nếu chưa có thì tạo mới
                }

                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == pid) {
                        item.setQuantity(item.getQuantity() + quantity);
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    CartItem newItem = new CartItem(product, quantity);
                    newItem.setOriginalPrice(originalPrice);
                    newItem.setDiscountAmount(discountAmount);
                    newItem.setFinalPrice(finalPrice);
                    newItem.setDealType(dealType);
                    newItem.setDealId(dealId);
                    cart.add(newItem);
                }
                session.setAttribute("cart", cart);

                BigDecimal totalMoney = BigDecimal.ZERO;
                int totalQuantity = 0;
                for (CartItem item : cart) {
                    totalMoney = totalMoney.add(item.getTotalPrice());
                    totalQuantity += item.getQuantity();
                }
                session.setAttribute("totalMoney", totalMoney.doubleValue());
                session.setAttribute("size", cart.size());
                System.out.println("=== AddToCart Debug ===");
                System.out.println("Product ID: " + pid + ", Quantity added: " + quantity);
                System.out.println("Total cart items: " + cart.size());
                System.out.println("Total quantity: " + totalQuantity);
                for (CartItem item : cart) {
                    System.out.println("  - Product #" + item.getProduct().getId() + " x " + item.getQuantity());
                }
                System.out.println("=======================");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        String ajaxHeader = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(ajaxHeader)) {
            HttpSession session = request.getSession();
            Integer cartSize = (Integer) session.getAttribute("size");
            if (cartSize == null) cartSize = 0;

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": true, \"message\": \"Đã thêm vào giỏ hàng\", \"size\": " + cartSize + "}");
            return;
        }

        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("shop");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
