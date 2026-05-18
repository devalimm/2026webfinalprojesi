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

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

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

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Ad soyad, e-posta ve şifre zorunludur.");
            request.setAttribute("full_name", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);

            List<Category> categories = categoryDAO.findAllActive();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 3) {
            request.setAttribute("error", "Şifre en az 3 karakter olmalıdır.");
            request.setAttribute("full_name", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);

            List<Category> categories = categoryDAO.findAllActive();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User existingUser = userDAO.findByEmail(email.trim());
        if (existingUser != null) {
            request.setAttribute("error", "Bu e-posta adresi zaten kayıtlı.");
            request.setAttribute("full_name", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);

            List<Category> categories = categoryDAO.findAllActive();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPassword(PasswordUtil.hash(password));
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");
        user.setRole("customer");

        userDAO.insert(user);

        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "Kayıt başarılı! Giriş yapabilirsiniz.");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
