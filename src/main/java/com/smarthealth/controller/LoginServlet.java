package com.smarthealth.controller;

import com.smarthealth.dao.UserDao;
import com.smarthealth.model.User;
import com.smarthealth.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        if (email != null)
            email = email.trim();
        if (password != null)
            password = password.trim();

        try {
            User user = userDao.findByEmail(email);

            // Auto-init admin if missing and they are trying to login as admin
            if (user == null && "admin@health.com".equals(email)) {
                System.out.println("Admin missing. Initializing new admin [admin@health.com]...");
                User newAdmin = new User();
                newAdmin.setFullName("Super Admin");
                newAdmin.setEmail("admin@health.com");
                newAdmin.setPasswordHash(PasswordUtil.sha256("1234"));
                newAdmin.setRole("ADMIN");
                userDao.create(newAdmin);
                user = userDao.findByEmail(email);
            }

            if (user == null) {
                System.out.println("Login failed: User not found for email: " + email);
                req.setAttribute("error", "Invalid credentials.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            String providedHash = PasswordUtil.sha256(password);
            if (!user.getPasswordHash().equals(providedHash)) {
                System.out.println("Login failed: Password mismatch for email: " + email);
                System.out.println("Expected hash: " + user.getPasswordHash());
                System.out.println("Provided hash: " + providedHash);
                req.setAttribute("error", "Invalid credentials.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if ("DOCTOR".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/patient/dashboard");
            }
        } catch (SQLException ex) {
            req.setAttribute("error", "Login failed: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
