<%@ page import="com.smarthealth.model.*,java.util.List,java.time.LocalDate,java.time.format.DateTimeFormatter" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <% User user=(User) session.getAttribute("user"); List<Doctor> doctors = (List<Doctor>)
                request.getAttribute("doctors");
                List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                        PatientProfile profile = (PatientProfile) request.getAttribute("profile");
                        String flashSuccess = (String) session.getAttribute("flashSuccess");
                        String flashError = (String) session.getAttribute("flashError");
                        if (flashSuccess != null) session.removeAttribute("flashSuccess");
                        if (flashError != null) session.removeAttribute("flashError");

                        int totalAppointments = 0;
                        int scheduledAppointments = 0;
                        int confirmedAppointments = 0;
                        int completedAppointments = 0;
                        int cancelledAppointments = 0;
                        Appointment nextAppointment = null;
                        LocalDate today = LocalDate.now();

                        int profileFields = 4;
                        int profileFilled = 0;
                        if (profile != null) {
                        if (profile.getPhone() != null && !profile.getPhone().isBlank()) profileFilled++;
                        if (profile.getAddress() != null && !profile.getAddress().isBlank()) profileFilled++;
                        if (profile.getGender() != null && !profile.getGender().isBlank()) profileFilled++;
                        if (profile.getAge() != null) profileFilled++;
                        }
                        int profilePercent = (int) Math.round(profileFields == 0 ? 0 : (profileFilled * 100.0) /
                        profileFields);

                        if (appointments != null) {
                        for (Appointment a : appointments) {
                        totalAppointments++;
                        String status = a.getStatus();
                        if ("scheduled".equalsIgnoreCase(status)) scheduledAppointments++;
                        if ("confirmed".equalsIgnoreCase(status)) confirmedAppointments++;
                        if ("completed".equalsIgnoreCase(status)) completedAppointments++;
                        if ("cancelled".equalsIgnoreCase(status)) cancelledAppointments++;

                        LocalDate date = a.getAppointmentDate();
                        boolean isUpcoming = date != null && (date.isEqual(today) || date.isAfter(today));
                        boolean isActive = "scheduled".equalsIgnoreCase(status) || "confirmed".equalsIgnoreCase(status);
                        if (isUpcoming && isActive) {
                        if (nextAppointment == null || date.isBefore(nextAppointment.getAppointmentDate())) {
                        nextAppointment = a;
                        }
                        }
                        }
                        }

                        String displayName = user != null && user.getFullName() != null ? user.getFullName() :
                        "Patient";
                        String initials = "P";
                        if (displayName != null && !displayName.isBlank()) {
                        String[] parts = displayName.trim().split("\\s+");
                        initials = parts.length == 1
                        ? parts[0].substring(0, 1).toUpperCase()
                        : (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
                        }

                        DateTimeFormatter monthDay = DateTimeFormatter.ofPattern("dd MMM");
                        DateTimeFormatter fullDate = DateTimeFormatter.ofPattern("MMM d, yyyy");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Patient Dashboard – Smart Health</title>
                            <meta name="description"
                                content="Manage your appointments, health records, and personal details on the Smart Health Patient Portal.">
                            <link rel="preconnect" href="https://fonts.googleapis.com">
                            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                                rel="stylesheet">
                            <style>
                                /* ── Reset & Base ── */
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
                                    letter-spacing: 0.03em;
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
                                    transition: background .2s;
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
                                    background: linear-gradient(120deg, #e8f5ee 0%, #d0ece6 45%, #c5e8f2 100%);
                                    border-radius: 20px;
                                    padding: 28px 32px 24px;
                                    margin-bottom: 0;
                                    border: 1px solid #cde8e0;
                                }

                                .hero-eyebrow {
                                    font-size: 13px;
                                    font-weight: 600;
                                    color: #0d6b55;
                                    margin-bottom: 8px;
                                }

                                .hero-banner h1 {
                                    font-size: clamp(1.5rem, 3vw, 2.1rem);
                                    font-weight: 800;
                                    color: #0a2e22;
                                    line-height: 1.2;
                                    margin-bottom: 8px;
                                }

                                .hero-banner p {
                                    font-size: 13.5px;
                                    color: #4a7a6a;
                                    max-width: 560px;
                                    margin-bottom: 20px;
                                }

                                .hero-btn-row {
                                    display: flex;
                                    gap: 10px;
                                    flex-wrap: wrap;
                                }

                                .btn-hero-primary {
                                    background: #0d6b55;
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
                                    transition: background .2s;
                                }

                                .btn-hero-primary:hover {
                                    background: #0b5c48;
                                }

                                .btn-hero-ghost {
                                    background: transparent;
                                    color: #0d6b55;
                                    border: 1.5px solid #9ecfc4;
                                    border-radius: 10px;
                                    padding: 9px 20px;
                                    font-size: 13.5px;
                                    font-weight: 700;
                                    cursor: pointer;
                                    font-family: inherit;
                                    text-decoration: none;
                                    display: inline-block;
                                    transition: border-color .2s;
                                }

                                .btn-hero-ghost:hover {
                                    border-color: #0d6b55;
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

                                .stat-item .dot {
                                    display: inline-block;
                                    width: 8px;
                                    height: 8px;
                                    border-radius: 50%;
                                    margin-right: 5px;
                                    vertical-align: middle;
                                }

                                .dot-confirmed {
                                    background: #0d6b55;
                                }

                                .dot-scheduled {
                                    background: #f0aa2f;
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

                                /* Next Apt badge */
                                .badge-confirmed {
                                    display: inline-block;
                                    background: #e6f5ef;
                                    color: #0d6b55;
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

                                .ic-link {
                                    font-size: 12.5px;
                                    font-weight: 700;
                                    color: #0d6b55;
                                    text-decoration: none;
                                    display: inline-block;
                                    margin-top: 4px;
                                }

                                .ic-link:hover {
                                    text-decoration: underline;
                                }

                                /* Progress bar */
                                .prog-track {
                                    width: 100%;
                                    height: 8px;
                                    background: #e5efec;
                                    border-radius: 4px;
                                    overflow: hidden;
                                    margin: 4px 0 10px;
                                }

                                .prog-fill {
                                    height: 100%;
                                    background: #0d6b55;
                                    width: 0;
                                    border-radius: 4px;
                                    transition: width 1s ease;
                                }

                                .prog-pct {
                                    font-size: 22px;
                                    font-weight: 800;
                                    color: #0a2e22;
                                    margin-bottom: 2px;
                                }

                                /* Care Snapshot */
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
                                    background: #e6f5ef;
                                    color: #0d6b55;
                                }

                                .sp-scheduled {
                                    background: #fef3dd;
                                    color: #a06010;
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

                                /* ── Section Label ── */
                                .section-label {
                                    font-size: 11px;
                                    font-weight: 700;
                                    text-transform: uppercase;
                                    letter-spacing: .07em;
                                    color: #8aada3;
                                    margin: 0 0 14px;
                                }

                                /* ── Two-col grid ── */
                                .two-col {
                                    display: grid;
                                    grid-template-columns: 1fr 1fr;
                                    gap: 18px;
                                    margin-bottom: 28px;
                                }

                                @media (max-width: 680px) {
                                    .two-col {
                                        grid-template-columns: 1fr;
                                    }
                                }

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

                                /* Form fields */
                                .form-group {
                                    margin-bottom: 14px;
                                }

                                .form-group label {
                                    display: block;
                                    font-size: 10.5px;
                                    font-weight: 700;
                                    text-transform: uppercase;
                                    letter-spacing: .05em;
                                    color: #8aada3;
                                    margin-bottom: 5px;
                                }

                                .form-group input,
                                .form-group select,
                                .form-group textarea {
                                    width: 100%;
                                    padding: 10px 14px;
                                    border: 1.5px solid #d8ebe4;
                                    border-radius: 10px;
                                    background: #fff;
                                    color: #0a2e22;
                                    font-size: 13.5px;
                                    font-family: inherit;
                                    transition: box-shadow .2s, border-color .2s;
                                }

                                .form-group textarea {
                                    resize: vertical;
                                    min-height: 72px;
                                }

                                .form-group select {
                                    appearance: none;
                                    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%235e7c73' stroke-width='1.8' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
                                    background-repeat: no-repeat;
                                    background-position: calc(100% - 14px) 50%;
                                    padding-right: 36px;
                                    background-color: #fff;
                                }

                                .form-group input::placeholder,
                                .form-group textarea::placeholder {
                                    color: #8aada3;
                                }

                                .form-group input:focus,
                                .form-group select:focus,
                                .form-group textarea:focus {
                                    outline: none;
                                    box-shadow: 0 0 0 2.5px rgba(13, 107, 85, .35);
                                    background-color: #ffffff !important;
                                }

                                input,
                                select,
                                textarea {
                                    background-color: #ffffff !important;
                                    background: #ffffff !important;
                                    color: #0f3c2f !important;
                                    border: 1.5px solid #d8ebe4 !important;
                                }

                                /* ── Appointment History ── */
                                .history-section {
                                    margin-bottom: 32px;
                                }

                                .hist-item {
                                    display: grid;
                                    grid-template-columns: 56px 1fr auto;
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
                                    background: #e9f4ef;
                                    border-radius: 10px;
                                    padding: 7px 4px;
                                    text-align: center;
                                }

                                .hist-date-day {
                                    font-size: 17px;
                                    font-weight: 800;
                                    color: #0a2e22;
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
                                    background: #e6f5ef;
                                    color: #0d6b55;
                                }

                                .hb-scheduled {
                                    background: #fef3dd;
                                    color: #a06010;
                                }

                                .hb-cancelled {
                                    background: #fdecea;
                                    color: #a32d2d;
                                }

                                .hb-completed {
                                    background: #e0f0eb;
                                    color: #1a6a5c;
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

                                /* Scroll arrow */
                                .scroll-fab {
                                    position: fixed;
                                    bottom: 24px;
                                    right: 24px;
                                    width: 42px;
                                    height: 42px;
                                    border-radius: 50%;
                                    background: #0d6b55;
                                    color: #fff;
                                    border: 0;
                                    cursor: pointer;
                                    z-index: 200;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    box-shadow: 0 4px 14px rgba(13, 107, 85, .35);
                                    transition: background .2s;
                                }

                                .scroll-fab:hover {
                                    background: #0b5c48;
                                }
                            
                                 /* ── Mindblowing Success Popup Styles ── */
                                 .success-popup-overlay {
                                     position: fixed;
                                     top: 0;
                                     left: 0;
                                     width: 100%;
                                     height: 100%;
                                     background: rgba(10, 46, 34, 0.45);
                                     backdrop-filter: blur(12px);
                                     -webkit-backdrop-filter: blur(12px);
                                     display: flex;
                                     align-items: center;
                                     justify-content: center;
                                     z-index: 2000;
                                     opacity: 0;
                                     pointer-events: none;
                                     transition: opacity 0.4s cubic-bezier(0.16, 1, 0.3, 1);
                                 }

                                 .success-popup-overlay.active {
                                     opacity: 1;
                                     pointer-events: auto;
                                 }

                                 .success-popup-card {
                                     background: rgba(255, 255, 255, 0.95);
                                     border: 1px solid rgba(255, 255, 255, 0.4);
                                     box-shadow: 0 24px 64px rgba(13, 107, 85, 0.2), 
                                                 inset 0 0 0 1px rgba(255, 255, 255, 0.6);
                                     border-radius: 24px;
                                     padding: 36px 32px;
                                     width: 90%;
                                     max-width: 420px;
                                     text-align: center;
                                     position: relative;
                                     overflow: hidden;
                                     transform: scale(0.9) translateY(20px);
                                     transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
                                 }

                                 .success-popup-overlay.active .success-popup-card {
                                     transform: scale(1) translateY(0);
                                 }

                                 /* 3D Animated Checkmark */
                                 .success-icon-wrapper {
                                     width: 80px;
                                     height: 80px;
                                     border-radius: 50%;
                                     background: linear-gradient(135deg, #e8f5ee 0%, #c5e8f2 100%);
                                     display: flex;
                                     align-items: center;
                                     justify-content: center;
                                     margin: 0 auto 20px;
                                     box-shadow: 0 10px 20px rgba(13, 107, 85, 0.12);
                                     position: relative;
                                 }

                                 .success-svg {
                                     width: 52px;
                                     height: 52px;
                                     display: block;
                                 }

                                 .success-circle {
                                     stroke-dasharray: 166;
                                     stroke-dashoffset: 166;
                                     stroke-width: 3;
                                     stroke-miterlimit: 10;
                                     stroke: #0d6b55;
                                     fill: none;
                                     animation: stroke-circle 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
                                 }

                                 .success-check {
                                     transform-origin: 50% 50%;
                                     stroke-dasharray: 48;
                                     stroke-dashoffset: 48;
                                     stroke-width: 3;
                                     stroke: #0d6b55;
                                     stroke-linecap: round;
                                     animation: stroke-check 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.6s forwards;
                                 }

                                 @keyframes stroke-circle {
                                     100% {
                                         stroke-dashoffset: 0;
                                     }
                                 }

                                 @keyframes stroke-check {
                                     100% {
                                         stroke-dashoffset: 0;
                                     }
                                 }

                                 .success-popup-card h3 {
                                     font-size: 22px;
                                     font-weight: 800;
                                     color: #0a2e22;
                                     margin-bottom: 8px;
                                     letter-spacing: -0.02em;
                                 }

                                 .popup-subtitle {
                                     font-size: 13.5px;
                                     color: #4a7a6a;
                                     line-height: 1.4;
                                     margin-bottom: 24px;
                                 }

                                 /* Details Card */
                                 .appointment-details-card {
                                     background: linear-gradient(135deg, #f3f8f6 0%, #eaf4ee 100%);
                                     border: 1px solid #d4e8e2;
                                     border-radius: 16px;
                                     padding: 16px;
                                     margin-bottom: 28px;
                                     display: flex;
                                     flex-direction: column;
                                     gap: 10px;
                                     text-align: left;
                                 }

                                 .detail-row {
                                     display: flex;
                                     justify-content: space-between;
                                     align-items: center;
                                     font-size: 13px;
                                 }

                                 .detail-label {
                                     color: #5e7c73;
                                     font-weight: 600;
                                     font-size: 11px;
                                     text-transform: uppercase;
                                     letter-spacing: 0.05em;
                                 }

                                 .detail-value {
                                     color: #0a2e22;
                                     font-weight: 700;
                                 }

                                 /* Dynamic Confetti */
                                 .confetti-container {
                                     position: absolute;
                                     top: 0;
                                     left: 0;
                                     width: 100%;
                                     height: 100%;
                                     pointer-events: none;
                                     z-index: 10;
                                 }

                                 .confetti-piece {
                                     position: absolute;
                                     width: 8px;
                                     height: 8px;
                                     border-radius: 50%;
                                     opacity: 0;
                                 }

                                 /* Interactive Action Button */
                                 .popup-btn {
                                     width: 100%;
                                     padding: 12px;
                                     background: linear-gradient(135deg, #0d6b55 0%, #158f73 100%);
                                     color: #fff !important;
                                     border: 0;
                                     border-radius: 12px;
                                     font-size: 14px;
                                     font-weight: 800;
                                     cursor: pointer;
                                     font-family: inherit;
                                     box-shadow: 0 8px 20px rgba(13, 107, 85, 0.25);
                                     transition: transform 0.2s, box-shadow 0.2s, filter 0.2s;
                                 }

                                 .popup-btn:hover {
                                     transform: translateY(-2px);
                                     box-shadow: 0 12px 24px rgba(13, 107, 85, 0.35);
                                     filter: brightness(1.05);
                                 }

                                 .popup-btn:active {
                                     transform: translateY(0);
                                 }
                             </style>
                        </head>

                        <body>

                            <!-- ══ TOPBAR ══ -->
                            <header class="topbar">
                                <div class="brand">Smart Health<small>Patient Portal</small></div>
                                <div class="topbar-right">
                                    <span class="welcome-chip">Welcome, <%= displayName %></span>
                                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                                </div>
                            </header>

                            <main class="main">

                                <!-- ══ Flash Messages ══ -->
                                <% if (flashSuccess !=null) { %>
                                    <div class="flash success">
                                        <%= flashSuccess %>
                                    </div>
                                    <% } %>
                                        <% if (flashError !=null || request.getAttribute("error") !=null) { %>
                                            <div class="flash error">
                                                <%= flashError !=null ? flashError : request.getAttribute("error") %>
                                            </div>
                                            <% } %>

                                                <!-- ══ HERO BANNER ══ -->
                                                <section class="hero-banner">
                                                    <div class="hero-eyebrow">Your care, always connected</div>
                                                    <h1>Book, track, and manage your appointments</h1>
                                                    <p>Fast booking workflows with status updates, secure records, and
                                                        reminders built in.</p>
                                                    <div class="hero-btn-row">
                                                        <a href="#book-appointment" class="btn-hero-primary">Book
                                                            Appointment</a>
                                                        <a href="#appointment-history" class="btn-hero-ghost">View
                                                            History</a>
                                                    </div>
                                                </section>

                                                <!-- ══ STATS BAR ══ -->
                                                <div class="stats-bar">
                                                    <span class="stat-item">Total Appointments <strong>
                                                            <%= totalAppointments %>
                                                        </strong></span>
                                                    <span class="stat-item"><span
                                                            class="dot dot-confirmed"></span>Confirmed <strong>
                                                            <%= confirmedAppointments %>
                                                        </strong></span>
                                                    <span class="stat-item"><span
                                                            class="dot dot-scheduled"></span>Scheduled <strong>
                                                            <%= scheduledAppointments %>
                                                        </strong></span>
                                                    <span class="stat-item"><span
                                                            class="dot dot-cancelled"></span>Cancelled <strong>
                                                            <%= cancelledAppointments %>
                                                        </strong></span>
                                                </div>

                                                <!-- ══ INFO CARDS ROW ══ -->
                                                <div class="info-cards-row">

                                                    <!-- Next Appointment -->
                                                    <div class="info-card">
                                                        <div class="ic-label">Next Appointment</div>
                                                        <% if (nextAppointment !=null) { String
                                                            ns=nextAppointment.getStatus() !=null ?
                                                            nextAppointment.getStatus().toLowerCase() : "scheduled" ;
                                                            String badgeCls=ns.equals("confirmed") ? "badge-confirmed" :
                                                            (ns.equals("cancelled") ? "badge-cancelled"
                                                            : "badge-scheduled" ); %>
                                                            <div class="ic-date">
                                                                <%= nextAppointment.getAppointmentDate() !=null ?
                                                                    nextAppointment.getAppointmentDate().format(fullDate)
                                                                    : "—" %>
                                                            </div>
                                                            <div class="ic-sub">
                                                                <%= nextAppointment.getDoctorName() %>
                                                            </div>
                                                            <span class="<%= badgeCls %>">
                                                                <%= nextAppointment.getStatus() %>
                                                            </span><br>
                                                            <% } else { %>
                                                                <div class="ic-date"
                                                                    style="font-size:14px;color:#5e7c73;">No upcoming
                                                                    visit</div>
                                                                <div class="ic-sub">Book an appointment to get started.
                                                                </div>
                                                                <% } %>
                                                                    <a href="#book-appointment" class="ic-link">Book now
                                                                        →</a>
                                                    </div>

                                                    <!-- Profile Completion -->
                                                    <div class="info-card">
                                                        <div class="ic-label">Profile Completion</div>
                                                        <div class="prog-pct" id="profPct">0%</div>
                                                        <div class="prog-track">
                                                            <div class="prog-fill" id="progBar"
                                                                data-target="<%= profilePercent %>"></div>
                                                        </div>
                                                        <div class="ic-sub" style="margin-top:4px;">Add missing details
                                                            for faster check-ins.</div>
                                                        <a href="#personal-details" class="ic-link">Update profile →</a>
                                                    </div>

                                                    <!-- Care Snapshot -->
                                                    <div class="info-card">
                                                        <div class="ic-label">Care Snapshot</div>
                                                        <div class="ic-sub"
                                                            style="margin-bottom:8px;font-weight:600;color:#0a2e22;">
                                                            This month</div>
                                                        <div class="snap-pill-row">
                                                            <span class="snap-pill sp-confirmed">Confirmed <%=
                                                                    confirmedAppointments %></span>
                                                            <span class="snap-pill sp-scheduled">Scheduled <%=
                                                                    scheduledAppointments %></span>
                                                            <span class="snap-pill sp-cancelled">Cancelled <%=
                                                                    cancelledAppointments %></span>
                                                        </div>
                                                        <div class="snap-note">Keep an eye on upcoming visits.</div>
                                                    </div>
                                                </div>

                                                <!-- ══ APPOINTMENTS & BOOKING ══ -->
                                                <p class="section-label">Appointments &amp; Booking</p>
                                                <div class="two-col" id="book-appointment">

                                                    <!-- Book Appointment -->
                                                    <div class="panel">
                                                        <h2>Book Appointment</h2>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/patient/dashboard"
                                                            id="bookForm">
                                                            <input type="hidden" name="action" value="book">

                                                            <div class="form-group">
                                                                <label for="doctorId">Select Doctor</label>
                                                                <select name="doctorId" id="doctorId" required>
                                                                    <option value="">Choose doctor</option>
                                                                    <% if (doctors !=null) { for (Doctor d : doctors) {
                                                                        %>
                                                                        <option value="<%= d.getId() %>">
                                                                            <%= d.getDoctorName() %> – <%=
                                                                                    d.getSpecialization() %>
                                                                        </option>
                                                                        <% } } else { %>
                                                                            <option value="1">Dr. Priya Sharma –
                                                                                Cardiology</option>
                                                                            <option value="2">Dr. Anil Thapa – General
                                                                            </option>
                                                                            <option value="3">Dr. Rekha Joshi –
                                                                                Endocrinology</option>
                                                                            <% } %>
                                                                </select>
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="appointmentDate">Appointment Date</label>
                                                                <input type="date" name="appointmentDate"
                                                                    id="appointmentDate" required
                                                                    placeholder="mm/dd/yyyy">
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="reason">Reason for Visit</label>
                                                                <textarea name="reason" id="reason"
                                                                    placeholder="Describe your symptoms or reason…"
                                                                    required></textarea>
                                                            </div>

                                                            <button type="submit" id="bookBtn"
                                                                style="width:100%;padding:11px;background:#0d6b55;color:#fff;border:0;border-radius:10px;
                           font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;"
                                                                onmouseover="this.style.background='#0b5c48'"
                                                                onmouseout="this.style.background='#0d6b55'">
                                                                Confirm Appointment
                                                            </button>
                                                        </form>
                                                    </div>

                                                    <!-- Personal Details -->
                                                    <div class="panel" id="personal-details">
                                                        <h2>Personal Details</h2>
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/patient/dashboard"
                                                            id="profileForm">
                                                            <input type="hidden" name="action" value="updateProfile">

                                                            <div class="form-group">
                                                                <label for="phone">Phone</label>
                                                                <input type="tel" name="phone" id="phone"
                                                                    placeholder="+977-980-000-0000"
                                                                    value="<%= profile != null && profile.getPhone() != null ? profile.getPhone() : "" %>">
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="address">Address</label>
                                                                <input type="text" name="address" id="address"
                                                                    placeholder="Kathmandu, Nepal"
                                                                    value="<%= profile != null && profile.getAddress() != null ? profile.getAddress() : "" %>">
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="gender">Gender</label>
                                                                <% String g=profile !=null ? profile.getGender() : null;
                                                                    %>
                                                                    <select name="gender" id="gender">
                                                                        <option value="">Select</option>
                                                                        <option value="Male" <%="Male" .equals(g)
                                                                            ? "selected" : "" %>>Male</option>
                                                                        <option value="Female" <%="Female" .equals(g)
                                                                            ? "selected" : "" %>>Female</option>
                                                                        <option value="Other" <%="Other" .equals(g)
                                                                            ? "selected" : "" %>>Other</option>
                                                                        <option value="Prefer not to say"
                                                                            <%="Prefer not to say" .equals(g)
                                                                            ? "selected" : "" %>>Prefer not to say
                                                                        </option>
                                                                    </select>
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="age">Age</label>
                                                                <input type="number" name="age" id="age" min="0"
                                                                    max="120" placeholder="Enter age"
                                                                    value="<%= (profile != null && profile.getAge() != null) ? profile.getAge() : "" %>">
                                                            </div>

                                                            <button type="submit"
                                                                style="width:100%;padding:11px;background:#0d6b55;color:#fff;border:0;border-radius:10px;
                           font-size:14px;font-weight:700;cursor:pointer;font-family:inherit;transition:background .2s;"
                                                                onmouseover="this.style.background='#0b5c48'"
                                                                onmouseout="this.style.background='#0d6b55'">
                                                                Save Details
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>

                                                <!-- ══ APPOINTMENT HISTORY ══ -->
                                                <p class="section-label" style="margin-top:4px;">Upcoming Visits</p>
                                                <div class="panel history-section" id="appointment-history">
                                                    <h2>Appointment History</h2>
                                                    <div>
                                                        <% if (appointments !=null && !appointments.isEmpty()) { int
                                                            count=0; for (Appointment a : appointments) { if (count++>=
                                                            8) break;
                                                            String status = a.getStatus() != null ? a.getStatus() :
                                                            "scheduled";
                                                            String statusLC = status.toLowerCase();
                                                            String hbClass = "hb-scheduled";
                                                            if ("confirmed".equals(statusLC)) hbClass = "hb-confirmed";
                                                            if ("cancelled".equals(statusLC)) hbClass = "hb-cancelled";
                                                            if ("completed".equals(statusLC)) hbClass = "hb-completed";
                                                            LocalDate d = a.getAppointmentDate();
                                                            String dayStr = d != null ? String.format("%02d",
                                                            d.getDayOfMonth()) : "—";
                                                            String monStr = d != null ?
                                                            d.format(DateTimeFormatter.ofPattern("MMM")) : "";
                                                            %>
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
                                                                        <%= a.getDoctorName() %>
                                                                    </div>
                                                                    <div class="hist-meta">
                                                                        <%= a.getReason() !=null ? a.getReason() : "General Visit" %>
                                                                    </div>
                                                                </div>
                                                                <span class="hist-badge <%= hbClass %>">
                                                                    <%= status.substring(0,1).toUpperCase() + status.substring(1) %>
                                                                </span>
                                                            </div>
                                                            <% } } else { %>
                                                                <p style="color:#5e7c73;font-size:13.5px;">No appointment history yet.</p>
                                                                <% } %>
                                                     </div>
                                                 </div>

                                                <!-- Medical Records Section -->
                                                <p class="section-label" style="margin-top: 32px;">Clinical Records</p>
                                                <div class="panel" id="medical-records" style="margin-bottom: 24px; padding: 24px; background: #ffffff; border-radius: 16px; border: 1.5px solid #d4e8e2;">
                                                    <h2>My Medical Records</h2>
                                                    <div style="overflow-x:auto;">
                                                        <table style="width:100%; border-collapse:collapse; text-align:left; font-size:13px; color:#0f3c2f;">
                                                            <thead>
                                                                <tr style="background:#f3f7f5; border-bottom: 1.5px solid #d4e8e2;">
                                                                    <th style="padding:10px;">Visit Date</th>
                                                                    <th style="padding:10px;">Doctor</th>
                                                                    <th style="padding:10px;">Chief Complaint</th>
                                                                    <th style="padding:10px;">Diagnosis</th>
                                                                    <th style="padding:10px;">Treatment Plan</th>
                                                                    <th style="padding:10px;">Vitals</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% 
                                                                List<MedicalRecord> medicalRecords = (List<MedicalRecord>) request.getAttribute("medicalRecords");
                                                                if (medicalRecords != null && !medicalRecords.isEmpty()) {
                                                                    for (MedicalRecord rec : medicalRecords) {
                                                                %>
                                                                <tr style="border-bottom: 1px solid #e9efec;">
                                                                    <td style="padding:10px;"><%= rec.getVisitDate() %></td>
                                                                    <td style="padding:10px;"><strong><%= rec.getDoctorName() != null ? rec.getDoctorName() : "Doctor" %></strong></td>
                                                                    <td style="padding:10px;"><%= rec.getChiefComplaint() %></td>
                                                                    <td style="padding:10px;"><span style="background:#e0edf8; color:#1a5f9e; padding:2px 8px; border-radius:4px;"><%= rec.getDiagnosis() %></span></td>
                                                                    <td style="padding:10px;"><%= rec.getTreatmentPlan() %></td>
                                                                    <td style="padding:10px;">
                                                                        <small style="color:#5e7c73;">
                                                                            BP: <%= rec.getVitalsBp() %><br>
                                                                            Temp: <%= rec.getVitalsTemp() %>°F<br>
                                                                            Pulse: <%= rec.getVitalsPulse() %> bpm
                                                                        </small>
                                                                    </td>
                                                                </tr>
                                                                <% 
                                                                    }
                                                                } else {
                                                                %>
                                                                <tr>
                                                                    <td colspan="6" style="padding:12px; text-align:center; color:#5e7c73;">No medical records found.</td>
                                                                </tr>
                                                                <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>

                                                <!-- Prescriptions Section -->
                                                <p class="section-label" style="margin-top: 32px;">Active Prescriptions</p>
                                                <div class="panel" id="prescriptions" style="margin-bottom: 24px; padding: 24px; background: #ffffff; border-radius: 16px; border: 1.5px solid #d4e8e2;">
                                                    <h2>My Prescriptions</h2>
                                                    <div style="overflow-x:auto;">
                                                        <table style="width:100%; border-collapse:collapse; text-align:left; font-size:13px; color:#0f3c2f;">
                                                            <thead>
                                                                <tr style="background:#f3f7f5; border-bottom: 1.5px solid #d4e8e2;">
                                                                    <th style="padding:10px;">Rx ID</th>
                                                                    <th style="padding:10px;">Doctor</th>
                                                                    <th style="padding:10px;">Issued Date</th>
                                                                    <th style="padding:10px;">Expiry Date</th>
                                                                    <th style="padding:10px;">Medications & Directions</th>
                                                                    <th style="padding:10px;">Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% 
                                                                List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                                                                if (prescriptions != null && !prescriptions.isEmpty()) {
                                                                    for (Prescription rx : prescriptions) {
                                                                %>
                                                                <tr style="border-bottom: 1px solid #e9efec;">
                                                                    <td style="padding:10px;">#<%= rx.getId() %></td>
                                                                    <td style="padding:10px;"><strong><%= rx.getDoctorName() != null ? rx.getDoctorName() : "Doctor" %></strong></td>
                                                                    <td style="padding:10px;"><%= rx.getIssuedDate() %></td>
                                                                    <td style="padding:10px;"><%= rx.getExpiryDate() %></td>
                                                                    <td style="padding:10px;">
                                                                        <% if (rx.getItems() != null) { 
                                                                            for (PrescriptionItem item : rx.getItems()) { %>
                                                                            <div style="margin-bottom: 6px;">
                                                                                <strong><%= item.getMedicationName() %></strong> - 
                                                                                <%= item.getDosage() %>, <%= item.getFrequency() %> for <%= item.getDurationDays() %> days (Qty: <%= item.getQuantity() %>)<br>
                                                                                <small style="color:#5e7c73;"><%= item.getInstructions() %></small>
                                                                            </div>
                                                                        <% } } %>
                                                                    </td>
                                                                    <td style="padding:10px;"><span style="background:#e0edf8; color:#1a5f9e; padding:2px 8px; border-radius:4px;"><%= rx.getStatus() %></span></td>
                                                                </tr>
                                                                <% 
                                                                    }
                                                                } else {
                                                                %>
                                                                <tr>
                                                                    <td colspan="6" style="padding:12px; text-align:center; color:#5e7c73;">No prescriptions found.</td>
                                                                </tr>
                                                                <% } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>

                                                <!-- Insurance & Billing Sections in a two-column layout -->
                                                <div class="two-col" style="margin-top: 32px;">
                                                    <!-- Insurance Policy -->
                                                    <div class="panel" id="insurance" style="padding: 24px; background: #ffffff; border-radius: 16px; border: 1.5px solid #d4e8e2;">
                                                        <h2>Insurance Policy</h2>
                                                        <% 
                                                        List<Insurance> insList = (List<Insurance>) request.getAttribute("insuranceList");
                                                        Insurance activeIns = (insList != null && !insList.isEmpty()) ? insList.get(0) : null;
                                                        if (activeIns != null) {
                                                        %>
                                                        <div style="background: #e8f5ee; border: 1px solid #cfe0da; border-radius: 12px; padding: 16px; margin-bottom: 16px;">
                                                            <div style="font-size: 11px; font-weight:700; color:#5f9e8a; text-transform: uppercase;">Active Coverage</div>
                                                            <div style="font-size: 20px; font-weight:800; color:#0d6b55; margin-top: 4px;"><%= activeIns.getProviderName() %></div>
                                                            <div style="margin-top: 8px; font-size:13px; color:#0f3c2f;">
                                                                <strong>Policy No:</strong> <%= activeIns.getPolicyNumber() %><br>
                                                                <strong>Group No:</strong> <%= activeIns.getGroupNumber() != null ? activeIns.getGroupNumber() : "—" %><br>
                                                                <strong>Holder:</strong> <%= activeIns.getHolderName() != null ? activeIns.getHolderName() : "—" %><br>
                                                                <strong>Coverage Limit:</strong> $<%= activeIns.getCoverageLimit() %><br>
                                                                <strong>Validity:</strong> <%= activeIns.getValidFrom() %> to <%= activeIns.getValidTo() != null ? activeIns.getValidTo() : "Present" %>
                                                            </div>
                                                        </div>
                                                        <form method="post" action="${pageContext.request.contextPath}/patient/dashboard">
                                                            <input type="hidden" name="action" value="deleteInsurance">
                                                            <input type="hidden" name="insuranceId" value="<%= activeIns.getId() %>">
                                                            <button type="submit" style="width:100%; padding:10px; background:#c0362b; color:#fff; border:none; border-radius:10px; font-weight:700; cursor:pointer;">
                                                                Deregister Policy
                                                            </button>
                                                        </form>
                                                        <% } else { %>
                                                        <p style="color:#5e7c73; font-size:13.5px; margin-bottom: 16px;">No insurance policy registered.</p>
                                                        
                                                        <form method="post" action="${pageContext.request.contextPath}/patient/dashboard" style="display: flex; flex-direction: column; gap: 10px;">
                                                            <input type="hidden" name="action" value="addInsurance">
                                                            <div>
                                                                <label style="font-size:11px; font-weight:600; color:#5e7c73;">Insurance Company</label>
                                                                <input type="text" name="providerName" placeholder="e.g. MetLife" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                            </div>
                                                            <div>
                                                                <label style="font-size:11px; font-weight:600; color:#5e7c73;">Policy Number</label>
                                                                <input type="text" name="policyNumber" placeholder="e.g. POL-992384" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                            </div>
                                                            <div>
                                                                <label style="font-size:11px; font-weight:600; color:#5e7c73;">Group Number</label>
                                                                <input type="text" name="groupNumber" placeholder="e.g. GRP-445" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                            </div>
                                                            <div>
                                                                <label style="font-size:11px; font-weight:600; color:#5e7c73;">Policy Holder Name</label>
                                                                <input type="text" name="holderName" placeholder="e.g. John Doe" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                            </div>
                                                            <div style="display: flex; gap: 10px;">
                                                                <div style="flex: 1;">
                                                                    <label style="font-size:11px; font-weight:600; color:#5e7c73;">Valid From</label>
                                                                    <input type="date" name="validFrom" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                                </div>
                                                                <div style="flex: 1;">
                                                                    <label style="font-size:11px; font-weight:600; color:#5e7c73;">Valid To</label>
                                                                    <input type="date" name="validTo" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <label style="font-size:11px; font-weight:600; color:#5e7c73;">Coverage Limit ($)</label>
                                                                <input type="number" name="coverageLimit" value="5000" min="0" required style="width:100%; border:1.5px solid #cfe0da; padding:8px; border-radius:8px; background: #fff !important; color: #0f3c2f !important;">
                                                            </div>
                                                            <button type="submit" style="width:100%; padding:10px; background:#0d6b55; color:#fff; border:none; border-radius:10px; font-weight:700; cursor:pointer; margin-top: 4px;">
                                                                Register Policy
                                                            </button>
                                                        </form>
                                                        <% } %>
                                                    </div>

                                                    <!-- Invoices & Bills -->
                                                    <div class="panel" id="billing" style="padding: 24px; background: #ffffff; border-radius: 16px; border: 1.5px solid #d4e8e2;">
                                                        <h2>Invoices & Bills</h2>
                                                        <div style="overflow-x:auto;">
                                                            <table style="width:100%; border-collapse:collapse; text-align:left; font-size:13px; color:#0f3c2f;">
                                                                <thead>
                                                                    <tr style="background:#f3f7f5; border-bottom: 1.5px solid #d4e8e2;">
                                                                        <th style="padding:8px;">Date</th>
                                                                        <th style="padding:8px;">Description</th>
                                                                        <th style="padding:8px;">Amount</th>
                                                                        <th style="padding:8px;">Status</th>
                                                                        <th style="padding:8px;">Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% 
                                                                    List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
                                                                    if (invoices != null && !invoices.isEmpty()) {
                                                                        for (Invoice inv : invoices) {
                                                                            boolean isPaid = "Paid".equalsIgnoreCase(inv.getPaymentStatus());
                                                                    %>
                                                                    <tr style="border-bottom: 1px solid #e9efec;">
                                                                        <td style="padding:8px;"><%= inv.getIssuedDate() %></td>
                                                                        <td style="padding:8px;"><%= inv.getNotes() != null ? inv.getNotes() : "Medical Services" %></td>
                                                                        <td style="padding:8px;"><strong>$<%= inv.getTotal() %></strong></td>
                                                                        <td style="padding:8px;">
                                                                            <span style="background: <%= isPaid ? "#e6f5ef" : "#fdecea" %>; color: <%= isPaid ? "#0d6b55" : "#a32d2d" %>; padding:2px 8px; border-radius:4px; font-weight:bold;">
                                                                                <%= inv.getPaymentStatus() %>
                                                                            </span>
                                                                        </td>
                                                                        <td style="padding:8px;">
                                                                            <% if (!isPaid) { %>
                                                                            <form method="post" action="${pageContext.request.contextPath}/patient/dashboard">
                                                                                <input type="hidden" name="action" value="payInvoice">
                                                                                <input type="hidden" name="invoiceId" value="<%= inv.getId() %>">
                                                                                <input type="hidden" name="paymentMethod" value="Card">
                                                                                <button type="submit" style="background:#de7b0f; color:#fff; border:none; padding:4px 10px; border-radius:6px; font-weight:bold; cursor:pointer;">Pay</button>
                                                                            </form>
                                                                            <% } else { %>
                                                                            <span style="color:#5e7c73; font-style:italic;">N/A</span>
                                                                            <% } %>
                                                                        </td>
                                                                    </tr>
                                                                    <% 
                                                                        }
                                                                    } else {
                                                                    %>
                                                                    <tr>
                                                                        <td colspan="5" style="padding:12px; text-align:center; color:#5e7c73;">No bills or invoices issued.</td>
                                                                    </tr>
                                                                    <% } %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>

                            </main>

                            <!-- Scroll to top -->
                            <button class="scroll-fab" onclick="window.scrollTo({top:0,behavior:'smooth'})"
                                aria-label="Scroll to top">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                    <path d="M12 19V5M5 12l7-7 7 7" stroke="#fff" stroke-width="2.2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                            </button>

                            <!-- ── Success Popup Overlay ── -->
                             <div class="success-popup-overlay" id="successPopup">
                                 <div class="success-popup-card">
                                     <div class="confetti-container" id="confettiContainer"></div>
                                     <div class="success-icon-wrapper">
                                         <svg class="success-svg" viewBox="0 0 52 52">
                                             <circle class="success-circle" cx="26" cy="26" r="25" fill="none"/>
                                             <path class="success-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
                                         </svg>
                                     </div>
                                     <h3>Booking Confirmed!</h3>
                                     <p class="popup-subtitle">Your appointment has been successfully scheduled.</p>
                                     <div class="appointment-details-card">
                                         <div class="detail-row">
                                             <span class="detail-label">Doctor</span>
                                             <span class="detail-value" id="popupDoctor">-</span>
                                         </div>
                                         <div class="detail-row">
                                             <span class="detail-label">Date</span>
                                             <span class="detail-value" id="popupDate">-</span>
                                         </div>
                                     </div>
                                     <button class="popup-btn" id="popupCloseBtn">Acknowledge & Continue</button>
                                 </div>
                             </div>

                             <script>
                                /* ── Animate profile progress bar ── */
                                (function () {
                                    var bar = document.getElementById("progBar");
                                    var label = document.getElementById("profPct");
                                    if (!bar) return;
                                    var target = parseInt(bar.getAttribute("data-target"), 10) || 0;
                                    var curr = 0;
                                    setTimeout(function () {
                                        var t = setInterval(function () {
                                            curr += 2;
                                            if (curr >= target) { curr = target; clearInterval(t); }
                                            bar.style.width = curr + "%";
                                            if (label) label.textContent = curr + "%";
                                        }, 16);
                                    }, 500);
                                })();
                            
                                 /* ── Booking Confirmation & Success Pop-up Handler ── */
                                 (function () {
                                     // Submit listener on booking form to set sessionStorage flags
                                     var bookForm = document.getElementById("bookForm");
                                     if (bookForm) {
                                         bookForm.addEventListener("submit", function() {
                                             sessionStorage.setItem("justBooked", "true");
                                             var docSelect = document.getElementById("doctorId");
                                             var docName = docSelect.options[docSelect.selectedIndex].text;
                                             sessionStorage.setItem("bookedDoctor", docName);
                                             
                                             var dateVal = document.getElementById("appointmentDate").value;
                                             sessionStorage.setItem("bookedDate", dateVal);
                                         });
                                     }

                                     // Function to trigger the confetti burst
                                     function triggerConfetti() {
                                         var container = document.getElementById("confettiContainer");
                                         if (!container) return;
                                         container.innerHTML = "";
                                         var colors = ["#0d6b55", "#de7b0f", "#3a6e5f", "#4a90e2", "#f5a623", "#7ed321"];
                                         for (var i = 0; i < 60; i++) {
                                             var piece = document.createElement("div");
                                             piece.className = "confetti-piece";
                                             piece.style.background = colors[Math.floor(Math.random() * colors.length)];
                                             
                                             if (Math.random() > 0.5) {
                                                 piece.style.borderRadius = "0px"; // squares
                                             }
                                             
                                             container.appendChild(piece);
                                             
                                             var angle = Math.random() * Math.PI * 2;
                                             var velocity = 4 + Math.random() * 8;
                                             var x = 50; 
                                             var y = 50; 
                                             
                                             piece.style.left = x + "%";
                                             piece.style.top = y + "%";
                                             
                                             var transformX = Math.cos(angle) * velocity * 15;
                                             var transformY = Math.sin(angle) * velocity * 15;
                                             
                                             piece.animate([
                                                 { transform: 'translate(0, 0) scale(1)', opacity: 1 },
                                                 { transform: 'translate(' + transformX + 'px, ' + transformY + 'px) scale(0)', opacity: 0 }
                                             ], {
                                                 duration: 1000 + Math.random() * 1000,
                                                 easing: 'cubic-bezier(0.1, 0.8, 0.3, 1)',
                                                 fill: 'forwards'
                                             });
                                         }
                                     }

                                     // Check on page load if booking was successful
                                     var flashSuccess = "<%= flashSuccess != null ? flashSuccess : "" %>";
                                     var justBooked = sessionStorage.getItem("justBooked");
                                     
                                     if (flashSuccess && justBooked === "true") {
                                         var docName = sessionStorage.getItem("bookedDoctor") || "Your selected physician";
                                         var dateVal = sessionStorage.getItem("bookedDate");
                                         var formattedDate = "Scheduled Date";
                                         if (dateVal) {
                                             var dateObj = new Date(dateVal);
                                             if (!isNaN(dateObj.getTime())) {
                                                 formattedDate = dateObj.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
                                             } else {
                                                 formattedDate = dateVal;
                                             }
                                         }
                                         
                                         document.getElementById("popupDoctor").textContent = docName;
                                         document.getElementById("popupDate").textContent = formattedDate;
                                         
                                         // Hide standard flash success div if present
                                         var standardFlash = document.querySelector(".flash.success");
                                         if (standardFlash) {
                                             standardFlash.style.display = "none";
                                         }
                                         
                                         // Open the popup with a tiny delay for transition smoothness
                                         setTimeout(function() {
                                             var popup = document.getElementById("successPopup");
                                             if (popup) {
                                                 popup.classList.add("active");
                                                 triggerConfetti();
                                             }
                                         }, 150);
                                         
                                         // Clear flags
                                         sessionStorage.removeItem("justBooked");
                                         sessionStorage.removeItem("bookedDoctor");
                                         sessionStorage.removeItem("bookedDate");
                                     }

                                     // Close button listener
                                     var closeBtn = document.getElementById("popupCloseBtn");
                                     if (closeBtn) {
                                         closeBtn.addEventListener("click", function() {
                                             var popup = document.getElementById("successPopup");
                                             if (popup) {
                                                 popup.classList.remove("active");
                                             }
                                         });
                                     }
                                 })();
                             </script>
                        </body>

                        </html>