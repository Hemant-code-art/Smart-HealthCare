<%@ page import="java.sql.*, com.smarthealth.util.DBConnection" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <html>

        <head>
            <title>DB Debug</title>
        </head>

        <body>
            <h1>Database Debug Info</h1>
            <% try { Connection conn=DBConnection.getConnection(); out.println("<p style='color:green'>Connection
                Successful!</p>");
                out.println("<p>Checking <b>users</b> table...</p>");

                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT count(*) FROM users");
                if (rs.next()) {
                out.println("<p>Total users in DB: " + rs.getInt(1) + "</p>");
                }

                out.println("<p>Checking for admin user (admin@smarthealth.com)...</p>");
                PreparedStatement ps = conn.prepareStatement("SELECT full_name, role FROM users WHERE email = ?");
                ps.setString(1, "admin@smarthealth.com");
                ResultSet rs2 = ps.executeQuery();
                if (rs2.next()) {
                out.println("<p style='color:blue'>Found Admin: " + rs2.getString("full_name") + " with role: " +
                    rs2.getString("role") + "</p>");
                } else {
                out.println("<p style='color:red'>Admin user NOT FOUND in database.</p>");
                }

                conn.close();
                } catch (Exception e) {
                out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
                }
                %>
        </body>

        </html>