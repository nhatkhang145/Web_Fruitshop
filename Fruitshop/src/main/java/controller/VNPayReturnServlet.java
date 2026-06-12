package controller;

import dal.CartDAO;
import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebServlet(name = "VNPayReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPayReturnServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy các tham số từ VNPAY trả về
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");

        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
        int orderId = 0;
        try {
            String[] parts = vnp_OrderInfo.split(" ");
            orderId = Integer.parseInt(parts[4]);
        } catch (NumberFormatException e) {
            System.err.println("Mã đơn hàng không hợp lệ từ VNPAY");
        }

        if ("00".equals(vnp_ResponseCode)) {
            orderDAO.updateStatus(orderId, "processing");
            orderDAO.updatePaymentStatus(orderId, 1);

            request.getSession().setAttribute("successMessage", "Thanh toán thành công qua ví VNPAY! Mã đơn hàng: #" + orderId);

        } else {
            orderDAO.updateStatus(orderId, "cancelled");
            request.getSession().setAttribute("error", "Giao dịch thanh toán thất bại hoặc đã bị hủy.");
        }

        response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
    }
}
