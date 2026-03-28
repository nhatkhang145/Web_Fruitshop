package controller;

import dal.AdminProductDAO;
import dal.AdminWeekendDealDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.WeekendDeal;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "AdminWeekendDealServlet", urlPatterns = {"/admin/weekend-deals", "/admin/weekend-deal-edit"})
public class AdminWeekendDealServlet extends HttpServlet {

    private final AdminWeekendDealDAO dealDAO = new AdminWeekendDealDAO();
    private final AdminProductDAO productDAO = new AdminProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String path = request.getServletPath();

        if (path.equals("/admin/weekend-deal-edit")) {
            showEditPage(request, response);
        } else {
            String action = request.getParameter("action");

            if (action != null) {
                switch (action) {
                    case "delete":
                        handleDelete(request, response, session);
                        return;
                    case "toggle":
                        handleToggleStatus(request, response, session);
                        return;
                }
            }


            List<WeekendDeal> deals = dealDAO.getAllDeals();
            request.setAttribute("deals", deals);
            request.setAttribute("now", System.currentTimeMillis());
            request.getRequestDispatcher("weekend-deals.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        handleSave(request, response, session);
    }


    private void showEditPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dealIdStr = request.getParameter("id");

        if (dealIdStr != null) {

            try {
                int dealId = Integer.parseInt(dealIdStr);
                WeekendDeal deal = dealDAO.getDealById(dealId);

                if (deal != null) {
                    request.setAttribute("deal", deal);
                } else {
                    request.getSession().setAttribute("errorMessage", " Không tìm thấy deal");
                    response.sendRedirect(request.getContextPath() + "/admin/weekend-deals");
                    return;
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", " ID không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/admin/weekend-deals");
                return;
            }
        }


        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);

        request.getRequestDispatcher("weekend-deal-edit.jsp").forward(request, response);
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            String dealIdStr = request.getParameter("dealId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            String tag = request.getParameter("tag");
            String subtitle = request.getParameter("subtitle");
            int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            int status = request.getParameter("status") != null ? 1 : 0;
            int sortOrder = Integer.parseInt(request.getParameter("sortOrder"));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Timestamp startDate = new Timestamp(sdf.parse(startDateStr).getTime());
            Timestamp endDate = new Timestamp(sdf.parse(endDateStr).getTime());

            WeekendDeal deal = new WeekendDeal();
            deal.setProductId(productId);
            deal.setTag(tag);
            deal.setSubtitle(subtitle);
            deal.setDiscountPercent(discountPercent);
            deal.setStartDate(startDate);
            deal.setEndDate(endDate);
            deal.setStatus(status);
            deal.setSortOrder(sortOrder);

            boolean success;
            if (dealIdStr != null && !dealIdStr.isEmpty()) {
                deal.setId(Integer.parseInt(dealIdStr));
                success = dealDAO.updateDeal(deal);
                session.setAttribute("successMessage", success ? " Cập nhật deal thành công" : " Cập nhật thất bại");
            } else {
                success = dealDAO.insertDeal(deal);
                session.setAttribute("successMessage", success ? " Thêm deal mới thành công" : " Thêm deal thất bại");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", " Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/weekend-deals");
    }


    private void handleDelete(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            int dealId = Integer.parseInt(request.getParameter("id"));

            if (dealDAO.deleteDeal(dealId)) {
                session.setAttribute("successMessage", " Đã xóa deal thành công");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa deal. Vui lòng thử lại");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/weekend-deals");
    }


    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        try {
            int dealId = Integer.parseInt(request.getParameter("id"));
            WeekendDeal deal = dealDAO.getDealById(dealId);

            if (deal != null) {
                int newStatus = deal.getStatus() == 1 ? 0 : 1;
                deal.setStatus(newStatus);

                if (dealDAO.updateDeal(deal)) {
                    session.setAttribute("successMessage",
                            newStatus == 1 ? "Đã BẬT deal!" : "⚠Đã TẮT deal!");
                } else {
                    session.setAttribute("errorMessage", "Không thể cập nhật trạng thái!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", " Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/weekend-deals");
    }
}