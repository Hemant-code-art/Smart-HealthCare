package com.smarthealth.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.smarthealth.dao.AppointmentDao;
import com.smarthealth.dao.DoctorDao;
import com.smarthealth.dao.PatientDao;
import com.smarthealth.model.Appointment;
import com.smarthealth.model.PatientProfile;
import com.smarthealth.model.User;
import com.smarthealth.util.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
    private final DoctorDao doctorDao = new DoctorDao();
    private final AppointmentDao appointmentDao = new AppointmentDao();
    private final PatientDao patientDao = new PatientDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!AuthUtil.isPatient(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = AuthUtil.getSessionUser(req);
        try {
            req.setAttribute("doctors", doctorDao.listAll());
            req.setAttribute("appointments", appointmentDao.listByPatient(user.getId()));

            PatientProfile profile = patientDao.findByUserId(user.getId());
            if (profile == null) {
                patientDao.createEmptyProfile(user.getId());
                profile = patientDao.findByUserId(user.getId());
            }
            req.setAttribute("profile", profile);
        } catch (SQLException ex) {
            req.setAttribute("error", ex.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/patient-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        if (!AuthUtil.isPatient(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = AuthUtil.getSessionUser(req);
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "book" -> book(req, user.getId());
                case "updateProfile" -> updateProfile(req, user.getId());
                case "cancel" -> cancel(req, user.getId());
                case "reschedule" -> reschedule(req, user.getId());
                default -> req.getSession().setAttribute("flashError", "Unknown action.");
            }
            req.getSession().setAttribute("flashSuccess", "Action completed successfully.");
        } catch (SQLException | IllegalArgumentException | DateTimeParseException ex) {
            req.getSession().setAttribute("flashError", "Action failed: " + ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/patient/dashboard");
    }

    private void book(HttpServletRequest req, int patientId) throws SQLException {
        int doctorId = Integer.parseInt(req.getParameter("doctorId"));
        LocalDate date = LocalDate.parse(req.getParameter("appointmentDate"));
        String reason = req.getParameter("reason");

        Appointment appointment = new Appointment();
        appointment.setPatientId(patientId);
        appointment.setDoctorId(doctorId);
        appointment.setAppointmentDate(date);
        appointment.setReason(reason);
        appointmentDao.book(appointment);
    }

    private void updateProfile(HttpServletRequest req, int patientId) throws SQLException {
        PatientProfile profile = new PatientProfile();
        profile.setUserId(patientId);
        profile.setPhone(req.getParameter("phone"));
        profile.setAddress(req.getParameter("address"));
        profile.setGender(req.getParameter("gender"));
        String age = req.getParameter("age");
        if (age != null && !age.isBlank()) {
            profile.setAge(Integer.parseInt(age));
        }
        patientDao.saveOrUpdate(profile);
    }

    private void cancel(HttpServletRequest req, int patientId) throws SQLException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
        appointmentDao.cancelByPatient(appointmentId, patientId);
    }

    private void reschedule(HttpServletRequest req, int patientId) throws SQLException {
        int appointmentId = Integer.parseInt(req.getParameter("appointmentId"));
        Date newDate = Date.valueOf(req.getParameter("newDate"));
        appointmentDao.rescheduleByPatient(appointmentId, patientId, newDate);
    }
}
