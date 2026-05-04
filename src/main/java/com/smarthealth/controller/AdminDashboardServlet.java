package com.smarthealth.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.smarthealth.dao.AppointmentDao;
import com.smarthealth.dao.DoctorDao;
import com.smarthealth.dao.PatientDao;
import com.smarthealth.dao.ReportDao;
import com.smarthealth.dao.UserDao;
import com.smarthealth.model.Doctor;
import com.smarthealth.model.PatientProfile;
import com.smarthealth.model.User;
import com.smarthealth.util.AuthUtil;
import com.smarthealth.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final AppointmentDao appointmentDao = new AppointmentDao();
    private final DoctorDao doctorDao = new DoctorDao();
    private final UserDao userDao = new UserDao();
    private final PatientDao patientDao = new PatientDao();
    private final ReportDao reportDao = new ReportDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!AuthUtil.isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            req.setAttribute("appointments", appointmentDao.listAllDetailed());
            req.setAttribute("doctors", doctorDao.listAll());
            req.setAttribute("users", userDao.listAll());
            req.setAttribute("patientProfiles", patientDao.listAllProfiles());
            req.setAttribute("stats", reportDao.getStats());
        } catch (SQLException ex) {
            req.setAttribute("error", ex.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!AuthUtil.isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        try {
            switch (action) {
                case "decision" -> decision(req);
                case "addDoctor" -> addDoctor(req);
                case "updateDoctor" -> updateDoctor(req);
                case "deleteDoctor" -> deleteDoctor(req);
                case "createUser" -> createUser(req);
                case "updateUserRole" -> updateUserRole(req);
                case "deleteUser" -> deleteUser(req);
                case "updatePatientProfile" -> updatePatientProfile(req);
                case "deletePatientProfile" -> deletePatientProfile(req);
                default -> req.getSession().setAttribute("flashError", "Unknown admin action.");
            }
            req.getSession().setAttribute("flashSuccess", "Admin action completed.");
        } catch (SQLException | IllegalArgumentException ex) {
            req.getSession().setAttribute("flashError", "Admin action failed: " + ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    private void decision(HttpServletRequest req) throws SQLException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
        String status = req.getParameter("status");
        String note = req.getParameter("adminNote");
        if (!List.of("confirmed", "cancelled").contains(status)) {
            throw new IllegalArgumentException("Invalid status");
        }
        appointmentDao.updateStatus(appointmentId, status, note);
    }

    private void addDoctor(HttpServletRequest req) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorName(req.getParameter("doctorName"));
        doctor.setSpecialization(req.getParameter("specialization"));
        doctor.setScheduleDay(req.getParameter("scheduleDay"));
        doctor.setTimeSlot(req.getParameter("timeSlot"));
        doctor.setMaxPatients(Integer.parseInt(req.getParameter("maxPatients")));
        doctorDao.create(doctor);
    }

    private void updateDoctor(HttpServletRequest req) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setId(Integer.parseInt(req.getParameter("doctorId")));
        doctor.setDoctorName(req.getParameter("doctorName"));
        doctor.setSpecialization(req.getParameter("specialization"));
        doctor.setScheduleDay(req.getParameter("scheduleDay"));
        doctor.setTimeSlot(req.getParameter("timeSlot"));
        doctor.setMaxPatients(Integer.parseInt(req.getParameter("maxPatients")));
        doctorDao.update(doctor);
    }

    private void deleteDoctor(HttpServletRequest req) throws SQLException {
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));
        doctorDao.delete(doctorId);
    }

    private void createUser(HttpServletRequest req) throws SQLException {
        User user = new User();
        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPasswordHash(PasswordUtil.sha256(req.getParameter("password")));
        user.setRole(req.getParameter("role"));
        int id = userDao.create(user);
        if ("PATIENT".equals(user.getRole())) {
            patientDao.createEmptyProfile(id);
        }
    }

    private void updateUserRole(HttpServletRequest req) throws SQLException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        String role = req.getParameter("role");
        userDao.updateRole(userId, role);
        if ("PATIENT".equals(role)) {
            patientDao.createEmptyProfile(userId);
        }
    }

    private void deleteUser(HttpServletRequest req) throws SQLException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        userDao.deleteUser(userId);
    }

    private void updatePatientProfile(HttpServletRequest req) throws SQLException {
        PatientProfile profile = new PatientProfile();
        profile.setUserId(Integer.parseInt(req.getParameter("userId")));
        profile.setPhone(req.getParameter("phone"));
        profile.setAddress(req.getParameter("address"));
        profile.setGender(req.getParameter("gender"));
        String age = req.getParameter("age");
        if (age != null && !age.isBlank()) {
            profile.setAge(Integer.parseInt(age));
        }
        patientDao.saveOrUpdate(profile);
    }

    private void deletePatientProfile(HttpServletRequest req) throws SQLException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        patientDao.deleteProfile(userId);
    }
}
