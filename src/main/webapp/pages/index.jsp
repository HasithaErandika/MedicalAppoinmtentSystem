<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Your Healthcare Companion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Light Mode Color Palette */
        :root {
            --primary: #4A90E2;        /* Soft Blue for trust and professionalism */
            --secondary: #26A69A;      /* Teal for health and positivity */
            --accent: #EF5350;         /* Soft Red for alerts or highlights */
            --bg-light: #F5F6F5;       /* Light Gray for clean backgrounds */
            --text-primary: #333333;   /* Dark Gray for readable text */
            --card-bg: #FFFFFF;        /* White for cards */
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05); /* Subtle shadow */
            --register-btn: #66BB6A;   /* Green for registration */
        }

        /* Reset and Base Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
        }
        .container { max-width: 1280px; margin: 0 auto; padding: 0 2rem; }

        /* Navigation */
        nav {
            background: var(--primary);
            position: fixed;
            width: 100%;
            z-index: 100;
            padding: 1rem 0;
            box-shadow: var(--shadow);
        }
        .nav-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 1.75rem;
            font-weight: 700;
            color: #FFFFFF;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .nav-actions {
            display: flex;
            gap: 1.5rem;
            align-items: center;
        }
        .register-btn {
            background: var(--register-btn);
            color: #FFFFFF;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            display: flex;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }
        .register-btn:hover {
            background: #4CAF50;
            transform: translateY(-2px);
        }
        .dropdown-btn {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            display: flex;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }
        .dropdown-btn:hover {
            background: #00897B;
            transform: translateY(-2px);
        }
        .dropdown { position: relative; }
        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: var(--card-bg);
            border-radius: 10px;
            box-shadow: var(--shadow);
            min-width: 180px;
            opacity: 0;
            visibility: hidden;
            transform: translateY(10px);
            transition: all 0.3s ease;
        }
        .dropdown:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        .dropdown-menu a {
            padding: 0.75rem 1.25rem;
            display: block;
            color: var(--text-primary);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .dropdown-menu a:hover {
            background: var(--secondary);
            color: #FFFFFF;
        }

        /* Hero Section */
        .hero {
            background: url('https://images.unsplash.com/photo-1576091160550-2173dba999ef') center/cover no-repeat;
            padding: 8rem 2rem 6rem;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(74, 144, 226, 0.8), rgba(38, 166, 154, 0.6));
        }
        .hero-content {
            position: relative;
            text-align: center;
            color: #FFFFFF;
            max-width: 800px;
            margin: 0 auto;
        }
        .hero h1 {
            font-size: 2.75rem;
            font-weight: 700;
            margin-bottom: 1rem;
            animation: slideUp 1s ease;
        }
        .hero p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
        }
        .cta-btn {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.8rem 2rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }
        .cta-btn:hover {
            background: #00897B;
            transform: scale(1.05);
        }

        /* Search Section */
        .search-section {
            margin: -3rem 2rem 4rem;
            position: relative;
        }
        .search-form {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            border: 2px solid var(--primary);
        }
        .search-form h2 {
            font-size: 1.75rem;
            margin-bottom: 1.5rem;
            color: var(--primary);
        }
        .form-grid {
            display: grid;
            gap: 1rem;
        }
        @media (min-width: 768px) {
            .form-grid { grid-template-columns: repeat(3, 1fr); }
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-primary);
        }
        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #E0E0E0;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
            outline: none;
        }
        .search-btn {
            background: var(--primary);
            color: #FFFFFF;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            margin: 1rem auto 0;
        }
        .search-btn:hover {
            background: #357ABD;
            transform: translateY(-2px);
        }

        /* Features Section */
        .features {
            padding: 4rem 0;
        }
        .features h2 {
            text-align: center;
            font-size: 2rem;
            margin-bottom: 3rem;
            color: var(--primary);
        }
        .features-grid {
            display: grid;
            gap: 2rem;
        }
        @media (min-width: 768px) {
            .features-grid { grid-template-columns: repeat(3, 1fr); }
        }
        .feature-card {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }
        .feature-card i {
            font-size: 2rem;
            color: var(--secondary);
            margin-bottom: 1rem;
        }
        .feature-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
            color: var(--text-primary);
        }

        /* Specialties Section */
        .specialties {
            padding: 4rem 0;
            background: linear-gradient(180deg, var(--bg-light) 70%, rgba(74, 144, 226, 0.05) 100%);
        }
        .specialties h2 {
            text-align: center;
            font-size: 2rem;
            margin-bottom: 3rem;
            color: var(--primary);
        }
        .specialties-grid {
            display: grid;
            gap: 2rem;
        }
        @media (min-width: 768px) {
            .specialties-grid { grid-template-columns: repeat(3, 1fr); }
        }
        .specialty-card {
            background: var(--card-bg);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }
        .specialty-card:hover {
            transform: translateY(-8px);
        }
        .specialty-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        .specialty-card-content {
            padding: 1.5rem;
        }
        .specialty-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
            color: var(--text-primary);
        }

        /* Footer */
        footer {
            background: var(--primary);
            color: #FFFFFF;
            padding: 2rem 0;
        }
        .footer-content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 2rem;
        }
        .footer-links a {
            color: #FFFFFF;
            margin-left: 1.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .footer-links a:hover {
            color: var(--secondary);
        }

        /* Animation */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
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
                <button class="dropdown-btn">
                    <i class="fas fa-user-md"></i> Login
                </button>
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
                <button type="submit" class="register-btn">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
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
        <form class="search-form" action="<%=request.getContextPath()%>/UserServlet" method="get">
            <h2>Find Your Doctor</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="specialty">Specialty</label>
                    <select id="specialty" name="specialty" class="form-input">
                        <option value="">All Specialties</option>
                        <option value="cardiology">Cardiology</option>
                        <option value="neurology">Neurology</option>
                        <option value="pediatrics">Pediatrics</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="doctor">Doctor Name</label>
                    <input type="text" id="doctor" name="doctor" class="form-input" placeholder="e.g., Dr. Smith">
                </div>
                <div class="form-group">
                    <label for="date">Preferred Date</label>
                    <input type="date" id="date" name="date" class="form-input" required>
                </div>
            </div>
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Search Doctors
            </button>
        </form>
    </div>
</section>

<section class="features">
    <div class="container">
        <h2>Why MediSchedule?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <i class="fas fa-bolt"></i>
                <h3>Instant Booking</h3>
                <p>Schedule with available doctors in seconds.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-shield-alt"></i>
                <h3>Secure Access</h3>
                <p>Your data stays protected with top-tier security.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-mobile-alt"></i>
                <h3>Mobile Friendly</h3>
                <p>Manage appointments anytime, anywhere.</p>
            </div>
        </div>
    </div>
</section>

<section class="specialties">
    <div class="container">
        <h2>Specialized Care Solutions</h2>
        <div class="specialties-grid">
            <div class="specialty-card">
                <img src="https://images.unsplash.com/photo-1576091160550-2173dba999ef" alt="Cardiology">
                <div class="specialty-card-content">
                    <h3>Cardiology</h3>
                    <p>Heart health management made simple.</p>
                </div>
            </div>
            <div class="specialty-card">
                <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d" alt="Dentistry">
                <div class="specialty-card-content">
                    <h3>Dentistry</h3>
                    <p>Smile with confidence through easy bookings.</p>
                </div>
            </div>
            <div class="specialty-card">
                <img src="https://img.freepik.com/premium-photo/psychology-doctor-examine-listen-patient-home-psychologic-health-care-house-isolated_660230-145414.jpg" alt="Psychology">
                <div class="specialty-card-content">
                    <h3>Psychology</h3>
                    <p>Mental wellness support at your fingertips.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="container footer-content">
        <p>© 2025 MediSchedule - Healthcare Simplified</p>
        <div class="footer-links">
            <a href="#">Privacy</a>
            <a href="#">Terms</a>
            <a href="#">Support</a>
        </div>
    </div>
</footer>
</body>
</html>