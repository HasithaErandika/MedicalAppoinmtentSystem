<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Doctor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #2C5282;
            --secondary: #38B2AC;
            --accent: #E53E3E;
            --bg-light: #F7FAFC;
            --text-primary: #2D3748;
            --text-muted: #718096;
            --card-bg: #FFFFFF;
            --shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
            --border: #E2E8F0;
            --hover: #EDF2F7;
            --transition: all 0.3s ease;
            --border-radius: 12px;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
        }
        .sidebar {
            width: 250px;
            background: var(--primary);
            color: #FFFFFF;
            padding: 2rem 1rem;
            position: fixed;
            height: 100%;
            box-shadow: var(--shadow);
        }
        .sidebar h2 {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .sidebar ul { list-style: none; }
        .sidebar ul li {
            margin: 1.5rem 0;
        }
        .sidebar ul li a {
            color: #FFFFFF;
            text-decoration: none;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            border-radius: 8px;
            transition: var(--transition);
        }
        .sidebar ul li a:hover, .sidebar ul li a.active {
            background: var(--secondary);
            transform: translateX(5px);
        }
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            flex-grow: 1;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        .header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 1.5rem;
            border-radius: var(--border-radius);
            color: #FFFFFF;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .header h1 {
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .logout-btn {
            background: var(--accent);
            color: #FFFFFF;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            cursor: pointer;
            font-size: 1rem;
            transition: var(--transition);
        }
        .logout-btn:hover {
            background: #C53030;
            transform: translateY(-2px);
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            text-align: center;
            transition: var(--transition);
            border-left: 4px solid var(--secondary);
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .card i {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 0.75rem;
        }
        .card h3 {
            font-size: 1.1rem;
            font-weight: 500;
            color: var(--text-muted);
        }
        .card p {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
        }
        .section {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .section h2 {
            font-size: 1.5rem;
            color: var(--primary);
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .detail-item { padding: 1rem; border-bottom: 1px solid var(--border); }
        .detail-item label { font-weight: 500; color: var(--text-muted); }
        .detail-item span, .detail-item input {
            display: block;
            font-size: 1.1rem;
            width: 100%;
            padding: 0.5rem;
            border: 1px solid var(--border);
            border-radius: 5px;
        }
        .chart-container { position: relative; height: 300px; margin-top: 1.5rem; }
        table { width: 100%; border-collapse: separate; border-spacing: 0; border-radius: var(--border-radius); overflow: hidden; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); }
        th { background: var(--primary); color: #FFFFFF; font-weight: 600; }
        tr:hover { background: var(--hover); }
        .emergency { color: var(--accent); font-weight: 600; }
        .message { padding: 1rem; border-radius: var(--border-radius); margin-bottom: 1rem; text-align: center; }
        .error-message { background: #FEE2E2; color: var(--accent); }
        .success-message { background: #D4EDDA; color: #38A169; }
        .btn {
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
        }
        .btn:hover { background: #1E3A8A; }
        .btn-cancel { background: var(--accent); }
        .btn-cancel:hover { background: #C53030; }

        @media (max-width: 768px) {
            .sidebar { width: 200px; }
            .main-content { margin-left: 200px; }
            .dashboard-grid { grid-template-columns: 1fr; }
            .details-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"doctor".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        return;
    }
    String section = request.getParameter("section") != null ? request.getParameter("section") : "dashboard";
%>
<div class="sidebar">
    <h2><i class="ri-stethoscope-line"></i> Doctor Panel</h2>
    <ul>
        <li><a href="<%=request.getContextPath()%>/DoctorServlet?section=dashboard" class="<%= "dashboard".equals(section) ? "active" : "" %>"><i class="ri-dashboard-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/DoctorServlet?section=details" class="<%= "details".equals(section) ? "active" : "" %>"><i class="ri-user-line"></i> Personal Details</a></li>
        <li><a href="<%=request.getContextPath()%>/DoctorServlet?section=appointments" class="<%= "appointments".equals(section) ? "active" : "" %>"><i class="ri-calendar-2-line"></i> Appointments</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="container">
        <div class="header">
            <h1><i class="ri-stethoscope-line"></i> Doctor Dashboard</h1>
            <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
                <button type="submit" class="logout-btn"><i class="ri-logout-box-line"></i> Logout</button>
            </form>
        </div>

        <c:if test="${not empty error}">
            <div class="message error-message">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="message success-message">${message}</div>
        </c:if>

        <!-- Dashboard Section -->
        <c:if test="${section == 'dashboard'}">
            <div class="dashboard-grid">
                <div class="card">
                    <i class="ri-calendar-2-line"></i>
                    <h3>Total Appointments</h3>
                    <p>${totalAppointments != null ? totalAppointments : 0}</p>
                </div>
                <div class="card">
                    <i class="ri-calendar-todo-line"></i>
                    <h3>Upcoming</h3>
                    <p>${upcomingAppointments != null ? upcomingAppointments : 0}</p>
                </div>
                <div class="card">
                    <i class="ri-alert-line"></i>
                    <h3>Emergency</h3>
                    <p>${emergencyAppointments != null ? emergencyAppointments : 0}</p>
                </div>
                <div class="card">
                    <i class="ri-calendar-event-line"></i>
                    <h3>Today</h3>
                    <p>${todayAppointments != null ? todayAppointments : 0}</p>
                </div>
            </div>
            <div class="section">
                <h2><i class="ri-bar-chart-line"></i> Appointment Summary</h2>
                <div class="chart-container">
                    <canvas id="appointmentChart"></canvas>
                </div>
            </div>
        </c:if>

        <!-- Personal Details Section -->
        <c:if test="${section == 'details'}">
            <div class="section">
                <h2><i class="ri-user-line"></i> Personal Details</h2>
                <c:choose>
                    <c:when test="${not empty doctor}">
                        <form action="<%=request.getContextPath()%>/DoctorServlet" method="post">
                            <input type="hidden" name="action" value="updateDetails">
                            <div class="details-grid">
                                <div class="detail-item">
                                    <label>ID:</label>
                                    <span>${doctor.id}</span>
                                    <input type="hidden" name="id" value="${doctor.id}">
                                </div>
                                <div class="detail-item">
                                    <label>Name:</label>
                                    <input type="text" name="name" value="${doctor.name}" required>
                                </div>
                                <div class="detail-item">
                                    <label>Specialization:</label>
                                    <input type="text" name="specialization" value="${doctor.specialization}" required>
                                </div>
                                <div class="detail-item">
                                    <label>Contact:</label>
                                    <input type="text" name="contact" value="${doctor.contact}" required>
                                </div>
                            </div>
                            <button type="submit" class="btn" style="margin-top: 1rem;"><i class="ri-save-line"></i> Save Changes</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p>No doctor details available.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <!-- Appointments Section -->
        <c:if test="${section == 'appointments'}">
            <div class="section">
                <h2><i class="ri-calendar-2-line"></i> Your Appointments</h2>
                <c:choose>
                    <c:when test="${not empty appointments}">
                        <table>
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient Name</th>
                                <th>Date & Time</th>
                                <th>Priority</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="appt" items="${appointments}">
                                <tr>
                                    <td>${appt.id}</td>
                                    <td>${appt.patientName != null ? appt.patientName : 'Unknown'}</td>
                                    <td>${appt.dateTime}</td>
                                    <td>${appt.priority == 1 ? 'Emergency' : 'Regular'}</td>
                                    <td>
                                        <form action="<%=request.getContextPath()%>/DoctorServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="cancelAppointment">
                                            <input type="hidden" name="appointmentId" value="${appt.id}">
                                            <button type="submit" class="btn btn-cancel"><i class="ri-close-line"></i> Cancel</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <p>No appointments found.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>
</div>

<script>
    <c:if test="${section == 'dashboard'}">
    document.addEventListener('DOMContentLoaded', function() {
        const appointments = [
            <c:forEach var="appt" items="${appointments}" varStatus="loop">
            { id: '${appt.id}', patientId: '${appt.patientId}', dateTime: '${appt.dateTime}', priority: ${appt.priority} }${loop.last ? '' : ','}
            </c:forEach>
        ];

        const ctx = document.getElementById('appointmentChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Total', 'Upcoming', 'Emergency', 'Today'],
                datasets: [{
                    label: 'Appointments',
                    data: [
                        ${totalAppointments != null ? totalAppointments : 0},
                        ${upcomingAppointments != null ? upcomingAppointments : 0},
                        ${emergencyAppointments != null ? emergencyAppointments : 0},
                        ${todayAppointments != null ? todayAppointments : 0}
                    ],
                    backgroundColor: [
                        'rgba(44, 82, 130, 0.8)',
                        'rgba(56, 178, 172, 0.8)',
                        'rgba(229, 62, 62, 0.8)',
                        'rgba(102, 126, 234, 0.8)'
                    ],
                    borderColor: [
                        'rgba(44, 82, 130, 1)',
                        'rgba(56, 178, 172, 1)',
                        'rgba(229, 62, 62, 1)',
                        'rgba(102, 126, 234, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Number of Appointments', color: '#2D3748' }, ticks: { stepSize: 1 } },
                    x: { title: { display: true, text: 'Category', color: '#2D3748' } }
                },
                plugins: {
                    legend: { display: false },
                    title: { display: true, text: 'Appointment Categories', color: '#2D3748', font: { size: 18 } }
                }
            }
        });
    });
    </c:if>
</script>
</body>
</html>