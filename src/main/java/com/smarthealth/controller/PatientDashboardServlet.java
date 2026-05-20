package com.smarthealth.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

import com.smarthealth.dao.*;
import com.smarthealth.model.*;
import com.smarthealth.util.AuthUtil;
import com.smarthealth.util.DBExchange;

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
    private final MedicalRecordDao medicalRecordDao = new MedicalRecordDao();
    private final PrescriptionDao prescriptionDao = new PrescriptionDao();
    private final InsuranceDao insuranceDao = new InsuranceDao();
    private final InvoiceDao invoiceDao = new InvoiceDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!AuthUtil.isPatient(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Auto sync
        DBExchange.sync();

        User user = AuthUtil.getSessionUser(req);
        int patientTableId = DBExchange.getPatientIdByUserId(user.getId());

        try {
            req.setAttribute("doctors", doctorDao.listAll());
            req.setAttribute("appointments", appointmentDao.listByPatient(user.getId()));

            PatientProfile profile = patientDao.findByUserId(user.getId());
            if (profile == null) {
                patientDao.createEmptyProfile(user.getId());
                profile = patientDao.findByUserId(user.getId());
            }
            req.setAttribute("profile", profile);

            if (patientTableId != -1) {
                req.setAttribute("medicalRecords", medicalRecordDao.listByPatient(patientTableId));
                req.setAttribute("prescriptions", prescriptionDao.listByPatient(patientTableId));
                req.setAttribute("insuranceList", insuranceDao.listByPatient(patientTableId));
                req.setAttribute("invoices", invoiceDao.listByPatient(patientTableId));
            }
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

        // Auto sync
        DBExchange.sync();

        User user = AuthUtil.getSessionUser(req);
        int patientTableId = DBExchange.getPatientIdByUserId(user.getId());
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "book" -> book(req, user.getId());
                case "updateProfile" -> updateProfile(req, user.getId());
                case "cancel" -> cancel(req, user.getId());
                case "reschedule" -> reschedule(req, user.getId());
                case "addInsurance" -> addInsurance(req, patientTableId);
                case "deleteInsurance" -> deleteInsurance(req);
                case "payInvoice" -> payInvoice(req);
                default -> req.getSession().setAttribute("flashError", "Unknown action.");
            }
            if (req.getSession().getAttribute("flashError") == null) {
                req.getSession().setAttribute("flashSuccess", "Action completed successfully.");
            }
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
        DBExchange.sync(); // Propagate change to patients table
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

    private void addInsurance(HttpServletRequest req, int patientId) throws SQLException {
        if (patientId == -1) {
            throw new IllegalArgumentException("No patient record found to link insurance policy.");
        }
        Insurance ins = new Insurance();
        ins.setPatientId(patientId);
        ins.setProviderName(req.getParameter("providerName"));
        ins.setPolicyNumber(req.getParameter("policyNumber"));
        ins.setGroupNumber(req.getParameter("groupNumber"));
        ins.setHolderName(req.getParameter("holderName"));
        ins.setValidFrom(LocalDate.parse(req.getParameter("validFrom")));
        String validTo = req.getParameter("validTo");
        if (validTo != null && !validTo.isBlank()) {
            ins.setValidTo(LocalDate.parse(validTo));
        }
        ins.setCoverageLimit(new BigDecimal(req.getParameter("coverageLimit")));
        ins.setPrimary(req.getParameter("isPrimary") != null);
        ins.setActive(true);
        insuranceDao.create(ins);
    }

    private void deleteInsurance(HttpServletRequest req) throws SQLException {
        int insId = Integer.parseInt(req.getParameter("insuranceId"));
        insuranceDao.delete(insId);
    }

    private void payInvoice(HttpServletRequest req) throws SQLException {
        int invoiceId = Integer.parseInt(req.getParameter("invoiceId"));
        String paymentMethod = req.getParameter("paymentMethod");
        invoiceDao.updatePayment(invoiceId, "paid", paymentMethod, LocalDateTime.now());
    }
}
