package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.FacebookOAuthConfig;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@WebServlet(name = "FacebookLoginServlet", urlPatterns = {"/login-facebook-redirect"})
public class FacebookLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String state = UUID.randomUUID().toString();
        request.getSession().setAttribute("oauth_state", state);

        String authUrl = FacebookOAuthConfig.AUTHORIZATION_URL +
                "?client_id=" + URLEncoder.encode(FacebookOAuthConfig.APP_ID, StandardCharsets.UTF_8) +
                "&redirect_uri=" + URLEncoder.encode(FacebookOAuthConfig.REDIRECT_URI, StandardCharsets.UTF_8) +
                "&state=" + URLEncoder.encode(state, StandardCharsets.UTF_8) +
                "&scope=email,public_profile";

        response.sendRedirect(authUrl);
    }
}