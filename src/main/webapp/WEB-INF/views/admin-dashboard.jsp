<%@ page import="com.smarthealth.model.*,java.util.*" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <% User user=(User) session.getAttribute("user"); List<Appointment> appointments = (List<Appointment>)
                request.getAttribute("appointments");
                List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                        List<User> users = (List<User>) request.getAttribute("users");
                                List<PatientProfile> profiles = (List<PatientProfile>)
                                        request.getAttribute("patientProfiles");
                                        ReportStats stats = (ReportStats) request.getAttribute("stats");
                                        String flashSuccess = (String) session.getAttribute("flashSuccess");
                                        String flashError = (String) session.getAttribute("flashError");
                                        if (flashSuccess != null) session.removeAttribute("flashSuccess");
                                        if (flashError != null) session.removeAttribute("flashError");

                                        Map<Integer, PatientProfile> profileMap = new HashMap<>();
                                                if (profiles != null) {
                                                for (PatientProfile p : profiles) {
                                                profileMap.put(p.getUserId(), p);
                                                }
                                                }
                                                %>
                                                <!DOCTYPE html>
                                                <html>

                                                <head>
                                                    <title>Admin Dashboard</title>
                                                    <link rel="stylesheet"
                                                        href="${pageContext.request.contextPath}/assets/css/style.css?v=2.5">
                                                    <style>
                                                        input,
                                                        select,
                                                        textarea {
                                                            background-color: #ffffff !important;
                                                            background: #ffffff !important;
                                                            color: #0f3c2f !important;
                                                            border: 1.5px solid #cfe0da !important;
                                                            border-radius: 8px !important;
                                                            padding: 8px 12px !important;
                                                        }

                                                        input:focus,
                                                        select:focus,
                                                        textarea:focus {
                                                            border-color: #0d6b55 !important;
                                                            box-shadow: 0 0 0 4px rgba(13, 107, 85, 0.25) !important;
                                                            outline: none !important;
                                                        }

                                                        .meta strong {
                                                            color: #0f3c2f !important;
                                                        }

                                                        .row-actions button.btn-small {
                                                            padding: 6px 14px !important;
                                                            font-size: 11px !important;
                                                            border-radius: 8px !important;
                                                            font-weight: 700 !important;
                                                            width: auto !important;
                                                            text-transform: uppercase;
                                                            letter-spacing: 0.02em;
                                                        }

                                                        .row-actions button.danger {
                                                            background: #ffffff !important;
                                                            color: #c0362b !important;
                                                            border: 1.5px solid #efb5a3 !important;
                                                        }

                                                        .row-actions button.danger:hover {
                                                            background: #fcebeb !important;
                                                        }

                                                        .hero h1,
                                                        .hero p {
                                                            color: #0a2e54 !important;
                                                            font-weight: 800 !important;
                                                        }
                                                    </style>
                                                </head>

                                                <body>
                                                    <header class="topbar">
                                                        <div class="brand">Smart Health<small>Admin Command
                                                                Center</small></div>
                                                        <div>
                                                            <span class="meta">Signed in as <%= user !=null ?
                                                                    user.getFullName() : "Admin" %></span>
                                                            <a class="btn warn"
                                                                href="${pageContext.request.contextPath}/logout">Logout</a>
                                                        </div>
                                                    </header>

                                                    <main class="container">
                                                        <section class="hero">
                                                            <h1>Operational dashboard for appointments and records</h1>
                                                            <p>Approve requests, maintain data quality, and monitor
                                                                system health in one place.</p>
                                                        </section>

                                                        <% if (flashSuccess !=null) { %>
                                                            <div class="flash success">
                                                                <%= flashSuccess %>
                                                            </div>
                                                            <% } %>
                                                                <% if (flashError !=null ||
                                                                    request.getAttribute("error") !=null) { %>
                                                                    <div class="flash error">
                                                                        <%= flashError !=null ? flashError :
                                                                            request.getAttribute("error") %>
                                                                    </div>
                                                                    <% } %>

                                                                        <section class="grid three">
                                                                            <article class="card">
                                                                                <h3>Total Appointments</h3>
                                                                                <h2>
                                                                                    <%= stats !=null ?
                                                                                        stats.getTotalAppointments() : 0
                                                                                        %>
                                                                                </h2>
                                                                            </article>
                                                                            <article class="card">
                                                                                <h3>Scheduled</h3>
                                                                                <h2>
                                                                                    <%= stats !=null ?
                                                                                        stats.getPendingAppointments() :
                                                                                        0 %>
                                                                                </h2>
                                                                            </article>
                                                                            <article class="card">
                                                                                <h3>Confirmed</h3>
                                                                                <h2>
                                                                                    <%= stats !=null ?
                                                                                        stats.getApprovedAppointments()
                                                                                        : 0 %>
                                                                                </h2>
                                                                            </article>
                                                                            <article class="card">
                                                                                <h3>Completed</h3>
                                                                                <h2>
                                                                                    <%= stats !=null ?
                                                                                        stats.getRejectedAppointments()
                                                                                        : 0 %>
                                                                                </h2>
                                                                            </article>
                                                                            <article class="card">
                                                                                <h3>Cancelled</h3>
                                                                                <h2>
                                                                                    <%= stats !=null ?
                                                                                        stats.getCancelledAppointments()
                                                                                        : 0 %>
                                                                                </h2>
                                                                            </article>
                                                                            <article class="card">
                                                                                <h3>Patients / Doctors</h3>
                                                                                <h2>
                                                                                    <%= stats !=null ?
                                                                                        stats.getTotalPatients() : 0 %>
                                                                                        / <%= stats !=null ?
                                                                                            stats.getTotalDoctors() : 0
                                                                                            %>
                                                                                </h2>
                                                                            </article>
                                                                        </section>

                                                                        <section class="card">
                                                                            <h2>Appointment Approval Queue</h2>
                                                                            <div class="table-wrap">
                                                                                <table>
                                                                                    <thead>
                                                                                        <tr>
                                                                                            <th>ID</th>
                                                                                            <th>Patient</th>
                                                                                            <th>Doctor</th>
                                                                                            <th>Date</th>
                                                                                            <th>Reason</th>
                                                                                            <th>Status</th>
                                                                                            <th>Decision</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <% if (appointments !=null &&
                                                                                            !appointments.isEmpty()) {
                                                                                            for (Appointment a :
                                                                                            appointments) { %>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <%= a.getId() %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= a.getPatientName()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= a.getDoctorName()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= a.getAppointmentDate()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= a.getReason() %>
                                                                                                </td>
                                                                                                <td><span
                                                                                                        class="badge <%= a.getStatus() %>">
                                                                                                        <%= a.getStatus()
                                                                                                            %>
                                                                                                    </span></td>
                                                                                                <td>
                                                                                                    <form method="post"
                                                                                                        action="${pageContext.request.contextPath}/admin/dashboard">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="action"
                                                                                                            value="decision">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="appointmentId"
                                                                                                            value="<%= a.getId() %>">
                                                                                                        <select
                                                                                                            name="status"
                                                                                                            required>
                                                                                                            <option
                                                                                                                value="confirmed">
                                                                                                                Confirm
                                                                                                            </option>
                                                                                                            <option
                                                                                                                value="cancelled">
                                                                                                                Cancel
                                                                                                            </option>
                                                                                                        </select>
                                                                                                        <input
                                                                                                            type="text"
                                                                                                            name="adminNote"
                                                                                                            placeholder="Optional note">
                                                                                                        <button
                                                                                                            type="submit">Submit</button>
                                                                                                    </form>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } } else { %>
                                                                                                <tr>
                                                                                                    <td colspan="7">No
                                                                                                        appointments
                                                                                                        available.</td>
                                                                                                </tr>
                                                                                                <% } %>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </section>

                                                                        <section class="grid two">
                                                                            <article class="card">
                                                                                <h2>Manage Doctor Schedules</h2>
                                                                                <h3>Add Doctor</h3>
                                                                                <form method="post"
                                                                                    action="${pageContext.request.contextPath}/admin/dashboard">
                                                                                    <input type="hidden" name="action"
                                                                                        value="addDoctor">
                                                                                    <input type="text" name="doctorName"
                                                                                        placeholder="Doctor Name"
                                                                                        required>
                                                                                    <input type="text"
                                                                                        name="specialization"
                                                                                        placeholder="Specialization"
                                                                                        required>
                                                                                    <input type="text"
                                                                                        name="scheduleDay"
                                                                                        placeholder="Schedule Day"
                                                                                        required>
                                                                                    <input type="text" name="timeSlot"
                                                                                        placeholder="Time Slot"
                                                                                        required>
                                                                                    <input type="number"
                                                                                        name="maxPatients" min="1"
                                                                                        placeholder="Max Patients"
                                                                                        required>
                                                                                    <button type="submit">Add
                                                                                        Doctor</button>
                                                                                </form>

                                                                                <h3>Current Doctors</h3>
                                                                                <% if (doctors !=null) for (Doctor d :
                                                                                    doctors) { %>
                                                                                    <form method="post"
                                                                                        action="${pageContext.request.contextPath}/admin/dashboard">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="updateDoctor">
                                                                                        <input type="hidden"
                                                                                            name="doctorId"
                                                                                            value="<%= d.getId() %>">
                                                                                        <input type="text"
                                                                                            name="doctorName"
                                                                                            value="<%= d.getDoctorName() %>"
                                                                                            required>
                                                                                        <input type="text"
                                                                                            name="specialization"
                                                                                            value="<%= d.getSpecialization() %>"
                                                                                            required>
                                                                                        <input type="text"
                                                                                            name="scheduleDay"
                                                                                            value="<%= d.getScheduleDay() %>"
                                                                                            required>
                                                                                        <input type="text"
                                                                                            name="timeSlot"
                                                                                            value="<%= d.getTimeSlot() %>"
                                                                                            required>
                                                                                        <input type="number"
                                                                                            name="maxPatients"
                                                                                            value="<%= d.getMaxPatients() %>"
                                                                                            min="1" required>
                                                                                        <div class="row-actions"
                                                                                            style="display: flex; gap: 10px; margin-top: 10px;">
                                                                                            <button type="submit"
                                                                                                class="btn-small">Update</button>
                                                                                    </form>
                                                                                    <form method="post"
                                                                                        action="${pageContext.request.contextPath}/admin/dashboard"
                                                                                        style="display:inline;">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="deleteDoctor">
                                                                                        <input type="hidden"
                                                                                            name="doctorId"
                                                                                            value="<%= d.getId() %>">
                                                                                        <button class="btn-small danger"
                                                                                            type="submit">Delete
                                                                                            Doctor</button>
                                                                                    </form>
                                                                                    </div>
                                                                                    <hr>
                                                                                    <% } %>
                                                                            </article>

                                                                            <article class="card">
                                                                                <h2>Manage System Users</h2>
                                                                                <h3>Create User</h3>
                                                                                <form method="post"
                                                                                    action="${pageContext.request.contextPath}/admin/dashboard">
                                                                                    <input type="hidden" name="action"
                                                                                        value="createUser">
                                                                                    <input type="text" name="fullName"
                                                                                        placeholder="Full Name"
                                                                                        required>
                                                                                    <input type="email" name="email"
                                                                                        placeholder="Email" required>
                                                                                    <input type="password"
                                                                                        name="password"
                                                                                        placeholder="Password" required>
                                                                                    <select name="role" required>
                                                                                        <option value="PATIENT">PATIENT
                                                                                        </option>
                                                                                        <option value="ADMIN">ADMIN
                                                                                        </option>
                                                                                    </select>
                                                                                    <button type="submit">Create
                                                                                        User</button>
                                                                                </form>

                                                                                <h3>User List</h3>
                                                                                <% if (users !=null) for (User u :
                                                                                    users) { %>
                                                                                    <form method="post"
                                                                                        action="${pageContext.request.contextPath}/admin/dashboard">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="updateUserRole">
                                                                                        <input type="hidden"
                                                                                            name="userId"
                                                                                            value="<%= u.getId() %>">
                                                                                        <div class="meta"><strong>
                                                                                                <%= u.getFullName() %>
                                                                                            </strong> - <%= u.getEmail()
                                                                                                %>
                                                                                        </div>
                                                                                        <select name="role">
                                                                                            <option value="PATIENT"
                                                                                                <%="PATIENT"
                                                                                                .equals(u.getRole())
                                                                                                ? "selected" : "" %>
                                                                                                >PATIENT</option>
                                                                                            <option value="ADMIN"
                                                                                                <%="ADMIN"
                                                                                                .equals(u.getRole())
                                                                                                ? "selected" : "" %>
                                                                                                >ADMIN</option>
                                                                                        </select>
                                                                                        <div class="row-actions"
                                                                                            style="display: flex; gap: 10px; margin-top: 10px;">
                                                                                            <button type="submit"
                                                                                                class="btn-small">Update
                                                                                                Role</button>
                                                                                            <form method="post"
                                                                                                action="${pageContext.request.contextPath}/admin/dashboard"
                                                                                                style="display:inline;">
                                                                                                <input type="hidden"
                                                                                                    name="action"
                                                                                                    value="deleteUser">
                                                                                                <input type="hidden"
                                                                                                    name="userId"
                                                                                                    value="<%= u.getId() %>">
                                                                                                <button type="submit"
                                                                                                    class="btn-small danger">Delete
                                                                                                    User</button>
                                                                                            </form>
                                                                                        </div>
                                                                                    </form>
                                                                                    <hr>
                                                                                    <% } %>
                                                                            </article>
                                                                        </section>

                                                                        <section class="card">
                                                                            <h2>Manage Patient Records (CRUD)</h2>
                                                                            <div class="table-wrap">
                                                                                <table>
                                                                                    <thead>
                                                                                        <tr>
                                                                                            <th>User ID</th>
                                                                                            <th>Name</th>
                                                                                            <th>Phone</th>
                                                                                            <th>Address</th>
                                                                                            <th>Gender</th>
                                                                                            <th>Age</th>
                                                                                            <th>Actions</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <% if (users !=null) { for (User
                                                                                            u : users) { if
                                                                                            (!"PATIENT".equals(u.getRole()))
                                                                                            continue; PatientProfile
                                                                                            p=profileMap.get(u.getId());
                                                                                            %>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <%= u.getId() %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <%= u.getFullName()
                                                                                                        %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <form method="post"
                                                                                                        action="${pageContext.request.contextPath}/admin/dashboard">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="action"
                                                                                                            value="updatePatientProfile">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="userId"
                                                                                                            value="<%= u.getId() %>">
                                                                                                        <input
                                                                                                            type="text"
                                                                                                            name="phone"
                                                                                                            value="<%= p != null && p.getPhone() != null ? p.getPhone() : "" %>">
                                                                                                </td>
                                                                                                <td><input type="text"
                                                                                                        name="address"
                                                                                                        value="<%= p != null && p.getAddress() != null ? p.getAddress() : "" %>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    <select
                                                                                                        name="gender">
                                                                                                        <option
                                                                                                            value="">
                                                                                                            Select
                                                                                                        </option>
                                                                                                        <option
                                                                                                            value="Male"
                                                                                                            <%=p !=null
                                                                                                            && "Male"
                                                                                                            .equals(p.getGender())
                                                                                                            ? "selected"
                                                                                                            : "" %>>Male
                                                                                                        </option>
                                                                                                        <option
                                                                                                            value="Female"
                                                                                                            <%=p !=null
                                                                                                            && "Female"
                                                                                                            .equals(p.getGender())
                                                                                                            ? "selected"
                                                                                                            : "" %>
                                                                                                            >Female
                                                                                                        </option>
                                                                                                        <option
                                                                                                            value="Other"
                                                                                                            <%=p !=null
                                                                                                            && "Other"
                                                                                                            .equals(p.getGender())
                                                                                                            ? "selected"
                                                                                                            : "" %>
                                                                                                            >Other
                                                                                                        </option>
                                                                                                    </select>
                                                                                                </td>
                                                                                                <td><input type="number"
                                                                                                        name="age"
                                                                                                        min="0"
                                                                                                        max="120"
                                                                                                        value="<%= (p != null && p.getAge() != null) ? p.getAge() : "" %>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div class="row-actions"
                                                                                                        style="display: flex; gap: 8px;">
                                                                                                        <button
                                                                                                            type="submit"
                                                                                                            class="btn-small">Save</button>
                                                                                                        </form>
                                                                                                        <form
                                                                                                            method="post"
                                                                                                            action="${pageContext.request.contextPath}/admin/dashboard"
                                                                                                            style="display:inline;">
                                                                                                            <input
                                                                                                                type="hidden"
                                                                                                                name="action"
                                                                                                                value="deletePatientProfile">
                                                                                                            <input
                                                                                                                type="hidden"
                                                                                                                name="userId"
                                                                                                                value="<%= u.getId() %>">
                                                                                                            <button
                                                                                                                class="btn-small danger"
                                                                                                                type="submit">Delete
                                                                                                                Profile</button>
                                                                                                        </form>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% } } %>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </section>
                                                    </main>
                                                </body>

                                                </html>