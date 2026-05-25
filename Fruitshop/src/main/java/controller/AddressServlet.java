package controller;

import dal.AddressDAO;
import model.Address;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddressServlet", urlPatterns = { "/addresses" })
public class AddressServlet extends HttpServlet {

    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getUserFromSession(request, response);
        if (user == null)
            return;

        loadAddressesToRequest(request, user.getId());
        request.getRequestDispatcher("addresses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        User user = getUserFromSession(request, response);
        if (user == null)
            return;

        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "") {
                case "add":
                    handleAddAction(request, response, user);
                    if (response.isCommitted())
                        return;
                    break;
                case "update":
                    updateAddress(request, user);
                    request.setAttribute("message", "Cập nhật địa chỉ thành công!");
                    break;
                case "delete":
                    deleteAddress(request, user);
                    request.setAttribute("message", "Xóa địa chỉ thành công!");
                    break;
                case "setDefault":
                    setDefaultAddress(request, user);
                    request.setAttribute("message", "Đã thiết lập địa chỉ mặc định!");
                    break;
                default:
                    request.setAttribute("error", "Hành động không hợp lệ!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu ID không đúng định dạng!");
        } catch (RuntimeException e) {
            request.setAttribute("error", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        loadAddressesToRequest(request, user.getId());
        request.getRequestDispatcher("addresses.jsp").forward(request, response);
    }

    private void updateAddress(HttpServletRequest request, User user) {
        int addressId = Integer.parseInt(request.getParameter("addressId"));

        verifyAddressOwnership(addressId, user.getId());

        String receiverName = request.getParameter("receiverName");
        String phoneNumber = request.getParameter("phoneNumber");
        String addressDetail = getParamTrim(request, "address");
        String city = getParamTrim(request, "city");
        boolean isDefault = "on".equals(request.getParameter("isDefault"));

        if (addressDetail.isEmpty()) {
            throw new RuntimeException("Địa chỉ không được để trống!");
        }

        if (city.isEmpty()) {
            city = inferCityFromAddress(addressDetail);
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            throw new RuntimeException("Số điện thoại không được để trống!");
        }

        if (!validateVietnamesePhone(phoneNumber.trim())) {
            throw new RuntimeException("Số điện thoại không hợp lệ. Yêu cầu: 10 chữ số. Ví dụ: 0912345678");
        }

        Address address = new Address(addressId, user.getId(), receiverName, phoneNumber, addressDetail, city,
                isDefault);
        addressDAO.updateAddress(address);
    }

    private void deleteAddress(HttpServletRequest request, User user) {
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        verifyAddressOwnership(addressId, user.getId());
        addressDAO.deleteAddress(addressId);
    }

    private void setDefaultAddress(HttpServletRequest request, User user) {
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        verifyAddressOwnership(addressId, user.getId());
        addressDAO.setDefaultAddress(user.getId(), addressId);
    }

    private void verifyAddressOwnership(int addressId, int userId) {
        Address address = addressDAO.getAddressById(addressId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy địa chỉ yêu cầu!"));

        if (address.getUserId() != userId) {
            throw new RuntimeException("Bạn không có quyền thao tác trên địa chỉ này!");
        }
    }

    private User getUserFromSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("account");
        if (user == null) {
            response.sendRedirect("login.jsp");
        }
        return user;
    }

    private void loadAddressesToRequest(HttpServletRequest request, int userId) {
        List<Address> addresses = addressDAO.getAddressesByUserId(userId);
        request.setAttribute("addresses", addresses);
    }

    private void handleAddAction(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String receiverName = request.getParameter("receiverName");
        String phoneNumber = request.getParameter("phoneNumber");
        String addressDetail = getParamTrim(request, "address");
        String city = getParamTrim(request, "city");
        boolean isDefault = "on".equals(request.getParameter("isDefault"))
                || "1".equals(request.getParameter("isDefault"));

        if (addressDetail.isEmpty()) {
            request.setAttribute("error", "Địa chỉ không được để trống!");
            return;
        }

        if (city.isEmpty()) {
            city = inferCityFromAddress(addressDetail);
        }

        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            request.setAttribute("error", "Số điện thoại không được để trống!");
            return;
        }

        if (!validateVietnamesePhone(phoneNumber.trim())) {
            request.setAttribute("error",
                    "Số điện thoại không hợp lệ. Yêu cầu: 10 chữ số, bắt đầu từ 03, 05, 07, 08 hoặc 09. Ví dụ: 0912345678");
            return;
        }

        Address address = new Address(0, user.getId(), receiverName, phoneNumber, addressDetail, city, isDefault);
        boolean success = addressDAO.addAddress(address);

        if (success) {
            request.setAttribute("message", "Thêm địa chỉ thành công!");
        } else {
            request.setAttribute("error", "Thêm địa chỉ thất bại, vui lòng thử lại!");
        }

        if (Boolean.TRUE.equals(request.getSession().getAttribute("returnToCheckout"))) {
            request.getSession().removeAttribute("returnToCheckout");
            response.sendRedirect("checkout");
        }
    }

    private boolean validateVietnamesePhone(String phone) {
        return phone != null && phone.matches("0[3578][0-9]{8}");
    }

    private String getParamTrim(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private String inferCityFromAddress(String addressDetail) {
        if (addressDetail == null) {
            return "";
        }
        String[] parts = addressDetail.split(",");
        if (parts.length < 2) {
            return "";
        }
        int start = Math.max(0, parts.length - 3);
        StringBuilder sb = new StringBuilder();
        for (int i = start; i < parts.length; i++) {
            String part = parts[i].trim();
            if (part.isEmpty()) {
                continue;
            }
            if (sb.length() > 0) {
                sb.append(", ");
            }
            sb.append(part);
        }
        return sb.toString();
    }
}