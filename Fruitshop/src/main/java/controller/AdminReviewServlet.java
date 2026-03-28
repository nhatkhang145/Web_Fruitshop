package controller;

import dal.AdminReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminReviewServlet", urlPatterns = {"/admin/review"})
public class AdminReviewServlet extends HttpServlet {

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
        response.sendRedirect("reviews.jsp");
    }
}
