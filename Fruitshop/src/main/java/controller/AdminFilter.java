package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.AdminPermissionHelper;


@WebFilter(filterName = "AdminFilter", urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");

        } else if (!AdminPermissionHelper.isAdminAccount(user)) {
            redirectWithFlash(request, response, "Tài khoản này chưa được cấp quyền truy cập khu quản trị.");

        } else if (!AdminPermissionHelper.canAccess(user, request)) {
            redirectWithFlash(request, response, "Bạn không có quyền truy cập chức năng này.");

        } else {
            chain.doFilter(req, resp);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}

    private void redirectWithFlash(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        Object accountObj = request.getSession().getAttribute("account");
        String target = request.getContextPath() + "/";
        if (accountObj instanceof User user) {
            String landingPath = AdminPermissionHelper.resolveAdminLandingPath(user);
            if (landingPath != null && !landingPath.isBlank()) {
                target = request.getContextPath() + landingPath;
            }
        }

        String separator = target.contains("?") ? "&" : "?";
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(target + separator + "permMsg=" + encodedMessage);
    }
}
