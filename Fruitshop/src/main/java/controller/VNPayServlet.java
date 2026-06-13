package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.VNPayConfig;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "VNPayServlet", urlPatterns = {"/vnpay-payment"})
public class VNPayServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String amountParam = request.getParameter("amount");
        if (amountParam == null || amountParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        long amount = Long.parseLong(amountParam) * 100;
        String orderId = request.getParameter("orderId");

        // Tạo chuỗi thông tin hóa đơn tiếng Việt không dấu
        String orderInfo = "Thanh toan don hang " + orderId + " tai Fruitshop";

        String vnp_IpAddr = VNPayConfig.getIpAddress(request);
        if ("0:0:0:0:0:0:0:1".equals(vnp_IpAddr)) {
            vnp_IpAddr = "127.0.0.1";
        }

        // Đóng gói các tham số cơ bản
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VNPayConfig.vnp_Version);
        vnp_Params.put("vnp_Command", VNPayConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", String.valueOf(System.currentTimeMillis() % 100000000));
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        // Định dạng thời gian tạo đơn
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        String vnp_SecureHash = VNPayConfig.hashAllFields(vnp_Params);

        StringBuilder query = new StringBuilder();
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                query.append(fieldName);
                query.append("=");
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()).replace("+", "%20"));
                if (itr.hasNext()) {
                    query.append("&");
                }
            }
        }

        String paymentUrl = VNPayConfig.vnp_Url + "?" + query.toString() + "&vnp_SecureHashType=HmacSHA512" + "&vnp_SecureHash=" + vnp_SecureHash;
        response.sendRedirect(paymentUrl);

    }
}
