package util;

public class FacebookOAuthConfig {
    public static final String APP_ID = System.getenv("FACEBOOK_APP_ID");
    public static final String APP_SECRET = System.getenv("FACEBOOK_APP_SECRET");

    public static final String REDIRECT_URI = "http://localhost:8080/Fruitshop_Web/login-facebook";

    public static final String AUTHORIZATION_URL = "https://www.facebook.com/v19.0/dialog/oauth";
    public static final String TOKEN_URL = "https://graph.facebook.com/v19.0/oauth/access_token";
    public static final String USER_INFO_URL = "https://graph.facebook.com/me";
}
