package controller;

import dal.AddressDAO;
import dal.CartDAO;
import dal.OrderDAO;
import model.Address;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Product;
import model.User;
import service.GHNService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "CheckoutServlet", urlPatterns = { "/checkout" })
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private AddressDAO addressDAO = new AddressDAO();
    private CartDAO cartDAO = new CartDAO();
    private GHNService ghnService = new GHNService();

    private static final int STORE_DISTRICT_ID = 1442;

    private List<CartItem> resolveCheckoutCart(HttpServletRequest req, HttpSession session) {
        List<CartItem> buyNowCart = (List<CartItem>) session.getAttribute("buyNowCart");
        Boolean isBuyNow = (Boolean) session.getAttribute("isBuyNow");

        if (isBuyNow != null && isBuyNow && buyNowCart != null && !buyNowCart.isEmpty()) {
            return buyNowCart;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        String[] selectedPids = req.getParameterValues("selectedPids");

        if (selectedPids == null || selectedPids.length == 0) {
            List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("checkoutCart");
            if (checkoutCart != null && !checkoutCart.isEmpty()) {
                return checkoutCart;
            }
            session.removeAttribute("checkoutCart");
            return cart;
        }

        Set<Integer> selectedIds = new HashSet<>();
        for (String selectedPid : selectedPids) {
            try {
                selectedIds.add(Integer.parseInt(selectedPid));
            } catch (NumberFormatException ignored) {
            }
        }

        List<CartItem> selectedItems = new ArrayList<>();
        if (cart != null) {
            for (CartItem item : cart) {
                Product product = item.getProduct();
                if (product != null && selectedIds.contains(product.getId())) {
                    selectedItems.add(item);
                }
            }
        }

        session.setAttribute("checkoutCart", selectedItems);
        return selectedItems;
    }

    private void syncCheckoutCartImages(List<CartItem> cart) {
        for (CartItem item : cart) {
            Product product = item.getProduct();
            if (product != null && (product.getImage() == null || product.getImage().trim().isEmpty())
                    && product.getProductImages() != null && !product.getProductImages().isEmpty()
                    && product.getProductImages().get(0).getImageUrl() != null
                    && !product.getProductImages().get(0).getImageUrl().trim().isEmpty()) {
                product.setImage(product.getProductImages().get(0).getImageUrl());
            }
        }
    }

    private void removePurchasedItemsFromCart(HttpSession session, List<CartItem> purchasedItems, Integer userId) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty() || purchasedItems == null || purchasedItems.isEmpty()) {
            return;
        }

        Set<Integer> purchasedIds = new HashSet<>();
        for (CartItem item : purchasedItems) {
            if (item.getProduct() != null) {
                purchasedIds.add(item.getProduct().getId());
            }
        }

        cart.removeIf(item -> item.getProduct() != null && purchasedIds.contains(item.getProduct().getId()));

        double totalMoney = 0;
        int totalQuantity = 0;
        for (CartItem item : cart) {
            totalMoney += item.getTotalPrice().doubleValue();
            totalQuantity += item.getQuantity();
        }

        if (cart.isEmpty()) {
            session.removeAttribute("cart");
            session.removeAttribute("size");
            session.removeAttribute("totalMoney");
        } else {
            session.setAttribute("cart", cart);
            session.setAttribute("size", cart.size());
            session.setAttribute("totalMoney", totalMoney);
        }

        if (userId != null) {
            cartDAO.replaceCartItems(userId, cart);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cart = resolveCheckoutCart(req, session);

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        syncCheckoutCartImages(cart);
        session.setAttribute("checkoutCart", cart);

        List<Address> addresses = addressDAO.getAddressesByUserId(user.getId());

        Address defaultAddress = null;

        if (addresses == null || addresses.isEmpty()) {
            req.setAttribute("addresses", new ArrayList<Address>());
            req.setAttribute("addressMissing", true);
            req.setAttribute("addressMessage", "Bạn chưa có địa chỉ nhận hàng. Hãy thêm địa chỉ trước khi đặt hàng.");
        } else {
            req.setAttribute("addresses", addresses);
            for (Address a : addresses) {
                if (a.isDefault()) {
                    defaultAddress = a;
                    break;
                }
            }
            if (defaultAddress == null) {
                defaultAddress = addresses.get(0);
            }
        }

        req.setAttribute("user", user);

        double totalProducts = 0;
        double totalOriginalPrice = 0;
        int totalWeight = 0;

        for (CartItem item : cart) {
            totalProducts += item.getFinalPrice().doubleValue() * item.getQuantity();
            totalOriginalPrice += item.getOriginalPrice().doubleValue() * item.getQuantity();
            totalWeight += 500 * item.getQuantity();
        }

        double shippingFee = 0;
        if (defaultAddress != null && defaultAddress.getDistrictId() > 0) {
            try {
                shippingFee = ghnService.calculateShippingFee(STORE_DISTRICT_ID, defaultAddress.getDistrictId(),
                        defaultAddress.getWardCode(), totalWeight, (int) totalProducts);
            } catch (Exception e) {
                e.printStackTrace();
                shippingFee = 30000;
            }
        } else if (defaultAddress != null) {
            shippingFee = 30000;
        }

        double discount = 0;
        double finalAmount = totalProducts + shippingFee - discount;

        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalOriginalPrice", totalOriginalPrice);
        req.setAttribute("shippingFee", shippingFee);
        req.setAttribute("discount", discount);
        req.setAttribute("finalAmount", finalAmount);
        req.setAttribute("storeDistrictId", 1442);
        req.setAttribute("totalWeight", totalWeight);

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String addressIdStr = req.getParameter("addressId");
        String fullname;
        String phone;
        String address;
        int toDistrictId = 0;
        String toWardCode = null;

        if (addressIdStr != null && !addressIdStr.isEmpty()) {
            int addressId = Integer.parseInt(addressIdStr);

            Address selectedAddress = addressDAO.getAddressById(addressId).orElse(null);

            if (selectedAddress != null && selectedAddress.getUserId() == user.getId()) {
                fullname = selectedAddress.getReceiverName();
                phone = selectedAddress.getPhoneNumber();
                address = selectedAddress.getAddress() + ", " + selectedAddress.getCity();
                toDistrictId = selectedAddress.getDistrictId();
                toWardCode = selectedAddress.getWardCode();
            } else {
                fullname = req.getParameter("fullname");
                phone = req.getParameter("phone");
                address = req.getParameter("address");
            }
        } else {
            fullname = req.getParameter("fullname");
            phone = req.getParameter("phone");
            address = req.getParameter("address");
        }

        String note = req.getParameter("note");
        String paymentMethod = req.getParameter("paymentMethod");

        if (fullname == null || fullname.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                paymentMethod == null) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            doGet(req, resp);
            return;
        }

        List<CartItem> cart = resolveCheckoutCart(req, session);

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart.jsp");
            return;
        }

        syncCheckoutCartImages(cart);

        dal.ProductDAO productDAO = new dal.ProductDAO();
        for (CartItem item : cart) {
            Product currentProduct = productDAO.getProductByID(item.getProduct().getId());

            if (currentProduct == null || currentProduct.getStatus() != 1) {
                req.setAttribute("error", "Sản phẩm [" + item.getProduct().getName()
                        + "] hiện không còn kinh doanh. Vui lòng xóa khỏi giỏ hàng!");
                doGet(req, resp);
                return;
            }

            if (item.getQuantity() > currentProduct.getQuantity()) {
                req.setAttribute("error", "Sản phẩm [" + item.getProduct().getName() + "] chỉ còn "
                        + currentProduct.getQuantity() + " sản phẩm trong kho. Vui lòng cập nhật lại số lượng!");
                doGet(req, resp);
                return;
            }
        }

        try {
            double totalProducts = 0;
            int totalWeight = 0;
            for (CartItem item : cart) {
                totalProducts += item.getFinalPrice().doubleValue() * item.getQuantity();
                totalWeight += 500 * item.getQuantity();
            }
            double shippingFee = 30000;
            if (toDistrictId > 0) {
                try {
                    shippingFee = ghnService.calculateShippingFee(STORE_DISTRICT_ID, toDistrictId, toWardCode, totalWeight,
                            (int) totalProducts);
                } catch (Exception e) {
                    e.printStackTrace();
                    shippingFee = 30000;
                }
            }

            double discount = 0;
            double finalAmount = totalProducts + shippingFee - discount;

            Order order = new Order();
            order.setUserId(user.getId());
            order.setFullname(fullname);
            order.setPhone(phone);
            order.setAddress(address);
            order.setNote(note);
            order.setTotalProductsMoney(totalProducts);
            order.setShippingFee(shippingFee);
            order.setDiscountAmount(discount);
            order.setFinalAmount(finalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus(0);
            order.setStatus("pending");

            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem cartItem : cart) {
                OrderItem item = new OrderItem();
                item.setProductId(cartItem.getProduct().getId());
                item.setProductName(cartItem.getProduct().getName());
                item.setDealType(cartItem.getDealType());
                item.setDealId(cartItem.getDealId());
                item.setOriginalPrice(cartItem.getOriginalPrice());
                item.setDiscountAmount(cartItem.getDiscountAmount());
                item.setFinalPrice(cartItem.getFinalPrice());
                item.setQuantity(cartItem.getQuantity());
                item.setTotal(cartItem.getTotalPrice());
                orderItems.add(item);
            }

            int orderId = orderDAO.placeOrder(order, orderItems);

            if (orderId > 0) {

                try {
                    dal.NotificationDAO notificationDAO = new dal.NotificationDAO();
                    String notifLink = "/admin/orders" + orderId;

                    notificationDAO.insert(
                            "order",
                            "Đơn hàng mới #" + orderId,
                            "Khách hàng " + fullname + " vừa đặt hàng.",
                            notifLink);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                Boolean isBuyNow = (Boolean) session.getAttribute("isBuyNow");
                if (isBuyNow != null && isBuyNow) {
                    session.removeAttribute("buyNowCart");
                    session.removeAttribute("isBuyNow");
                } else {
                    removePurchasedItemsFromCart(session, cart, user.getId());
                }

                session.removeAttribute("checkoutCart");
                if ("vnpay".equals(paymentMethod) || "VNPay".equalsIgnoreCase(paymentMethod)) {
                    resp.sendRedirect(req.getContextPath() + "/vnpay-payment?orderId=" + orderId + "&amount="
                            + (long) finalAmount);
                } else {
                    session.setAttribute("successMessage", "Đặt hàng thành công! Mã đơn hàng: #" + orderId);
                    resp.sendRedirect(req.getContextPath() + "/order-detail?id=" + orderId);
                }
            } else {
                req.setAttribute("error", "Có lỗi xảy ra khi tạo đơn hàng!");
                doGet(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(req, resp);
        }
    }
}
