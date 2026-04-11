package util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.util.Properties;

public class EmailUtils {

    public static void sendOTPEmail(String to, String fullname, String otp, String type) throws Exception {
        String subject;
        String title;
        String description;

        if ("register".equals(type)) {
            subject = "Xác thực đăng ký tài khoản - Organic Harvest";
            title = " Xác thực đăng ký tài khoản";
            description = "Cảm ơn bạn đã đăng ký tài khoản tại <strong>Organic Harvest</strong>. Vui lòng sử dụng mã OTP bên dưới để hoàn tất đăng ký:";
        } else if ("forgot-password".equals(type)) {
            subject = "Đặt lại mật khẩu - Organic Harvest";
            title = " Đặt lại mật khẩu";
            description = "Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. Vui lòng sử dụng mã OTP bên dưới để tiếp tục:";
        } else {
            subject = "Mã OTP xác thực - Organic Harvest";
            title = " Mã OTP xác thực";
            description = "Vui lòng sử dụng mã OTP bên dưới để xác thực:";
        }

        String body = buildOTPEmailTemplate(fullname, otp, title, description);
        sendEmail(to, subject, body);
    }

    private static String buildOTPEmailTemplate(String fullname, String otp, String title, String description) {
        return "<!DOCTYPE html>" +
                "<html><head><style>" +
                "body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
                ".header { text-align: center; color: #4CAF50; margin-bottom: 20px; }" +
                ".otp-code { font-size: 36px; font-weight: bold; color: #4CAF50; text-align: center; " +
                "           padding: 25px; background: #f0f0f0; border-radius: 8px; margin: 25px 0; letter-spacing: 8px; }" +
                ".note { color: #666; font-size: 14px; margin-top: 20px; line-height: 1.6; }" +
                ".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #999; font-size: 12px; }" +
                "</style></head><body>" +
                "<div class='container'>" +
                "  <h2 class='header'>" + title + "</h2>" +
                "  <p>Xin chào <strong>" + fullname + "</strong>,</p>" +
                "  <p>" + description + "</p>" +
                "  <div class='otp-code'>" + otp + "</div>" +
                "  <p class='note'> Mã OTP có hiệu lực trong <strong>5 phút</strong>.</p>" +
                "  <p class='note'> Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email.</p>" +
                "  <div class='footer'>© 2026 Organic Harvest. All rights reserved.</div>" +
                "</div></body></html>";
    }

    public static void sendEmail(String toEmail, String subject, String htmlContent) throws Exception {
        Properties props = new Properties();
        try (InputStream input = EmailUtils.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (input == null) {
                throw new Exception("Không tìm thấy file mail.properties");
            }
            props.load(input);
        }

        final String fromEmail = props.getProperty("mail.username");
        final String password = props.getProperty("mail.password");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(fromEmail, "Organic Harvest"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
        System.out.println(" Đã gửi email thành công tới: " + toEmail);
    }
}