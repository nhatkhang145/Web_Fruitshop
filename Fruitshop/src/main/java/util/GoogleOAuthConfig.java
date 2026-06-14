package util;

import java.io.InputStream;
import java.util.Properties;

public class GoogleOAuthConfig {

    public static final String CLIENT_ID;
    public static final String CLIENT_SECRET;

    static {
        Properties props = new Properties();
        try (InputStream is = GoogleOAuthConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (Exception e) {
            System.err.println("Không thể tải cấu hình Google OAuth từ db.properties: " + e.getMessage());
        }
        
        String envId = System.getenv("GOOGLE_CLIENT_ID");
        CLIENT_ID = (envId != null && !envId.isBlank()) ? envId : props.getProperty("google.client_id");

        String envSecret = System.getenv("GOOGLE_CLIENT_SECRET");
        CLIENT_SECRET = (envSecret != null && !envSecret.isBlank()) ? envSecret : props.getProperty("google.client_secret");
    }

    public static final String REDIRECT_URI = "http://localhost:8080/Fruitshop_Web/login-google";
    public static final String AUTHORIZATION_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    public static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
    public static final String SCOPE = "openid email profile";
}

