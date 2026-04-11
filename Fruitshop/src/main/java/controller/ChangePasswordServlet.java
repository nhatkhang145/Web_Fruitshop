package controller;

import dal.UserDAO;
import model.User;
import util.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User u = (User) session.getAttribute("account");

        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPass = request.getParameter("old_pass");
        String newPass = request.getParameter("new_pass");
        String renewPass = request.getParameter("renew_pass");

        if (oldPass == null || newPass == null || renewPass == null || oldPass.trim().isEmpty() || newPass.trim().isEmpty()) {
            forwardWithError(request, response, "Vui lòng nhập đầy đủ thông tin!");
            return;
        }

        if (!newPass.equals(renewPass)) {
            forwardWithError(request, response, "Mật khẩu xác nhận không khớp!");
            return;
        }

        if (newPass.equals(oldPass)) {
            forwardWithError(request, response, "Mật khẩu mới không được trùng mật khẩu cũ!");
            return;
        }

        String hashedOldPass = PasswordUtils.hashMD5(oldPass);
        if (!hashedOldPass.equals(u.getPassword())) {
            forwardWithError(request, response, "Mật khẩu cũ không đúng!");
            return;
        }

        String passwordError = PasswordUtils.getPasswordValidationMessage(newPass);
        if (passwordError != null) {
            forwardWithError(request, response, passwordError);
            return;
        }

        try {
            String hashedNewPass = PasswordUtils.hashMD5(newPass);

            boolean isUpdated = userDAO.changePassword(u.getId(), hashedNewPass);

            if (isUpdated) {
                u.setPassword(hashedNewPass);
                session.setAttribute("account", u);
                request.setAttribute("mess", "Đổi mật khẩu thành công!");
                request.getRequestDispatcher("change-password.jsp").forward(request, response);
            } else {
                forwardWithError(request, response, "Có lỗi xảy ra khi cập nhật mật khẩu.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "Lỗi hệ thống, vui lòng thử lại sau!");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }
}