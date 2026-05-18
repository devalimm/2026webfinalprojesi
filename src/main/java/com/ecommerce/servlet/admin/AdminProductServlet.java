package com.ecommerce.servlet.admin;

import java.io.IOException;
import java.math.BigDecimal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

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
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("product", productDAO.findById(id));
            request.setAttribute("categories", categoryDAO.findAllActive());
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            request.setAttribute("categories", categoryDAO.findAllActive());
            request.setAttribute("action", "add");
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
        } else {
            request.setAttribute("products", productDAO.findAllAdmin());
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
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
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        if ("toggle".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean active = "true".equals(request.getParameter("active"));
            productDAO.toggleActive(id, active);
            request.getSession().setAttribute("successMessage", "Ürün durumu güncellendi.");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.delete(id);
            request.getSession().setAttribute("successMessage", "Ürün pasif yapıldı.");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        } else if ("add".equals(action) || "update".equals(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String categoryIdStr = request.getParameter("category_id");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("image_url");
            boolean isActive = "on".equals(request.getParameter("is_active"));

            StringBuilder errors = new StringBuilder();

            if (name == null || name.trim().isEmpty()) {
                errors.append("Ürün adı boş olamaz. ");
            }

            BigDecimal price = null;
            try {
                price = new BigDecimal(priceStr);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    errors.append("Fiyat 0'dan büyük olmalıdır. ");
                }
            } catch (Exception e) {
                errors.append("Geçerli bir fiyat giriniz. ");
            }

            int stock = -1;
            try {
                stock = Integer.parseInt(stockStr);
                if (stock < 0) {
                    errors.append("Stok negatif olamaz. ");
                }
            } catch (Exception e) {
                errors.append("Geçerli bir stok değeri giriniz. ");
            }

            int categoryId = -1;
            try {
                categoryId = Integer.parseInt(categoryIdStr);
                if (categoryId <= 0) {
                    errors.append("Geçerli bir kategori seçiniz. ");
                }
            } catch (Exception e) {
                errors.append("Geçerli bir kategori seçiniz. ");
            }

            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString().trim());
                request.setAttribute("categories", categoryDAO.findAllActive());
                request.setAttribute("action", action);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                return;
            }

            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description);
            product.setPrice(price);
            product.setStock(stock);
            product.setCategoryId(categoryId);
            product.setImageUrl(imageUrl);
            product.setActive(isActive);

            if ("add".equals(action)) {
                productDAO.insert(product);
                request.getSession().setAttribute("successMessage", "Ürün başarıyla eklendi.");
            } else {
                product.setId(Integer.parseInt(request.getParameter("id")));
                productDAO.update(product);
                request.getSession().setAttribute("successMessage", "Ürün başarıyla güncellendi.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}
