<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/adminDashboard.css">
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
        return;
    }
%>
<div class="sidebar" id="sidebar">
    <button class="toggle-btn" onclick="toggleSidebar()"><i class="ri-menu-line"></i></button>
    <div class="logo"><i class="ri-hospital-line"></i><span>MediSchedule</span></div>
    <ul>
        <li><a href="<%=request.getContextPath()%>/AdminServlet" class="active"><i class="ri-dashboard-line"></i><span>Dashboard</span></a></li>
        <li><a href="<%=request.getContextPath()%>/ManageDoctorsServlet"><i class="ri-stethoscope-line"></i><span>Manage Doctors</span></a></li>
        <li><a href="<%=request.getContextPath()%>/ManagePatientsServlet"><i class="ri-user-3-line"></i><span>Manage Patients</span></a></li>
        <li><a href="<%=request.getContextPath()%>/DoctorScheduleServlet"><i class="ri-calendar-2-line"></i><span>Doctor Schedule</span></a></li>
        <li><a href="<%=request.getContextPath()%>/ManageAppointmentsServlet"><i class="ri-calendar-check-line"></i><span>Manage Appointments</span></a></li>
        <li><a href="<%=request.getContextPath()%>/DataManagementServlet"><i class="ri-database-2-line"></i><span>Data Management</span></a></li>
    </ul>
</div>

<div class="main-content" id="main-content">
    <div class="header">
        <h1><i class="ri-user-settings-line"></i> Welcome, <%= username %> !</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn"><i class="ri-logout-box-line"></i> Logout</button>
        </form>
    </div>

    <c:if test="${not empty error}"><div class="message error-message">${error}</div></c:if>
    <c:if test="${not empty message}"><div class="message success-message">${message}</div></c:if>

    <div class="dashboard-grid">
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/AdminServlet'">
            <i class="ri-calendar-check-line"></i>
            <h3>Total Appointments</h3>
            <p>${totalAppointments}</p>
        </div>
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/AdminServlet'">
            <i class="ri-calendar-todo-line"></i>
            <h3>Previous Appointments</h3>
            <p>${previousAppointments}</p>
        </div>
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/AdminServlet'">
            <i class="ri-calendar-event-line"></i>
            <h3>Future Appointments</h3>
            <p>${futureAppointments}</p>
        </div>
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/ManageDoctorsServlet'">
            <i class="ri-stethoscope-line"></i>
            <h3>Doctors</h3>
            <p>${totalDoctors}</p>
        </div>
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/ManagePatientsServlet'">
            <i class="ri-user-3-line"></i>
            <h3>Patients</h3>
            <p>${totalPatients}</p>
        </div>
        <div class="card" onclick="alert('Emergency Queue: ${emergencyQueueSize}')">
            <i class="ri-alert-line"></i>
            <h3>Emergency Queue</h3>
            <p>${emergencyQueueSize}</p>
        </div>
    </div>

    <div class="search-section">
        <h2><i class="ri-search-line"></i> Search & Export</h2>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="doctorSearch" placeholder="Search doctors..." onkeyup="searchDoctors()">
                <i class="ri-stethoscope-line"></i>
            </div>
            <button class="btn export-btn" onclick="exportDoctors()"><i class="ri-download-line"></i> Export Doctors</button>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="patientSearch" placeholder="Search patients..." onkeyup="searchPatients()">
                <i class="ri-user-3-line"></i>
            </div>
            <button class="btn export-btn" onclick="exportPatients()"><i class="ri-download-line"></i> Export Patients</button>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="appointmentSearch" placeholder="Search appointments..." onkeyup="searchAppointments()">
                <i class="ri-calendar-check-line"></i>
            </div>
            <button class="btn export-btn" onclick="exportAppointments()"><i class="ri-download-line"></i> Export Appointments</button>
        </div>
    </div>

    <div class="chart-section">
        <h2><i class="ri-bar-chart-line"></i> Appointment Analysis</h2>
        <div class="chart-container">
            <canvas id="appointmentChart"></canvas>
        </div>
    </div>
</div>

<script>
    const doctors = [
        <c:forEach var="doctor" items="${doctorLines}">
        "${doctor}",
        </c:forEach>
    ];
    const patients = [
        <c:forEach var="patient" items="${patientLines}">
        "${patient}",
        </c:forEach>
    ];
    const appointments = [
        <c:forEach var="appt" items="${sortedAppointments}">
        { id: '${appt.id}', patientId: '${appt.patientId}', doctorId: '${appt.doctorId}', tokenID: '${appt.tokenID}', dateTime: '${appt.dateTime}', priority: ${appt.priority} },
        </c:forEach>
    ];

    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('collapsed');
        document.getElementById('main-content').classList.toggle('expanded');
    }

    function searchDoctors() {
        const input = document.getElementById('doctorSearch').value.toLowerCase();
        return doctors.filter(doctor => doctor.toLowerCase().includes(input));
    }

    function searchPatients() {
        const input = document.getElementById('patientSearch').value.toLowerCase();
        return patients.filter(patient => patient.toLowerCase().includes(input));
    }

    function searchAppointments() {
        const input = document.getElementById('appointmentSearch').value.toLowerCase();
        return appointments.filter(appt =>
            appt.id.toLowerCase().includes(input) ||
            appt.patientId.toLowerCase().includes(input) ||
            appt.doctorId.toLowerCase().includes(input) ||
            appt.tokenID.toLowerCase().includes(input) ||
            appt.dateTime.toLowerCase().includes(input)
        );
    }

    function exportToCSV(data, filename, headers) {
        let csv = headers + '\n';
        data.forEach(item => {
            if (typeof item === 'string') {
                csv += `${item}\n`;
            } else {
                const priority = item.priority === 1 ? 'Emergency' : 'Normal';
                csv += `${item.id},${item.patientId},${item.doctorId},${item.tokenID},${item.dateTime},${priority}\n`;
            }
        });
        const link = document.createElement('a');
        link.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        link.download = filename + '_' + new Date().toISOString().slice(0, 10) + '.csv';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    function exportDoctors() {
        const filteredDoctors = searchDoctors();
        exportToCSV(filteredDoctors, 'doctors', 'Doctor Details');
    }

    function exportPatients() {
        const filteredPatients = searchPatients();
        exportToCSV(filteredPatients, 'patients', 'Patient Details');
    }

    function exportAppointments() {
        const filteredAppointments = searchAppointments();
        exportToCSV(filteredAppointments, 'appointments', 'ID,Patient ID,Doctor ID,Token ID,Date & Time,Priority');
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Chart for Previous vs Future Appointments
        const ctx = document.getElementById('appointmentChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Previous Appointments', 'Future Appointments'],
                datasets: [
                    {
                        label: 'Appointment Count',
                        data: [${previousAppointments}, ${futureAppointments}],
                        backgroundColor: [
                            'rgba(239, 83, 80, 0.8)', // Previous (red)
                            'rgba(38, 166, 154, 0.8)' // Future (teal)
                        ],
                        borderColor: [
                            'rgba(239, 83, 80, 1)',
                            'rgba(38, 166, 154, 1)'
                        ],
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: {
                        title: { display: true, text: 'Appointment Type', color: '#2D3748' }
                    },
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: 'Number of Appointments', color: '#2D3748' },
                        ticks: { stepSize: 1 }
                    }
                },
                plugins: {
                    legend: { position: 'top', labels: { font: { size: 14 } } },
                    title: {
                        display: true,
                        text: 'Previous vs Future Appointments',
                        color: '#2D3748',
                        font: { size: 18 }
                    }
                }
            }
        });
    });
</script>
</body>
</html>