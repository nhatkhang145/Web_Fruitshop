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
        if (amountParam == null || amountParam.trim().isEmpty()){
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        long amount = Long.parseLong(amountParam) * 100;
        String orderId = request.getParameter("orderId");
        String vnp_TxnRef = String.valueOf(System.currentTimeMillis() % 100000000);
        String orderInfo = "Thanh toan don hang " + orderId + " tai Fruitshop";

        String vnp_IpAddr = VNPayConfig.getIpAddress(request);
        if ("0:0:0:0:0:0:0:1".equals(vnp_IpAddr)) {
            vnp_IpAddr = "127.0.0.1";
        }

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VNPayConfig.vnp_Version);
        vnp_Params.put("vnp_Command", VNPayConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                if (hashData.length() > 0) hashData.append("&");
                if (query.length() > 0) query.append("&");

                // BẮT BUỘC ENCODE GIÁ TRỊ TRƯỚC KHI NỐI VÀO CẢ QUERY VÀ HASHDATA
                String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.UTF_8).replace("+", "%20");

                hashData.append(fieldName).append("=").append(encodedValue);
                query.append(fieldName).append("=").append(encodedValue);
            }
        }

        String queryUrl = query.toString();
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());

        String paymentUrl = VNPayConfig.vnp_Url + "?" + queryUrl + "&vnp_SecureHash=" + vnp_SecureHash;

        response.sendRedirect(paymentUrl);

    }
}
