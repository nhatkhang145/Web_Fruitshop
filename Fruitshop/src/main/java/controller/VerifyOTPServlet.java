package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "VerifyOTPServlet", urlPatterns = {"/verifyOTP"})
public class VerifyOTPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String enteredOTP = request.getParameter("otp");
        HttpSession session = request.getSession();
        String sessionOTP = (String) session.getAttribute("otp");

        if (sessionOTP != null && sessionOTP.equals(enteredOTP)) {
            session.removeAttribute("otp");
            session.removeAttribute("otpType");
            session.removeAttribute("otpEmail");

            session.setAttribute("isVerified", true);
            response.sendRedirect("reset_pass.jsp");
        } else {
            request.setAttribute("error", "Mã xác thực không đúng!");
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        }
    }
}