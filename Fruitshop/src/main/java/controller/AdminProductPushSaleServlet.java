package controller;

import com.google.gson.Gson;
import dal.AdminProductDAO;
import dal.WeekendDealDAO;
import model.WeekendDeal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import util.AdminPermissionHelper;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminProductPushSaleServlet", urlPatterns = {"/admin/product-push-sale"})
public class AdminProductPushSaleServlet extends HttpServlet {

    private AdminProductDAO productDAO;
    private WeekendDealDAO weekendDealDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new AdminProductDAO();
        weekendDealDAO = new WeekendDealDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();
        Gson gson = new Gson();

        User user = (User) req.getSession().getAttribute("account");
        if (user == null || !AdminPermissionHelper.isAdminAccount(user) || !AdminPermissionHelper.canAccess(user, req)) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            result.put("success", false);
            result.put("message", "Không có quyền thực hiện chức năng này");
            resp.getWriter().write(gson.toJson(result));
            return;
        }

        try {
            int productId = Integer.parseInt(req.getParameter("productId"));
            double salePrice = Double.parseDouble(req.getParameter("salePrice"));
            int durationHours = Integer.parseInt(req.getParameter("durationHours"));
            
            String rawBatchItemId = req.getParameter("batchItemId");
            Integer batchItemId = null;
            if (rawBatchItemId != null && !rawBatchItemId.trim().isEmpty()) {
                batchItemId = Integer.parseInt(rawBatchItemId.trim());
            }

            if (salePrice <= 0 || durationHours <= 0) {
                result.put("success", false);
                result.put("message", "Dữ liệu không hợp lệ");
                resp.getWriter().write(gson.toJson(result));
                return;
            }

            WeekendDeal activeDeal = weekendDealDAO.getActiveDealByProductId(productId);
            if (activeDeal != null) {
                result.put("success", false);
                result.put("message", "Sản phẩm này đang có chương trình Weekend Deal, không thể đẩy sale từ tồn kho.");
                resp.getWriter().write(gson.toJson(result));
                return;
            }

            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (durationHours * 3600 * 1000L));
            productDAO.updatePushSale(productId, salePrice, expiresAt, batchItemId);

            result.put("success", true);
            result.put("message", "Đẩy sale thành công");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        resp.getWriter().write(gson.toJson(result));
    }
}
