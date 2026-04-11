package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.PasswordUtils;

import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/resetPassword"})
public class ResetPasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String email = (String) session.getAttribute("emailReset");
        Boolean isVerified = (Boolean) session.getAttribute("isVerified");

        if (email == null || isVerified == null || !isVerified) {
            response.sendRedirect("login.jsp");
            return;
        }

        String newPass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");

        if (newPass == null || !newPass.equals(confirmPass)) {
            forwardWithError(request, response, "Mật khẩu xác nhận không khớp!");
            return;
        }

        if (!PasswordUtils.isValidPassword(newPass)) {
            String errorDetail = PasswordUtils.getPasswordValidationMessage(newPass);
            forwardWithError(request, response, errorDetail != null ? errorDetail : "Mật khẩu không đúng định dạng!");
            return;
        }

        try {
            String hashedPass = PasswordUtils.hashMD5(newPass);
            boolean isUpdated = userDAO.updatePasswordByEmail(email, hashedPass);

            if (isUpdated) {
                session.invalidate();

                request.setAttribute("mess", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                forwardWithError(request, response, "Cập nhật thất bại. Vui lòng thử lại sau!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("reset_pass.jsp").forward(request, response);
    }
}