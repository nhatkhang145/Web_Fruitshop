package util;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class VNPayConfig {
    public static final String vnp_Url;
    public static final String vnp_ReturnUrl;
    public static final String vnp_TmnCode;
    public static final String vnp_HashSecret;

    static {
        try {
            java.io.InputStream is = VNPayConfig.class.getClassLoader().getResourceAsStream("db.properties");
            java.util.Properties props = new java.util.Properties();
            props.load(is);
            vnp_Url = props.getProperty("vnpay.url");
            vnp_ReturnUrl = props.getProperty("vnpay.return_url");
            vnp_TmnCode = props.getProperty("vnpay.tmn_code");
            vnp_HashSecret = props.getProperty("vnpay.hash_secret");
        } catch (Exception e) {
            throw new RuntimeException("Lỗi cấu hình VNPAY: " + e.getMessage());
        }
    }

    public static final String vnp_Version = "2.1.0";
    public static final String vnp_Command = "pay";

    public static String hmacSHA512(final String key, final String data){
        try {
            if (key == null || data == null) {
                return null;
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    public static String hashAllFields(Map<String, String> fields) {
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        List<String> queryStrings = new ArrayList<>();
        for (String fieldName : fieldNames) {
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                try {
                    String encodedName = URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString());
                    String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                    queryStrings.add(encodedName + "=" + encodedValue);
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
        }
        String hashData = String.join("&", queryStrings);
        return hmacSHA512(vnp_HashSecret, hashData);
    }

    public static String getIpAddress(HttpServletRequest request){
        String ipAddress;
        try {
            ipAddress = request.getHeader("X-FORWARDED-FOR");
            if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                ipAddress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAddress = "127.0.0.1";
        }
        return ipAddress;
    }

}
