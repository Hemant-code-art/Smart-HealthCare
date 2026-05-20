<%@ page import="com.smarthealth.model.*,java.util.List,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError != null) session.removeAttribute("flashError");

    String displayName = user != null && user.getFullName() != null ? user.getFullName() : "Doctor";
    DateTimeFormatter fullDate = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
    DateTimeFormatter compactDate = DateTimeFormatter.ofPattern("MMM d");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Schedules – Smart Health</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Plus Jakarta Sans", "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #f4faf7 0%, #eaf4f0 100%);
            color: #0f3c2f;
            min-height: 100vh;
            line-height: 1.5;
        }

        /* ── Topbar ── */
        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            padding: 0 28px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(13, 107, 85, 0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .brand {
            font-weight: 800;
            font-size: 16px;
            color: #0d6b55;
            line-height: 1.1;
            cursor: pointer;
            text-decoration: none;
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
            gap: 16px;
        }

        .welcome-chip {
            font-size: 13.5px;
            color: #3a6e5f;
            font-weight: 600;
            background: #e6f3ef;
            padding: 6px 14px;
            border-radius: 99px;
            border: 1px solid #d0e8e0;
        }

        .btn-back {
            background: #0d6b55;
            color: #fff !important;
            border: 0;
            border-radius: 12px;
            padding: 8px 18px;
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 4px 12px rgba(13, 107, 85, 0.2);
            transition: all 0.2s;
        }

        .btn-back:hover {
            background: #0b5c48;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(13, 107, 85, 0.3);
        }

        /* ── Main Container ── */
        .container {
            max-width: 960px;
            margin: 0 auto;
            padding: 40px 24px 80px;
        }

        /* ── Glass Header Banner ── */
        .page-header {
            background: rgba(255, 255, 255, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 32px;
            margin-bottom: 32px;
            box-shadow: 0 16px 40px rgba(13, 107, 85, 0.04);
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 140px;
            height: 140px;
            background: radial-gradient(circle, rgba(13, 107, 85, 0.08) 0%, transparent 70%);
            border-radius: 50%;
        }

        .page-header h1 {
            font-size: 26px;
            font-weight: 800;
            color: #062b20;
            letter-spacing: -0.02em;
            margin-bottom: 8px;
        }

        .page-header p {
            font-size: 14.5px;
            color: #4f7368;
            max-width: 600px;
        }

        /* ── Controls Row (Search & Filters) ── */
        .controls-row {
            display: flex;
            gap: 16px;
            margin-bottom: 28px;
            flex-wrap: wrap;
        }

        .search-wrapper {
            flex: 1;
            min-width: 280px;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 12px 16px 12px 42px;
            background: #ffffff !important;
            border: 1.5px solid #cfe0da !important;
            border-radius: 16px;
            font-size: 14px;
            font-family: inherit;
            color: #0f3c2f;
            outline: none;
            transition: all 0.25s;
        }

        .search-input:focus {
            border-color: #0d6b55 !important;
            box-shadow: 0 0 0 4px rgba(13, 107, 85, 0.15) !important;
        }

        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #8faea4;
            pointer-events: none;
        }

        .filter-select {
            padding: 12px 20px;
            background: #ffffff !important;
            border: 1.5px solid #cfe0da !important;
            border-radius: 16px;
            font-size: 14px;
            font-weight: 600;
            font-family: inherit;
            color: #0f3c2f;
            cursor: pointer;
            outline: none;
            transition: all 0.25s;
        }

        .filter-select:focus {
            border-color: #0d6b55 !important;
            box-shadow: 0 0 0 4px rgba(13, 107, 85, 0.15) !important;
        }

        /* ── Flash Messaging ── */
        .flash {
            padding: 14px 20px;
            border-radius: 16px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 600;
            border: 1px solid;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .flash.success {
            background: #eaf8f4;
            border-color: #9edbcf;
            color: #0f5244;
        }

        /* ── Appointment Cards Timeline ── */
        .timeline {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .apt-card {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid rgba(13, 107, 85, 0.08);
            border-radius: 20px;
            padding: 24px 28px;
            box-shadow: 0 8px 24px rgba(13, 107, 85, 0.03);
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
            transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.3s;
        }

        .apt-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 36px rgba(13, 107, 85, 0.07);
        }

        /* Glowing status bars */
        .apt-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: #8faea4;
        }

        .apt-card.status-confirmed::before { background: linear-gradient(to bottom, #1a5f9e, #3a96e2); }
        .apt-card.status-scheduled::before { background: linear-gradient(to bottom, #f0aa2f, #ffd280); }
        .apt-card.status-completed::before { background: linear-gradient(to bottom, #1a6a5c, #3ab69e); }
        .apt-card.status-cancelled::before { background: linear-gradient(to bottom, #d9534f, #f29b98); }

        .apt-main-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
        }

        /* Calendar Date box */
        .date-badge {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 72px;
            height: 76px;
            border-radius: 16px;
            text-align: center;
            box-shadow: inset 0 0 0 1px rgba(13, 107, 85, 0.05);
            transition: all 0.2s;
        }

        .status-confirmed .date-badge { background: #eef5fc; color: #1a5f9e; }
        .status-scheduled .date-badge { background: #fffcf4; color: #a06010; }
        .status-completed .date-badge { background: #f2faf7; color: #1a6a5c; }
        .status-cancelled .date-badge { background: #fff8f7; color: #a32d2d; }

        .date-badge .day-number {
            font-size: 24px;
            font-weight: 800;
            line-height: 1;
        }

        .date-badge .month-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-top: 3px;
        }

        /* Patient Details */
        .patient-block {
            display: flex;
            align-items: center;
            gap: 16px;
            flex: 1;
            min-width: 220px;
        }

        .avatar-circle {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
        }

        .status-confirmed .avatar-circle { background: #e0eaf6; color: #1a5f9e; }
        .status-scheduled .avatar-circle { background: #fef3dd; color: #a06010; }
        .status-completed .avatar-circle { background: #e0f0eb; color: #1a6a5c; }
        .status-cancelled .avatar-circle { background: #fdecea; color: #a32d2d; }

        .patient-info {
            display: flex;
            flex-direction: column;
        }

        .patient-name {
            font-size: 16px;
            font-weight: 700;
            color: #062b20;
        }

        .patient-email {
            font-size: 12.5px;
            color: #5e7c73;
            margin-top: 1px;
        }

        /* Status badges */
        .status-badge {
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 5px 14px;
            border-radius: 99px;
            white-space: nowrap;
        }

        .status-confirmed .status-badge { background: #e0eaf6; color: #1a5f9e; }
        .status-scheduled .status-badge { background: #fef3dd; color: #a06010; }
        .status-completed .status-badge { background: #e0f0eb; color: #1a6a5c; }
        .status-cancelled .status-badge { background: #fdecea; color: #a32d2d; }

        /* Expand Button */
        .expand-btn {
            background: transparent;
            border: 0;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #5e7c73;
            transition: all 0.25s;
        }

        .expand-btn:hover {
            background: #eef5f2;
            color: #0d6b55;
        }

        .expand-btn svg {
            transition: transform 0.3s;
        }

        .expand-btn.active svg {
            transform: rotate(180deg);
        }

        /* Expandable details drawer */
        .details-drawer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.3s;
            opacity: 0;
            border-top: 0px solid rgba(13, 107, 85, 0.06);
            margin-top: 0;
            padding-top: 0;
        }

        .details-drawer.active {
            max-height: 400px;
            opacity: 1;
            border-top-width: 1px;
            margin-top: 20px;
            padding-top: 20px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        @media (max-width: 600px) {
            .details-grid {
                grid-template-columns: 1fr;
            }
        }

        .details-group h4 {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #8faea4;
            margin-bottom: 6px;
        }

        .details-group p {
            font-size: 13.5px;
            color: #0f3c2f;
            font-weight: 500;
        }

        /* Inline Status update */
        .update-box {
            background: #f4faf7;
            border: 1px solid #d0e8e0;
            border-radius: 14px;
            padding: 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .update-box label {
            font-size: 12.5px;
            font-weight: 700;
            color: #0d6b55;
        }

        .update-form-inner {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .update-form-inner select {
            padding: 8px 14px;
            background: #ffffff !important;
            border: 1.5px solid #cfe0da !important;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            font-family: inherit;
            color: #0f3c2f;
            cursor: pointer;
        }

        .update-form-inner button {
            padding: 8px 16px;
            background: #0d6b55;
            color: #fff;
            border: 0;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(13, 107, 85, 0.15);
            transition: all 0.2s;
        }

        .update-form-inner button:hover {
            background: #0b5c48;
            box-shadow: 0 6px 14px rgba(13, 107, 85, 0.25);
        }

        /* ── Empty State ── */
        .empty-state {
            background: #fff;
            border: 1px solid #d8ebe4;
            border-radius: 24px;
            padding: 48px;
            text-align: center;
            box-shadow: 0 8px 24px rgba(13, 107, 85, 0.02);
        }

        .empty-icon {
            width: 72px;
            height: 72px;
            background: #f4faf7;
            color: #0d6b55;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 800;
            color: #062b20;
            margin-bottom: 6px;
        }

        .empty-state p {
            font-size: 14px;
            color: #5e7c73;
            max-width: 380px;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <!-- ══ TOPBAR ══ -->
    <header class="topbar">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="brand">
            Smart Health<small>Doctor Portal</small>
        </a>
        <div class="topbar-right">
            <span class="welcome-chip">Dr. <%= displayName %></span>
            <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn-back">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Dashboard
            </a>
        </div>
    </header>

    <div class="container">

        <!-- Flash messages -->
        <% if (flashSuccess != null) { %>
            <div class="flash success">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
                <%= flashSuccess %>
            </div>
        <% } %>

        <% if (flashError != null) { %>
            <div class="flash error" style="background:#ffece5; border-color:#efb5a3; color:#7d2b0b;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <%= flashError %>
            </div>
        <% } %>

        <!-- Glass Header Banner -->
        <header class="page-header">
            <h1>Patient Schedules & Details</h1>
            <p>View comprehensive histories, pre-visit notes, and execute real-time slot confirmations for all your registered patient slots.</p>
        </header>

        <!-- Search & Filter Controls -->
        <div class="controls-row">
            <div class="search-wrapper">
                <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="searchInput" class="search-input" placeholder="Search patients by name or reason...">
            </div>
            <select id="statusFilter" class="filter-select">
                <option value="all">All Statuses</option>
                <option value="confirmed">Confirmed Only</option>
                <option value="scheduled">Scheduled Only</option>
                <option value="completed">Completed Only</option>
                <option value="cancelled">Cancelled Only</option>
            </select>
        </div>

        <!-- Timeline / Cards List -->
        <div class="timeline" id="timelineList">
            <%
                if (appointments != null && !appointments.isEmpty()) {
                    for (Appointment a : appointments) {
                        String status = a.getStatus() != null ? a.getStatus().toLowerCase() : "scheduled";
                        LocalDate d = a.getAppointmentDate();
                        String dayStr = d != null ? String.format("%02d", d.getDayOfMonth()) : "—";
                        String monStr = d != null ? d.format(DateTimeFormatter.ofPattern("MMM")) : "";
                        String fullDateStr = d != null ? d.format(fullDate) : "—";
                        
                        String patName = a.getPatientName() != null ? a.getPatientName() : "Patient";
                        String initial = patName.substring(0, 1).toUpperCase();
            %>
                        <div class="apt-card status-<%= status %>" data-patient="<%= patName.toLowerCase() %>" data-reason="<%= (a.getReason() != null ? a.getReason() : "").toLowerCase() %>" data-status="<%= status %>">
                            <div class="apt-main-row">
                                <!-- Calendar box -->
                                <div class="date-badge">
                                    <span class="day-number"><%= dayStr %></span>
                                    <span class="month-label"><%= monStr %></span>
                                </div>

                                <!-- Patient info block -->
                                <div class="patient-block">
                                    <div class="avatar-circle"><%= initial %></div>
                                    <div class="patient-info">
                                        <span class="patient-name"><%= patName %></span>
                                        <span class="patient-email">Slot ID: #APT-0<%= a.getId() %></span>
                                    </div>
                                </div>

                                <!-- Status pill -->
                                <span class="status-badge"><%= status %></span>

                                <!-- Expand button -->
                                <button class="expand-btn" onclick="toggleDetails(this)">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="6 9 12 15 18 9"></polyline>
                                    </svg>
                                </button>
                            </div>

                            <!-- Expandable Drawer details -->
                            <div class="details-drawer">
                                <div class="details-grid">
                                    <div class="details-group">
                                        <h4>Scheduled Appointment Time</h4>
                                        <p><%= fullDateStr %></p>
                                    </div>
                                    <div class="details-group">
                                        <h4>Reason for Visit</h4>
                                        <p><%= a.getReason() != null ? a.getReason() : "General Consultation" %></p>
                                    </div>
                                    <div class="details-group">
                                        <h4>Assigned Doctor</h4>
                                        <p>Dr. <%= a.getDoctorName() != null ? a.getDoctorName() : "On Duty" %></p>
                                    </div>
                                    <div class="details-group">
                                        <h4>Patient Notes / Remarks</h4>
                                        <p style="color:#5e7c73;"><%= a.getAdminNote() != null && !a.getAdminNote().isBlank() ? a.getAdminNote() : "No special instructions recorded." %></p>
                                    </div>
                                </div>

                                <!-- Inline update status -->
                                <div class="update-box">
                                    <label>Quick Action: Manage Slot Status</label>
                                    <form method="post" action="${pageContext.request.contextPath}/doctor/appointments" class="update-form-inner">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="appointmentId" value="<%= a.getId() %>">
                                        <select name="status">
                                            <option value="scheduled" <%= "scheduled".equals(status) ? "selected" : "" %>>Scheduled</option>
                                            <option value="confirmed" <%= "confirmed".equals(status) ? "selected" : "" %>>Confirmed</option>
                                            <option value="completed" <%= "completed".equals(status) ? "selected" : "" %>>Completed</option>
                                            <option value="cancelled" <%= "cancelled".equals(status) ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                        <button type="submit">Update</button>
                                    </form>
                                </div>
                            </div>
                        </div>
            <%
                    }
                } else {
            %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <h3>No Schedules Found</h3>
                        <p>Your calendar is completely clear. No patient appointments have been recorded yet.</p>
                    </div>
            <%
                }
            %>
        </div>

    </div>

    <script>
        // Toggle slide-in details drawer
        function toggleDetails(btn) {
            var card = btn.closest('.apt-card');
            var drawer = card.querySelector('.details-drawer');
            btn.classList.toggle('active');
            drawer.classList.toggle('active');
        }

        // Live Filtering & Search
        var searchInput = document.getElementById("searchInput");
        var statusFilter = document.getElementById("statusFilter");
        var cards = document.querySelectorAll(".apt-card");

        function filterSchedules() {
            var query = searchInput.value.toLowerCase().trim();
            var status = statusFilter.value;
            var visibleCount = 0;

            cards.forEach(function(card) {
                var patName = card.getAttribute("data-patient");
                var reason = card.getAttribute("data-reason");
                var cardStatus = card.getAttribute("data-status");

                var matchesSearch = patName.includes(query) || reason.includes(query);
                var matchesStatus = (status === "all") || (cardStatus === status);

                if (matchesSearch && matchesStatus) {
                    card.style.display = "block";
                    visibleCount++;
                } else {
                    card.style.display = "none";
                }
            });

            // Handle empty state during filter
            var emptyBox = document.querySelector(".empty-state");
            if (visibleCount === 0) {
                if (!emptyBox) {
                    var timeline = document.getElementById("timelineList");
                    var block = document.createElement("div");
                    block.className = "empty-state temp-empty";
                    block.innerHTML = '<div class="empty-icon"><svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg></div><h3>No Matches Found</h3><p>Try refining your search filter criteria.</p>';
                    timeline.appendChild(block);
                }
            } else {
                var tempEmpty = document.querySelector(".temp-empty");
                if (tempEmpty) {
                    tempEmpty.remove();
                }
            }
        }

        if (searchInput) searchInput.addEventListener("input", filterSchedules);
        if (statusFilter) statusFilter.addEventListener("change", filterSchedules);
    </script>
</body>
</html>
