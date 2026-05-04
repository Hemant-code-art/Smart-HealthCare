package com.smarthealth.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.smarthealth.model.PatientProfile;
import com.smarthealth.util.DBConnection;

public class PatientDao {
    public void createEmptyProfile(int userId) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement check = conn.prepareStatement(
                    "SELECT 1 FROM patient_profiles WHERE user_id = ?")) {
                check.setInt(1, userId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        return;
                    }
                }
            }
            try (PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO patient_profiles (user_id) VALUES (?)")) {
                insert.setInt(1, userId);
                insert.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public PatientProfile findByUserId(int userId) throws SQLException {
        String sql = "SELECT user_id, phone, address, gender, age FROM patient_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void saveOrUpdate(PatientProfile profile) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement update = conn.prepareStatement(
                    "UPDATE patient_profiles SET phone = ?, address = ?, gender = ?, age = ? WHERE user_id = ?")) {
                update.setString(1, profile.getPhone());
                update.setString(2, profile.getAddress());
                update.setString(3, profile.getGender());
                if (profile.getAge() != null) {
                    update.setInt(4, profile.getAge());
                } else {
                    update.setNull(4, Types.INTEGER);
                }
                update.setInt(5, profile.getUserId());

                int updated = update.executeUpdate();
                if (updated > 0) {
                    return;
                }
            }

            try (PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO patient_profiles (user_id, phone, address, gender, age) VALUES (?, ?, ?, ?, ?)")) {
                insert.setInt(1, profile.getUserId());
                insert.setString(2, profile.getPhone());
                insert.setString(3, profile.getAddress());
                insert.setString(4, profile.getGender());
                if (profile.getAge() != null) {
                    insert.setInt(5, profile.getAge());
                } else {
                    insert.setNull(5, Types.INTEGER);
                }
                insert.executeUpdate();
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<PatientProfile> listAllProfiles() throws SQLException {
        List<PatientProfile> profiles = new ArrayList<>();
        String sql = "SELECT user_id, phone, address, gender, age FROM patient_profiles ORDER BY user_id DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                profiles.add(map(rs));
            }
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
        return profiles;
    }

    public void deleteProfile(int userId) throws SQLException {
        String sql = "DELETE FROM patient_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }  catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private PatientProfile map(ResultSet rs) throws SQLException {
        PatientProfile profile = new PatientProfile();
        profile.setUserId(rs.getInt("user_id"));
        profile.setPhone(rs.getString("phone"));
        profile.setAddress(rs.getString("address"));
        profile.setGender(rs.getString("gender"));
        Integer age = (Integer) rs.getObject("age");
        profile.setAge(age);
        return profile;
    }
}
