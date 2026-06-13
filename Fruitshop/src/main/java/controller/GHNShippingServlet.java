package controller;

import com.google.gson.JsonObject;
import service.GHNService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "GHNShippingServlet", urlPatterns = {"/api/shipping-fee"})
public class GHNShippingServlet extends HttpServlet {

    private GHNService ghnService;

    @Override
    public void init() throws ServletException {
        ghnService = new GHNService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String fromDistrictStr = req.getParameter("from_district_id");
            String toDistrictStr = req.getParameter("to_district_id");
            String weightStr = req.getParameter("weight");
            String insuranceValueStr = req.getParameter("insurance_value");

            if (fromDistrictStr == null || toDistrictStr == null || weightStr == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\": 400, \"message\": \"Thiếu tham số bắt buộc\"}");
                return;
            }

            int fromDistrictId = Integer.parseInt(fromDistrictStr);
            int toDistrictId = Integer.parseInt(toDistrictStr);
            int weight = Integer.parseInt(weightStr);
            int insuranceValue = insuranceValueStr != null ? Integer.parseInt(insuranceValueStr) : 0;

            int shippingFee = ghnService.calculateShippingFee(fromDistrictId, toDistrictId, weight, insuranceValue);

            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("status", 200);
            jsonResponse.addProperty("message", "Success");
            jsonResponse.addProperty("shipping_fee", shippingFee);

            resp.getWriter().write(jsonResponse.toString());

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\": 400, \"message\": \"Tham số không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("status", 500);
            errorResponse.addProperty("message", "Lỗi khi gọi API tính phí: " + e.getMessage());
            resp.getWriter().write(errorResponse.toString());
        }
    }
}
