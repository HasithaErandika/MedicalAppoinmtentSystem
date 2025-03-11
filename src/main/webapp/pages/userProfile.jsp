<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Color Palette */
        :root {
            --primary: #4A90E2;        /* Soft Blue */
            --secondary: #26A69A;      /* Teal */
            --accent: #EF5350;         /* Soft Red */
            --bg-light: #F5F6F5;       /* Light Gray */
            --text-primary: #333333;   /* Dark Gray */
            --card-bg: #FFFFFF;        /* White */
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        /* Base Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background: var(--card-bg);
            padding: 2rem 1rem;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            box-shadow: var(--shadow);
        }
        .sidebar .logo {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .sidebar nav ul {
            list-style: none;
        }
        .sidebar nav ul li {
            margin-bottom: 1.5rem;
        }
        .sidebar nav ul li a {
            text-decoration: none;
            color: var(--text-primary);
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar nav ul li a:hover,
        .sidebar nav ul li a.active {
            background: var(--primary);
            color: #FFFFFF;
        }

        /* Main Content */
        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 2rem;
        }
        .container { max-width: 1000px; margin: 0 auto; }

        /* Header */
        .header {
            background: var(--primary);
            color: #FFFFFF;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 { font-size: 1.8rem; }

        /* Form Section */
        .form-section {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .form-section h2 {
            font-size: 1.5rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
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
            padding: 0.75rem;
            border: 2px solid #E0E0E0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-group select:focus,
        .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
            outline: none;
        }
        .form-group.checkbox {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        button {
            background: var(--secondary);
            color: #FFFFFF;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        button:hover {
            background: #00897B;
            transform: translateY(-2px);
        }

        /* Table Section */
        .table-section {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
        }
        .table-section h2 {
            font-size: 1.5rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #E0E0E0;
        }
        th {
            background: var(--primary);
            color: #FFFFFF;
        }
        tr:hover {
            background: #F9FAFB;
        }
        .priority-emergency {
            color: var(--accent);
            font-weight: 600;
        }

        /* Message Styling */
        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
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
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
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
<div class="sidebar">
    <div class="logo">
        <i class="fas fa-heartbeat"></i> MediSchedule
    </div>
    <nav>
        <ul>
            <li><a href="<%=request.getContextPath()%>/pages/index.jsp" class="active"><i class="fas fa-calendar-check"></i> Book Appointment</a></li>
            <li><a href="<%=request.getContextPath()%>/UserServlet?action=appointments"><i class="fas fa-list"></i> My Appointments</a></li>
            <li><a href="<%=request.getContextPath()%>/UserServlet?action=profile"><i class="fas fa-user"></i> Profile</a></li>
            <li>
                <form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;">
                    <a href="#" onclick="this.parentNode.submit();"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </form>
            </li>
        </ul>
    </nav>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="container">
        <div class="header">
            <h1>Welcome, <%= username %>!</h1>
        </div>

        <% if (request.getAttribute("message") != null) { %>
        <div class="message <%= "error".equals(request.getAttribute("messageType")) ? "error" : "success" %>">
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <!-- Book Appointment Section (Index Page) -->
        <div class="form-section">
            <h2>Book an Appointment</h2>
            <form action="<%=request.getContextPath()%>/UserServlet" method="post">
                <input type="hidden" name="action" value="book">
                <div class="form-group">
                    <label for="doctorId">Doctor</label>
                    <select id="doctorId" name="doctorId" required onchange="updateTimeSlots()">
                        <option value="">Select Doctor</option>
                        <c:forEach var="doctor" items="${filteredDoctors}">
                            <option value="${doctor.split(',')[0]}">${doctor.split(',')[0]} - ${doctor.split(',')[2]} (${doctor.split(',')[4]})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date" value="${param.date}" required onchange="updateTimeSlots()">
                </div>
                <div class="form-group">
                    <label for="timeSlot">Available Time Slot</label>
                    <select id="timeSlot" name="timeSlot" required>
                        <option value="">Select Time Slot</option>
                    </select>
                </div>
                <div class="form-group checkbox">
                    <input type="checkbox" id="isEmergency" name="isEmergency">
                    <label for="isEmergency">Emergency</label>
                </div>
                <button type="submit">Book Appointment</button>
            </form>
        </div>

        <!-- My Appointments Section (Hidden by Default, Accessible via Sidebar) -->
        <div class="table-section" style="display: none;">
            <h2>Your Appointments</h2>
            <table>
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
    function updateTimeSlots() {
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlotSelect = document.getElementById('timeSlot');
        timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';

        if (doctorId && date) {
            fetch('<%=request.getContextPath()%>/UserServlet?action=getTimeSlots&doctorId=' + doctorId + '&date=' + date)
                .then(response => response.json())
                .then(slots => {
                    slots.forEach(slot => {
                        const option = document.createElement('option');
                        option.value = slot;
                        option.text = slot;
                        timeSlotSelect.appendChild(option);
                    });
                })
                .catch(error => console.error('Error fetching time slots:', error));
        }
    }
</script>
</body>
</html>