package controller;

import dal.UserDAO;
import util.PasswordUtils;
import util.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private static final int OTP_EXPIRY_TIME_MS = 5 * 60 * 1000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = getTrimmedParameter(request, "user");
        String email = getTrimmedParameter(request, "email");
        String pass = request.getParameter("pass");
        String rePass = request.getParameter("re_pass");

        if (fullname.isEmpty()) {
            forwardWithError(request, response, "Tên đăng nhập không được để trống!", fullname, email);
            return;
        }

        if (email.isEmpty()) {
            forwardWithError(request, response, "Email không được để trống!", fullname, email);
            return;
        }
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        if (!email.matches(emailRegex)){
            forwardWithError(request, response, "Định dạng Email không hợp lệ (ví dụ: abc@gmail.com)!", fullname, email);
            return;
        }

        String passwordError = PasswordUtils.getPasswordValidationMessage(pass);
        if (passwordError != null) {
            forwardWithError(request, response, passwordError, fullname, email);
            return;
        }

        if (pass == null || !pass.equals(rePass)) {
            forwardWithError(request, response, "Mật khẩu xác nhận không khớp!", fullname, email);
            return;
        }

        UserDAO dao = new UserDAO();
        if (dao.checkExist(email)) {
            forwardWithError(request, response, "Email này đã được sử dụng!", fullname, email);
            return;
        }

        String otp = generateSecureOTP();

        try {
            EmailUtils.sendOTPEmail(email, fullname, otp, "register");
        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "Không thể gửi email xác thực. Vui lòng thử lại!", fullname, email);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("registerOTP", otp);
        session.setAttribute("otpExpiry", System.currentTimeMillis() + OTP_EXPIRY_TIME_MS);
        session.setAttribute("registerFullname", fullname);
        session.setAttribute("registerEmail", email);
        session.setAttribute("registerPassword", PasswordUtils.hashMD5(pass)); // Note: Nên dùng BCrypt thay vì MD5
        session.setAttribute("otpType", "register");
        session.setAttribute("otpEmail", email);

        response.sendRedirect("verify-otp.jsp");
    }

    private String getTrimmedParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return (value != null) ? value.trim() : "";
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response,
                                  String errorMessage, String fullname, String email)
            throws ServletException, IOException {
        request.setAttribute("registerError", errorMessage);
        request.setAttribute("regFullname", fullname);
        request.setAttribute("regEmail", email);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private String generateSecureOTP() {
        SecureRandom random = new SecureRandom();
        int otpValue = 100000 + random.nextInt(900000);
        return String.valueOf(otpValue);
    }

}