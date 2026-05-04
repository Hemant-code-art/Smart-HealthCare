<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Health</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/landing.css">
    </head>

    <body>
        <div class="bg-orb orb-1"></div>
        <div class="bg-orb orb-2"></div>
        <div class="bg-orb orb-3"></div>

        <header class="nav">
            <a class="logo" href="${pageContext.request.contextPath}/">Smart Health</a>
            <nav class="nav-links">
                <a href="#home">Home</a>
                <a href="#features">Features</a>
                <a href="#about">About</a>
                <a href="#contact">Contact</a>
            </nav>
            <a class="nav-cta" href="${pageContext.request.contextPath}/login">Login</a>
        </header>

        <main>
            <section id="home" class="hero">
                <div class="hero-content">
                    <span class="eyebrow">Smarter care, streamlined</span>
                    <h1>Your Health, Smarter and Simpler</h1>
                    <p>Book appointments, manage records, and access healthcare services effortlessly.</p>
                    <div class="hero-actions">
                        <a class="btn primary" href="${pageContext.request.contextPath}/login">Get Started</a>
                        <a class="btn ghost" href="${pageContext.request.contextPath}/login">Login</a>
                    </div>
                    <div class="hero-meta">
                        <div class="meta-item">
                            <strong>120+</strong>
                            <span>Clinics onboarded</span>
                        </div>
                        <div class="meta-item">
                            <strong>24/7</strong>
                            <span>Patient access</span>
                        </div>
                    </div>
                </div>
                <div class="hero-visual" aria-hidden="true">
                    <div class="glass-card">
                        <div class="card-header">
                            <span class="dot"></span>
                            <span class="dot"></span>
                            <span class="dot"></span>
                        </div>
                        <div class="card-body">
                            <div class="mini-row">
                                <div class="mini-avatar"></div>
                                <div class="mini-info">
                                    <div class="mini-title"></div>
                                    <div class="mini-sub"></div>
                                </div>
                                <div class="mini-badge">Approved</div>
                            </div>
                            <div class="mini-row">
                                <div class="mini-avatar"></div>
                                <div class="mini-info">
                                    <div class="mini-title"></div>
                                    <div class="mini-sub"></div>
                                </div>
                                <div class="mini-badge pending">Pending</div>
                            </div>
                            <div class="chart">
                                <div class="bar" style="--h: 60%;"></div>
                                <div class="bar" style="--h: 80%;"></div>
                                <div class="bar" style="--h: 45%;"></div>
                                <div class="bar" style="--h: 90%;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="floating-pill">
                        <div class="pill-icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path
                                    d="M12 4a4 4 0 0 1 4 4v1h1a4 4 0 1 1 0 8h-1v1a4 4 0 1 1-8 0v-1H7a4 4 0 1 1 0-8h1V8a4 4 0 0 1 4-4Z"
                                    fill="currentColor" />
                            </svg>
                        </div>
                        <div>
                            <p>Health Dashboard</p>
                            <span>Updated in real-time</span>
                        </div>
                    </div>
                </div>
            </section>

            <section id="features" class="features">
                <div class="section-header">
                    <h2>Designed for modern care teams</h2>
                    <p>Everything you need to manage appointments, records, and communication.</p>
                </div>
                <div class="feature-grid">
                    <article class="feature-card">
                        <div class="icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M6 3h12a2 2 0 0 1 2 2v14l-4-3H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2Z"
                                    fill="currentColor" />
                            </svg>
                        </div>
                        <h3>Easy Appointment Booking</h3>
                        <p>Find availability instantly and confirm bookings in seconds.</p>
                    </article>
                    <article class="feature-card">
                        <div class="icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path
                                    d="M12 2a6 6 0 0 1 6 6v3h1a3 3 0 1 1 0 6h-1v3a6 6 0 0 1-12 0v-3H5a3 3 0 1 1 0-6h1V8a6 6 0 0 1 6-6Z"
                                    fill="currentColor" />
                            </svg>
                        </div>
                        <h3>Secure Patient Records</h3>
                        <p>Role-based access keeps sensitive information protected.</p>
                    </article>
                    <article class="feature-card">
                        <div class="icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 3 2 8l10 5 10-5-10-5Zm0 9L2 7v9l10 5 10-5V7l-10 5Z" fill="currentColor" />
                            </svg>
                        </div>
                        <h3>Doctor Approval Workflow</h3>
                        <p>Automate approvals with clear queues and status tracking.</p>
                    </article>
                    <article class="feature-card">
                        <div class="icon">
                            <svg viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 2a9 9 0 0 1 9 9c0 4-2.6 7.3-6.2 8.5l-2.8 2-2.8-2A9 9 0 1 1 12 2Z"
                                    fill="currentColor" />
                            </svg>
                        </div>
                        <h3>Real-Time Notifications</h3>
                        <p>Keep patients and staff aligned with instant updates.</p>
                    </article>
                </div>
            </section>

            <section id="about" class="about">
                <div class="about-card">
                    <h2>About Smart Health</h2>
                    <p>Smart Health is a digital healthcare platform designed to simplify appointment booking and
                        patient management. We bring together clinics, doctors, and patients in one secure, intuitive
                        experience.</p>
                </div>
            </section>

            <section class="cta">
                <div class="cta-content">
                    <h2>Take control of your health today</h2>
                    <p>Join a platform built for transparency, trust, and better outcomes.</p>
                </div>
                <a class="btn primary" href="${pageContext.request.contextPath}/register">Register Now</a>
            </section>
        </main>

        <footer id="contact" class="footer">
            <div class="footer-brand">
                <h3>Smart Health</h3>
                <p>hmtcky@gmail.com<br>9824012375/9818267321</p>
            </div>
            <div class="footer-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms</a>
                <a href="#">Support</a>
            </div>
            <div class="footer-social">
                <a href="#" aria-label="LinkedIn">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path
                            d="M6 8.5V20H2.5V8.5H6Zm-1.8-5A2.2 2.2 0 1 1 4.2 7a2.2 2.2 0 0 1 0-4.4ZM21.5 20h-3.5v-5.7c0-1.4-.5-2.3-1.7-2.3a1.9 1.9 0 0 0-1.8 1.3 2.4 2.4 0 0 0-.1.9V20H11V8.5h3.4v1.6a3.7 3.7 0 0 1 3.3-1.8c2.4 0 3.8 1.6 3.8 4.6V20Z"
                            fill="currentColor" />
                    </svg>
                </a>
                <a href="#" aria-label="Twitter">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path
                            d="M19.9 7.2v.5A11.2 11.2 0 0 1 8.6 19a11 11 0 0 1-6-1.8 7.6 7.6 0 0 0 .9 0 7.8 7.8 0 0 0 4.8-1.6 3.9 3.9 0 0 1-3.6-2.7 4 4 0 0 0 1.7-.1 3.9 3.9 0 0 1-3.1-3.8v-.1a3.9 3.9 0 0 0 1.8.5 3.9 3.9 0 0 1-1.2-5.2 11.2 11.2 0 0 0 8.1 4.1 4.4 4.4 0 0 1 7.5-4 7.7 7.7 0 0 0 2.5-1 3.9 3.9 0 0 1-1.7 2.2 7.7 7.7 0 0 0 2.2-.6 8.4 8.4 0 0 1-1.9 2Z"
                            fill="currentColor" />
                    </svg>
                </a>
                <a href="#" aria-label="Facebook">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path
                            d="M14.7 8.6V6.5c0-1 .7-1.2 1.1-1.2h2.1V2H15c-3 0-4.2 2.2-4.2 4.3v2.3H8.2v3.5h2.6V22h3.9V12h2.8l.4-3.5h-3.2Z"
                            fill="currentColor" />
                    </svg>
                </a>
            </div>
            <div class="footer-copy">© 2026 Smart Health. All rights reserved.</div>
        </footer>
    </body>

    </html>