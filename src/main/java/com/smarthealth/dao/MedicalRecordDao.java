package com.smarthealth.dao;

import com.smarthealth.model.MedicalRecord;
import com.smarthealth.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDao {

    public List<MedicalRecord> listAll() throws SQLException {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                "CONCAT(s.first_name, ' ', s.last_name) AS doctor_name " +
                "FROM medical_records r " +
                "JOIN patients p ON r.patient_id = p.id " +
                "JOIN staff s ON r.doctor_id = s.id " +
                "ORDER BY r.visit_date DESC, r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapDetailed(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<MedicalRecord> listByPatient(int patientId) throws SQLException {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                "CONCAT(s.first_name, ' ', s.last_name) AS doctor_name " +
                "FROM medical_records r " +
                "JOIN patients p ON r.patient_id = p.id " +
                "JOIN staff s ON r.doctor_id = s.id " +
                "WHERE r.patient_id = ? " +
                "ORDER BY r.visit_date DESC, r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDetailed(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<MedicalRecord> listByDoctor(int doctorId) throws SQLException {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                "CONCAT(s.first_name, ' ', s.last_name) AS doctor_name " +
                "FROM medical_records r " +
                "JOIN patients p ON r.patient_id = p.id " +
                "JOIN staff s ON r.doctor_id = s.id " +
                "WHERE r.doctor_id = ? " +
                "ORDER BY r.visit_date DESC, r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapDetailed(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public MedicalRecord findById(int id) throws SQLException {
        String sql = "SELECT r.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                "CONCAT(s.first_name, ' ', s.last_name) AS doctor_name " +
                "FROM medical_records r " +
                "JOIN patients p ON r.patient_id = p.id " +
                "JOIN staff s ON r.doctor_id = s.id " +
                "WHERE r.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDetailed(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public int create(MedicalRecord rec) throws SQLException {
        String sql = "INSERT INTO medical_records (patient_id, doctor_id, appointment_id, visit_date, chief_complaint, diagnosis, treatment_plan, vitals_bp, vitals_temp, vitals_pulse, vitals_weight_kg, vitals_height_cm, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, rec.getPatientId());
            ps.setInt(2, rec.getDoctorId());
            if (rec.getAppointmentId() != null) {
                ps.setInt(3, rec.getAppointmentId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setDate(4, Date.valueOf(rec.getVisitDate()));
            ps.setString(5, rec.getChiefComplaint());
            ps.setString(6, rec.getDiagnosis());
            ps.setString(7, rec.getTreatmentPlan());
            ps.setString(8, rec.getVitalsBp());
            ps.setBigDecimal(9, rec.getVitalsTemp());
            if (rec.getVitalsPulse() != null) {
                ps.setShort(10, rec.getVitalsPulse());
            } else {
                ps.setNull(10, Types.SMALLINT);
            }
            ps.setBigDecimal(11, rec.getVitalsWeightKg());
            ps.setBigDecimal(12, rec.getVitalsHeightCm());
            ps.setString(13, rec.getNotes());
            
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return -1;
    }

    public void update(MedicalRecord rec) throws SQLException {
        String sql = "UPDATE medical_records SET patient_id = ?, doctor_id = ?, appointment_id = ?, visit_date = ?, chief_complaint = ?, diagnosis = ?, treatment_plan = ?, vitals_bp = ?, vitals_temp = ?, vitals_pulse = ?, vitals_weight_kg = ?, vitals_height_cm = ?, notes = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rec.getPatientId());
            ps.setInt(2, rec.getDoctorId());
            if (rec.getAppointmentId() != null) {
                ps.setInt(3, rec.getAppointmentId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setDate(4, Date.valueOf(rec.getVisitDate()));
            ps.setString(5, rec.getChiefComplaint());
            ps.setString(6, rec.getDiagnosis());
            ps.setString(7, rec.getTreatmentPlan());
            ps.setString(8, rec.getVitalsBp());
            ps.setBigDecimal(9, rec.getVitalsTemp());
            if (rec.getVitalsPulse() != null) {
                ps.setShort(10, rec.getVitalsPulse());
            } else {
                ps.setNull(10, Types.SMALLINT);
            }
            ps.setBigDecimal(11, rec.getVitalsWeightKg());
            ps.setBigDecimal(12, rec.getVitalsHeightCm());
            ps.setString(13, rec.getNotes());
            ps.setInt(14, rec.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM medical_records WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private MedicalRecord mapDetailed(ResultSet rs) throws SQLException {
        MedicalRecord rec = new MedicalRecord();
        rec.setId(rs.getInt("id"));
        rec.setPatientId(rs.getInt("patient_id"));
        rec.setDoctorId(rs.getInt("doctor_id"));
        int apptId = rs.getInt("appointment_id");
        rec.setAppointmentId(rs.wasNull() ? null : apptId);
        Date visit = rs.getDate("visit_date");
        if (visit != null) rec.setVisitDate(visit.toLocalDate());
        rec.setChiefComplaint(rs.getString("chief_complaint"));
        rec.setDiagnosis(rs.getString("diagnosis"));
        rec.setTreatmentPlan(rs.getString("treatment_plan"));
        rec.setVitalsBp(rs.getString("vitals_bp"));
        rec.setVitalsTemp(rs.getBigDecimal("vitals_temp"));
        short pulse = rs.getShort("vitals_pulse");
        rec.setVitalsPulse(rs.wasNull() ? null : pulse);
        rec.setVitalsWeightKg(rs.getBigDecimal("vitals_weight_kg"));
        rec.setVitalsHeightCm(rs.getBigDecimal("vitals_height_cm"));
        rec.setNotes(rs.getString("notes"));
        rec.setPatientName(rs.getString("patient_name"));
        rec.setDoctorName(rs.getString("doctor_name"));
        return rec;
    }
}
