package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.OrderDAO;
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
import java.util.List;

@WebServlet(name = "MyOrdersServlet", urlPatterns = {"/my-orders"})
public class MyOrdersServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("errorMessage", "Siparişlerinizi görüntülemek için giriş yapmalısınız.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Category> categories = categoryDAO.findAllActive();
        request.setAttribute("categories", categories);

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(idParam);
                Order order = orderDAO.findById(orderId);

                if (order == null || order.getUserId() != user.getId()) {
                    session.setAttribute("errorMessage", "Sipariş bulunamadı.");
                    response.sendRedirect(request.getContextPath() + "/my-orders");
                    return;
                }

                List<OrderItem> items = orderDAO.findItemsByOrderId(orderId);

                request.setAttribute("orderDetail", order);
                request.setAttribute("orderItems", items);
                request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
            }
        } else {
            List<Order> orders = orderDAO.findByUserId(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
        }
    }
}
