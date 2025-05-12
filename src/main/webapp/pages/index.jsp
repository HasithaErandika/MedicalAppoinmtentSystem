<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="MediSchedule - Book doctor appointments easily and securely.">
    <title>MediSchedule - Your Healthcare Companion</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/index.css">
</head>
<body>
<nav aria-label="Main navigation">
    <div class="container nav-content">
        <a href="<%=request.getContextPath()%>/pages/index.jsp" class="logo" aria-label="MediSchedule Home">
            <i class="fas fa-heartbeat"></i> MediSchedule
        </a>
        <button class="mobile-menu-toggle" aria-label="Toggle menu" aria-expanded="false">
            <i class="fas fa-bars"></i>
        </button>
        <div class="nav-actions" role="navigation">
            <% if (session.getAttribute("username") == null) { %>
            <div class="dropdown">
                <button class="dropdown-btn" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-user-md"></i> Login
                </button>
                <div class="dropdown-menu" role="menu">
                    <a href="<%=request.getContextPath()%>/pages/login.jsp?role=patient" role="menuitem">Patient Login</a>
                    <a href="<%=request.getContextPath()%>/pages/login.jsp?role=doctor" role="menuitem">Doctor Login</a>
                    <a href="<%=request.getContextPath()%>/pages/login.jsp?role=admin" role="menuitem">Admin Login</a>
                </div>
            </div>
            <button class="register-btn" onclick="window.location.href='<%=request.getContextPath()%>/pages/register.jsp';">
                <i class="fas fa-plus"></i> Register
            </button>
            <% } else { %>
            <% if ("patient".equals(session.getAttribute("role"))) { %>
            <a href="<%=request.getContextPath()%>/pages/userProfile/userProfile.jsp" class="dropdown-btn" aria-label="View Patient Profile">
                <i class="fas fa-user"></i> My Profile
            </a>
            <% } %>
            <form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;">
                <button type="submit" class="register-btn" aria-label="Logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </button>
            </form>
            <% } %>
        </div>
    </div>
</nav>

<header class="hero" role="banner">
    <div class="hero-content">
        <h1>Your Healthcare Journey Starts Here</h1>
        <p>Seamlessly book appointments with top doctors.</p>
        <a href="<%=request.getContextPath()%>/pages/login.jsp?role=patient" class="cta-btn" aria-label="Schedule an appointment">
            <i class="fas fa-calendar-check"></i> Schedule Now
        </a>
    </div>
</header>

