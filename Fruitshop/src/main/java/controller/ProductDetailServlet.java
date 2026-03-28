package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.ReviewDAO;
import dal.WeekendDealDAO;
import model.Category;
import model.Product;
import model.WeekendDeal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Review;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String idRaw = request.getParameter("pid"); // Lấy id từ URL
        ProductDAO pDao = new ProductDAO();
        CategoryDAO cDao = new CategoryDAO();
        WeekendDealDAO wdDao = new WeekendDealDAO();
        ReviewDAO rDao = new ReviewDAO();

        try {
            int id = Integer.parseInt(idRaw);

            Product p = pDao.getProductByID(id);
            if(p == null) {
                response.sendRedirect("index.jsp");
                return;
            }

            WeekendDeal activeDeal = wdDao.getActiveDealByProductId(id);
            if (activeDeal != null) {
                request.setAttribute("weekendDeal", activeDeal);
            }

            List<Product> relatedP = pDao.getProductsByCategoryID(p.getCategoryId());

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

            request.setAttribute("detail", p);       // Biến 'detail' chứa thông tin 1 sản phẩm
            request.setAttribute("relatedP", relatedP); // Biến 'relatedP' chứa list sản phẩm liên quan

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
}