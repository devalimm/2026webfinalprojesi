package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Category;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {

    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("errorMessage", "Sipariş oluşturmak için giriş yapmalısınız.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        HashMap<Integer, CartItem> cart = (HashMap<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<Category> categories = categoryDAO.findAllActive();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/order-confirmation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("errorMessage", "Sipariş oluşturmak için giriş yapmalısınız.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        @SuppressWarnings("unchecked")
        HashMap<Integer, CartItem> cart = (HashMap<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            session.setAttribute("errorMessage", "Sepetiniz boş.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            BigDecimal total = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();

            for (CartItem cartItem : cart.values()) {
                BigDecimal itemTotal = cartItem.getSubtotal();
                total = total.add(itemTotal);

                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setProductName(cartItem.getProductName());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setUnitPrice(cartItem.getPrice());
                orderItem.setSubtotal(itemTotal);
                orderItems.add(orderItem);
            }

            Order order = new Order();
            order.setUserId(user.getId());
            order.setTotalAmount(total);
            order.setShippingAddress(user.getAddress());
            order.setStatus("Beklemede");

            int orderId = orderDAO.createOrder(order, orderItems);

            if (orderId > 0) {
                session.removeAttribute("cart");
                session.setAttribute("successMessage", "Siparişiniz başarıyla oluşturuldu!");
                response.sendRedirect(request.getContextPath() + "/my-orders");
            } else {
                session.setAttribute("errorMessage", "Sipariş oluşturulamadı. Stok yetersiz olabilir.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Sipariş oluşturulamadı. Lütfen tekrar deneyin.");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
