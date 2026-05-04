<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – Smart Health</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Plus Jakarta Sans", "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #e8f5ee 0%, #d0ece6 50%, #c5e8f2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px 16px;
        }

        .register-card {
            background: #fff;
            border-radius: 24px;
            padding: 36px 36px 28px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 24px 60px rgba(13, 107, 85, 0.12);
            border: 1px solid #d8ebe4;
        }

        .brand {
            font-size: 13px; font-weight: 800; color: #0d6b55;
            letter-spacing: 0.02em; margin-bottom: 4px;
        }
        .brand small { display: block; font-size: 10px; font-weight: 600; color: #5f9e8a; }

        h1 {
            font-size: 22px; font-weight: 800; color: #0a2e22;
            margin: 18px 0 4px;
        }
        .subtitle { font-size: 13px; color: #5e7c73; margin-bottom: 22px; }

        /* Role Toggle */
        .role-toggle {
            display: grid; grid-template-columns: 1fr 1fr;
            background: #f0f7f4; border-radius: 12px; padding: 4px;
            margin-bottom: 22px; border: 1px solid #d8ebe4;
        }
        .role-toggle input[type="radio"] { display: none; }
        .role-toggle label {
            text-align: center; padding: 10px 0; font-size: 13.5px; font-weight: 700;
            color: #5e7c73; border-radius: 9px; cursor: pointer;
            transition: background .2s, color .2s;
            display: flex; align-items: center; justify-content: center; gap: 7px;
            text-transform: none; letter-spacing: 0;
        }
        .role-toggle input[type="radio"]:checked + label {
            background: #0d6b55; color: #fff;
            box-shadow: 0 2px 8px rgba(13, 107, 85, 0.25);
        }
        .role-toggle label svg { width: 16px; height: 16px; }

        /* Form fields */
        .form-group { margin-bottom: 14px; }
        .form-group label {
            display: block; font-size: 10.5px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .05em;
            color: #8aada3; margin-bottom: 5px;
        }
        .form-group input,
        .form-group select {
            width: 100%; padding: 10px 14px;
            border: 1.5px solid #d8ebe4; border-radius: 10px;
            background: #fff; color: #0a2e22; font-size: 13.5px;
            font-family: inherit; transition: border-color .2s, box-shadow .2s;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none; border-color: #0d6b55;
            box-shadow: 0 0 0 3px rgba(13, 107, 85, 0.15);
        }
        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%235e7c73' stroke-width='1.8' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: calc(100% - 14px) 50%;
            padding-right: 36px;
        }

        /* Doctor-only section */
        .doctor-fields { display: none; }
        .doctor-fields.visible { display: block; }
        .section-divider {
            font-size: 10.5px; font-weight: 700; text-transform: uppercase;
            letter-spacing: .07em; color: #8aada3;
            margin: 18px 0 14px; padding-top: 14px;
            border-top: 1px solid #eaf2ee;
        }

        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

        /* Submit */
        .btn-submit {
            width: 100%; padding: 12px; background: #0d6b55; color: #fff;
            border: 0; border-radius: 12px; font-size: 14px; font-weight: 800;
            cursor: pointer; font-family: inherit; margin-top: 6px;
            transition: background .2s;
        }
        .btn-submit:hover { background: #0b5c48; }

        .footer-note {
            text-align: center; font-size: 12.5px; color: #5e7c73; margin-top: 16px;
        }
        .footer-note a { color: #0d6b55; font-weight: 700; text-decoration: none; }
        .footer-note a:hover { text-decoration: underline; }

        .flash-error {
            background: #ffece5; border: 1px solid #efb5a3; color: #7d2b0b;
            border-radius: 10px; padding: 10px 14px; font-size: 13px;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

<div class="register-card">
    <div class="brand">Smart Health<small>Patient &amp; Doctor Portal</small></div>

    <h1>Create your account</h1>
    <p class="subtitle">Join Smart Health to manage care, appointments, and more.</p>

    <% if (request.getAttribute("error") != null) { %>
    <div class="flash-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/register" id="regForm">

        <!-- Role Toggle -->
        <div class="role-toggle">
            <input type="radio" name="role" id="rolePatient" value="PATIENT" checked>
            <label for="rolePatient">
                <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a5 5 0 1 0 0-10 5 5 0 0 0 0 10Zm0 2c-5.33 0-8 2.67-8 4v2h16v-2c0-1.33-2.67-4-8-4Z"/></svg>
                Patient
            </label>
            <input type="radio" name="role" id="roleDoctor" value="DOCTOR">
            <label for="roleDoctor">
                <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2Zm-7 3a3 3 0 1 1 0 6 3 3 0 0 1 0-6Zm5 12H7v-.5C7 15 9 13 12 13s5 2 5 4.5V18Z"/></svg>
                Doctor
            </label>
        </div>

        <!-- Common Fields -->
        <div class="form-group">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" placeholder="e.g. Dr. Priya Sharma" required>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="you@example.com" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" minlength="6" placeholder="Min 6 characters" required>
        </div>

        <!-- Doctor-only Fields -->
        <div class="doctor-fields" id="doctorFields">
            <div class="section-divider">Doctor Profile</div>
            <div class="form-group">
                <label for="specialization">Specialization</label>
                <select id="specialization" name="specialization">
                    <option value="">Select specialization</option>
                    <option>Cardiology</option>
                    <option>General Practice</option>
                    <option>Endocrinology</option>
                    <option>Neurology</option>
                    <option>Pediatrics</option>
                    <option>Orthopedics</option>
                    <option>Dermatology</option>
                    <option>Psychiatry</option>
                    <option>Oncology</option>
                    <option>Radiology</option>
                </select>
            </div>
            <div class="two-col">
                <div class="form-group">
                    <label for="scheduleDay">Schedule Day</label>
                    <select id="scheduleDay" name="scheduleDay">
                        <option value="">Select day</option>
                        <option>Monday</option>
                        <option>Tuesday</option>
                        <option>Wednesday</option>
                        <option>Thursday</option>
                        <option>Friday</option>
                        <option>Saturday</option>
                        <option>Sunday</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="timeSlot">Time Slot</label>
                    <select id="timeSlot" name="timeSlot">
                        <option value="">Select slot</option>
                        <option>8:00 AM – 12:00 PM</option>
                        <option>12:00 PM – 4:00 PM</option>
                        <option>4:00 PM – 8:00 PM</option>
                        <option>8:00 AM – 4:00 PM</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="maxPatients">Max Patients Per Day</label>
                <input type="number" id="maxPatients" name="maxPatients" min="1" max="100" placeholder="e.g. 20" value="20">
            </div>
        </div>

        <button type="submit" class="btn-submit" id="submitBtn">Create Account</button>
    </form>

    <p class="footer-note">Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
</div>

<script>
    var patientRadio = document.getElementById("rolePatient");
    var doctorRadio  = document.getElementById("roleDoctor");
    var doctorFields = document.getElementById("doctorFields");
    var submitBtn    = document.getElementById("submitBtn");

    function updateRole() {
        var isDoctor = doctorRadio.checked;
        doctorFields.classList.toggle("visible", isDoctor);

        // Toggle required on doctor fields so form validation works correctly
        var docInputs = doctorFields.querySelectorAll("select, input");
        docInputs.forEach(function(el) {
            // Only specialization is required for doctor signup
            if (el.id === "specialization") {
                el.required = isDoctor;
            }
        });

        submitBtn.textContent = isDoctor ? "Register as Doctor" : "Create Account";
    }

    patientRadio.addEventListener("change", updateRole);
    doctorRadio.addEventListener("change", updateRole);
    updateRole();
</script>
</body>
</html>
