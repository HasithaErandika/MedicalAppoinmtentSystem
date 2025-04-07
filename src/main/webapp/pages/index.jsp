<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Your Healthcare Companion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<%--    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/styles.css">--%>
    <style>
        :root {
            --primary: #4A90E2;    /* Calm blue */
            --secondary: #7ACCC8;  /* Soft teal */
            --accent: #F4F7FA;     /* Light gray-blue */
            --text: #2D3748;       /* Dark gray */
            --white: #FFFFFF;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, var(--accent), var(--white));
            color: var(--text);
            line-height: 1.6;
        }

        nav {
            background: var(--white);
            box-shadow: var(--shadow);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .logo {
            color: var(--primary);
            font-size: 1.5rem;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .logo:hover {
            color: var(--secondary);
        }

        .nav-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .dropdown-btn, .register-btn {
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            border: none;
            background: var(--primary);
            color: var(--white);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .dropdown-btn:hover, .register-btn:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }

        .dropdown-menu {
            position: absolute;
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow);
            padding: 0.5rem;
            display: none;
        }

        .dropdown:hover .dropdown-menu {
            display: block;
        }

        .hero {
            background: linear-gradient(45deg, var(--primary), var(--secondary));
            color: var(--white);
            padding: 5rem 2rem;
            text-align: center;
            clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
        }

        .hero-content h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            animation: fadeInUp 1s ease;
        }

        .cta-btn {
            display: inline-block;
            padding: 1rem 2rem;
            background: var(--white);
            color: var(--primary);
            border-radius: 25px;
            text-decoration: none;
            margin-top: 2rem;
            transition: all 0.3s ease;
        }

        .cta-btn:hover {
            background: var(--secondary);
            color: var(--white);
            transform: scale(1.05);
        }

        .search-section {
            padding: 4rem 2rem;
            background: var(--white);
            border-radius: 16px;
            margin: -3rem 2rem 0;
            position: relative;
            box-shadow: var(--shadow);
        }

        .search-form {
            max-width: 800px;
            margin: 0 auto;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin: 1rem 0;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-input {
            padding: 0.75rem;
            border: 1px solid var(--accent);
            border-radius: 8px;
            background: var(--accent);
            transition: border-color 0.3s ease;
        }

        .form-input:focus {
            border-color: var(--primary);
            outline: none;
        }

        .availability-table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            background: var(--white);
            border-radius: 8px;
            overflow: hidden;
        }

        .availability-table th {
            background: var(--primary);
            color: var(--white);
            padding: 1rem;
        }

        .availability-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--accent);
        }

        .login-popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            backdrop-filter: blur(4px);
        }

        .login-popup-content {
            background: var(--white);
            padding: 2rem;
            border-radius: 16px;
            max-width: 400px;
            margin: 2rem;
            box-shadow: var(--shadow);
            animation: slideIn 0.3s ease;
        }

        .login-btn {
            background: var(--primary);
            color: var(--white);
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .login-btn:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }
        .dropdown {
            position: relative;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            min-width: 200px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(8px);
            transition: var(--transition);
        }

        .dropdown:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-menu a {
            padding: 0.75rem 1.5rem;
            display: block;
            color: var(--text-primary);
            text-decoration: none;
            font-size: 0.9rem;
        }

        .dropdown-menu a:hover {
            background: var(--secondary);
            color: #FFFFFF;
        }


        .features, .specialties {
            padding: 4rem 2rem;
        }

        .features-grid, .specialties-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .feature-card, .specialty-card {
            background: var(--white);
            border-radius: 16px;
            padding: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: transform 0.3s ease;
        }

        .feature-card:hover, .specialty-card:hover {
            transform: translateY(-5px);
        }

        .specialty-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 12px 12px 0 0;
        }

        footer {
            background: var(--text);
            color: var(--white);
            padding: 2rem;
            text-align: center;
        }

        .footer-links a {
            color: var(--accent);
            margin: 0 1rem;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--secondary);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<nav>
    <div class="container nav-content">
        <a href="<%=request.getContextPath()%>/pages/index.jsp" class="logo">
            <i class="fas fa-heartbeat"></i> MediSchedule
        </a>
        <div class="nav-actions">
            <% if (session.getAttribute("username") == null) { %>
            <div class="dropdown">
                <button class="dropdown-btn"><i class="fas fa-user-md"></i> Login</button>
                <div class="dropdown-menu">
                    <a href="<%=request.getContextPath()%>/pages/login.jsp?role=patient">Patient Login</a>
                    <a href="<%=request.getContextPath()%>/pages/login.jsp?role=doctor">Doctor Login</a>
                    <a href="<%=request.getContextPath()%>/pages/login.jsp?role=admin">Admin Login</a>
                </div>
            </div>
            <button class="register-btn" onclick="window.location.href='<%=request.getContextPath()%>/pages/register.jsp';">
                <i class="fas fa-plus"></i> Register
            </button>
            <% } else { %>
            <a href="<%=request.getContextPath()%>/UserServlet" class="dropdown-btn">
                <i class="fas fa-user"></i> Profile
            </a>
            <form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;">
                <button type="submit" class="register-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </form>
            <% } %>
        </div>
    </div>
