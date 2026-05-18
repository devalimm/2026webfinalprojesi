package com.ecommerce.servlet.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.PasswordUtil;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(email);

        if (user != null && PasswordUtil.verify(password, user.getPassword()) && "admin".equals(user.getRole())) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", user);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("error", "Geçersiz email, şifre veya admin yetkisi yok.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
