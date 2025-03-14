<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Patient Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* New Color Palette */
        :root {
            --primary: #3B82F6;        /* Vibrant Blue */
            --secondary: #10B981;      /* Emerald Green */
            --accent: #F43F5E;         /* Rose Red */
            --bg-light: #F9FAFB;       /* Light Gray */
            --text-primary: #1F2937;   /* Dark Gray */
            --text-secondary: #6B7280; /* Muted Gray */
            --card-bg: #FFFFFF;        /* White */
            --shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            --hover: #EFF6FF;          /* Light Blue Hover */
            --border-radius: 10px;
        }

        /* Base Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--card-bg);
            padding: 2rem 1.5rem;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            box-shadow: var(--shadow);
            transition: width 0.3s ease;
        }
        .sidebar.collapsed { width: 80px; padding: 2rem 1rem; }
        .sidebar .logo {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .sidebar.collapsed .logo span { display: none; }
        .sidebar nav ul { list-style: none; }
        .sidebar nav ul li { margin-bottom: 1rem; }
        .sidebar nav ul li a {
            text-decoration: none;
            color: var(--text-primary);
            font-size: 1rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.75rem 1rem;
            border-radius: var(--border-radius);
            transition: all 0.3s ease;
        }
        .sidebar nav ul li a:hover,
        .sidebar nav ul li a.active {
            background: var(--primary);
            color: #FFFFFF;
        }
        .sidebar.collapsed nav ul li a span { display: none; }
        .toggle-btn {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1.3rem;
            cursor: pointer;
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            transition: transform 0.3s ease;
        }
        .sidebar.collapsed .toggle-btn { transform: rotate(180deg); }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 2.5rem;
            transition: margin-left 0.3s ease;
        }
        .main-content.expanded { margin-left: 80px; }
        .container { max-width: 1100px; margin: 0 auto; }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--primary), #2563EB);
            color: #FFFFFF;
            padding: 1.75rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 { font-size: 2rem; font-weight: 600; }

        /* Form Section */
        .form-section {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .form-section h2 {
            font-size: 1.6rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        .form-group select,
        .form-group input {
            width: 100%;
            padding: 0.85rem;
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            font-size: 1rem;
            background: #F9FAFB;
            transition: all 0.3s ease;
        }
        .form-group select:focus,
        .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(59, 130, 246, 0.2);
            outline: none;
        }
        .form-group.checkbox {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-top: 1rem;
        }
        .btn {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.85rem 1.75rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn:hover {
            background: #059669;
            transform: translateY(-2px);
        }

        /* Table Section */
        .table-section {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }
        .table-section h2 {
            font-size: 1.6rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .sort-controls select {
            padding: 0.5rem;
            border-radius: 8px;
            border: 1px solid #D1D5DB;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        th, td {
            padding: 1.25rem;
            text-align: left;
            border-bottom: 1px solid #E5E7EB;
        }
        th {
            background: var(--primary);
            color: #FFFFFF;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        tr:hover {
            background: var(--hover);
        }
        .priority-emergency {
            color: var(--accent);
            font-weight: 600;
            background: #FEE2E2;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
        }

        /* Messages */
        .message {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .message.success {
            background: #D1FAE5;
            color: var(--secondary);
        }
        .message.error {
            background: #FEE2E2;
            color: var(--accent);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar { width: 80px; }
            .sidebar .logo span,
            .sidebar nav ul li a span { display: none; }
            .main-content { margin-left: 80px; padding: 1.5rem; }
            .form-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 480px) {
            .header h1 { font-size: 1.5rem; }
            th, td { padding: 0.75rem; font-size: 0.9rem; }
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"patient".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=patient");
        return;
    }
%>

<!-- Sidebar Navigation -->
<div class="sidebar" id="sidebar">
    <button class="toggle-btn" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <div class="logo"><i class="fas fa-heartbeat"></i><span>MediSchedule</span></div>
    <nav>
        <ul>
            <li><a href="<%=request.getContextPath()%>/pages/index.jsp" class="active"><i class="fas fa-calendar-check"></i><span>Book Appointment</span></a></li>
            <li><a href="<%=request.getContextPath()%>/UserServlet?action=appointments"><i class="fas fa-list"></i><span>My Appointments</span></a></li>
            <li><a href="<%=request.getContextPath()%>/UserServlet?action=profile"><i class="fas fa-user"></i><span>Profile</span></a></li>
            <li>
                <form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;">
                    <a href="#" onclick="this.parentNode.submit();"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
                </form>
            </li>
        </ul>
    </nav>
</div>

<!-- Main Content -->
<div class="main-content" id="main-content">
    <div class="container">
        <div class="header">
            <h1>Welcome, <%= username %>!</h1>
        </div>

        <% if (request.getAttribute("message") != null) { %>
        <div class="message <%= "error".equals(request.getAttribute("messageType")) ? "error" : "success" %>">
            <i class="fas <%= "error".equals(request.getAttribute("messageType")) ? "fa-exclamation-circle" : "fa-check-circle" %>"></i>
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <!-- Book Appointment Section -->
        <div class="form-section">
            <h2>Book an Appointment</h2>
            <form action="<%=request.getContextPath()%>/UserServlet" method="post" id="bookForm">
                <input type="hidden" name="action" value="book">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="specialty">Select Specialty</label>
                        <select id="specialty" name="specialty" onchange="updateDoctors()">
                            <option value="">Choose Specialty</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="doctorId">Select Doctor</label>
                        <select id="doctorId" name="doctorId" onchange="updateAvailability()">
                            <option value="">Choose Doctor</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="date">Preferred Date</label>
                        <input type="date" id="date" name="date" onchange="updateAvailability()" required>
                    </div>
                    <div class="form-group">
                        <label for="timeSlot">Preferred Time</label>
                        <select id="timeSlot" name="timeSlot" required>
                            <option value="">Select Time Slot</option>
                        </select>
                    </div>
                    <div class="form-group checkbox">
                        <input type="checkbox" id="isEmergency" name="isEmergency">
                        <label for="isEmergency">Emergency</label>
                    </div>
                </div>
                <button type="submit" class="btn"><i class="fas fa-calendar-plus"></i> Book Now</button>
            </form>
        </div>

        <!-- My Appointments Section (Hidden by Default) -->
        <div class="table-section" style="display: none;" id="appointmentsSection">
            <div class="table-header">
                <h2>Your Appointments</h2>
                <div class="sort-controls">
                    <select id="sortAppointments" onchange="sortAppointments()">
                        <option value="date">Sort by Date</option>
                        <option value="doctor">Sort by Doctor</option>
                        <option value="priority">Sort by Priority</option>
                    </select>
                </div>
            </div>
            <table id="appointmentsTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Doctor ID</th>
                    <th>Date & Time</th>
                    <th>Priority</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="appt" items="${appointments}">
                    <tr>
                        <td>${appt.id}</td>
                        <td>${appt.doctorId}</td>
                        <td>${appt.dateTime}</td>
                        <td class="${appt.priority == 1 ? 'priority-emergency' : ''}">
                                ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    }

    function updateDoctors() {
        const specialty = document.getElementById('specialty').value;
        const doctorSelect = document.getElementById('doctorId');
        doctorSelect.innerHTML = '<option value="">Choose Doctor</option>';

        if (specialty) {
            fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${specialty}`)
                .then(response => response.json())
                .then(data => {
                    data.doctors.forEach(doctor => {
                        const option = document.createElement('option');
                        option.value = doctor;
                        option.text = doctor;
                        doctorSelect.appendChild(option);
                    });
                    updateAvailability();
                })
                .catch(error => console.error('Error fetching doctors:', error));
        }
    }

    function updateAvailability() {
        const specialty = document.getElementById('specialty').value;
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlotSelect = document.getElementById('timeSlot');
        timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';

        if (specialty && doctorId && date) {
            fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${specialty}&doctor=${doctorId}&date=${date}`)
                .then(response => response.json())
                .then(data => {
                    data.availability.forEach(doc => {
                        const option = document.createElement('option');
                        option.value = `${doc.startTime}-${doc.endTime}`;
                        option.text = `${doc.startTime} - ${doc.endTime}`;
                        timeSlotSelect.appendChild(option);
                    });
                })
                .catch(error => console.error('Error fetching availability:', error));
        }
    }

    function sortAppointments() {
        const sortBy = document.getElementById('sortAppointments').value;
        const table = document.getElementById('appointmentsTable');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            let aValue, bValue;
            if (sortBy === 'date') {
                aValue = a.cells[2].textContent;
                bValue = b.cells[2].textContent;
            } else if (sortBy === 'doctor') {
                aValue = a.cells[1].textContent;
                bValue = b.cells[1].textContent;
            } else if (sortBy === 'priority') {
                aValue = a.cells[3].textContent === 'Emergency' ? 1 : 0;
                bValue = b.cells[3].textContent === 'Emergency' ? 1 : 0;
            }
            return aValue > bValue ? 1 : -1;
        });

        rows.forEach(row => tbody.appendChild(row));
    }

    // Load specialties on page load
    window.onload = () => {
        fetch('<%=request.getContextPath()%>/SortServlet')
            .then(response => response.json())
            .then(data => {
                const specialtySelect = document.getElementById('specialty');
                data.specialties.forEach(specialty => {
                    const option = document.createElement('option');
                    option.value = specialty;
                    option.text = specialty;
                    specialtySelect.appendChild(option);
                });
            })
            .catch(error => console.error('Error loading specialties:', error));
    };
</script>
</body>
</html>