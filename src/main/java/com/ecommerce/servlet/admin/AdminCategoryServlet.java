package com.ecommerce.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.model.Category;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("category", categoryDAO.findById(id));
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            request.setAttribute("action", "add");
            request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
        } else {
            request.setAttribute("categories", categoryDAO.findAll());
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
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
        CategoryDAO categoryDAO = new CategoryDAO();

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            int activeProductCount = categoryDAO.countActiveProductsByCategory(id);
            categoryDAO.delete(id);
            if (activeProductCount > 0) {
                request.getSession().setAttribute("successMessage", "Kategori pasif yapıldı.");
            } else {
                request.getSession().setAttribute("successMessage", "Kategori başarıyla silindi.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } else if ("add".equals(action) || "update".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean isActive = "on".equals(request.getParameter("is_active"));

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Kategori adı boş olamaz.");
                request.setAttribute("action", action);
                request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
                return;
            }

            Category category = new Category();
            category.setName(name.trim());
            category.setDescription(description);
            category.setActive(isActive);

            if ("add".equals(action)) {
                categoryDAO.insert(category);
                request.getSession().setAttribute("successMessage", "Kategori başarıyla eklendi.");
            } else {
                category.setId(Integer.parseInt(request.getParameter("id")));
                categoryDAO.update(category);
                request.getSession().setAttribute("successMessage", "Kategori başarıyla güncellendi.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
}
