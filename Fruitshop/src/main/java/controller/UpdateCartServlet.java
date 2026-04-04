package controller;

import model.CartItem;
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

                        if ("plus".equals(mode)) {
                            item.setQuantity(currentQty + 1);
                        } else if ("minus".equals(mode)) {
                            if (currentQty > 1) {
                                item.setQuantity(currentQty - 1);
                            } else {
                            }
                        }
                        break;
                    }
                }

                double totalMoney = 0;
                for (CartItem item : cart) {
                    totalMoney += item.getTotalPrice().doubleValue();
                }
                session.setAttribute("totalMoney", totalMoney);
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
