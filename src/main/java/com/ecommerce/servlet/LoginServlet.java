package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.User;
import com.ecommerce.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<Category> categories = categoryDAO.findAllActive();
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "E-posta ve şifre zorunludur.");

            List<Category> categories = categoryDAO.findAllActive();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email.trim());

        if (user != null && PasswordUtil.verify(password, user.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "Geçersiz e-posta veya şifre.");

            List<Category> categories = categoryDAO.findAllActive();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
