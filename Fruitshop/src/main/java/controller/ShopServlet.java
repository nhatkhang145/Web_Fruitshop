package controller;

import dal.ProductDAO;
import dal.CategoryDAO;
import dal.WishlistDAO;
import dal.WeekendDealDAO;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.Category;
import model.WeekendDeal;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "ShopServlet", urlPatterns = { "/shop" })
public class ShopServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        ProductDAO pDao = new ProductDAO();
        CategoryDAO cDao = new CategoryDAO();

        // Lấy các tham số từ request
        String indexPage = request.getParameter("index");
        String categoryId = request.getParameter("cid");
        String searchKeyword = request.getParameter("q");
        String priceRaw = request.getParameter("price");
        String sortRaw = request.getParameter("sort");

        List<Product> listP;
        List<Integer> likedIds = new ArrayList<>();
        List<Category> listC = cDao.getAllCategories();
        request.setAttribute("listC", listC);

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            listP = pDao.searchProducts(searchKeyword, null);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("isSearch", true);
        }
        else {
            int index = 1;
            try {
                if (indexPage != null && !indexPage.isEmpty()) {
                    index = Integer.parseInt(indexPage);
                }
            } catch (NumberFormatException e) {
                index = 1;
            }

            Integer cid = null;
            try {
                if (categoryId != null && !categoryId.isEmpty()) {
                    cid = Integer.parseInt(categoryId);
                }
            } catch (NumberFormatException e) {
                cid = null;
            }

            List<Integer> categoryIds = new ArrayList<>();
            if (cid != null) {
                categoryIds = cDao.getCategoryIdsIncludingChildren(cid);
            }

            Double minPrice = null, maxPrice = null;
            if (priceRaw != null && !priceRaw.isEmpty()) {
                String[] parts = priceRaw.split("-");
                if (parts.length >= 1)
                    minPrice = Double.parseDouble(parts[0]);
                if (parts.length >= 2 && !parts[1].equals("max"))
                    maxPrice = Double.parseDouble(parts[1]);
            }


            int count;
            List<Product> listP_temp;

            if (!categoryIds.isEmpty()) {
                count = pDao.countProductsByFilterWithCategoryList(categoryIds, minPrice, maxPrice);
                listP_temp = pDao.filterProductsWithCategoryList(categoryIds, minPrice, maxPrice, sortRaw, index);
            } else {
                count = pDao.countProductsByFilter(null, minPrice, maxPrice);
                listP_temp = pDao.filterProducts(null, minPrice, maxPrice, sortRaw, index);
            }
            listP = listP_temp;

            int endPage = count / 16;
            if (count % 16 != 0)
                endPage++;

            request.setAttribute("endP", endPage);
            if (cid != null) {
                request.setAttribute("tag", cid);
            } else {
                request.setAttribute("tag", index);
            }
            request.setAttribute("cid", categoryId);
            request.setAttribute("priceTag", priceRaw);
            request.setAttribute("sortTag", sortRaw);
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user != null) {
            WishlistDAO wDao = new WishlistDAO();
            likedIds = wDao.getLikedProductIds(user.getId());
            // Cập nhật số lượng wishlist vào session
            int wishlistCount = wDao.countWishlist(user.getId());
            session.setAttribute("wishlistCount", wishlistCount);
        } else {
            session.setAttribute("wishlistCount", 0);
        }
        request.setAttribute("likedIds", likedIds);

        // 4. Load weekend deals Map cho product cards
        WeekendDealDAO dealDAO = new WeekendDealDAO();
        java.util.Map<Integer, WeekendDeal> weekendDealMap = dealDAO.getActiveDealsByProductIds();
        request.setAttribute("weekendDealMap", weekendDealMap);

        // 5. Gửi dữ liệu về JSP
        request.setAttribute("listP", listP);
        request.getRequestDispatcher("shop.jsp").forward(request, response);
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