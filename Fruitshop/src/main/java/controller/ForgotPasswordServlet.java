package controller;

import dal.UserDAO;
import model.User;
import util.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.Optional;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");

        Optional<User> userOptional = userDAO.getUserByEmail(email);

        if (userOptional.isPresent()) {
            User user = userOptional.get();

            java.security.SecureRandom random = new java.security.SecureRandom();
            String otp = String.format("%06d", random.nextInt(1000000));

            String fullname = (user.getFullName() != null) ? user.getFullName() : "Khách hàng";

            try {
                EmailUtils.sendOTPEmail(email, fullname, otp, "forgot-password");

                HttpSession session = request.getSession();
                session.setAttribute("otp", otp);
                session.setAttribute("otpExpiry", System.currentTimeMillis() + 5 * 60 * 1000);
                session.setAttribute("otpEmail", email);
                session.setAttribute("otpType", "forgot-password");
                session.setMaxInactiveInterval(300);

                response.sendRedirect("verify-otp.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Hệ thống gặp sự cố khi gửi mail. Vui lòng thử lại sau!");
                request.getRequestDispatcher("forget_pass.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Email này không tồn tại trong hệ thống.");
            request.getRequestDispatcher("forget_pass.jsp").forward(request, response);
        }
    }
}