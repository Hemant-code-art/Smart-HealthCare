package com.smarthealth.controller;

import com.smarthealth.dao.AppointmentDao;
import com.smarthealth.dao.MedicalRecordDao;
import com.smarthealth.dao.PrescriptionDao;
import com.smarthealth.dao.MedicationDao;
import com.smarthealth.model.*;
import com.smarthealth.util.DBExchange;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private final AppointmentDao appointmentDao = new AppointmentDao();
    private final MedicalRecordDao medicalRecordDao = new MedicalRecordDao();
    private final PrescriptionDao prescriptionDao = new PrescriptionDao();
    private final MedicationDao medicationDao = new MedicationDao();

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

        // Auto sync
        DBExchange.sync();
        int doctorStaffId = DBExchange.getStaffIdByUserId(user.getId());

        try {
            List<Appointment> appointments = appointmentDao.listByDoctorName(user.getFullName());
            req.setAttribute("appointments", appointments);
            
            if (doctorStaffId != -1) {
                req.setAttribute("medicalRecords", medicalRecordDao.listByDoctor(doctorStaffId));
                req.setAttribute("prescriptions", prescriptionDao.listByDoctor(doctorStaffId));
            }
            
            req.setAttribute("medications", medicationDao.listActive());
            req.setAttribute("patientsTable", DBExchange.listPatientsFromTable());
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/WEB-INF/views/doctor-dashboard.jsp").forward(req, resp);
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

        DBExchange.sync();
        int doctorStaffId = DBExchange.getStaffIdByUserId(user.getId());
        if (doctorStaffId == -1) {
            session.setAttribute("flashError", "Failed to resolve staff profile for doctor.");
            resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
            return;
        }

        String action = req.getParameter("action");
        try {
            switch (action) {
                case "updateStatus" -> updateStatus(req);
                case "createMedicalRecord" -> createMedicalRecord(req, doctorStaffId);
                case "deleteMedicalRecord" -> deleteMedicalRecord(req);
                case "createPrescription" -> createPrescription(req, doctorStaffId);
                case "deletePrescription" -> deletePrescription(req);
                default -> session.setAttribute("flashError", "Unknown doctor action.");
            }
            if (session.getAttribute("flashError") == null) {
                session.setAttribute("flashSuccess", "Doctor action completed successfully.");
            }
        } catch (Exception e) {
            session.setAttribute("flashError", "Action failed: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
    }

    private void updateStatus(HttpServletRequest req) throws SQLException {
        String appointmentIdStr = req.getParameter("appointmentId");
        String status = req.getParameter("status");
        String note = req.getParameter("note");
        int appointmentId = Integer.parseInt(appointmentIdStr);
        appointmentDao.updateStatus(appointmentId, status, note);
    }

    private void createMedicalRecord(HttpServletRequest req, int doctorId) throws SQLException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        String complaint = req.getParameter("chiefComplaint");
        String diagnosis = req.getParameter("diagnosis");
        String treatment = req.getParameter("treatmentPlan");
        
        MedicalRecord rec = new MedicalRecord();
        rec.setPatientId(patientId);
        rec.setDoctorId(doctorId);
        rec.setVisitDate(LocalDate.now());
        rec.setChiefComplaint(complaint);
        rec.setDiagnosis(diagnosis);
        rec.setTreatmentPlan(treatment);
        
        String bp = req.getParameter("vitalsBp");
        rec.setVitalsBp(bp != null ? bp : "120/80");
        
        String temp = req.getParameter("vitalsTemp");
        rec.setVitalsTemp(temp != null && !temp.isBlank() ? new BigDecimal(temp) : new BigDecimal("98.6"));
        
        String pulse = req.getParameter("vitalsPulse");
        rec.setVitalsPulse(pulse != null && !pulse.isBlank() ? Short.parseShort(pulse) : (short)72);
        
        String weight = req.getParameter("vitalsWeightKg");
        rec.setVitalsWeightKg(weight != null && !weight.isBlank() ? new BigDecimal(weight) : new BigDecimal("70.0"));
        
        String height = req.getParameter("vitalsHeightCm");
        rec.setVitalsHeightCm(height != null && !height.isBlank() ? new BigDecimal(height) : new BigDecimal("175.0"));
        
        rec.setNotes(req.getParameter("notes"));
        medicalRecordDao.create(rec);
    }

    private void deleteMedicalRecord(HttpServletRequest req) throws SQLException {
        int recordId = Integer.parseInt(req.getParameter("recordId"));
        medicalRecordDao.delete(recordId);
    }

    private void createPrescription(HttpServletRequest req, int doctorId) throws SQLException {
        int patientId = Integer.parseInt(req.getParameter("patientId"));
        int medicationId = Integer.parseInt(req.getParameter("medicationId"));
        String dosage = req.getParameter("dosage");
        String freq = req.getParameter("frequency");
        int days = Integer.parseInt(req.getParameter("durationDays"));
        int qty = Integer.parseInt(req.getParameter("quantity"));
        String inst = req.getParameter("instructions");
        String rxNotes = req.getParameter("notes");

        // Lookup medication name
        Medication med = medicationDao.findById(medicationId);
        String medName = med != null ? med.getName() : "Medication";

        Prescription rx = new Prescription();
        rx.setRecordId(1); // default link
        rx.setPatientId(patientId);
        rx.setDoctorId(doctorId);
        rx.setIssuedDate(LocalDate.now());
        rx.setExpiryDate(LocalDate.now().plusDays(days));
        rx.setStatus("active");
        rx.setNotes(rxNotes);

        PrescriptionItem item = new PrescriptionItem();
        item.setMedicationId(medicationId);
        item.setMedicationName(medName);
        item.setDosage(dosage);
        item.setFrequency(freq);
        item.setDurationDays(days);
        item.setQuantity(qty);
        item.setInstructions(inst);

        rx.getItems().add(item);
        prescriptionDao.create(rx);
    }

    private void deletePrescription(HttpServletRequest req) throws SQLException {
        int rxId = Integer.parseInt(req.getParameter("prescriptionId"));
        prescriptionDao.delete(rxId);
    }
}
