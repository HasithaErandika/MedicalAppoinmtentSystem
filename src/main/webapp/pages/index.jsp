<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Your Healthcare Companion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c5282;
            --secondary: #48bb78;
            --accent: #ed8936;
            --bg-light: #f7fafc;
            --bg-dark: #1a202c;
            --text-light: #2d3748;
            --text-dark: #e2e8f0;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        [data-theme="dark"] {
            --primary: #63b3ed;
            --secondary: #68d391;
            --bg-light: #1a202c;
            --text-light: #e2e8f0;
            --card-bg: #2d3748;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-light);
            line-height: 1.6;
            transition: all 0.3s ease;
        }

        .container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        /* Navbar */
        nav {
            background: linear-gradient(90deg, var(--primary) 0%, var(--primary) 50%, transparent 100%);
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
            color: white;
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

        .dropdown-btn {
            background: var(--secondary);
            color: white;
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            display: flex;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .dropdown-btn:hover {
            transform: translateY(-2px);
            background: #38a169;
        }

        .dropdown {
            position: relative;
        }

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
            color: var(--text-light);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .dropdown-menu a:hover {
            background: var(--secondary);
            color: white;
        }

        .theme-toggle {
            background: rgba(255,255,255,0.2);
            border: none;
            padding: 0.6rem;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .theme-toggle:hover {
            transform: rotate(20deg);
            background: rgba(255,255,255,0.3);
        }

        /* Hero */
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
            background: linear-gradient(135deg, rgba(44,82,130,0.8), rgba(72,187,120,0.6));
        }

        .hero-content {
            position: relative;
            text-align: center;
            color: white;
            max-width: 800px;
            margin: 0 auto;
        }

        .hero h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            animation: slideUp 1s ease;
        }

        .hero p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
        }

        .cta-btn {
            background: var(--accent);
            color: white;
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
            transform: scale(1.05);
            background: #dd6b20;
        }

        /* Search Form */
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
            .form-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44,82,130,0.2);
            outline: none;
        }

        .search-btn {
            background: var(--primary);
            color: white;
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
            background: #2b6cb0;
            transform: translateY(-2px);
        }

        /* Features */
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
            .features-grid {
                grid-template-columns: repeat(3, 1fr);
            }
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
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .feature-card i {
            font-size: 2rem;
            color: var(--secondary);
            margin-bottom: 1rem;
        }

        .feature-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
        }

        /* Specialties */
        .specialties {
            padding: 4rem 0;
            background: linear-gradient(180deg, var(--bg-light) 70%, rgba(44,82,130,0.1) 100%);
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
            .specialties-grid {
                grid-template-columns: repeat(3, 1fr);
            }
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
        }

        /* Footer */
        footer {
            background: var(--primary);
            color: white;
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
            color: white;
            margin-left: 1.5rem;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--accent);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
            <button class="theme-toggle" id="theme-toggle">
                <i class="fas fa-moon"></i>
            </button>
        </div>
    </div>
</nav>
<header class="hero">
    <div class="hero-content">
        <h1>Your Healthcare Journey Starts Here</h1>
        <p>Seamlessly book appointments and manage your medical needs with our intuitive platform.</p>
        <a href="#" class="cta-btn">
            <i class="fas fa-calendar-check"></i> Schedule Now
        </a>
    </div>
</header>

<section class="search-section">
    <div class="container">
        <form class="search-form">
            <h2>Find Your Perfect Appointment</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="doctor">Doctor</label>
                    <input type="text" id="doctor" class="form-input" placeholder="Dr. Name">
                </div>
                <div class="form-group">
                    <label for="hospital">Hospital</label>
                    <input type="text" id="hospital" class="form-input" placeholder="Hospital Name">
                </div>
                <div class="form-group">
                    <label for="specialty">Specialty</label>
                    <select id="specialty" class="form-input">
                        <option value="">Choose Specialty</option>
                        <option value="cardiology">Cardiology</option>
                        <option value="neurology">Neurology</option>
                        <option value="pediatrics">Pediatrics</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" class="form-input">
                </div>
            </div>
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Find Appointment
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
                <p>Schedule appointments in seconds with our streamlined system.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-shield-alt"></i>
                <h3>Secure Access</h3>
                <p>Your health data stays protected with top-tier security.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-mobile-alt"></i>
                <h3>Mobile Friendly</h3>
                <p>Manage your appointments anytime, anywhere.</p>
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
                <img src="https://images.unsplash.com/photo-1631217868264-e6b8221a077f" alt="Psychology">
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
<script>
    const toggle = document.getElementById('theme-toggle');
    const body = document.body;
    const sun = '<i class="fas fa-sun"></i>';
    const moon = '<i class="fas fa-moon"></i>';
    if (localStorage.getItem('theme') === 'dark') {
        body.setAttribute('data-theme', 'dark');
        toggle.innerHTML = sun;
    } else {
        toggle.innerHTML = moon;
    }
    toggle.addEventListener('click', () => {
        if (body.getAttribute('data-theme') === 'dark') {
            body.removeAttribute('data-theme');
            toggle.innerHTML = moon;
            localStorage.setItem('theme', 'light');
        } else {
            body.setAttribute('data-theme', 'dark');
            toggle.innerHTML = sun;
            localStorage.setItem('theme', 'dark');
        }
    });
</script>
</body>
</html>