package controller;

import dal.UserDAO;
import model.User;
import util.CloudinaryUploadHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = { "/profile" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String currentAddress = userDAO.getUserAddress(user.getId());
        request.setAttribute("userAddress", currentAddress);

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String birthDay = request.getParameter("birthDay");
        String birthMonth = request.getParameter("birthMonth");
        String birthYear = request.getParameter("birthYear");
        String city = "Hồ Chí Minh";

        try {
            handleAvatarUpload(request, user);
        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(request, response, "Lỗi khi tải ảnh lên: " + e.getMessage());
            return;
        }

        if (fullName != null) {
            fullName = fullName.trim();
        }
        if (phone != null) {
            phone = phone.trim();
        }

        if (fullName == null || fullName.isEmpty()) {
            forwardWithError(request, response, "Họ và tên không được để trống.");
            return;
        }

        if (fullName.length() > 50) {
            forwardWithError(request, response, "Họ và tên tối đa 50 ký tự.");
            return;
        }

        if (phone != null && !phone.isEmpty()) {
            if (!phone.matches("0[35789][0-9]{8}")) {
                forwardWithError(request, response,
                        "Số điện thoại không hợp lệ. Yêu cầu: 10 chữ số, bắt đầu từ 03, 05, 07, 08 hoặc 09. Ví dụ: 0912345678");
                return;
            }
        }

        if (fullName != null && !fullName.trim().isEmpty() && !fullName.equals(user.getFullName())) {

            if (user.isNameChanged()) {
                forwardWithError(request, response, "Bạn chỉ được phép thay đổi tên người dùng 1 lần duy nhất!");
                return;
            } else {
                user.setFullName(fullName);
                user.setNameChanged(true);
            }
        }
        user.setPhone(phone);
        user.setGender(gender);

        if (birthDay != null && birthMonth != null && birthYear != null &&
                !birthDay.isEmpty() && !birthMonth.isEmpty() && !birthYear.isEmpty()) {
            try {
                String dateStr = String.format("%s-%02d-%02d",
                        birthYear, Integer.parseInt(birthMonth), Integer.parseInt(birthDay));
                user.setBirthDate(java.sql.Date.valueOf(dateStr));
            } catch (NumberFormatException e) {
                System.err.println("Lỗi định dạng số khi lưu ngày sinh: " + e.getMessage());

            } catch (IllegalArgumentException e) {
                System.err.println("Lỗi ngày sinh không hợp lệ: " + e.getMessage());
            }
        }

        try {
            boolean isSuccess = userDAO.updateProfile(user);

            if (isSuccess){
                if (address != null && !address.trim().isEmpty()) {
                    userDAO.updateAddress(user.getId(), address, city, fullName, phone);
                }
                session.setAttribute("account", user);
                request.setAttribute("message", "Cập nhật hồ sơ thành công!");
                request.setAttribute("userAddress", address);
            } else {
                request.setAttribute("error", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");

                String currentAddress = userDAO.getUserAddress(user.getId());
                request.setAttribute("userAddress", currentAddress);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống khi cập nhật: " + e.getMessage());
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    private void handleAvatarUpload(HttpServletRequest request, User user) throws IOException, ServletException {
        Part avatarPart = request.getPart("avatarFile");
        String avatarFolder = "fruitshop/avatars/user_" + user.getId();
        String uploadedUrl = CloudinaryUploadHelper.upload(avatarPart, avatarFolder);
        if (uploadedUrl != null) {
            user.setAvatar(uploadedUrl);
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}