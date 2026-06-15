package controller;

import dal.UserDAO;
import model.User;
import util.CloudinaryUploadHelper;
import util.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet(name = "AdminProfileServlet", urlPatterns = {"/admin/profile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)
public class AdminProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        userDAO.getUserById(user.getId()).ifPresent(freshUser -> {
            session.setAttribute("account", freshUser);
            request.setAttribute("adminUser", freshUser);
        });
        if (request.getAttribute("adminUser") == null) {
            request.setAttribute("adminUser", user);
        }

        request.getRequestDispatcher("/admin/admin-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("changePassword".equals(action)) {
            handleChangePassword(request, response, session, user);
        } else {
            handleUpdateProfile(request, response, session, user);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
                                     HttpSession session, User user)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullname");
        String phone    = request.getParameter("phone");
        String gender   = request.getParameter("gender");
        String birthDay   = request.getParameter("birthDay");
        String birthMonth = request.getParameter("birthMonth");
        String birthYear  = request.getParameter("birthYear");

        try {
            Part avatarPart = request.getPart("avatarFile");
            String avatarFolder = "fruitshop/avatars/admin_" + user.getId();
            String uploadedUrl = CloudinaryUploadHelper.upload(avatarPart, avatarFolder);
            if (uploadedUrl != null) {
                user.setAvatar(uploadedUrl);
            }
        } catch (Exception e) {
            forwardWithMessage(request, response, null, "Lỗi khi tải ảnh lên: " + e.getMessage(), user);
            return;
        }

        if (fullName != null) fullName = fullName.trim();
        if (phone    != null) phone    = phone.trim();

        if (fullName == null || fullName.isEmpty()) {
            forwardWithMessage(request, response, null, "Họ và tên không được để trống.", user);
            return;
        }
        if (fullName.length() > 50) {
            forwardWithMessage(request, response, null, "Họ và tên tối đa 50 ký tự.", user);
            return;
        }
        if (phone != null && !phone.isEmpty() && !phone.matches("0[35789][0-9]{8}")) {
            forwardWithMessage(request, response, null,
                    "Số điện thoại không hợp lệ (10 chữ số, bắt đầu 03/05/07/08/09).", user);
            return;
        }

        user.setFullName(fullName);
        user.setPhone(phone);
        user.setGender(gender);

        if (birthDay != null && birthMonth != null && birthYear != null
                && !birthDay.isEmpty() && !birthMonth.isEmpty() && !birthYear.isEmpty()) {
            try {
                String dateStr = String.format("%s-%02d-%02d",
                        birthYear, Integer.parseInt(birthMonth), Integer.parseInt(birthDay));
                user.setBirthDate(java.sql.Date.valueOf(dateStr));
            } catch (Exception ignored) {
            }
        }

        boolean ok = userDAO.updateProfile(user);
        if (ok) {
            session.setAttribute("account", user);
            forwardWithMessage(request, response, "Cập nhật hồ sơ thành công!", null, user);
        } else {
            forwardWithMessage(request, response, null, "Cập nhật hồ sơ thất bại. Vui lòng thử lại!", user);
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
                                      HttpSession session, User user)
            throws ServletException, IOException {

        String oldPass  = request.getParameter("old_pass");
        String newPass  = request.getParameter("new_pass");
        String renewPass = request.getParameter("renew_pass");

        if (oldPass == null || newPass == null || renewPass == null
                || oldPass.trim().isEmpty() || newPass.trim().isEmpty()) {
            forwardWithMessage(request, response, null, "Vui lòng nhập đầy đủ thông tin!", user);
            return;
        }
        if (!newPass.equals(renewPass)) {
            forwardWithMessage(request, response, null, "Mật khẩu xác nhận không khớp!", user);
            return;
        }
        if (newPass.equals(oldPass)) {
            forwardWithMessage(request, response, null, "Mật khẩu mới không được trùng mật khẩu cũ!", user);
            return;
        }
        if (!PasswordUtils.hashMD5(oldPass).equals(user.getPassword())) {
            forwardWithMessage(request, response, null, "Mật khẩu cũ không đúng!", user);
            return;
        }
        String pwdError = PasswordUtils.getPasswordValidationMessage(newPass);
        if (pwdError != null) {
            forwardWithMessage(request, response, null, pwdError, user);
            return;
        }

        String hashed = PasswordUtils.hashMD5(newPass);
        boolean ok = userDAO.changePassword(user.getId(), hashed);
        if (ok) {
            user.setPassword(hashed);
            session.setAttribute("account", user);
            forwardWithMessage(request, response, "Đổi mật khẩu thành công!", null, user);
        } else {
            forwardWithMessage(request, response, null, "Có lỗi xảy ra khi cập nhật mật khẩu.", user);
        }
    }

    private void forwardWithMessage(HttpServletRequest request, HttpServletResponse response,
                                    String success, String error, User user)
            throws ServletException, IOException {
        if (success != null) request.setAttribute("success", success);
        if (error   != null) request.setAttribute("error",   error);
        request.setAttribute("adminUser", user);
        request.getRequestDispatcher("/admin/admin-profile.jsp").forward(request, response);
    }
}
