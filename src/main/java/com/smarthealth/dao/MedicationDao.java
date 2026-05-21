package com.smarthealth.dao;

import com.smarthealth.model.Medication;
import com.smarthealth.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicationDao {

    public List<Medication> listAll() throws SQLException {
        List<Medication> list = new ArrayList<>();
        String sql = "SELECT id, name, generic_name, category, dosage_form, unit, stock_quantity, reorder_level, unit_price, expiry_date, is_active FROM medications ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<Medication> listActive() throws SQLException {
        List<Medication> list = new ArrayList<>();
        String sql = "SELECT id, name, generic_name, category, dosage_form, unit, stock_quantity, reorder_level, unit_price, expiry_date, is_active FROM medications WHERE is_active = true ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Medication findById(int id) throws SQLException {
        String sql = "SELECT id, name, generic_name, category, dosage_form, unit, stock_quantity, reorder_level, unit_price, expiry_date, is_active FROM medications WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void create(Medication med) throws SQLException {
        String sql = "INSERT INTO medications (name, generic_name, category, dosage_form, unit, stock_quantity, reorder_level, unit_price, expiry_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, med.getName());
            ps.setString(2, med.getGenericName());
            ps.setString(3, med.getCategory());
            ps.setString(4, med.getDosageForm());
            ps.setString(5, med.getUnit());
            ps.setInt(6, med.getStockQuantity());
            ps.setInt(7, med.getReorderLevel());
            ps.setBigDecimal(8, med.getUnitPrice());
            ps.setDate(9, med.getExpiryDate() != null ? Date.valueOf(med.getExpiryDate()) : null);
            ps.setBoolean(10, med.isActive());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Medication med) throws SQLException {
        String sql = "UPDATE medications SET name = ?, generic_name = ?, category = ?, dosage_form = ?, unit = ?, stock_quantity = ?, reorder_level = ?, unit_price = ?, expiry_date = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, med.getName());
            ps.setString(2, med.getGenericName());
            ps.setString(3, med.getCategory());
            ps.setString(4, med.getDosageForm());
            ps.setString(5, med.getUnit());
            ps.setInt(6, med.getStockQuantity());
            ps.setInt(7, med.getReorderLevel());
            ps.setBigDecimal(8, med.getUnitPrice());
            ps.setDate(9, med.getExpiryDate() != null ? Date.valueOf(med.getExpiryDate()) : null);
            ps.setBoolean(10, med.isActive());
            ps.setInt(11, med.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM medications WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private Medication map(ResultSet rs) throws SQLException {
        Medication med = new Medication();
        med.setId(rs.getInt("id"));
        med.setName(rs.getString("name"));
        med.setGenericName(rs.getString("generic_name"));
        med.setCategory(rs.getString("category"));
        med.setDosageForm(rs.getString("dosage_form"));
        med.setUnit(rs.getString("unit"));
        med.setStockQuantity(rs.getInt("stock_quantity"));
        med.setReorderLevel(rs.getInt("reorder_level"));
        med.setUnitPrice(rs.getBigDecimal("unit_price"));
        Date exp = rs.getDate("expiry_date");
        if (exp != null) med.setExpiryDate(exp.toLocalDate());
        med.setActive(rs.getBoolean("is_active"));
        return med;
    }
}
