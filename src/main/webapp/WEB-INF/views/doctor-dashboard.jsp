<%@ page import="com.smarthealth.model.*,java.util.List,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <% User user=(User) session.getAttribute("user"); List<Appointment> appointments = (List<Appointment>)
                request.getAttribute("appointments");
                String flashSuccess = (String) session.getAttribute("flashSuccess");
                String flashError = (String) session.getAttribute("flashError");
                if (flashSuccess != null) session.removeAttribute("flashSuccess");
                if (flashError != null) session.removeAttribute("flashError");

                int totalApts = 0;
                int scheduledApts = 0;
                int confirmedApts = 0;
                int completedApts = 0;
                int cancelledApts = 0;
                Appointment nextApt = null;
                LocalDate today = LocalDate.now();

                if (appointments != null) {
                for (Appointment a : appointments) {
                totalApts++;
                String st = a.getStatus();
                if ("scheduled".equalsIgnoreCase(st)) scheduledApts++;
                if ("confirmed".equalsIgnoreCase(st)) confirmedApts++;
                if ("completed".equalsIgnoreCase(st)) completedApts++;
                if ("cancelled".equalsIgnoreCase(st)) cancelledApts++;

                LocalDate d = a.getAppointmentDate();
                boolean upcoming = d != null && (d.isEqual(today) || d.isAfter(today));
                boolean active = "scheduled".equalsIgnoreCase(st) || "confirmed".equalsIgnoreCase(st);
                if (upcoming && active && (nextApt == null || d.isBefore(nextApt.getAppointmentDate()))) {
                nextApt = a;
                }
                }
                }

                String displayName = user != null && user.getFullName() != null ? user.getFullName() : "Doctor";
                String initials = "D";
                if (displayName != null && !displayName.isBlank()) {
                String[] parts = displayName.trim().split("\\s+");
                initials = parts.length == 1
                ? parts[0].substring(0, 1).toUpperCase()
                : (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
                }

                DateTimeFormatter fullDate = DateTimeFormatter.ofPattern("MMM d, yyyy");
                %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Doctor Dashboard – Smart Health</title>
                    <meta name="description"
                        content="Manage your patient appointments and schedule on the Smart Health Doctor Portal.">
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                        rel="stylesheet">
                    <style>
                        *,
                        *::before,
                        *::after {
                            box-sizing: border-box;
                            margin: 0;
                            padding: 0;
                        }

                        body {
                            font-family: "Plus Jakarta Sans", "Segoe UI", sans-serif;
                            background: #f3f7f5;
                            color: #0f3c2f;
                            min-height: 100vh;
                        }

                        /* ── Topbar ── */
                        .topbar {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            height: 56px;
                            padding: 0 28px;
                            background: #fff;
                            border-bottom: 1px solid #d4e8e2;
                            position: sticky;
                            top: 0;
                            z-index: 100;
                        }

                        .brand {
                            font-weight: 800;
                            font-size: 15px;
                            color: #0d6b55;
                            line-height: 1.1;
                        }

                        .brand small {
                            display: block;
                            font-size: 10px;
                            font-weight: 600;
                            color: #5f9e8a;
                            letter-spacing: .03em;
                        }

                        .topbar-right {
                            display: flex;
                            align-items: center;
                            gap: 14px;
                        }

                        .welcome-chip {
                            font-size: 13px;
                            color: #3a6e5f;
                            font-weight: 500;
                        }

                        .btn-logout {
                            background: #de7b0f;
                            color: #fff;
                            border: 0;
                            border-radius: 10px;
                            padding: 6px 16px;
                            font-size: 13px;
                            font-weight: 700;
                            cursor: pointer;
                            font-family: inherit;
                            text-decoration: none;
                            display: inline-block;
                        }

                        .btn-logout:hover {
                            background: #c56b09;
                        }

                        /* ── Layout ── */
                        .main {
                            max-width: 1080px;
                            margin: 0 auto;
                            padding: 24px 18px 48px;
                        }

                        /* ── Hero Banner ── */
                        .hero-banner {
                            background: linear-gradient(120deg, #e0edf8 0%, #d0e8e4 45%, #c8e2f0 100%);
                            border-radius: 20px;
                            padding: 28px 32px 24px;
                            margin-bottom: 0;
                            border: 1px solid #c5dce8;
                        }

                        .hero-eyebrow {
                            font-size: 13px;
                            font-weight: 600;
                            color: #1a5f9e;
                            margin-bottom: 8px;
                        }

                        .hero-banner h1 {
                            font-size: clamp(1.5rem, 3vw, 2.1rem);
                            font-weight: 800;
                            color: #0a2035;
                            line-height: 1.2;
                            margin-bottom: 8px;
                        }

                        .hero-banner p {
                            font-size: 13.5px;
                            color: #3a6070;
                            max-width: 560px;
                            margin-bottom: 20px;
                        }

                        .hero-btn-row {
                            display: flex;
                            gap: 10px;
                            flex-wrap: wrap;
                        }

                        .btn-hero-primary {
                            background: #1a5f9e;
                            color: #fff;
                            border: 0;
                            border-radius: 10px;
                            padding: 9px 20px;
                            font-size: 13.5px;
                            font-weight: 700;
                            cursor: pointer;
                            font-family: inherit;
                            text-decoration: none;
                            display: inline-block;
                        }

                        .btn-hero-primary:hover {
                            background: #164e85;
                        }

                        .btn-hero-ghost {
                            background: transparent;
                            color: #1a5f9e;
                            border: 1.5px solid #9ec5de;
                            border-radius: 10px;
                            padding: 9px 20px;
                            font-size: 13.5px;
                            font-weight: 700;
                            cursor: pointer;
                            font-family: inherit;
                            text-decoration: none;
                            display: inline-block;
                        }

                        .btn-hero-ghost:hover {
                            border-color: #1a5f9e;
                        }

                        /* ── Stats Bar ── */
                        .stats-bar {
                            display: flex;
                            align-items: center;
                            gap: 24px;
                            padding: 12px 18px;
                            flex-wrap: wrap;
                        }

                        .stat-item {
                            font-size: 13px;
                            color: #3a6e5f;
                            font-weight: 500;
                        }

                        .stat-item strong {
                            font-weight: 700;
                            color: #0a2e22;
                        }

                        .dot {
                            display: inline-block;
                            width: 8px;
                            height: 8px;
                            border-radius: 50%;
                            margin-right: 5px;
                            vertical-align: middle;
                        }

                        .dot-confirmed {
                            background: #1a5f9e;
                        }

                        .dot-scheduled {
                            background: #f0aa2f;
                        }

                        .dot-completed {
                            background: #1a6a5c;
                        }

                        .dot-cancelled {
                            background: #d9534f;
                        }

                        /* ── Info Cards Row ── */
                        .info-cards-row {
                            display: grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap: 14px;
                            margin-bottom: 24px;
                        }

                        @media (max-width: 750px) {
                            .info-cards-row {
                                grid-template-columns: 1fr;
                            }
                        }

                        .info-card {
                            background: #fff;
                            border: 1px solid #d8ebe4;
                            border-radius: 16px;
                            padding: 18px 20px;
                        }

                        .ic-label {
                            font-size: 11px;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: .05em;
                            color: #8aada3;
                            margin-bottom: 10px;
                        }

                        .ic-date {
                            font-size: 15px;
                            font-weight: 700;
                            color: #0a2e22;
                            margin-bottom: 2px;
                        }

                        .ic-sub {
                            font-size: 12.5px;
                            color: #5e7c73;
                            margin-bottom: 8px;
                        }

                        .ic-link {
                            font-size: 12.5px;
                            font-weight: 700;
                            color: #1a5f9e;
                            text-decoration: none;
                            display: inline-block;
                            margin-top: 4px;
                        }

                        .ic-link:hover {
                            text-decoration: underline;
                        }

                        .badge-confirmed {
                            display: inline-block;
                            background: #e0eaf6;
                            color: #1a5f9e;
                            font-size: 11.5px;
                            font-weight: 700;
                            border-radius: 999px;
                            padding: 3px 11px;
                            margin-bottom: 10px;
                        }

                        .badge-scheduled {
                            display: inline-block;
                            background: #fef3dd;
                            color: #a06010;
                            font-size: 11.5px;
                            font-weight: 700;
                            border-radius: 999px;
                            padding: 3px 11px;
                            margin-bottom: 10px;
                        }

                        .badge-completed {
                            display: inline-block;
                            background: #e0f0eb;
                            color: #1a6a5c;
                            font-size: 11.5px;
                            font-weight: 700;
                            border-radius: 999px;
                            padding: 3px 11px;
                            margin-bottom: 10px;
                        }

                        .badge-cancelled {
                            display: inline-block;
                            background: #fdecea;
                            color: #a32d2d;
                            font-size: 11.5px;
                            font-weight: 700;
                            border-radius: 999px;
                            padding: 3px 11px;
                            margin-bottom: 10px;
                        }

                        /* Snap pills */
                        .snap-pill-row {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 6px;
                            margin-bottom: 4px;
                        }

                        .snap-pill {
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                            font-size: 12px;
                            font-weight: 600;
                            border-radius: 999px;
                            padding: 4px 11px;
                        }

                        .sp-confirmed {
                            background: #e0eaf6;
                            color: #1a5f9e;
                        }

                        .sp-scheduled {
                            background: #fef3dd;
                            color: #a06010;
                        }

                        .sp-completed {
                            background: #e0f0eb;
                            color: #1a6a5c;
                        }

                        .sp-cancelled {
                            background: #fdecea;
                            color: #a32d2d;
                        }

                        .snap-note {
                            font-size: 12px;
                            color: #5e7c73;
                            margin-top: 8px;
                        }

                        /* ── Section label ── */
                        .section-label {
                            font-size: 11px;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: .07em;
                            color: #8aada3;
                            margin: 0 0 14px;
                        }

                        /* ── Appointment table panel ── */
                        .panel {
                            background: #fff;
                            border: 1px solid #d8ebe4;
                            border-radius: 16px;
                            padding: 22px 22px 18px;
                        }

                        .panel h2 {
                            font-size: 15px;
                            font-weight: 800;
                            color: #0a2e22;
                            margin-bottom: 16px;
                        }

                        /* ── History list ── */
                        .hist-item {
                            display: grid;
                            grid-template-columns: 56px 1fr auto auto;
                            align-items: center;
                            gap: 14px;
                            padding: 12px 0;
                            border-bottom: 1px solid #eaf2ee;
                        }

                        .hist-item:last-child {
                            border-bottom: 0;
                        }

                        .hist-date-box {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            justify-content: center;
                            background: #e8f0f8;
                            border-radius: 10px;
                            padding: 7px 4px;
                            text-align: center;
                        }

                        .hist-date-day {
                            font-size: 17px;
                            font-weight: 800;
                            color: #0a2035;
                            line-height: 1;
                        }

                        .hist-date-month {
                            font-size: 10px;
                            font-weight: 700;
                            color: #5e7c73;
                            text-transform: uppercase;
                            letter-spacing: .04em;
                        }

                        .hist-name {
                            font-size: 13.5px;
                            font-weight: 700;
                            color: #0a2e22;
                        }

                        .hist-meta {
                            font-size: 12px;
                            color: #5e7c73;
                            margin-top: 1px;
                        }

                        .hist-badge {
                            font-size: 11px;
                            font-weight: 700;
                            border-radius: 999px;
                            padding: 4px 12px;
                            white-space: nowrap;
                        }

                        .hb-confirmed {
                            background: #e0eaf6;
                            color: #1a5f9e;
                        }

                        .hb-scheduled {
                            background: #fef3dd;
                            color: #a06010;
                        }

                        .hb-completed {
                            background: #e0f0eb;
                            color: #1a6a5c;
                        }

                        .hb-cancelled {
                            background: #fdecea;
                            color: #a32d2d;
                        }

                        /* Status update form inside row */
                        .status-form {
                            display: flex;
                            gap: 6px;
                            align-items: center;
                            flex-wrap: wrap;
                        }

                        .status-form select {
                            padding: 5px 10px;
                            border: 1.5px solid #d8ebe4;
                            border-radius: 8px;
                            font-size: 12px;
                            font-family: inherit;
                            color: #0a2e22;
                            background: #fff;
                            cursor: pointer;
                        }

                        .status-form button {
                            padding: 5px 12px;
                            background: #1a5f9e;
                            color: #fff;
                            border: 0;
                            border-radius: 8px;
                            font-size: 12px;
                            font-weight: 700;
                            font-family: inherit;
                            cursor: pointer;
                        }

                        .status-form button:hover {
                            background: #164e85;
                        }

                        /* Flash messages */
                        .flash {
                            padding: 12px 16px;
                            border-radius: 12px;
                            margin-bottom: 14px;
                            border: 1px solid;
                            font-size: 13.5px;
                            font-weight: 500;
                        }

                        .flash.success {
                            background: #e8f7f3;
                            border-color: #9edbcf;
                            color: #1a5f56;
                        }

                        .flash.error {
                            background: #ffece5;
                            border-color: #efb5a3;
                            color: #7d2b0b;
                        }

                        /* Scroll FAB */
                        .scroll-fab {
                            position: fixed;
                            bottom: 24px;
                            right: 24px;
                            width: 42px;
                            height: 42px;
                            border-radius: 50%;
                            background: #1a5f9e;
                            color: #fff;
                            border: 0;
                            cursor: pointer;
                            z-index: 200;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            box-shadow: 0 4px 14px rgba(26, 95, 158, .3);
                        }

                        .scroll-fab:hover {
                            background: #164e85;
                        }

                        @media (max-width: 680px) {
                            .hist-item {
                                grid-template-columns: 50px 1fr;
                            }

                            .hist-badge,
                            .status-form {
                                grid-column: 2;
                            }
                        }
                    </style>
                </head>

                <body>

                    <!-- ══ TOPBAR ══ -->
                    <header class="topbar">
                        <div class="brand">Smart Health<small>Doctor Portal</small></div>
                        <div class="topbar-right">
                            <span class="welcome-chip">Welcome, <%= displayName %></span>
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.2">
                            <style>
                                input,
                                select,
                                textarea {
                                    background-color: #ffffff !important;
                                    background: #ffffff !important;
                                    color: #0f3c2f !important;
                                    border: 1.5px solid #cfe0da !important;
                                }

                                input:focus,
                                select:focus,
                                textarea:focus {
                                    border-color: #0d6b55 !important;
                                    box-shadow: 0 0 0 4px rgba(13, 107, 85, 0.25) !important;
                                }
                            </style>
                            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                        </div>
                    </header>

                    <main class="main">

                        <!-- Flash Messages -->
                        <% if (flashSuccess !=null) { %>
                            <div class="flash success">
                                <%= flashSuccess %>
                            </div>
                            <% } %>
                                <% if (flashError !=null) { %>
                                    <div class="flash error">
                                        <%= flashError %>
                                    </div>
                                    <% } %>

                                        <!-- ══ HERO BANNER ══ -->
                                        <section class="hero-banner">
                                            <div class="hero-eyebrow">Your patients, always organised</div>
                                            <h1>View, confirm, and manage your appointments</h1>
                                            <p>Stay on top of your schedule with patient details, status tracking, and
                                                updates in one place.</p>
                                            <div class="hero-btn-row">
                                                <a href="#appointments" class="btn-hero-primary">View Appointments</a>
                                                <a href="#todays-schedule" class="btn-hero-ghost">Today's Schedule</a>
                                            </div>
                                        </section>

                                        <!-- ══ STATS BAR ══ -->
                                        <div class="stats-bar">
                                            <span class="stat-item">Total Appointments <strong>
                                                    <%= totalApts %>
                                                </strong></span>
                                            <span class="stat-item"><span class="dot dot-confirmed"></span>Confirmed
                                                <strong>
                                                    <%= confirmedApts %>
                                                </strong></span>
                                            <span class="stat-item"><span class="dot dot-scheduled"></span>Scheduled
                                                <strong>
                                                    <%= scheduledApts %>
                                                </strong></span>
                                            <span class="stat-item"><span class="dot dot-completed"></span>Completed
                                                <strong>
                                                    <%= completedApts %>
                                                </strong></span>
                                            <span class="stat-item"><span class="dot dot-cancelled"></span>Cancelled
                                                <strong>
                                                    <%= cancelledApts %>
                                                </strong></span>
                                        </div>

                                        <!-- ══ INFO CARDS ROW ══ -->
                                        <div class="info-cards-row">

                                            <!-- Next Appointment -->
                                            <div class="info-card">
                                                <div class="ic-label">Next Appointment</div>
                                                <% if (nextApt !=null) { String ns=nextApt.getStatus() !=null ?
                                                    nextApt.getStatus().toLowerCase() : "scheduled" ; String
                                                    badgeC=ns.equals("confirmed") ? "badge-confirmed" :
                                                    ns.equals("completed") ? "badge-completed" : "badge-scheduled" ; %>
                                                    <div class="ic-date">
                                                        <%= nextApt.getAppointmentDate() !=null ?
                                                            nextApt.getAppointmentDate().format(fullDate) : "—" %>
                                                    </div>
                                                    <div class="ic-sub">Patient: <%= nextApt.getPatientName() !=null ?
                                                            nextApt.getPatientName() : "—" %>
                                                    </div>
                                                    <span class="<%= badgeC %>">
                                                        <%= ns.substring(0,1).toUpperCase() + ns.substring(1) %>
                                                    </span><br>
                                                    <% } else { %>
                                                        <div class="ic-date" style="font-size:14px;color:#5e7c73;">No
                                                            upcoming appointment</div>
                                                        <div class="ic-sub">Your schedule is clear.</div>
                                                        <% } %>
                                                            <a href="#appointments" class="ic-link">View all →</a>
                                            </div>

                                            <!-- Today's Summary -->
                                            <div class="info-card" id="todays-schedule">
                                                <div class="ic-label">Today's Schedule</div>
                                                <% int todayCount=0; if (appointments !=null) { for (Appointment a :
                                                    appointments) { LocalDate d=a.getAppointmentDate(); if (d !=null &&
                                                    d.isEqual(today)) todayCount++; } } %>
                                                    <div class="ic-date" style="font-size: 28px; font-weight: 800;">
                                                        <%= todayCount %>
                                                    </div>
                                                    <div class="ic-sub">appointment<%= todayCount !=1 ? "s" : "" %>
                                                            today</div>
                                                    <div class="snap-note">Keep your schedule on track.</div>
                                            </div>

                                            <!-- Care Snapshot -->
                                            <div class="info-card">
                                                <div class="ic-label">Appointment Snapshot</div>
                                                <div class="ic-sub"
                                                    style="margin-bottom:8px;font-weight:600;color:#0a2e22;">All time
                                                </div>
                                                <div class="snap-pill-row">
                                                    <span class="snap-pill sp-confirmed">Confirmed <%= confirmedApts %>
                                                    </span>
                                                    <span class="snap-pill sp-scheduled">Scheduled <%= scheduledApts %>
                                                    </span>
                                                    <span class="snap-pill sp-completed">Completed <%= completedApts %>
                                                    </span>
                                                    <span class="snap-pill sp-cancelled">Cancelled <%= cancelledApts %>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- ══ APPOINTMENTS LIST ══ -->
                                        <p class="section-label">Patient Appointments</p>
                                        <div class="panel" id="appointments">
                                            <h2>All Appointments</h2>
                                            <div>
                                                <% if (appointments !=null && !appointments.isEmpty()) { for
                                                    (Appointment a : appointments) { String status=a.getStatus() !=null
                                                    ? a.getStatus() : "scheduled" ; String
                                                    statusLC=status.toLowerCase(); String hbClass="hb-scheduled" ; if
                                                    ("confirmed".equals(statusLC)) hbClass="hb-confirmed" ; if
                                                    ("completed".equals(statusLC)) hbClass="hb-completed" ; if
                                                    ("cancelled".equals(statusLC)) hbClass="hb-cancelled" ; LocalDate
                                                    d=a.getAppointmentDate(); String dayStr=d !=null ?
                                                    String.format("%02d", d.getDayOfMonth()) : "—" ; String monStr=d
                                                    !=null ? d.format(DateTimeFormatter.ofPattern("MMM")) : "" ; %>
                                                    <div class="hist-item">
                                                        <div class="hist-date-box">
                                                            <div class="hist-date-day">
                                                                <%= dayStr %>
                                                            </div>
                                                            <div class="hist-date-month">
                                                                <%= monStr %>
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <div class="hist-name">
                                                                <%= a.getPatientName() !=null ? a.getPatientName()
                                                                    : "Patient" %>
                                                            </div>
                                                            <div class="hist-meta">
                                                                <%= a.getReason() !=null ? a.getReason()
                                                                    : "General Visit" %>
                                                            </div>
                                                        </div>
                                                        <span class="hist-badge <%= hbClass %>">
                                                            <%= statusLC.substring(0,1).toUpperCase() +
                                                                statusLC.substring(1) %>
                                                        </span>
                                                        <!-- Quick status update -->
                                                        <form class="status-form" method="post"
                                                            action="${pageContext.request.contextPath}/doctor/dashboard">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="appointmentId"
                                                                value="<%= a.getId() %>">
                                                            <select name="status">
                                                                <option value="scheduled" <%="scheduled"
                                                                    .equals(statusLC) ? "selected" : "" %>>Scheduled
                                                                </option>
                                                                <option value="confirmed" <%="confirmed"
                                                                    .equals(statusLC) ? "selected" : "" %>>Confirmed
                                                                </option>
                                                                <option value="completed" <%="completed"
                                                                    .equals(statusLC) ? "selected" : "" %>>Completed
                                                                </option>
                                                                <option value="cancelled" <%="cancelled"
                                                                    .equals(statusLC) ? "selected" : "" %>>Cancelled
                                                                </option>
                                                            </select>
                                                            <button type="submit">Update</button>
                                                        </form>
                                                    </div>
                                                    <% } } else { %>
                                                        <p style="color:#5e7c73;font-size:13.5px;">No appointments
                                                            assigned to you yet.</p>
                                                        <% } %>
                                            </div>
                                        </div>

                    </main>

                    <!-- Scroll to top -->
                    <button class="scroll-fab" onclick="window.scrollTo({top:0,behavior:'smooth'})"
                        aria-label="Scroll to top">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                            <path d="M12 19V5M5 12l7-7 7 7" stroke="#fff" stroke-width="2.2" stroke-linecap="round"
                                stroke-linejoin="round" />
                        </svg>
                    </button>

                </body>

                </html>