package com.smarthealth.controller;

import com.smarthealth.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;

@WebServlet("/fix-db")
public class SchemaFixServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        out.println("<html><body><h1>Database Schema Fixer</h1>");

        try (Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement()) {

            out.println("<p>Connected to database. Running fixes...</p>");

            // 1. Fix Users Role
            out.println("<p>Updating [users] role list...</p>");
            st.executeUpdate(
                    "ALTER TABLE users MODIFY COLUMN role ENUM('PATIENT', 'ADMIN', 'DOCTOR') NOT NULL DEFAULT 'PATIENT'");

            // 2. Fix Appointments Columns
            out.println("<p>Renaming [appointments] columns (scheduled_at -> appointment_date)...</p>");
            try {
                st.executeUpdate("ALTER TABLE appointments CHANGE scheduled_at appointment_date DATE NOT NULL");
            } catch (Exception e) {
                out.println("<p>Skipped scheduled_at (already renamed or missing)</p>");
            }

            try {
                st.executeUpdate("ALTER TABLE appointments CHANGE notes reason VARCHAR(255)");
            } catch (Exception e) {
                out.println("<p>Skipped notes (already renamed or missing)</p>");
            }

            try {
                st.executeUpdate("ALTER TABLE appointments CHANGE cancelled_reason admin_note VARCHAR(255)");
            } catch (Exception e) {
                out.println("<p>Skipped cancelled_reason (already renamed or missing)</p>");
            }

            st.executeUpdate(
                    "ALTER TABLE appointments MODIFY COLUMN status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING'");

            // 3. Fix Doctors Table
            out.println("<p>Updating [doctors] column (name -> doctor_name)...</p>");
            try {
                st.executeUpdate("ALTER TABLE doctors CHANGE name doctor_name VARCHAR(120) NOT NULL");
            } catch (Exception e) {
                out.println("<p>Skipped doctor name (already renamed or missing)</p>");
            }

            // 4. Insert Admin
            out.println("<p>Ensuring Admin user exists...</p>");
            st.executeUpdate("INSERT INTO users (full_name, email, password_hash, role) " +
                    "VALUES ('System Admin', 'admin@smarthealth.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'ADMIN') "
                    +
                    "ON DUPLICATE KEY UPDATE role = 'ADMIN'");

            out.println("<h2 style='color:green'>Success! All database fixes applied.</h2>");
            out.println("<p><a href='" + req.getContextPath() + "/login'>Go to Login</a></p>");

        } catch (Exception e) {
            out.println("<h2 style='color:red'>Error applying fixes</h2>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(out);
        }

        out.println("</body></html>");
    }
}
