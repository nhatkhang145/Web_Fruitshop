package util;

import com.cloudinary.Cloudinary;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;


public class CloudinaryConfig {

    private static final Cloudinary INSTANCE;

    static {
        try {
            InputStream is = CloudinaryConfig.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties");
            Properties props = new Properties();
            props.load(is);

            Map<String, String> config = new HashMap<>();
            config.put("cloud_name", props.getProperty("cloudinary.cloud_name"));
            config.put("api_key",    props.getProperty("cloudinary.api_key"));
            config.put("api_secret", props.getProperty("cloudinary.api_secret"));
            config.put("secure",     "true");

            INSTANCE = new Cloudinary(config);
        } catch (Exception e) {
            throw new RuntimeException("Không thể khởi tạo Cloudinary: " + e.getMessage(), e);
        }
    }

    private CloudinaryConfig() {}

    public static Cloudinary get() {
        return INSTANCE;
    }
}
