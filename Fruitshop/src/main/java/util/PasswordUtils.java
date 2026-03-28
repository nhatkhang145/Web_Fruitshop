package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Pattern;

public class PasswordUtils {

    /**
     * Validate password theo yêu cầu:
     * - Tối thiểu 8 ký tự
     * - Có ít nhất 1 chữ in hoa
     * - Có ít nhất 1 chữ thường
     * - Có ít nhất 1 số
     * - Có ít nhất 1 ký tự đặc biệt
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        // Kiểm tra có chữ in hoa
        if (!Pattern.compile("[A-Z]").matcher(password).find()) {
            return false;
        }

        // Kiểm tra có chữ thường
        if (!Pattern.compile("[a-z]").matcher(password).find()) {
            return false;
        }

        // Kiểm tra có số
        if (!Pattern.compile("[0-9]").matcher(password).find()) {
            return false;
        }

        // Kiểm tra có ký tự đặc biệt
        if (!Pattern.compile("[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]").matcher(password).find()) {
            return false;
        }

        return true;
    }

    /**
     * Trả về thông báo lỗi chi tiết nếu password không hợp lệ
     */
    public static String getPasswordValidationMessage(String password) {
        if (password == null || password.isEmpty()) {
            return "Mật khẩu không được để trống!";
        }

        if (password.length() < 8) {
            return "Mật khẩu phải có ít nhất 8 ký tự!";
        }

        if (!Pattern.compile("[A-Z]").matcher(password).find()) {
            return "Mật khẩu phải có ít nhất 1 chữ in hoa!";
        }

        if (!Pattern.compile("[a-z]").matcher(password).find()) {
            return "Mật khẩu phải có ít nhất 1 chữ thường!";
        }

        if (!Pattern.compile("[0-9]").matcher(password).find()) {
            return "Mật khẩu phải có ít nhất 1 chữ số!";
        }

        if (!Pattern.compile("[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]").matcher(password).find()) {
            return "Mật khẩu phải có ít nhất 1 ký tự đặc biệt (!@#$%^&*...)!";
        }

        return null; // Hợp lệ
    }

    /**
     * Mã hóa mật khẩu bằng MD5
     */
    public static String hashMD5(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());

            // Convert byte array thành hex string
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5 algorithm not found", e);
        }
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        String hashedInput = hashMD5(plainPassword);
        return hashedInput.equals(hashedPassword);
    }
}
