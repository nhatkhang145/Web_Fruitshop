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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy thông tin đơn hàng và tổng tiền từ trang checkout gửi lên
        // Lưu ý: VNPAY quy định số tiền phải nhân thêm 100 (Ví dụ: 10,000 VND thành 1000000)
        String amountParam = request.getParameter("amount");
        long amount = Long.parseLong(amountParam) * 100;

        String orderInfo = request.getParameter("orderInfo");
        if (orderInfo == null || orderInfo.trim().isEmpty()) {
            orderInfo = "Thanh toan don hang tai Fruitshop";
        }

        // Tạo mã tham chiếu giao dịch độc nhất (Thường là ID đơn hàng tạm thời hoặc chuỗi ngẫu nhiên)
        String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
        String vnp_IpAddr = VNPayConfig.getIpAddress(request);

        // 2. Thiết lập các tham số gửi sang cổng VNPAY
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VNPayConfig.vnp_Version);
        vnp_Params.put("vnp_Command", VNPayConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", "other"); // Loại hàng hóa
        vnp_Params.put("vnp_Locale", "vn");       // Ngôn ngữ giao diện thanh toán
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        // Tạo thời gian khởi tạo giao dịch (vnp_CreateDate) theo định dạng yyyyMMddHHmmss
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

        // 3. Sắp xếp các tham số theo bảng chữ cái (Bắt buộc theo quy định của VNPAY)
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();

        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (!fieldValue.isEmpty())) {
                // Xây dựng chuỗi hash dữ liệu gốc
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                // Xây dựng chuỗi query URL
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));

                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }

        // 4. Tiến hành ký số bảo mật bằng chuỗi SecretKey
        String queryUrl = query.toString();
        String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());

        // 5. Kết hợp tạo thành URL hoàn chỉnh
        String paymentUrl = VNPayConfig.vnp_Url + "?" + queryUrl + "&vnp_SecureHash=" + vnp_SecureHash;

        // 6. Chuyển hướng trình duyệt người dùng sang cổng thanh toán VNPAY
        response.sendRedirect(paymentUrl);
    }
}
