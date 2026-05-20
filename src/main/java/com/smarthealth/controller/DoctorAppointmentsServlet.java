package com.smarthealth.controller;

import com.smarthealth.dao.AppointmentDao;
import com.smarthealth.model.Appointment;
import com.smarthealth.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/appointments")
public class DoctorAppointmentsServlet extends HttpServlet {
    private final AppointmentDao appointmentDao = new AppointmentDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            List<Appointment> appointments = appointmentDao.listByDoctorName(user.getFullName());
            req.setAttribute("appointments", appointments);
        } catch (Exception e) {
            req.setAttribute("appointments", null);
        }

        req.getRequestDispatcher("/WEB-INF/views/doctor-appointments.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("updateStatus".equals(action)) {
            String appointmentIdStr = req.getParameter("appointmentId");
            String status = req.getParameter("status");
            String note = req.getParameter("note");
            try {
                int appointmentId = Integer.parseInt(appointmentIdStr);
                appointmentDao.updateStatus(appointmentId, status, note);
                session.setAttribute("flashSuccess", "Appointment status updated to \"" + status + "\".");
            } catch (Exception e) {
                session.setAttribute("flashError", "Failed to update status: " + e.getMessage());
            }
        }

        resp.sendRedirect(req.getContextPath() + "/doctor/appointments");
    }
}
