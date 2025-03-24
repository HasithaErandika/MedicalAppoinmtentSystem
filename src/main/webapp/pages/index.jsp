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
            --primary: #2C6EBF;
            --secondary: #1A937C;
            --accent: #E63946;
            --bg-light: #F8FAFC;
            --text-primary: #1F2A44;
            --text-secondary: #64748B;
            --card-bg: #FFFFFF;
            --shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            --register-btn: #34C759;
            --border-radius: 12px;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.7;
        }
        .container { max-width: 1280px; margin: 0 auto; padding: 0 1.5rem; }
        nav {
            background: var(--primary);
            position: fixed;
            width: 100%;
            z-index: 100;
            padding: 1.25rem 0;
            box-shadow: var(--shadow);
        }
        .nav-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 1.75rem;
            font-weight: 600;
            color: #FFFFFF;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .nav-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        .register-btn, .dropdown-btn {
            padding: 0.65rem 1.75rem;
            border-radius: var(--border-radius);
            border: none;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .register-btn {
            background: var(--register-btn);
            color: #FFFFFF;
        }
        .register-btn:hover {
            background: #2DB84C;
            transform: translateY(-2px);
        }
        .dropdown-btn {
            background: var(--secondary);
            color: #FFFFFF;
        }
        .dropdown-btn:hover {
            background: #16725F;
            transform: translateY(-2px);
        }
        .dropdown { position: relative; }
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
            transition: all 0.2s ease;
        }
        .dropdown:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }
        .dropdown-menu a {
            padding: 0.85rem 1.5rem;
            display: block;
            color: var(--text-primary);
            text-decoration: none;
            font-size: 0.95rem;
        }
        .dropdown-menu a:hover {
            background: var(--secondary);
            color: #FFFFFF;
        }
        .hero {
            background: url('https://images.unsplash.com/photo-1576091160550-2173dba999ef') center/cover no-repeat;
            padding: 9rem 2rem 7rem;
            position: relative;
        }
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(44, 110, 191, 0.85), rgba(26, 147, 124, 0.7));
        }
        .hero-content {
            position: relative;
            text-align: center;
            color: #FFFFFF;
            max-width: 900px;
            margin: 0 auto;
        }
        .hero h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1.25rem;
        }
        .hero p {
            font-size: 1.2rem;
            margin-bottom: 2.5rem;
            color: rgba(255, 255, 255, 0.9);
        }
        .cta-btn {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.9rem 2.5rem;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .cta-btn:hover {
            background: #16725F;
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }
        .search-section {
            margin: -4rem 1.5rem 5rem;
            position: relative;
        }
        .search-form {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            border: 1px solid rgba(44, 110, 191, 0.1);
        }
        .search-form h2 {
            font-size: 1.85rem;
            margin-bottom: 2rem;
            color: var(--primary);
            font-weight: 600;
        }
        .form-grid {
            display: grid;
            gap: 1.25rem;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        }
        .form-group label {
            display: block;
            margin-bottom: 0.6rem;
            font-weight: 500;
            font-size: 0.95rem;
            color: var(--text-primary);
        }
        .form-input {
            width: 100%;
            padding: 0.9rem;
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            font-size: 1rem;
            background: #FFFFFF !important; /* Force white background */
            color: #000000 !important; /* Force black text */
            transition: all 0.3s ease;
            appearance: none; /* Reset to none for better control */
            -webkit-appearance: none; /* Reset for Safari/Chrome */
            -moz-appearance: none; /* Reset for Firefox */
            min-height: 40px; /* Ensure dropdown options have enough space */
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23000000%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E'); /* Custom dropdown arrow */
            background-repeat: no-repeat;
            background-position: right 0.7rem center;
            background-size: 12px;
        }
        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 110, 191, 0.15);
            outline: none;
        }
        .form-input option {
            color: #000000 !important; /* Force black text for options */
            background: #FFFFFF !important; /* Force white background for options */
            padding: 5px; /* Add padding for better readability */
        }
        .search-btn {
            background: var(--primary);
            color: #FFFFFF;
            padding: 0.9rem 2.5rem;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 600;
            margin: 1.5rem auto 0;
            display: block;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            background: #255DA3;
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        .popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .popup-content {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: var(--border-radius);
            max-width: 900px;
            width: 90%;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: var(--shadow);
            position: relative;
        }
        .close-btn {
            position: absolute;
            top: 1.25rem;
            right: 1.25rem;
            font-size: 1.75rem;
            cursor: pointer;
            background: none;
            border: none;
            color: var(--text-secondary);
        }
        .close-btn:hover { color: var(--accent); }
        .results-grid {
            display: grid;
            gap: 1.75rem;
            margin-top: 1.5rem;
        }
        @media (min-width: 768px) {
            .results-grid { grid-template-columns: repeat(2, 1fr); }
        }
        .result-card {
            background: #FFFFFF;
            padding: 1.75rem;
            border-radius: var(--border-radius);
            border: 1px solid #E5E7EB;
            transition: all 0.3s ease;
        }
        .result-card:hover {
            box-shadow: var(--shadow);
            transform: translateY(-4px);
        }
        .result-card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.75rem;
            color: var(--text-primary);
        }
        .result-card p {
            font-size: 0.95rem;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
        }
        .book-btn {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.65rem 1.5rem;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-weight: 500;
            margin-top: 1rem;
            transition: all 0.3s ease;
        }
        .book-btn:hover {
            background: #16725F;
            transform: translateY(-2px);
        }
        .features, .specialties { padding: 5rem 0; }
        .features h2, .specialties h2 {
            text-align: center;
            font-size: 2.25rem;
            margin-bottom: 3.5rem;
            color: var(--primary);
            font-weight: 600;
        }
        .features-grid, .specialties-grid {
            display: grid;
            gap: 2rem;
        }
        @media (min-width: 768px) {
            .features-grid, .specialties-grid { grid-template-columns: repeat(3, 1fr); }
        }
        .feature-card, .specialty-card {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: var(--border-radius);
            text-align: center;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
        }
        .feature-card:hover, .specialty-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .feature-card i {
            font-size: 2.25rem;
            color: var(--secondary);
            margin-bottom: 1.25rem;
        }
        .specialty-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        footer {
            background: var(--primary);
            color: #FFFFFF;
            padding: 2.5rem 0;
        }
        .footer-content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 1.5rem;
        }
        .footer-links a {
            color: rgba(255, 255, 255, 0.9);
            margin-left: 1.75rem;
            text-decoration: none;
            font-size: 0.95rem;
        }
        .footer-links a:hover { color: var(--secondary); }
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
        <form class="search-form" id="searchForm" onsubmit="searchDoctors(event)">
            <h2>Find Your Doctor</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="specialty">Specialty</label>
                    <select id="specialty" name="specialty" class="form-input" onchange="updateDoctors()">
                        <option value="">Select Specialty</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="doctor">Doctor Name</label>
                    <select id="doctor" name="doctor" class="form-input" onchange="updateDates()">
                        <option value="">Select Doctor</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="date">Preferred Date</label>
                    <select id="date" name="date" class="form-input">
                        <option value="">Select Date</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="time">Preferred Time</label>
                    <select id="time" name="time" class="form-input">
                        <option value="">Any Time</option>
                        <option value="morning">Morning (8:00-12:00)</option>
                        <option value="afternoon">Afternoon (12:00-17:00)</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="search-btn"><i class="fas fa-search"></i> Search Doctors</button>
        </form>
    </div>
