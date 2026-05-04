CREATE DATABASE IF NOT EXISTS smart_health_db;
USE smart_health_db;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('PATIENT', 'ADMIN', 'DOCTOR') NOT NULL DEFAULT 'PATIENT',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS patient_profiles (
    user_id INT PRIMARY KEY,
    phone VARCHAR(20),
    address VARCHAR(255),
    gender VARCHAR(20),
    age INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(120) NOT NULL,
    specialization VARCHAR(120) NOT NULL,
    schedule_day VARCHAR(20) NOT NULL,
    time_slot VARCHAR(40) NOT NULL,
    max_patients INT NOT NULL DEFAULT 20
);

CREATE TABLE IF NOT EXISTS appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    reason VARCHAR(255),
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    admin_note VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

INSERT INTO users (full_name, email, password_hash, role)
VALUES ('System Admin', 'admin@smarthealth.com',
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'ADMIN')
ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash), role = VALUES(role);

INSERT INTO doctors (doctor_name, specialization, schedule_day, time_slot, max_patients)
VALUES ('Dr. Maya Shah', 'Cardiology', 'Monday', '09:00 - 12:00', 18),
       ('Dr. Liam Turner', 'Dermatology', 'Tuesday', '10:00 - 14:00', 15),
       ('Dr. Sofia Kim', 'Pediatrics', 'Wednesday', '08:30 - 12:30', 20),
       ('Dr. Noah Patel', 'Orthopedics', 'Friday', '11:00 - 15:00', 16)
ON DUPLICATE KEY UPDATE doctor_name = VALUES(doctor_name);
