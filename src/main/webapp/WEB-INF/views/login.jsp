<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Smart Health - Login</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2.2">
        <style>
            input {
                background-color: #ffffff !important;
                background: #ffffff !important;
                color: #0f3c2f !important;
                border: 1.5px solid #cfe0da !important;
            }

            input:focus {
                border-color: #0d6b55 !important;
                box-shadow: 0 0 0 4px rgba(13, 107, 85, 0.25) !important;
            }
        </style>
    </head>

    <body>
        <div class="split">
            <section class="auth-card">
                <h1>Smart Health</h1>
                <p>Secure patient appointment and management portal.</p>
                <ul>
                    <li>Book and manage appointments</li>
                    <li>Admin approval workflow</li>
                    <li>Patient records and reporting</li>
                </ul>
            </section>

            <section class="auth-card">
                <h2>Login</h2>
                <% if (request.getParameter("registered") !=null) { %>
                    <div class="flash success">Registration successful. Please login.</div>
                    <% } %>
                        <% if (request.getAttribute("error") !=null) { %>
                            <div class="flash error">
                                <%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                                <form method="post" action="${pageContext.request.contextPath}/login">
                                    <label>Email</label>
                                    <input type="email" name="email" required>

                                    <label>Password</label>
                                    <input type="password" name="password" required>

                                    <button type="submit">Login</button>
                                </form>

                                <p class="meta">No account? <a href="${pageContext.request.contextPath}/register">Create
                                        patient account</a></p>
                                <p class="meta">Demo admin: admin@health.com | password: 1234</p>
            </section>
        </div>
    </body>

    </html>