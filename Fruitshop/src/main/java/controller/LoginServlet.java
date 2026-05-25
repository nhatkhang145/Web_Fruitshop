package controller;

import dal.CartDAO;
import dal.UserDAO;
import model.CartItem;
import model.User;
import util.CartSessionUtils;
import util.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

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

            CartDAO cartDAO = new CartDAO();
            List<CartItem> dbCart = cartDAO.getCartItemsByUserId(account.getId());
            List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
            List<CartItem> mergedCart = CartSessionUtils.mergeCarts(dbCart, sessionCart);
            CartSessionUtils.updateSessionCart(session, mergedCart);
            cartDAO.replaceCartItems(account.getId(), mergedCart);

            dal.WishlistDAO wishlistDAO = new dal.WishlistDAO();
            int wishlistCount = wishlistDAO.countWishlist(account.getId());
            session.setAttribute("wishlistCount", wishlistCount);

            if (account.getRole() == 1) {
                response.sendRedirect("admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }
    }
}