package controller;

import service.GHNService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "GHNLocationServlet", urlPatterns = {"/api/location"})
public class GHNLocationServlet extends HttpServlet {

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

        String type = req.getParameter("type");

        try {
            String jsonResult = "";

            if ("province".equals(type)) {
                jsonResult = ghnService.getProvinces();
            } else if ("district".equals(type)) {
                String provinceIdStr = req.getParameter("province_id");
                if (provinceIdStr != null) {
                    jsonResult = ghnService.getDistricts(Integer.parseInt(provinceIdStr));
                }
            } else if ("ward".equals(type)) {
                String districtIdStr = req.getParameter("district_id");
                if (districtIdStr != null) {
                    jsonResult = ghnService.getWards(Integer.parseInt(districtIdStr));
                }
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\": 400}");
                return;
            }

            resp.getWriter().write(jsonResult);

        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\": 500}");
        }
    }
}
