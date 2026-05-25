package controller;

import dal.ReviewDAO;
import model.Review;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review"})
public class ReviewServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            switch (action) {
                case "add":
                    handleAddReview(request, response);
                    break;
                case "delete":
                    handleDeleteReview(request, response);
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Hệ thống gặp sự cố!");
        }
    }

    private void handleAddReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getUserFromSession(request);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String productIdStr = request.getParameter("productId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (productIdStr == null || ratingStr == null || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int rating = Integer.parseInt(ratingStr);

        Review review = new Review();
        review.setUserId(user.getId());
        review.setProductId(productId);
        review.setRating(rating);
        review.setComment(comment.trim());

        reviewDAO.insertReview(review);
        response.sendRedirect("product-detail?pid=" + productId + "&msg=success");
    }

    private void handleDeleteReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = getUserFromSession(request);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        reviewDAO.deleteReview(id);

        response.sendRedirect(request.getContextPath() + "/admin/reviews.jsp");
    }

    private User getUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return (User) session.getAttribute("account");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Phương thức GET không được hỗ trợ cho chức năng này.");
    }
}