</nav>

<header class="hero">
    <div class="hero-content">
        <h1>Your Healthcare Journey Starts Here</h1>
        <p>Seamlessly book appointments with available doctors.</p>
        <a href="<%=request.getContextPath()%>/pages/login.jsp?role=patient" class="cta-btn">
            <i class="fas fa-calendar-check"></i> Schedule Now
        </a>
    </div>
</header>

<section class="search-section">
    <div class="container">
        <form class="search-form" id="searchForm">
            <h2>Find Your Doctor</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="specialty">Specialty</label>
                    <select id="specialty" name="specialty" class="form-input" onchange="updateAvailabilityTable()">
                        <option value="">Select Specialty</option>
                    </select>
                </div>
            </div>
            <div id="filterContainer" style="margin-top: 20px; display: none;">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="filterDoctor">Doctor Name</label>
                        <select id="filterDoctor" name="filterDoctor" class="form-input" onchange="filterTable()">
                            <option value="">All Doctors</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="filterDate">Preferred Date</label>
                        <select id="filterDate" name="filterDate" class="form-input" onchange="filterTable()">
                            <option value="">All Dates</option>
                        </select>
                    </div>
                </div>
            </div>
            <div id="availabilityTableContainer" style="margin-top: 20px;">
                <table id="availabilityTable" class="availability-table" style="display: none; width: 100%; border-collapse: collapse;">
                    <thead>
                    <tr>
                        <th>Doctor Name</th>
                        <th>Date</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Appointments Booked</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </form>
        <div id="debugResponse" style="margin-top: 20px; font-size: 12px; white-space: pre-wrap;"></div>
    </div>
</section>

<div class="login-popup" id="loginPopup">
    <div class="login-popup-content">
        <div class="popup-header">
            <i class="fas fa-lock"></i>
            <h2>Please Log In</h2>
        </div>
        <p>You need to log in as a patient to book an appointment.</p>
        <div class="countdown" id="countdownMessage" style="display: none;">
            Redirecting in <span id="countdownTimer">3</span> seconds...
        </div>
        <button class="login-btn" id="loginNowBtn">Log In Now</button>
    </div>
</div>

<section class="features">
    <div class="container">
        <h2>Why MediSchedule?</h2>
        <div class="features-grid">
            <div class="feature-card"><i class="fas fa-bolt"></i><h3>Instant Booking</h3><p>Schedule with available doctors in seconds.</p></div>
            <div class="feature-card"><i class="fas fa-shield-alt"></i><h3>Secure Access</h3><p>Your data stays protected with top-tier security.</p></div>
            <div class="feature-card"><i class="fas fa-mobile-alt"></i><h3>Mobile Friendly</h3><p>Manage appointments anytime, anywhere.</p></div>
        </div>
    </div>
</section>

<section class="specialties">
    <div class="container">
        <h2>Specialized Care Solutions</h2>
        <div class="specialties-grid">
            <div class="specialty-card"><img src="https://images.unsplash.com/photo-1576091160550-2173dba999ef" alt="Cardiology"><div class="specialty-card-content"><h3>Cardiology</h3><p>Heart health management made simple.</p></div></div>
            <div class="specialty-card"><img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d" alt="Dentistry"><div class="specialty-card-content"><h3>Dentistry</h3><p>Smile with confidence through easy bookings.</p></div></div>
            <div class="specialty-card"><img src="https://img.freepik.com/premium-photo/psychology-doctor-examine-listen-patient-home-psychologic-health-care-house-isolated_660230-145414.jpg" alt="Psychology"><div class="specialty-card-content"><h3>Psychology</h3><p>Mental wellness support at your fingertips.</p></div></div>
        </div>
    </div>
</section>

<footer>
    <div class="container footer-content">
        <p>© 2025 MediSchedule - Healthcare Simplified</p>
        <div class="footer-links">
            <a href="#">Privacy</a><a href="#">Terms</a><a href="#">Support</a>
        </div>
    </div>
</footer>

<script>
    window.contextPath = "<%=request.getContextPath()%>";
    <% if (session.getAttribute("username k") != null) { %>
    document.body.dataset.loggedIn = "true";
    <% } else { %>
    document.body.dataset.loggedIn = "false";
    <% } %>
</script>
<script src="<%=request.getContextPath()%>/assets/js/index.js?ver=<%=System.currentTimeMillis()%>"></script>
</body>
</html>