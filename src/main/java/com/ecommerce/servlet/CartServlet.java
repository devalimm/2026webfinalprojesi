package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAllActive();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        @SuppressWarnings("unchecked")
        HashMap<Integer, CartItem> cart = (HashMap<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            String productIdParam = request.getParameter("productId");
            String redirectParam = request.getParameter("redirect");

            try {
                int productId = Integer.parseInt(productIdParam);
                Product product = productDAO.findById(productId);

                if (product == null) {
                    session.setAttribute("errorMessage", "Ürün bulunamadı.");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                CartItem existingItem = cart.get(productId);
                int newQuantity = existingItem != null ? existingItem.getQuantity() + 1 : 1;

                if (newQuantity > product.getStock()) {
                    session.setAttribute("errorMessage", "Yetersiz stok. Sadece " + product.getStock() + " adet kaldı.");
                } else {
                    if (existingItem != null) {
                        existingItem.setQuantity(newQuantity);
                    } else {
                        CartItem item = new CartItem(productId, product.getName(), product.getPrice(), 1, product.getStock(), product.getImageUrl());
                        cart.put(productId, item);
                    }
                    session.setAttribute("successMessage", product.getName() + " sepete eklendi.");
                }

                if ("product".equals(redirectParam)) {
                    response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Geçersiz ürün ID.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } else if ("update".equals(action)) {
            String productIdParam = request.getParameter("productId");
            String quantityParam = request.getParameter("quantity");

            try {
                int productId = Integer.parseInt(productIdParam);
                int quantity = Integer.parseInt(quantityParam);

                CartItem item = cart.get(productId);
                if (item != null) {
                    Product product = productDAO.findById(productId);
                    if (product != null && quantity > product.getStock()) {
                        session.setAttribute("errorMessage", "Yetersiz stok. Sadece " + product.getStock() + " adet kaldı.");
                    } else if (quantity <= 0) {
                        cart.remove(productId);
                        session.setAttribute("successMessage", "Ürün sepetten çıkarıldı.");
                    } else {
                        item.setQuantity(quantity);
                        session.setAttribute("successMessage", "Sepet güncellendi.");
                    }
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Geçersiz değer.");
            }
            response.sendRedirect(request.getContextPath() + "/cart");

        } else if ("remove".equals(action)) {
            String productIdParam = request.getParameter("productId");

            try {
                int productId = Integer.parseInt(productIdParam);
                cart.remove(productId);
                session.setAttribute("successMessage", "Ürün sepetten çıkarıldı.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Geçersiz ürün ID.");
            }
            response.sendRedirect(request.getContextPath() + "/cart");

        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
