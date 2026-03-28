package controller;

import dal.AdminOrderDAO;
import model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderServlet extends HttpServlet {

    private AdminOrderDAO orderDAO = new AdminOrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String status = req.getParameter("status");
        List<Order> list;


        if (status != null && !status.isEmpty() && !status.equals("all")) {
            list = orderDAO.getOrdersByStatus(status);
        } else {
            list = orderDAO.getAllOrders();
        }

        req.setAttribute("orders", list);
        req.setAttribute("currentStatus", status);
        req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
    }
}
