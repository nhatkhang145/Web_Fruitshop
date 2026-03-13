package dal;

import org.jdbi.v3.core.Jdbi;
import java.io.InputStream;
import java.util.Properties;

public class DBContext {
    private static Jdbi jdbi;
    static {
        try {
            InputStream is = DBContext.class.getClassLoader().getResourceAsStream("db.properties");
            Properties props = new Properties();

                props.load(is);
                String driver = props.getProperty("db.driver");
                String url = props.getProperty("db.url");
                String user = props.getProperty("db.username");
                String pass = props.getProperty("db.password");
                Class.forName(driver);
                jdbi = Jdbi.create(url, user, pass);


        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(" Lỗi: " + e.getMessage());
        }
    }
    public static Jdbi get() {
        return jdbi;
    }
}