</section>

<div class="popup" id="resultsPopup">
    <div class="popup-content">
        <button class="close-btn" onclick="closePopup()">×</button>
        <h2>Available Time Slots (Sorted by Date & Time)</h2>
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
    let allSpecialties = [];
    let allDoctors = [];
    let allAvailability = [];

    window.onload = function() {
        console.log('Loading specialties...');
        document.getElementById('resultsContainer').innerHTML = '<p>Loading specialties...</p>';
        fetch('<%=request.getContextPath()%>/SortServlet', {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('Failed to fetch specialties: ' + response.statusText + ' - ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Specialties data:', data);
                allSpecialties = data.specialties || [];
                if (allSpecialties.length === 0) {
                    console.warn('No specialties found in the response.');
                }
                populateSpecialties();
                document.getElementById('resultsContainer').innerHTML = '';
            })
            .catch(error => {
                console.error('Error loading specialties:', error);
                document.getElementById('resultsContainer').innerHTML = '<p>Error loading specialties: ' + error.message + '</p>';
            });
    };

    function populateSpecialties() {
        const specialtySelect = document.getElementById('specialty');
        specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
        allSpecialties.forEach(specialty => {
            specialtySelect.innerHTML += `<option value="${specialty}">${specialty}</option>`;
        });
        console.log('Specialty dropdown populated with:', allSpecialties);
    }

    function updateDoctors() {
        const specialty = document.getElementById('specialty').value;
        const doctorSelect = document.getElementById('doctor');
        doctorSelect.innerHTML = '<option value="">Select Doctor</option>';

        if (!specialty) {
            console.log('No specialty selected, clearing doctor dropdown.');
            updateDates();
            return;
        }

        console.log('Fetching doctors for specialty:', specialty);
        fetch('<%=request.getContextPath()%>/SortServlet?specialty=' + encodeURIComponent(specialty), {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
            .then(response => {
                console.log('Doctors response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('Failed to fetch doctors: ' + response.statusText + ' - ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Doctors data:', data);
                allDoctors = data.doctors || [];
                if (allDoctors.length === 0) {
                    console.warn('No doctors found for specialty:', specialty);
                    doctorSelect.innerHTML = '<option value="">No doctors available</option>';
                } else {
                    doctorSelect.innerHTML = '<option value="">Select Doctor</option>';
                    allDoctors.forEach(doctor => {
                        doctorSelect.innerHTML += `<option value="${doctor}">${doctor}</option>`;
                    });
                    console.log('Doctor dropdown populated with:', allDoctors);
                }
                updateDates();
            })
            .catch(error => {
                console.error('Error loading doctors:', error);
                doctorSelect.innerHTML = '<option value="">Error loading doctors: ' + error.message + '</option>';
            });
    }

    function updateDates() {
        const specialty = document.getElementById('specialty').value;
        const doctor = document.getElementById('doctor').value;
        const dateSelect = document.getElementById('date');
        dateSelect.innerHTML = '<option value="">Select Date</option>';

        if (!specialty || !doctor) {
            console.log('Specialty or doctor not selected, clearing date dropdown.');
            return;
        }

        console.log('Fetching availability for specialty:', specialty, 'and doctor:', doctor);
        fetch('<%=request.getContextPath()%>/SortServlet?specialty=' + encodeURIComponent(specialty) +
            '&doctor=' + encodeURIComponent(doctor), {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
            .then(response => {
                console.log('Availability response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('Failed to fetch availability: ' + response.statusText + ' - ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Availability data:', data);
                allAvailability = data.availability || [];
                if (allAvailability.length === 0) {
                    console.warn('No availability found for specialty:', specialty, 'and doctor:', doctor);
                    dateSelect.innerHTML = '<option value="">No dates available</option>';
                } else {
                    const uniqueDates = [...new Set(allAvailability.map(avail => avail.date))];
                    uniqueDates.sort();
                    dateSelect.innerHTML = '<option value="">Select Date</option>';
                    uniqueDates.forEach(date => {
                        dateSelect.innerHTML += `<option value="${date}">${date}</option>`;
                    });
                    console.log('Date dropdown populated with:', uniqueDates);
                }
            })
            .catch(error => {
                console.error('Error loading dates:', error);
                dateSelect.innerHTML = '<option value="">Error loading dates: ' + error.message + '</option>';
            });
    }

    function searchDoctors(event) {
        event.preventDefault();

        const specialty = document.getElementById('specialty').value;
        const doctor = document.getElementById('doctor').value;
        const date = document.getElementById('date').value;
        const time = document.getElementById('time').value;

        if (!specialty) {
            alert('Please select a specialty');
            return;
        }

        console.log('Searching with params:', { specialty, doctor, date, time });
        const resultsContainer = document.getElementById('resultsContainer');
        resultsContainer.innerHTML = '<p>Searching...</p>';
        document.getElementById('resultsPopup').style.display = 'flex';

        fetch('<%=request.getContextPath()%>/SortServlet?' + new URLSearchParams({
            specialty: specialty,
            doctor: doctor,
            date: date,
            time: time
        }), {
            method: 'GET',
            headers: { 'Accept': 'application/json' }
        })
            .then(response => {
                console.log('Search response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('Failed to fetch search results: ' + response.statusText + ' - ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Search results:', data);
                resultsContainer.innerHTML = '';

                if (!data.availability || data.availability.length === 0) {
                    resultsContainer.innerHTML = '<p>No available time slots found.</p>';
                } else {
                    data.availability.forEach(doc => {
                        const card = `
                            <div class="result-card">
                                <h3>${doc.name}</h3>
                                <p>Specialty: ${doc.specialty}</p>
                                <p>Date: ${doc.date}</p>
                                <p>Time: ${doc.startTime} - ${doc.endTime}</p>
                                <button class="book-btn" onclick="bookAppointment('${doc.username}', '${doc.date}', '${doc.startTime}')">
                                    Book Now
                                </button>
                            </div>
                        `;
                        resultsContainer.innerHTML += card;
                    });
                    console.log('Sorted time slots displayed:', data.availability);
                }
            })
            .catch(error => {
                console.error('Search error:', error);
                resultsContainer.innerHTML = '<p>Error loading results: ' + error.message + '</p>';
            });
    }

    function closePopup() {
        document.getElementById('resultsPopup').style.display = 'none';
    }

    function bookAppointment(username, date, time) {
        <% if (session.getAttribute("username") == null) { %>
        alert("Please log in as a patient to book an appointment.");
        window.location.href = '<%=request.getContextPath()%>/pages/login.jsp?role=patient';
        return;
        <% } %>
        console.log('Booking appointment:', { username, date, time });
        fetch('<%=request.getContextPath()%>/AppointmentServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
            body: JSON.stringify({ doctorUsername: username, date: date, time: time })
        })
            .then(response => {
                console.log('Booking response status:', response.status);
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('Failed to book appointment: ' + response.statusText + ' - ' + text);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('Booking response:', data);
                if (data.success) {
                    alert('Appointment booked successfully!');
                    closePopup();
                } else {
                    alert('Failed to book: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Booking error:', error);
                alert('Error booking appointment: ' + error.message);
            });
    }
</script>
</body>
</html>