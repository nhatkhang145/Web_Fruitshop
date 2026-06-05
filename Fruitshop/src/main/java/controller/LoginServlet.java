package controller;

import java.io.IOException;
import java.util.Optional;

import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.AdminPermissionHelper;
import util.PasswordUtils;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("user");
        String pass = request.getParameter("pass");

        String hashedPassword = PasswordUtils.hashMD5(pass);

        UserDAO dao = new UserDAO();

        Optional<User> accountOpt = dao.checkLogin(email, hashedPassword);

        if (!accountOpt.isPresent()) {

            Optional<User> existingUserOpt = dao.getUserByEmail(email);

            if (existingUserOpt.isPresent() && "google".equals(existingUserOpt.get().getLoginType())) {

                request.setAttribute("error", "Tài khoản này đã được liên kết với Google. Vui lòng đăng nhập bằng nút 'Đăng nhập với Google'!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } else {
            User account = accountOpt.get();

            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            session.setAttribute("accountRoleName", resolveRoleName(account));
            session.setAttribute("adminLandingPath", AdminPermissionHelper.resolveAdminLandingPath(account));

            dal.WishlistDAO wishlistDAO = new dal.WishlistDAO();
            int wishlistCount = wishlistDAO.countWishlist(account.getId());
            session.setAttribute("wishlistCount", wishlistCount);

            if (isAdminAccount(account)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }

    private boolean isAdminAccount(User account) {
        return account != null && account.getRole() == 1;
    }

    private String resolveRoleName(User account) {
        if (account == null) {
            return "Khách hàng";
        }
        if (account.getRole() == 1) {
            return "Admin";
        }

        Integer roleId = account.getRoleId();
        if (roleId != null && roleId > 0) {
            var role = new RoleDAO().getRoleById(roleId);
            if (role != null && role.getName() != null && !role.getName().isBlank()) {
                return role.getName();
            }
            return "Vai trò #" + roleId;
        }

        return "Khách hàng";
    }
}