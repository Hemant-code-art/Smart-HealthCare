package com.smarthealth.dao;

import com.smarthealth.model.Doctor;
import com.smarthealth.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DoctorDao {
    public List<Doctor> listAll() throws SQLException {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT id, doctor_name, specialization, schedule_day, time_slot, max_patients FROM doctors ORDER BY doctor_name";
        try (Connection conn = DBConnection.getConnection()) {
            // First, load existing doctors
            try (PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    doctors.add(map(rs));
                }
            }

            // Next, find all users with role = 'DOCTOR'
            List<String> userDoctorNames = new ArrayList<>();
            String userSql = "SELECT full_name FROM users WHERE role = 'DOCTOR'";
            try (PreparedStatement psUser = conn.prepareStatement(userSql);
                    ResultSet rsUser = psUser.executeQuery()) {
                while (rsUser.next()) {
                    userDoctorNames.add(rsUser.getString("full_name"));
                }
            }

            // Sync missing ones
            boolean anyNew = false;
            for (String docName : userDoctorNames) {
                boolean exists = false;
                for (Doctor d : doctors) {
                    if (d.getDoctorName().equalsIgnoreCase(docName)) {
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    // Create in doctors table
                    String insertSql = "INSERT INTO doctors (name, doctor_name, specialization, schedule_day, time_slot, max_patients) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                        psInsert.setString(1, docName);
                        psInsert.setString(2, docName);
                        psInsert.setString(3, "General Practice");
                        psInsert.setString(4, "Monday-Friday");
                        psInsert.setString(5, "09:00 AM - 05:00 PM");
                        psInsert.setInt(6, 20);
                        psInsert.executeUpdate();
                        anyNew = true;
                    }
                }
            }

            // If we inserted any new doctor, reload the list
            if (anyNew) {
                doctors.clear();
                try (PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        doctors.add(map(rs));
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return doctors;
    }

    public void create(Doctor doctor) throws SQLException {
        String sql = "INSERT INTO doctors (name, doctor_name, specialization, schedule_day, time_slot, max_patients) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctor.getDoctorName());
            ps.setString(2, doctor.getDoctorName());
            ps.setString(3, doctor.getSpecialization());
            ps.setString(4, doctor.getScheduleDay());
            ps.setString(5, doctor.getTimeSlot());
            ps.setInt(6, doctor.getMaxPatients());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Doctor doctor) throws SQLException {
        String sql = "UPDATE doctors SET name = ?, doctor_name = ?, specialization = ?, schedule_day = ?, time_slot = ?, max_patients = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctor.getDoctorName());
            ps.setString(2, doctor.getDoctorName());
            ps.setString(3, doctor.getSpecialization());
            ps.setString(4, doctor.getScheduleDay());
            ps.setString(5, doctor.getTimeSlot());
            ps.setInt(6, doctor.getMaxPatients());
            ps.setInt(7, doctor.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int doctorId) throws SQLException {
        String sql = "DELETE FROM doctors WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private Doctor map(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setId(rs.getInt("id"));
        doctor.setDoctorName(rs.getString("doctor_name"));
        doctor.setSpecialization(rs.getString("specialization"));
        doctor.setScheduleDay(rs.getString("schedule_day"));
        doctor.setTimeSlot(rs.getString("time_slot"));
        doctor.setMaxPatients(rs.getInt("max_patients"));
        return doctor;
    }
}
