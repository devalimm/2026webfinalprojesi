package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 12;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException e) {}

        List<Product> products;
        int totalProducts;

        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.search(search.trim());
            totalProducts = products.size();
            int fromIndex = (page - 1) * pageSize;
            if (fromIndex > products.size()) fromIndex = 0;
            int toIndex = Math.min(fromIndex + pageSize, products.size());
            products = products.subList(fromIndex, toIndex);
        } else {
            products = productDAO.findPaginated(page, pageSize);
            totalProducts = productDAO.countAll();
        }

        List<Category> categories = categoryDAO.findAllActive();

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
