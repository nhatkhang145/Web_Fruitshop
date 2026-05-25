package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyRegisterOTPServlet", urlPatterns = {"/verify-register-otp"})
public class VerifyRegisterOTPServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String inputOTP = request.getParameter("otp");

        String sessionOTP = (String) session.getAttribute("registerOTP");
        Long otpExpiry = (Long) session.getAttribute("otpExpiry");
        String fullname = (String) session.getAttribute("registerFullname");
        String email = (String) session.getAttribute("registerEmail");
        String hashedPassword = (String) session.getAttribute("registerPassword");

        if (sessionOTP == null || otpExpiry == null || fullname == null || email == null || hashedPassword == null) {
            request.setAttribute("error", "Phiên đăng ký không hợp lệ hoặc đã hết hạn. Vui lòng đăng ký lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (inputOTP == null || inputOTP.trim().isEmpty()) {
            forwardWithError(request, response, "Vui lòng nhập mã OTP!");
            return;
        }

        if (System.currentTimeMillis() > otpExpiry) {
            forwardWithError(request, response, "Mã OTP đã hết hạn! Vui lòng yêu cầu gửi lại.");
            return;
        }

        if (!sessionOTP.equals(inputOTP.trim())) {
            forwardWithError(request, response, "Mã OTP không chính xác! Vui lòng thử lại.");
            return;
        }

        try {
            boolean isCreated = userDAO.signup(fullname, email, hashedPassword);

            if (isCreated) {
                clearRegisterSession(session);

                session.setAttribute("registerSuccess", "Đăng ký thành công! Vui lòng đăng nhập.");
                response.sendRedirect("login.jsp");
            } else {
                forwardWithError(request, response, "Lỗi tạo tài khoản (Email có thể đã tồn tại). Vui lòng thử lại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "Hệ thống đang bận! Vui lòng thử lại sau.");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
    }

    private void clearRegisterSession(HttpSession session) {
        session.removeAttribute("registerOTP");
        session.removeAttribute("otpExpiry");
        session.removeAttribute("registerFullname");
        session.removeAttribute("registerEmail");
        session.removeAttribute("registerPassword");
        session.removeAttribute("otpType");
        session.removeAttribute("otpEmail");
    }
}