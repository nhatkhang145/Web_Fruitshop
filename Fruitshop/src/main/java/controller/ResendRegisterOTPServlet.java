package controller;

import util.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;

@WebServlet(name = "ResendRegisterOTPServlet", urlPatterns = {"/resend-register-otp"})
public class ResendRegisterOTPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("registerEmail");
        String fullname = (String) session.getAttribute("registerFullname");

        if (email == null || fullname == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Phiên đăng ký không hợp lệ hoặc đã hết hạn. Vui lòng đăng ký lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        SecureRandom random = new SecureRandom();
        String newOtp = String.format("%06d", random.nextInt(1000000));

        try {
            EmailUtils.sendOTPEmail(email, fullname, newOtp, "register");

            session.setAttribute("registerOTP", newOtp);
            session.setAttribute("otpExpiry", System.currentTimeMillis() + 5 * 60 * 1000);

            request.setAttribute("success", "Mã OTP mới đã được gửi đến email của bạn!");
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Hệ thống đang bận, không thể gửi lại OTP ngay lúc này. Vui lòng thử lại sau!");
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        }
    }
}