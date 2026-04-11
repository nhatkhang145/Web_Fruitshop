package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.GoogleOAuthConfig;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/login-google-redirect"})
public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("oauth_state", state);

        String authUrl = GoogleOAuthConfig.AUTHORIZATION_URL +
                "?client_id=" + URLEncoder.encode(GoogleOAuthConfig.CLIENT_ID, StandardCharsets.UTF_8) +
                "&redirect_uri=" + URLEncoder.encode(GoogleOAuthConfig.REDIRECT_URI, StandardCharsets.UTF_8) +
                "&response_type=code" +
                "&scope=" + URLEncoder.encode(GoogleOAuthConfig.SCOPE, StandardCharsets.UTF_8) +
                "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8) +
                "&access_type=offline" +
                "&prompt=consent";

        response.sendRedirect(authUrl);
    }
}
