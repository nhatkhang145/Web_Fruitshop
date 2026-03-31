package controller;

import dal.AdminReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminReviewServlet", urlPatterns = {"/admin/reviews", "/admin/review-action"})

public class AdminReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AdminReviewDAO reviewDAO = new AdminReviewDAO();

        request.setAttribute("reviews", reviewDAO.getAllReviews());
        request.setAttribute("totalReviews", reviewDAO.getTotalReviews());
        request.setAttribute("unrepliedCount", reviewDAO.getUnrepliedReviews());
        request.setAttribute("avgRating", reviewDAO.getAverageRating());

        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        AdminReviewDAO dao = new AdminReviewDAO();
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            if ("reply".equals(action)) {
                String content = request.getParameter("replyContent");
                dao.replyReview(id, content);
            } else if ("hide".equals(action)) {
                dao.updateStatus(id, "hidden");
            } else if ("show".equals(action)) {
                dao.updateStatus(id, "approved");
            } else if ("delete".equals(action)) {
                dao.deleteReview(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/reviews");;
    }
}
