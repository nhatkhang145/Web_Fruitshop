package controller;

import dal.AdminBannerDAO;
import model.Banner;
import util.CloudinaryUploadHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBannerServlet", urlPatterns = {"/admin/banners"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminBannerServlet extends HttpServlet {

    private static final String CLOUDINARY_FOLDER = "fruitshop/banners";

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
            String imageUrl = CloudinaryUploadHelper.upload(request.getPart("image"), CLOUDINARY_FOLDER);
            if (imageUrl == null) imageUrl = "";

            Banner b = new Banner(0, title, description, imageUrl, link, linkType, linkTarget, order, status);
            dao.insert(b);

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String oldImage = request.getParameter("oldImage");

            String uploaded = CloudinaryUploadHelper.upload(request.getPart("image"), CLOUDINARY_FOLDER);
            String finalImageUrl = (uploaded != null) ? uploaded : oldImage;

            Banner b = new Banner(id, title, description, finalImageUrl, link, linkType, linkTarget, order, status);
            dao.update(b);
        }

        response.sendRedirect("banners");
    }

}
