package controller;

import dal.AdminBannerDAO;
import model.Banner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "AdminBannerServlet", urlPatterns = {"/admin/banners"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminBannerServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/images/banners";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AdminBannerDAO dao = new AdminBannerDAO();
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if(idStr != null) {
                int id = Integer.parseInt(idStr);
                dao.delete(id);
            }
            response.sendRedirect("banners");
            return;
        }

        List<Banner> list = dao.getAllBanners();
        request.setAttribute("banners", list);
        request.getRequestDispatcher("banners.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        AdminBannerDAO dao = new AdminBannerDAO();

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String link = request.getParameter("link");

        int order = 0;
        try {
            order = Integer.parseInt(request.getParameter("displayOrder"));
        } catch (NumberFormatException e) { order = 0; }

        int status = request.getParameter("status") != null ? 1 : 0;


        String linkType = request.getParameter("linkType");
        String linkTarget = request.getParameter("linkTarget");


        if (linkType == null || linkType.isEmpty()) {
            linkType = "none";
        }

        if ("add".equals(action)) {
            String fileName = uploadFile(request);
            String imageUrl = (fileName != null) ? UPLOAD_DIR + "/" + fileName : "";

            Banner b = new Banner(0, title, description, imageUrl, link, linkType, linkTarget, order, status);
            dao.insert(b);

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String oldImage = request.getParameter("oldImage");

            String fileName = uploadFile(request);

            String finalImageUrl = (fileName != null && !fileName.isEmpty()) ? UPLOAD_DIR + "/" + fileName : oldImage;

            Banner b = new Banner(id, title, description, finalImageUrl, link, linkType, linkTarget, order, status);
            dao.update(b);
        }

        response.sendRedirect("banners");
    }

    private String uploadFile(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("image");
        if (filePart == null || filePart.getSize() == 0 || filePart.getSubmittedFileName().isEmpty()) {
            return null;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        fileName = System.currentTimeMillis() + "_" + fileName;

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        filePart.write(uploadPath + File.separator + fileName);
        return fileName;
    }
}
