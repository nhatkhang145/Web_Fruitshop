package util;

public class GoogleOAuthConfig {

    // Google OAuth credentials
    public static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    public static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    public static final String REDIRECT_URI = "http://localhost:8080/Fruitshop_Web/login-google";

    // Google OAuth endpoints
    public static final String AUTHORIZATION_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    public static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

    // Scopes
    public static final String SCOPE = "openid email profile";
}