<section class="appointment-section" aria-labelledby="appointment-heading">
    <div class="container">
        <% if (session.getAttribute("username") != null && "patient".equals(session.getAttribute("role"))) { %>
        <h2 id="appointment-heading">Manage Your Appointments</h2>
        <div class="tabs">
            <button class="tab-btn active" data-tab="bookAppointment" aria-selected="true" aria-controls="bookAppointment">Book Appointment</button>
            <button class="tab-btn" data-tab="appointments" aria-selected="false" aria-controls="appointments">My Appointments</button>
        </div>
        <div class="tab-content">
            <!-- Book Appointment Section -->
            <div id="bookAppointment" class="tab-pane active" role="region" aria-labelledby="book-appointment-title">
                <header class="section-header">
                    <h3 id="book-appointment-title">
                        <i class="fas fa-calendar-plus" aria-hidden="true"></i> Schedule Your Appointment
                    </h3>
                </header>
                <form id="bookForm" class="appointment-form" novalidate>
                    <div class="form-field">
                        <label for="specialty" class="form-label">Specialty</label>
                        <select id="specialty" name="specialty" class="form-select" required aria-required="true" aria-describedby="specialty-error">
                            <option value="">Select Specialty</option>
                        </select>
                        <span class="error-text" id="specialty-error" aria-live="polite"></span>
                    </div>
                    <div id="filterContainer" class="filter-section" style="display: none;">
                        <div class="filter-grid">
                            <div class="form-field">
                                <label for="filterDoctor" class="form-label">Doctor Name</label>
                                <select id="filterDoctor" name="doctorId" class="form-select">
                                    <option value="">All Doctors</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="filterDate" class="form-label">Preferred Date</label>
                                <select id="filterDate" name="date" class="form-select">
                                    <option value="">All Dates</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div id="availabilityTableContainer" class="table-section">
                        <table id="availabilityTable" class="availability-table" style="display: none;" aria-label="Doctor Availability">
                            <thead>
                            <tr>
                                <th scope="col">Doctor Name</th>
                                <th scope="col">Date</th>
                                <th scope="col">Start Time</th>
                                <th scope="col">End Time</th>
                                <th scope="col">Appointments Booked</th>
                                <th scope="col">Your Token</th>
                                <th scope="col">Action</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div id="noResults" class="no-results" style="display: none;">
                            <i class="fas fa-calendar-times" aria-hidden="true"></i>
                            <p>No available appointments found.</p>
                        </div>
                    </div>
                </form>
            </div>
            <!-- My Appointments Section -->
            <div id="appointments" class="tab-pane" role="region" aria-labelledby="appointments-title">
                <header class="section-header">
                    <h3 id="appointments-title">
                        <i class="fas fa-calendar-alt" aria-hidden="true"></i> Your Appointments
                    </h3>
                </header>
                <div class="table-container">
                    <table role="grid" class="appointments-table" aria-label="Your Appointments">
                        <thead>
                        <tr>
                            <th scope="col" data-sort="0" class="sortable">
                                ID <i class="fas fa-sort" aria-hidden="true"></i>
                            </th>
                            <th scope="col" data-sort="1" class="sortable">
                                Doctor <i class="fas fa-sort" aria-hidden="true"></i>
                            </th>
                            <th scope="col" data-sort="2" class="sortable">
                                Token <i class="fas fa-sort" aria-hidden="true"></i>
                            </th>
                            <th scope="col" data-sort="3" class="sortable">
                                Date & Time <i class="fas fa-sort" aria-hidden="true"></i>
                            </th>
                            <th scope="col" data-sort="4" class="sortable">
                                Priority <i class="fas fa-sort" aria-hidden="true"></i>
                            </th>
                            <th scope="col">Actions</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <div class="no-appointments" id="noAppointmentsMessage" style="display: none;">
                        <i class="fas fa-calendar-times" aria-hidden="true"></i>
                        <p>No appointments found.</p>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <h2 id="appointment-heading">Schedule Your Appointment</h2>
        <div class="tab-content">
            <div id="bookAppointment" class="tab-pane active" role="region" aria-labelledby="book-appointment-title">
                <header class="section-header">
                    <h3 id="book-appointment-title">
                        <i class="fas fa-calendar-plus" aria-hidden="true"></i> Find a Doctor
                    </h3>
                </header>
                <form id="bookForm" class="appointment-form" novalidate>
                    <div class="form-field">
                        <label for="specialty" class="form-label">Specialty</label>
                        <select id="specialty" name="specialty" class="form-select" required aria-required="true" aria-describedby="specialty-error">
                            <option value="">Select Specialty</option>
                        </select>
                        <span class="error-text" id="specialty-error" aria-live="polite"></span>
                    </div>
                    <div id="filterContainer" class="filter-section" style="display: none;">
                        <div class="filter-grid">
                            <div class="form-field">
                                <label for="filterDoctor" class="form-label">Doctor Name</label>
                                <select id="filterDoctor" name="doctorId" class="form-select">
                                    <option value="">All Doctors</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label for="filterDate" class="form-label">Preferred Date</label>
                                <select id="filterDate" name="date" class="form-select">
                                    <option value="">All Dates</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div id="availabilityTableContainer" class="table-section">
                        <table id="availabilityTable" class="availability-table" style="display: none;" aria-label="Doctor Availability">
                            <thead>
                            <tr>
                                <th scope="col">Doctor Name</th>
                                <th scope="col">Date</th>
                                <th scope="col">Start Time</th>
                                <th scope="col">End Time</th>
                                <th scope="col">Appointments Booked</th>
                                <th scope="col">Your Token</th>
                                <th scope="col">Action</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div id="noResults" class="no-results" style="display: none;">
                            <i class="fas fa-calendar-times" aria-hidden="true"></i>
                            <p>No available appointments found.</p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</section>

<!-- Confirmation Modal -->
<dialog id="confirmModal" class="modal" aria-labelledby="modal-title" aria-modal="true">
    <div class="modal-content">
        <h3 id="modal-title">Confirm Booking</h3>
        <p id="confirmMessage">Are you sure you want to book this appointment?</p>
        <div id="appointmentDetails" class="appointment-details"></div>
        <div class="modal-actions">
            <button id="cancelBtn" class="cancel-btn" type="button">Cancel</button>
            <button id="confirmBtn" class="confirm-btn" type="button">Confirm</button>
        </div>
    </div>
</dialog>

<!-- Success Modal -->
<dialog id="successModal" class="modal" aria-labelledby="success-modal-title" aria-modal="true">
    <div class="modal-content">
        <h3 id="success-modal-title">Booking Confirmed</h3>
        <p id="successMessage">You have successfully confirmed your booking!</p>
        <div id="successAppointmentDetails" class="appointment-details"></div>
        <div class="modal-actions">
            <button id="successCloseBtn" class="confirm-btn" type="button">Close</button>
        </div>
    </div>
</dialog>

<!-- Cancel Confirmation Modal -->
<dialog id="cancelModal" class="modal" aria-labelledby="cancel-modal-title" aria-modal="true">
    <div class="modal-content">
        <h3 id="cancel-modal-title">Confirm Cancellation</h3>
        <p id="cancelMessage">Are you sure you want to cancel this appointment?</p>
        <div id="cancelAppointmentDetails" class="appointment-details"></div>
        <div class="modal-actions">
            <button id="cancelModalCancelBtn" class="cancel-btn" type="button">No, Keep</button>
            <button id="cancelModalConfirmBtn" class="confirm-btn" type="button">Yes, Cancel</button>
        </div>
    </div>
</dialog>

<!-- Login/Register Modal for Non-Logged-In Users -->
<dialog id="loginRegisterModal" class="modal" aria-labelledby="login-register-modal-title" aria-modal="true">
    <div class="modal-content">
        <h3 id="login-register-modal-title">Action Required</h3>
        <p>Please log in or register to book an appointment.</p>
        <div class="modal-actions">
            <button id="loginModalBtn" class="confirm-btn" type="button">Log In</button>
            <button id="registerModalBtn" class="confirm-btn" type="button">Register</button>
            <button id="cancelLoginModalBtn" class="cancel-btn" type="button">Cancel</button>
        </div>
    </div>
</dialog>

<section class="features" aria-labelledby="features-heading">
    <div class="container">
        <h2 id="features-heading">Why Choose MediSchedule?</h2>
        <div class="features-grid">
            <div class="feature-card" role="article">
                <i class="fas fa-bolt"></i>
                <h3>Instant Booking</h3>
                <p>Schedule with available doctors in seconds.</p>
            </div>
            <div class="feature-card" role="article">
                <i class="fas fa-shield-alt"></i>
                <h3>Secure Access</h3>
                <p>Your data stays protected with top-tier security.</p>
            </div>
            <div class="feature-card" role="article">
                <i class="fas fa-mobile-alt"></i>
                <h3>Mobile Friendly</h3>
                <p>Manage appointments anytime, anywhere.</p>
            </div>
        </div>
    </div>
</section>

<section class="specialties" aria-labelledby="specialties-heading">
    <div class="container">
        <h2 id="specialties-heading">Specialized Care Solutions</h2>
        <div class="specialties-grid">
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Cardiology.jpg" alt="Cardiology care">
                <div class="specialty-card-content">
                    <h3>Cardiology</h3>
                    <p>Expert care for your heart health.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Dentist.jpg" alt="Dentistry care">
                <div class="specialty-card-content">
                    <h3>Dentistry</h3>
                    <p>Perfect smiles, one visit at a time.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Psycology.jpg" alt="Psychology care">
                <div class="specialty-card-content">
                    <h3>Psychology</h3>
                    <p>Support for your mental well-being.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Pediatrics.jpg" alt="Pediatrics care">
                <div class="specialty-card-content">
                    <h3>Pediatrics</h3>
                    <p>Gentle care for little ones.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Orthopedics.png" alt="Orthopedics care">
                <div class="specialty-card-content">
                    <h3>Orthopedics</h3>
                    <p>Strengthening bones and joints.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Neurology.png" alt="Neurology care">
                <div class="specialty-card-content">
                    <h3>Neurology</h3>
                    <p>Advanced care for your brain.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Dermatology.png" alt="Dermatology care">
                <div class="specialty-card-content">
                    <h3>Dermatology</h3>
                    <p>Healthy skin starts here.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Ophthalmology.png" alt="Ophthalmology care">
                <div class="specialty-card-content">
                    <h3>Ophthalmology</h3>
                    <p>Clear vision, expert care.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Endocrinology.png" alt="Endocrinology care">
                <div class="specialty-card-content">
                    <h3>Endocrinology</h3>
                    <p>Balance your hormones with ease.</p>
                </div>
            </div>
            <div class="specialty-card" role="article">
                <img src="<%=request.getContextPath()%>/assets/images/Gastroenterology.png" alt="Gastroenterology care">
                <div class="specialty-card-content">
                    <h3>Gastroenterology</h3>
                    <p>Digestive health, simplified.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<footer role="contentinfo">
    <div class="container footer-content">
        <p>© 2025 MediSchedule - Healthcare Simplified</p>
        <div class="footer-links">
            <a href="#" aria-label="Privacy Policy">Privacy</a>
            <a href="#" aria-label="Terms of Service">Terms</a>
            <a href="#" aria-label="Support">Support</a>
        </div>
    </div>
</footer>

<script>
    window.contextPath = "<%=request.getContextPath()%>";
    <% if (session.getAttribute("username") != null) { %>
    document.body.dataset.loggedIn = "true";
    document.body.dataset.role = "<%=session.getAttribute("role")%>";
    <% } else { %>
    document.body.dataset.loggedIn = "false";
    document.body.dataset.role = "";
    <% } %>
</script>
<script src="<%=request.getContextPath()%>/assets/js/index.js?ver=<%=System.currentTimeMillis()%>"></script>
</body>
</html>