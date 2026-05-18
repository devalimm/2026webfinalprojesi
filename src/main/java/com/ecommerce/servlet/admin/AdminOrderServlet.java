package com.ecommerce.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.OrderDAO;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            request.setAttribute("order", orderDAO.findById(id));
            request.setAttribute("orderItems", orderDAO.findItemsByOrderId(id));
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
        } else {
            request.setAttribute("orders", orderDAO.findAll());
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.updateStatus(id, status);
            request.getSession().setAttribute("successMessage", "Sipariş durumu güncellendi.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
