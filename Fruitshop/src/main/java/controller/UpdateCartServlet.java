package controller;

import dal.CartDAO;
import model.CartItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UpdateCartServlet", urlPatterns = {"/update-cart"})
public class UpdateCartServlet extends HttpServlet {

    private int limitQuantityStock(int quantity, int stockQuantity) {
        if (stockQuantity <= 0) {
            return 0;
        }
        if (quantity < 1) {
            return 1;
        }
        return Math.min(quantity, stockQuantity);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pidRaw = request.getParameter("pid");
        String mode = request.getParameter("mode");

        try {
            int pid = Integer.parseInt(pidRaw);
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == pid) {
                        int currentQty = item.getQuantity();
                        int stockQty = item.getProduct().getQuantity();

                        if ("plus".equals(mode)) {
                            item.setQuantity(limitQuantityStock(currentQty + 1, stockQty));
                        } else if ("minus".equals(mode)) {
                            if (currentQty > 1) {
                                item.setQuantity(limitQuantityStock(currentQty - 1, stockQty));
                            }
                        }
                        item.setQuantity(limitQuantityStock(item.getQuantity(), stockQty));
                        break;
                    }
                }

                double totalMoney = 0;
                for (CartItem item : cart) {
                    totalMoney += item.getTotalPrice().doubleValue();
                }
                session.setAttribute("totalMoney", totalMoney);
                session.setAttribute("size", cart.size());

                User user = (User) session.getAttribute("account");
                if (user != null) {
                    CartDAO cartDAO = new CartDAO();
                    cartDAO.replaceCartItems(user.getId(), cart);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("cart.jsp");
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
