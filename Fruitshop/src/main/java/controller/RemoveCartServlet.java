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

@WebServlet(name = "RemoveCartServlet", urlPatterns = {"/remove-cart"})
public class RemoveCartServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pidRaw = request.getParameter("pid");

        try {
            int pid = Integer.parseInt(pidRaw);
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                CartItem itemToRemove = null;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == pid) {
                        itemToRemove = item;
                        break;
                    }
                }

                if (itemToRemove != null) {
                    cart.remove(itemToRemove);
                }

                double totalMoney = 0;
                for (CartItem item : cart) {
                    totalMoney += item.getTotalPrice().doubleValue();
                }
                session.setAttribute("totalMoney", totalMoney);
                session.setAttribute("size", cart.size()); // Cập nhật số lượng item trên icon giỏ
            }
        } catch (NumberFormatException e) {
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