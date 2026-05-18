package com.ecommerce.servlet.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.Category;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UserDAO userDAO = new UserDAO();
        OrderDAO orderDAO = new OrderDAO();

        request.setAttribute("totalProducts", productDAO.countAllAdmin());
        request.setAttribute("totalCategories", categoryDAO.countAll());
        request.setAttribute("totalUsers", userDAO.countAll());
        request.setAttribute("totalOrders", orderDAO.countAll());
        request.setAttribute("pendingOrders", orderDAO.countByStatus("Beklemede"));

        List<Category> categories = categoryDAO.findAll();
        List<Map<String, Object>> categoryStats = new ArrayList<>();
        int maxCount = 1;

        for (Category category : categories) {
            int count = categoryDAO.countActiveProductsByCategory(category.getId());
            if (count > maxCount) maxCount = count;
            Map<String, Object> stat = new HashMap<>();
            stat.put("name", category.getName());
            stat.put("productCount", count);
            categoryStats.add(stat);
        }

        request.setAttribute("categoryStats", categoryStats);
        request.setAttribute("maxProductCount", maxCount);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
