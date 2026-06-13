package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.ReviewDAO;
import dal.WeekendDealDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", urlPatterns = { "/product-detail" })
public class ProductDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String idRaw = request.getParameter("pid");
        ProductDAO pDao = new ProductDAO();
        CategoryDAO cDao = new CategoryDAO();
        WeekendDealDAO wdDao = new WeekendDealDAO();
        ReviewDAO rDao = new ReviewDAO();

        try {
            int id = Integer.parseInt(idRaw);

            Product p = pDao.getProductByID(id);
            if (p == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            int soldCount = pDao.getSoldQuantityByProductId(id);
            request.setAttribute("soldCount", soldCount);

            WeekendDeal activeDeal = wdDao.getActiveDealByProductId(id);
            if (activeDeal != null) {
                request.setAttribute("weekendDeal", activeDeal);
            }

            double basePrice = p.getSalePrice() > 0 ? p.getSalePrice() : p.getPrice();
            List<Product> relatedP = pDao.getRecommendedProducts(p.getCategoryId(), p.getId(), basePrice, 8);

            List<Category> listC = cDao.getAllCategories();
            request.setAttribute("listC", listC);

            List<Review> listR = new ArrayList<>();
            try {
                listR = rDao.getReviewsByProductId(id);
            } catch (Exception e) {
                System.out.println("Lỗi tải đánh giá sản phẩm ID " + id + ": " + e.getMessage());
                e.printStackTrace();
            }
            request.setAttribute("listR", listR);

            User user = (User) request.getSession().getAttribute("account");
            boolean canReview = false;

            if (user != null) {
                // Sử dụng hàm JDBI đã viết trong ReviewDAO để tìm đơn hàng thỏa mãn (đã giao, chưa review)
                Integer eligibleOrderDetailId = rDao.getEligibleOrderDetailId(user.getId(), p.getId());
                if (eligibleOrderDetailId != null) {
                    canReview = true; // Thỏa mãn điều kiện -> Đổi cờ thành true
                }
            }
            // Truyền biến canReview (true/false) sang trang product-detail.jsp
            request.setAttribute("canReview", canReview);

            request.setAttribute("detail", p);
            request.setAttribute("relatedP", relatedP);

            request.getRequestDispatcher("product-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}