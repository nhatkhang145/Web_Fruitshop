package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.GoogleOAuthConfig;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.Optional;

@WebServlet(name = "GoogleCallbackServlet", urlPatterns = {"/login-google"})
public class GoogleCallbackServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String error = request.getParameter("error");

        if (error != null) {
            request.setAttribute("error", "Đăng nhập Google thất bại: " + error);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String sessionState = (String) request.getSession().getAttribute("oauth_state");
        if (state == null || !state.equals(sessionState)) {
            request.setAttribute("error", "Lỗi bảo mật. Vui lòng thử lại.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            String accessToken = getAccessToken(code);

            JsonObject userInfo = getUserInfo(accessToken);

            String googleId = userInfo.get("id").getAsString();
            String email = userInfo.get("email").getAsString();
            String name = userInfo.get("name").getAsString();
            String picture = userInfo.has("picture") ? userInfo.get("picture").getAsString() : null;

            Optional<User> userOptional = userDAO.getUserByEmail(email);
            User user;

            if (userOptional.isEmpty()) {
                user = new User();
                user.setFullName(name);
                user.setEmail(email);
                user.setPassword(null);
                user.setAvatar(picture);
                user.setLoginType("google");
                user.setSocialId(googleId);
                user.setRole(0);
                user.setStatus(1);
                user.setCreatedAt(new Timestamp(System.currentTimeMillis()));

                userDAO.insertUser(user);

                user = userDAO.getUserByEmail(email).get();

            } else {
                user = userOptional.get();

                if (user.getStatus() == 0) {
                    request.setAttribute("error", "Tài khoản này đã bị khóa.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                if ("local".equals(user.getLoginType())) {
                    user.setLoginType("google");
                    user.setSocialId(googleId);
                    if (picture != null && (user.getAvatar() == null || user.getAvatar().isEmpty())) {
                        user.setAvatar(picture);
                    }
                    userDAO.updateSocialInfo(user);

                    request.getSession().setAttribute("message",
                            "Tài khoản của bạn đã được liên kết với Google thành công!");

                } else if ("google".equals(user.getLoginType())) {
                    user.setFullName(name);
                    if (picture != null && (user.getAvatar() == null || user.getAvatar().contains("default-user"))) {
                        user.setAvatar(picture);
                    }
                    userDAO.updateSocialInfo(user);
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("account", user);
            session.setAttribute("user", user);
            session.removeAttribute("oauth_state");

            if (user.getRole() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi đăng nhập Google: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private String getAccessToken(String code) throws IOException {
        URL url = new URL(GoogleOAuthConfig.TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String params = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8) +
                "&client_id=" + URLEncoder.encode(GoogleOAuthConfig.CLIENT_ID, StandardCharsets.UTF_8) +
                "&client_secret=" + URLEncoder.encode(GoogleOAuthConfig.CLIENT_SECRET, StandardCharsets.UTF_8) +
                "&redirect_uri=" + URLEncoder.encode(GoogleOAuthConfig.REDIRECT_URI, StandardCharsets.UTF_8) +
                "&grant_type=authorization_code";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes(StandardCharsets.UTF_8));
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
        }

        JsonObject jsonResponse = JsonParser.parseString(response.toString()).getAsJsonObject();
        return jsonResponse.get("access_token").getAsString();
    }

    private JsonObject getUserInfo(String accessToken) throws IOException {
        URL url = new URL(GoogleOAuthConfig.USER_INFO_URL + "?access_token=" + accessToken);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
        }

        return JsonParser.parseString(response.toString()).getAsJsonObject();
    }
}
