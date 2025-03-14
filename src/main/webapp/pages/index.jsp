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
            --primary: #4A90E2;
            --secondary: #26A69A;
            --accent: #EF5350;
            --bg-light: #F5F6F5;
            --text-primary: #333333;
            --card-bg: #FFFFFF;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --register-btn: #66BB6A;
            --hover-primary: #357ABD;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }
        .container { max-width: 1200px; margin: 0 auto; padding: 0 1rem; }

        /* Navigation */
        nav {
            background: var(--primary);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            padding: 1rem 0;
            box-shadow: var(--shadow);
        }
        .nav-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: #FFFFFF;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .nav-actions {
            display: flex;
            gap: 1rem;
        }
        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            color: #FFFFFF;
        }
        .login-btn {
            background: var(--secondary);
        }
        .login-btn:hover {
            background: #00897B;
            transform: translateY(-2px);
        }
        .register-btn {
            background: var(--register-btn);
        }
        .register-btn:hover {
            background: #4CAF50;
            transform: translateY(-2px);
        }

        /* Hero */
        .hero {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
            url('https://images.unsplash.com/photo-1576091160550-2173dba999ef') center/cover no-repeat;
            padding: 6rem 1rem 4rem;
            color: #FFFFFF;
            text-align: center;
        }
        .hero h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            animation: fadeIn 1s ease;
        }
        .hero p {
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto 2rem;
        }

        /* Search Section */
        .search-section {
            margin: -2rem 1rem 3rem;
            position: relative;
            z-index: 10;
        }
        .search-form {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            border: 2px solid var(--primary);
            animation: slideUp 0.5s ease;
        }
        .search-form h2 {
            font-size: 1.8rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        .form-grid {
            display: grid;
            gap: 1rem;
            grid-template-columns: 1fr;
        }
        @media (min-width: 768px) {
            .form-grid { grid-template-columns: repeat(4, 1fr); }
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        .form-input {
            padding: 0.75rem;
            border: 2px solid #E0E0E0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #FFFFFF;
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
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
            grid-column: span 4;
            margin-top: 1rem;
        }
        .search-btn:hover {
            background: var(--hover-primary);
            transform: translateY(-2px);
        }
        .search-btn:disabled {
            background: #cccccc;
            cursor: not-allowed;
        }

        /* Popup */
        .popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 2000;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease;
        }
        .popup-content {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 15px;
            max-width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            position: relative;
            box-shadow: var(--shadow);
            width: 800px;
        }
        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-primary);
            transition: color 0.3s ease;
        }
        .close-btn:hover {
            color: var(--accent);
        }
        .results-grid {
            display: grid;
            gap: 1.5rem;
            margin-top: 1rem;
        }
        @media (min-width: 768px) {
            .results-grid { grid-template-columns: repeat(2, 1fr); }
        }
        .result-card {
            background: #F9F9F9;
            padding: 1.5rem;
            border-radius: 10px;
            border: 1px solid #EEE;
            transition: transform 0.3s ease;
        }
        .result-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow);
        }
        .result-card h3 {
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        .result-card p {
            margin: 0.3rem 0;
            font-size: 0.95rem;
        }
        .book-btn {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            margin-top: 1rem;
            transition: all 0.3s ease;
        }
        .book-btn:hover {
            background: #00897B;
            transform: translateY(-2px);
        }

        /* Features */
        .features {
            padding: 3rem 1rem;
            background: var(--bg-light);
        }
        .features h2 {
            text-align: center;
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 2rem;
        }
        .features-grid {
            display: grid;
            gap: 1.5rem;
            grid-template-columns: 1fr;
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
        }
        .feature-card i {
            font-size: 2rem;
            color: var(--secondary);
            margin-bottom: 1rem;
        }

        /* Footer */
        footer {
            background: var(--primary);
            color: #FFFFFF;
            padding: 2rem 1rem;
            text-align: center;
        }
        .footer-content {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 1rem;
        }
        .footer-links a {
            color: #FFFFFF;
            text-decoration: none;
            margin: 0 0.5rem;
        }
        .footer-links a:hover {
            color: var(--secondary);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
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
            <button class="btn login-btn" onclick="window.location.href='<%=request.getContextPath()%>/pages/login.jsp';">
                <i class="fas fa-user-md"></i> Login
            </button>
            <button class="btn register-btn" onclick="window.location.href='<%=request.getContextPath()%>/pages/register.jsp';">
                <i class="fas fa-plus"></i> Register
            </button>
        </div>
    </div>
</nav>

<header class="hero">
    <div class="container">
        <h1>Your Healthcare Journey Starts Here</h1>
        <p>Book appointments with ease and manage your healthcare needs efficiently.</p>
    </div>
</header>

<section class="search-section">
    <div class="container">
        <form class="search-form" id="searchForm" onsubmit="searchDoctors(event)">
            <h2>Find Your Doctor</h2>
            <div class="form-grid">
                <div class="form-group">
                    <label for="specialty">Specialty</label>
                    <select id="specialty" name="specialty" class="form-input" onchange="updateDoctors()" required>
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
            <button type="submit" class="search-btn" id="searchBtn">
                <i class="fas fa-search"></i> Search Doctors
            </button>
        </form>
    </div>
</section>

<div class="popup" id="resultsPopup">
    <div class="popup-content">
        <button class="close-btn" onclick="closePopup()">×</button>
        <h2>Available Doctors</h2>
        <div class="results-grid" id="resultsContainer"></div>
    </div>
</div>

<section class="features">
    <div class="container">
        <h2>Why Choose MediSchedule?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <i class="fas fa-calendar-check"></i>
                <h3>Easy Booking</h3>
                <p>Schedule appointments in just a few clicks.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-user-md"></i>
                <h3>Expert Doctors</h3>
                <p>Connect with top healthcare professionals.</p>
            </div>
            <div class="feature-card">
                <i class="fas fa-clock"></i>
                <h3>Flexible Timing</h3>
                <p>Choose slots that fit your schedule.</p>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="container footer-content">
        <p>© 2025 MediSchedule - All Rights Reserved</p>
        <div class="footer-links">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Contact Us</a>
        </div>
    </div>
</footer>

<script>
    let specialties = [];
    let doctors = [];
    let availability = [];

    // Load specialties on page load
    window.onload = function() {
        fetch('<%=request.getContextPath()%>/SortServlet')
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log('Loaded specialties:', data);
                specialties = data.specialties || [];
                populateSpecialties();
            })
            .catch(error => {
                console.error('Error loading specialties:', error);
                alert('Failed to load specialties. Please refresh the page.');
            });
    };

    function populateSpecialties() {
        const specialtySelect = document.getElementById('specialty');
        specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
        specialties.forEach(specialty => {
            specialtySelect.innerHTML += `<option value="${specialty}">${specialty}</option>`;
        });
    }

    function updateDoctors() {
        const specialty = document.getElementById('specialty').value;
        const doctorSelect = document.getElementById('doctor');
        const dateSelect = document.getElementById('date');
        doctorSelect.innerHTML = '<option value="">Select Doctor</option>';
        dateSelect.innerHTML = '<option value="">Select Date</option>';

        if (!specialty) return;

        fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${encodeURIComponent(specialty)}`)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log('Loaded doctors:', data);
                doctors = data.doctors || [];
                doctors.forEach(doctor => {
                    doctorSelect.innerHTML += `<option value="${doctor}">${doctor}</option>`;
                });
            })
            .catch(error => {
                console.error('Error loading doctors:', error);
                doctorSelect.innerHTML = '<option value="">Error loading doctors</option>';
            });
    }

    function updateDates() {
        const specialty = document.getElementById('specialty').value;
        const doctor = document.getElementById('doctor').value;
        const dateSelect = document.getElementById('date');
        dateSelect.innerHTML = '<option value="">Select Date</option>';

        if (!specialty || !doctor) return;

        fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${encodeURIComponent(specialty)}&doctor=${encodeURIComponent(doctor)}`)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log('Loaded availability:', data);
                availability = data.availability || [];
                const uniqueDates = [...new Set(availability.map(item => item.date))];
                uniqueDates.forEach(date => {
                    dateSelect.innerHTML += `<option value="${date}">${date}</option>`;
                });
            })
            .catch(error => {
                console.error('Error loading dates:', error);
                dateSelect.innerHTML = '<option value="">Error loading dates</option>';
            });
    }

    function searchDoctors(event) {
        event.preventDefault();

        const specialty = document.getElementById('specialty').value;
        const doctor = document.getElementById('doctor').value;
        const date = document.getElementById('date').value;
        const time = document.getElementById('time').value;
        const searchBtn = document.getElementById('searchBtn');

        if (!specialty) {
            alert('Please select a specialty.');
            return;
        }

        searchBtn.disabled = true;
        searchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Searching...';

        fetch(`<%=request.getContextPath()%>/SortServlet?${new URLSearchParams({
                specialty: specialty,
                doctor: doctor,
                date: date,
                time: time
            })}`)
            .then(response => {
                if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
                return response.json();
            })
            .then(data => {
                console.log('Search results:', data);
                const resultsContainer = document.getElementById('resultsContainer');
                resultsContainer.innerHTML = '';

                if (!data.availability || data.availability.length === 0) {
                    resultsContainer.innerHTML = '<p>No doctors found matching your criteria.</p>';
                } else {
                    data.availability.forEach(doc => {
                        resultsContainer.innerHTML += `
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
                    });
                }
                document.getElementById('resultsPopup').style.display = 'flex';
            })
            .catch(error => {
                console.error('Search error:', error);
                document.getElementById('resultsContainer').innerHTML = `<p>Error: ${error.message}</p>`;
                document.getElementById('resultsPopup').style.display = 'flex';
            })
            .finally(() => {
                searchBtn.disabled = false;
                searchBtn.innerHTML = '<i class="fas fa-search"></i> Search Doctors';
            });
    }

    function closePopup() {
        document.getElementById('resultsPopup').style.display = 'none';
    }

    function bookAppointment(username, date, time) {
        console.log('Booking:', { username, date, time });
        fetch('<%=request.getContextPath()%>/AppointmentServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, date, time })
        })
            .then(response => {
                if (!response.ok) throw new Error('Booking failed');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert('Appointment booked successfully!');
                    closePopup();
                } else {
                    alert('Booking failed: ' + (data.message || 'Unknown error'));
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