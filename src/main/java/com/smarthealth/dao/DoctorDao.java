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
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                doctors.add(map(rs));
            }
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
        return doctors;
    }

    public void create(Doctor doctor) throws SQLException {
        String sql = "INSERT INTO doctors (doctor_name, specialization, schedule_day, time_slot, max_patients) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctor.getDoctorName());
            ps.setString(2, doctor.getSpecialization());
            ps.setString(3, doctor.getScheduleDay());
            ps.setString(4, doctor.getTimeSlot());
            ps.setInt(5, doctor.getMaxPatients());
            ps.executeUpdate();
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Doctor doctor) throws SQLException {
        String sql = "UPDATE doctors SET doctor_name = ?, specialization = ?, schedule_day = ?, time_slot = ?, max_patients = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, doctor.getDoctorName());
            ps.setString(2, doctor.getSpecialization());
            ps.setString(3, doctor.getScheduleDay());
            ps.setString(4, doctor.getTimeSlot());
            ps.setInt(5, doctor.getMaxPatients());
            ps.setInt(6, doctor.getId());
            ps.executeUpdate();
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int doctorId) throws SQLException {
        String sql = "DELETE FROM doctors WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.executeUpdate();
        }  catch (Exception e) {
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
