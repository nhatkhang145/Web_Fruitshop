package controller;

import dal.WeekendDealDAO;
import dal.WishlistDAO;
import model.User;
import model.WeekendDeal;
import model.WishlistItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist"})
public class WishlistServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        WishlistDAO dao = new WishlistDAO();

        if (action == null || action.equals("view")) {
            List<WishlistItem> list = dao.getWishlistByUserId(user.getId());
            WeekendDealDAO dealDAO = new WeekendDealDAO();
            Map<Integer, WeekendDeal> dealsMap = new HashMap<>();
            for (WishlistItem item : list) {
                WeekendDeal deal = dealDAO.getActiveDealByProductId(item.getProduct().getId());
                if (deal != null) {
                    dealsMap.put(item.getProduct().getId(), deal);
                }
            }

            request.setAttribute("wishlist", list);
            request.setAttribute("weekendDeals", dealsMap);
            request.getRequestDispatcher("wishlist.jsp").forward(request, response);

        } else if (action.equals("add")) {
            String pidStr = request.getParameter("pid");
            if (pidStr != null) {
                int pid = Integer.parseInt(pidStr);
                dao.addToWishlist(user.getId(), pid);

                int count = dao.countWishlist(user.getId());
                session.setAttribute("wishlistCount", count);
                String ajaxHeader = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(ajaxHeader)) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"action\": \"added\", \"count\": " + count + "}");
                    return;
                }
            }
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : "shop");

        } else if (action.equals("remove")) {
            String pidStr = request.getParameter("pid");
            if (pidStr != null) {
                int pid = Integer.parseInt(pidStr);
                dao.removeFromWishlist(user.getId(), pid);

                int count = dao.countWishlist(user.getId());
                session.setAttribute("wishlistCount", count);
                String ajaxHeader = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(ajaxHeader)) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"action\": \"removed\", \"count\": " + count + "}");
                    return;
                }
            }
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : "shop");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}