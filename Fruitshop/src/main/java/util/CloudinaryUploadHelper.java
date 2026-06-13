package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;


public class CloudinaryUploadHelper {

    private static final Cloudinary cloudinary = CloudinaryConfig.get();

    private CloudinaryUploadHelper() {}

   
    @SuppressWarnings("unchecked")
    public static String upload(Part filePart, String folder) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        String submittedName = filePart.getSubmittedFileName();
        if (submittedName == null || submittedName.isBlank()) {
            return null;
        }

    
        byte[] fileBytes;
        try (InputStream inputStream = filePart.getInputStream()) {
            fileBytes = inputStream.readAllBytes();
        }

        Map<?, ?> result = cloudinary.uploader().upload(
                fileBytes,
                ObjectUtils.asMap(
                        "folder",          folder,
                        "resource_type",   "image",
                        "use_filename",    false,
                        "unique_filename", true,
                        "overwrite",       false,
                        "quality",         "auto",
                        "fetch_format",    "auto"
                )
        );
        return (String) result.get("secure_url");
    }

   
    @SuppressWarnings("unchecked")
    public static void delete(String publicId) {
        if (publicId == null || publicId.isBlank()) return;
        try {
            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (Exception e) {
            System.err.println("[Cloudinary] Không thể xóa ảnh: " + publicId + " — " + e.getMessage());
        }
    }

   
    public static String extractPublicId(String cloudinaryUrl) {
        if (cloudinaryUrl == null || !cloudinaryUrl.contains("cloudinary.com")) {
            return null;
        }
        int uploadIdx = cloudinaryUrl.indexOf("/upload/");
        if (uploadIdx < 0) return null;
        String afterUpload = cloudinaryUrl.substring(uploadIdx + 8);
        if (afterUpload.startsWith("v") && afterUpload.indexOf('/') > 0) {
            String possibleVersion = afterUpload.substring(1, afterUpload.indexOf('/'));
            if (possibleVersion.matches("\\d+")) {
                afterUpload = afterUpload.substring(afterUpload.indexOf('/') + 1);
            }
        }
        int dotIdx = afterUpload.lastIndexOf('.');
        if (dotIdx > 0) {
            afterUpload = afterUpload.substring(0, dotIdx);
        }
        return afterUpload;
    }

   
    public static String toSlug(String text) {
        if (text == null || text.isBlank()) return "unknown";

        String s = text.trim().toLowerCase();

        
        s = java.text.Normalizer.normalize(s, java.text.Normalizer.Form.NFD);
        s = s.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

        s = s.replace("đ", "d").replace("Đ", "d");

        s = s.replaceAll("[^a-z0-9\\s]", "");

        s = s.trim().replaceAll("\\s+", "-");

        return s.isEmpty() ? "unknown" : s;
    }
}
