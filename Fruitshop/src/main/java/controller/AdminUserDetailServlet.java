package controller;

import java.io.IOException;
import java.util.List;
import dal.AdminUserDAO;
import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Address;
import model.Role;
import model.User;

@WebServlet(name = "AdminUserDetailServlet", urlPatterns = { "/admin/user-detail" })
public class AdminUserDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("users");
                return;
            }

            int userId = Integer.parseInt(idStr);
            AdminUserDAO userDAO = new AdminUserDAO();
            RoleDAO roleDAO = new RoleDAO();
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect("users");
                return;
            }

            List<Address> addresses = userDAO.getAllAddressesByUserId(userId);
            List<Role> roles = roleDAO.getAllRolesWithStats();

            request.setAttribute("user", user);
            request.setAttribute("addresses", addresses);
            request.setAttribute("roles", roles);

            request.getRequestDispatcher("/admin/user-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("users");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            int userId = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String birthDateStr = request.getParameter("birthDate");
            int role = Integer.parseInt(request.getParameter("role"));
            Integer roleId = parseOptionalInt(request.getParameter("roleId"));

            String statusRaw = request.getParameter("status");

            String statusToDb = "1";
            if ("banned".equals(statusRaw)) {
                statusToDb = "0";
            } else if ("active".equals(statusRaw)) {
                statusToDb = "1";
            }

            AdminUserDAO userDAO = new AdminUserDAO();
            User user = userDAO.getUserById(userId);

            if (user != null) {
                user.setFullName(fullName);
                user.setPhone(phone);
                user.setGender(gender);

                if (birthDateStr != null && !birthDateStr.isEmpty()) {
                    try {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                        java.util.Date utilDate = sdf.parse(birthDateStr);
                        java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
                        user.setBirthDate(sqlDate);
                    } catch (java.text.ParseException ignored) {
                    }
                }


                userDAO.updateProfile(user);

                userDAO.updateUserStatusAndRole(userId, role, roleId, Integer.parseInt(statusToDb));


                response.sendRedirect("user-detail?id=" + userId + "&msg=success");
            } else {
                response.sendRedirect("users");
            }

        } catch (NumberFormatException | IOException e) {
            response.sendRedirect("users");
        }
    }

    private Integer parseOptionalInt(String value) {
        try {
            if (value == null || value.isBlank()) {
                return null;
            }
            return Integer.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
