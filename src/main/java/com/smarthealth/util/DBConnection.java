package com.smarthealth.util;

import java.sql.Connection;
import java.sql.DriverManager;



public final class DBConnection {
    private static final String DB_URL = System.getenv().getOrDefault("SMART_HEALTH_DB_URL",
        "jdbc:mysql://localhost:3306/smart_health_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    private static final String DB_USER = System.getenv().getOrDefault("SMART_HEALTH_DB_USER", "root");
    private static final String DB_PASS = System.getenv().getOrDefault("SMART_HEALTH_DB_PASS", "1234");

    private DBConnection() {
    }

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}
