package util;

import java.io.InputStream;
import java.util.Properties;

public class FacebookOAuthConfig {
    public static final String APP_ID;
    public static final String APP_SECRET;

    static {
        Properties props = new Properties();
        try (InputStream is = FacebookOAuthConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (Exception e) {
            System.err.println("Không thể tải cấu hình Facebook OAuth từ db.properties: " + e.getMessage());
        }
        
        String envId = System.getenv("FACEBOOK_APP_ID");
        APP_ID = (envId != null && !envId.isBlank()) ? envId : props.getProperty("facebook.app_id");

        String envSecret = System.getenv("FACEBOOK_APP_SECRET");
        APP_SECRET = (envSecret != null && !envSecret.isBlank()) ? envSecret : props.getProperty("facebook.app_secret");
    }

    public static final String REDIRECT_URI = "http://localhost:8080/Fruitshop_Web/login-facebook";

    public static final String AUTHORIZATION_URL = "https://www.facebook.com/v19.0/dialog/oauth";
    public static final String TOKEN_URL = "https://graph.facebook.com/v19.0/oauth/access_token";
    public static final String USER_INFO_URL = "https://graph.facebook.com/me";
}

