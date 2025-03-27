<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Your Healthcare Companion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/styles.css">
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

<div class="popup" id="resultsPopup">
    <div class="popup-content">
        <button class="close-btn" onclick="closePopup()">×</button>
        <h2>Available Time Slots</h2>
        <div class="results-grid" id="resultsContainer"></div>
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
</script>
<script src="<%=request.getContextPath()%>/assets/js/index.js?ver=<%=System.currentTimeMillis()%>"></script>
</body>
</html>