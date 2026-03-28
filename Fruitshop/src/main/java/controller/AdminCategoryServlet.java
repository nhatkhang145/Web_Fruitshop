package controller;

import dal.AdminCategoryDAO;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


@WebServlet(name = "AdminCategoryServlet", urlPatterns = { "/admin/categories", "/admin/category-servlet",
        "/admin/delete-category" })
public class AdminCategoryServlet extends HttpServlet {

    private AdminCategoryDAO categoryDAO = new AdminCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        switch (action) {
            case "/admin/delete-category":
                deleteCategory(req, resp);
                break;
            case "/admin/categories":
            default:
                listCategories(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            addCategory(req, resp);
        } else if ("edit".equals(action)) {
            updateCategory(req, resp);
        } else {
            resp.sendRedirect("categories");
        }
    }


    private void listCategories(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> list = categoryDAO.getAllCategories();
        List<Category> parentCategories = categoryDAO.getParentCategories();
        req.setAttribute("listC", list);
        req.setAttribute("parentC", parentCategories);
        req.getRequestDispatcher("/admin/Categories.jsp").forward(req, resp);
    }


    private void deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            // Cần bổ sung method delete trong CategoryDAO
            categoryDAO.delete(Integer.parseInt(idStr));
        }
        resp.sendRedirect("categories");
    }


    private void addCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            String name = req.getParameter("name");
            String desc = req.getParameter("description");

            int parentId = Integer.parseInt(req.getParameter("parentId") == null ? "0" : req.getParameter("parentId"));
            int status = Integer.parseInt(req.getParameter("status") == null ? "1" : req.getParameter("status"));

            Category c = new Category();
            c.setName(name);
            c.setDescription(desc);
            c.setParentId(parentId);
            c.setStatus(status);

            categoryDAO.insert(c);

            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/categories?error=1");
        }
    }


    private void updateCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String desc = req.getParameter("description");
        int parentId = Integer.parseInt(req.getParameter("parentId"));
        int status = Integer.parseInt(req.getParameter("status"));

        Category c = new Category();
        c.setId(id);
        c.setName(name);
        c.setDescription(desc);
        c.setParentId(parentId);
        c.setStatus(status);

        categoryDAO.update(c);
        resp.sendRedirect("categories");
    }
}
