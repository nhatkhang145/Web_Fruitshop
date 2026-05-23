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
        String vnp_TxnRef = request.getParameter("vnp_TxnRef"); // Mã đơn hàng (orderId) chúng ta đã gửi đi

        int orderId = 0;
        try {
            orderId = Integer.parseInt(vnp_TxnRef);
        } catch (NumberFormatException e) {
            System.err.println("Mã đơn hàng không hợp lệ từ VNPAY");
        }

        if ("00".equals(vnp_ResponseCode)) {
            // THÀNH CÔNG: Cập nhật DB
            // Đổi status -> 'processing' (Đang xử lý) và payment_status -> 1 (Đã thanh toán)
            orderDAO.updateStatus(orderId, "processing");
            orderDAO.updatePaymentStatus(orderId, 1);

            // Thiết lập thông báo thành công cho giao diện
            request.getSession().setAttribute("successMessage", "Thanh toán thành công qua ví VNPAY! Mã đơn hàng: #" + orderId);

        } else {
            // THẤT BẠI: Người dùng hủy thanh toán hoặc lỗi thẻ
            // Đổi status -> 'cancelled' (Đã hủy)
            orderDAO.updateStatus(orderId, "cancelled");

            // Thiết lập thông báo lỗi cho giao diện
            request.getSession().setAttribute("error", "Giao dịch thanh toán thất bại hoặc đã bị hủy.");
        }

        // Chuyển hướng về trang chi tiết đơn hàng (giống cách CheckoutServlet đang làm)
        response.sendRedirect(request.getContextPath() + "/order-detail?id=" + orderId);
    }
}
