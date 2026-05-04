package com.smarthealth.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.smarthealth.model.ReportStats;
import com.smarthealth.util.DBConnection;

public class ReportDao {
    public ReportStats getStats() throws SQLException {
        ReportStats stats = new ReportStats();
        try (Connection conn = DBConnection.getConnection()) {
            stats.setTotalAppointments(singleCount(conn, "SELECT COUNT(*) FROM appointments"));
            stats.setPendingAppointments(
                    singleCount(conn, "SELECT COUNT(*) FROM appointments WHERE status = 'scheduled'"));
            stats.setApprovedAppointments(
                    singleCount(conn, "SELECT COUNT(*) FROM appointments WHERE status = 'confirmed'"));
            stats.setRejectedAppointments(
                    singleCount(conn, "SELECT COUNT(*) FROM appointments WHERE status = 'completed'"));
            stats.setCancelledAppointments(
                    singleCount(conn, "SELECT COUNT(*) FROM appointments WHERE status = 'cancelled'"));
            stats.setTotalPatients(singleCount(conn, "SELECT COUNT(*) FROM users WHERE role = 'PATIENT'"));
            stats.setTotalDoctors(singleCount(conn, "SELECT COUNT(*) FROM doctors"));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return stats;
    }

    private int singleCount(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
