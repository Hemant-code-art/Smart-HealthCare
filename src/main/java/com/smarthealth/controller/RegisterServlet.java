package com.smarthealth.controller;

import com.smarthealth.dao.DoctorDao;
import com.smarthealth.dao.PatientDao;
import com.smarthealth.dao.UserDao;
import com.smarthealth.model.Doctor;
import com.smarthealth.model.User;
import com.smarthealth.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();
    private final PatientDao patientDao = new PatientDao();
    private final DoctorDao doctorDao = new DoctorDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        // Normalise role — default to PATIENT
        if (role == null || (!role.equalsIgnoreCase("DOCTOR") && !role.equalsIgnoreCase("PATIENT"))) {
            role = "PATIENT";
        }
        role = role.toUpperCase();

        if (fullName == null || fullName.isBlank() || email == null || email.isBlank()
                || password == null || password.length() < 6) {
            req.setAttribute("error", "Provide valid details. Password must be at least 6 characters.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userDao.findByEmail(email) != null) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setPasswordHash(PasswordUtil.sha256(password));
            user.setRole(role);
            int userId = userDao.create(user);

            if ("DOCTOR".equals(role)) {
                // Also insert a row in the doctors table
                String specialization = req.getParameter("specialization");
                String scheduleDay    = req.getParameter("scheduleDay");
                String timeSlot       = req.getParameter("timeSlot");
                String maxPatientsStr = req.getParameter("maxPatients");

                int maxPatients = 20;
                try { maxPatients = Integer.parseInt(maxPatientsStr); } catch (NumberFormatException ignored) {}

                Doctor doctor = new Doctor();
                doctor.setDoctorName(fullName.trim());
                doctor.setSpecialization(specialization != null && !specialization.isBlank() ? specialization : "General Practice");
                doctor.setScheduleDay(scheduleDay != null ? scheduleDay : "");
                doctor.setTimeSlot(timeSlot != null ? timeSlot : "");
                doctor.setMaxPatients(maxPatients);
                doctorDao.create(doctor);

            } else {
                // PATIENT — create empty profile
                patientDao.createEmptyProfile(userId);
            }

            resp.sendRedirect(req.getContextPath() + "/login?registered=true");

        } catch (SQLException ex) {
            req.setAttribute("error", "Registration failed: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }
}
