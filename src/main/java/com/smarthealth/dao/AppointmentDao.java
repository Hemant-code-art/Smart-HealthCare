package com.smarthealth.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.smarthealth.model.Appointment;
import com.smarthealth.util.DBConnection;

public class AppointmentDao {
    public void book(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, scheduled_at, notes, status) VALUES (?, ?, ?, ?, 'scheduled')";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(appointment.getAppointmentDate().atStartOfDay()));
            ps.setString(4, appointment.getReason());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Appointment> listByPatient(int patientId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.id, a.patient_id, a.doctor_id, d.doctor_name, " +
                "a.scheduled_at AS appointment_date, a.notes AS reason, a.status, a.cancelled_reason AS admin_note " +
                "FROM appointments a JOIN doctors d ON a.doctor_id = d.id " +
                "WHERE a.patient_id = ? ORDER BY a.scheduled_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mapPatientAppointment(rs));
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return appointments;
    }

    public List<Appointment> listAllDetailed() throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.id, a.patient_id, a.doctor_id, a.scheduled_at AS appointment_date, " +
                "a.notes AS reason, a.status, a.cancelled_reason AS admin_note, " +
                "u.full_name AS patient_name, d.doctor_name " +
                "FROM appointments a " +
                "JOIN users u ON a.patient_id = u.id " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "ORDER BY CASE a.status WHEN 'scheduled' THEN 0 ELSE 1 END, a.scheduled_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                appointments.add(mapAdminAppointment(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return appointments;
    }

    public void updateStatus(int appointmentId, String status, String note) throws SQLException {
        String sql = "UPDATE appointments SET status = ?, cancelled_reason = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, appointmentId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void cancelByPatient(int appointmentId, int patientId) throws SQLException {
        String sql = "UPDATE appointments SET status = 'cancelled' " +
                "WHERE id = ? AND patient_id = ? AND status IN ('scheduled', 'confirmed')";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ps.setInt(2, patientId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void rescheduleByPatient(int appointmentId, int patientId, Date newDate) throws SQLException {
        String sql = "UPDATE appointments SET scheduled_at = ?, status = 'scheduled', cancelled_reason = NULL " +
                "WHERE id = ? AND patient_id = ? AND status IN ('scheduled', 'confirmed')";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new java.sql.Timestamp(newDate.getTime()));
            ps.setInt(2, appointmentId);
            ps.setInt(3, patientId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Appointment> listByDoctorName(String doctorName) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.id, a.patient_id, a.doctor_id, d.doctor_name, " +
                "a.scheduled_at AS appointment_date, a.notes AS reason, a.status, " +
                "a.cancelled_reason AS admin_note, u.full_name AS patient_name " +
                "FROM appointments a " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "JOIN users u ON a.patient_id = u.id " +
                "WHERE d.doctor_name = ? " +
                "ORDER BY a.scheduled_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctorName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mapAdminAppointment(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return appointments;
    }

    private Appointment mapPatientAppointment(ResultSet rs) throws Exception {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getInt("doctor_id"));
        appointment.setDoctorName(rs.getString("doctor_name"));
        java.sql.Timestamp scheduledAt = rs.getTimestamp("appointment_date");
        if (scheduledAt != null) {
            appointment.setAppointmentDate(scheduledAt.toLocalDateTime().toLocalDate());
        }
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        appointment.setAdminNote(rs.getString("admin_note"));
        return appointment;
    }

    private Appointment mapAdminAppointment(ResultSet rs) throws Exception {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getInt("doctor_id"));
        java.sql.Timestamp scheduledAt = rs.getTimestamp("appointment_date");
        if (scheduledAt != null) {
            appointment.setAppointmentDate(scheduledAt.toLocalDateTime().toLocalDate());
        }
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        appointment.setAdminNote(rs.getString("admin_note"));
        appointment.setPatientName(rs.getString("patient_name"));
        appointment.setDoctorName(rs.getString("doctor_name"));
        return appointment;
    }
}
