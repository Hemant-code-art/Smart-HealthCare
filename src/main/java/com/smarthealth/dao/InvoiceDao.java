package com.smarthealth.dao;

import com.smarthealth.model.Invoice;
import com.smarthealth.model.InvoiceItem;
import com.smarthealth.util.DBConnection;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class InvoiceDao {

    public List<Invoice> listAll() throws SQLException {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT iv.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name " +
                "FROM invoices iv " +
                "JOIN patients p ON iv.patient_id = p.id " +
                "ORDER BY iv.issued_date DESC, iv.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Invoice iv = mapDetailed(rs);
                iv.setItems(getItemsForInvoice(conn, iv.getId()));
                list.add(iv);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public List<Invoice> listByPatient(int patientId) throws SQLException {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT iv.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name " +
                "FROM invoices iv " +
                "JOIN patients p ON iv.patient_id = p.id " +
                "WHERE iv.patient_id = ? " +
                "ORDER BY iv.issued_date DESC, iv.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice iv = mapDetailed(rs);
                    iv.setItems(getItemsForInvoice(conn, iv.getId()));
                    list.add(iv);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public Invoice findById(int id) throws SQLException {
        String sql = "SELECT iv.*, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name " +
                "FROM invoices iv " +
                "JOIN patients p ON iv.patient_id = p.id " +
                "WHERE iv.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Invoice iv = mapDetailed(rs);
                    iv.setItems(getItemsForInvoice(conn, iv.getId()));
                    return iv;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void create(Invoice iv) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert invoice record
            String sql = "INSERT INTO invoices (patient_id, appointment_id, insurance_id, issued_date, due_date, subtotal, tax, discount, insurance_cover, total, payment_status, payment_method, paid_at, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            int ivId = -1;
            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, iv.getPatientId());
                if (iv.getAppointmentId() != null) {
                    ps.setInt(2, iv.getAppointmentId());
                } else {
                    ps.setNull(2, Types.INTEGER);
                }
                if (iv.getInsuranceId() != null) {
                    ps.setInt(3, iv.getInsuranceId());
                } else {
                    ps.setNull(3, Types.INTEGER);
                }
                ps.setDate(4, Date.valueOf(iv.getIssuedDate()));
                ps.setDate(5, Date.valueOf(iv.getDueDate()));
                ps.setBigDecimal(6, iv.getSubtotal());
                ps.setBigDecimal(7, iv.getTax());
                ps.setBigDecimal(8, iv.getDiscount());
                ps.setBigDecimal(9, iv.getInsuranceCover());
                ps.setBigDecimal(10, iv.getTotal());
                ps.setString(11, iv.getPaymentStatus() != null ? iv.getPaymentStatus() : "pending");
                ps.setString(12, iv.getPaymentMethod());
                ps.setTimestamp(13, iv.getPaidAt() != null ? Timestamp.valueOf(iv.getPaidAt()) : null);
                ps.setString(14, iv.getNotes());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        ivId = keys.getInt(1);
                    }
                }
            }

            if (ivId == -1) {
                throw new SQLException("Failed to retrieve generated invoice ID.");
            }

            // Insert line items
            String itemSql = "INSERT INTO invoice_items (invoice_id, item_type, description, unit_price, quantity, total) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                for (InvoiceItem item : iv.getItems()) {
                    psItem.setInt(1, ivId);
                    psItem.setString(2, item.getItemType());
                    psItem.setString(3, item.getDescription());
                    psItem.setBigDecimal(4, item.getUnitPrice());
                    psItem.setInt(5, item.getQuantity());
                    psItem.setBigDecimal(6, item.getTotal());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw new RuntimeException(e);
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }

    public void updatePayment(int id, String status, String method, java.time.LocalDateTime paidAt) throws SQLException {
        String sql = "UPDATE invoices SET payment_status = ?, payment_method = ?, paid_at = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setTimestamp(3, paidAt != null ? Timestamp.valueOf(paidAt) : null);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM invoices WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private List<InvoiceItem> getItemsForInvoice(Connection conn, int ivId) throws SQLException {
        List<InvoiceItem> list = new ArrayList<>();
        String sql = "SELECT id, invoice_id, item_type, description, unit_price, quantity, total FROM invoice_items WHERE invoice_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ivId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceItem item = new InvoiceItem();
                    item.setId(rs.getInt("id"));
                    item.setInvoiceId(rs.getInt("invoice_id"));
                    item.setItemType(rs.getString("item_type"));
                    item.setDescription(rs.getString("description"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTotal(rs.getBigDecimal("total"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private Invoice mapDetailed(ResultSet rs) throws SQLException {
        Invoice iv = new Invoice();
        iv.setId(rs.getInt("id"));
        iv.setPatientId(rs.getInt("patient_id"));
        int apptId = rs.getInt("appointment_id");
        iv.setAppointmentId(rs.wasNull() ? null : apptId);
        int insId = rs.getInt("insurance_id");
        iv.setInsuranceId(rs.wasNull() ? null : insId);
        
        Date issued = rs.getDate("issued_date");
        if (issued != null) iv.setIssuedDate(issued.toLocalDate());
        Date due = rs.getDate("due_date");
        if (due != null) iv.setDueDate(due.toLocalDate());
        
        iv.setSubtotal(rs.getBigDecimal("subtotal"));
        iv.setTax(rs.getBigDecimal("tax"));
        iv.setDiscount(rs.getBigDecimal("discount"));
        iv.setInsuranceCover(rs.getBigDecimal("insurance_cover"));
        iv.setTotal(rs.getBigDecimal("total"));
        iv.setPaymentStatus(rs.getString("payment_status"));
        iv.setPaymentMethod(rs.getString("payment_method"));
        
        Timestamp paidAt = rs.getTimestamp("paid_at");
        if (paidAt != null) iv.setPaidAt(paidAt.toLocalDateTime());
        
        iv.setNotes(rs.getString("notes"));
        iv.setPatientName(rs.getString("patient_name"));
        return iv;
    }
}
