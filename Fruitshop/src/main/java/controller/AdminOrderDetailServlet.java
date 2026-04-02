package controller;

import dal.AdminOrderDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminOrderDetailServlet", urlPatterns = {"/admin/order-detail", "/admin/order-update-status"})
public class AdminOrderDetailServlet extends HttpServlet {

    private AdminOrderDAO orderDAO = new AdminOrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int orderId = Integer.parseInt(idStr);
                Order order = orderDAO.getOrderById(orderId);
                req.setAttribute("order", order);
                req.getRequestDispatcher("/admin/order-detail.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String orderIdStr = req.getParameter("orderId");
            String status = req.getParameter("status");

            if (orderIdStr != null && status != null) {
                int orderId = Integer.parseInt(orderIdStr);
                boolean success = orderDAO.updateStatus(orderId, status);

                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/order-detail?id=" + orderId + "&msg=success");

                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/order-detail?id=" + orderId + "&msg=error");

                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }
}
