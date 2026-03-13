package constant;

public interface Iconstant {
    String GOOGLE_CLIENT_ID = "";
    String GOOGLE_CLIENT_SECRET = "";
    String GOOGLE_REDIRECT_URI = "http://localhost:8080/CFMS_Group6/login-google";
    String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";
    String GOOGLE_LINK_GET_USER_INFO = "https://openidconnect.googleapis.com/v1/userinfo?access_token=";
    String GOOGLE_GRANT_TYPE = "authorization_code";
}