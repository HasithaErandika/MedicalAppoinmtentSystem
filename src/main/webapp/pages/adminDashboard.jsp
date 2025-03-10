<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #ed8936; /* Orange */
            --secondary: #2c5282; /* Blue */
            --accent: #48bb78; /* Green */
            --bg-light: #f4f7fa;
            --bg-dark: #2d3748;
            --text-light: #2d3748;
            --text-dark: #ffffff;
            --card-bg: #ffffff;
            --shadow: 0 4px 15px rgba(0,0,0,0.1);
            --hover: #f1f5f9;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-light);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--bg-dark);
            color: var(--text-dark);
            height: 100vh;
            position: fixed;
            padding: 2rem 1rem;
            transition: width 0.3s ease;
            z-index: 1000;
        }

        .sidebar.collapsed {
            width: 80px;
        }

        .sidebar .logo {
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: var(--primary);
        }

        .sidebar.collapsed .logo span {
            display: none;
        }

        .sidebar ul {
            list-style: none;
        }

        .sidebar ul li a {
            color: var(--text-dark);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .sidebar ul li a:hover, .sidebar ul li a.active {
            background: var(--primary);
            color: var(--text-dark);
        }

        .sidebar.collapsed ul li a span {
            display: none;
        }

        .toggle-btn {
            background: none;
            border: none;
            color: var(--text-dark);
            font-size: 1.2rem;
            cursor: pointer;
            position: absolute;
            top: 1rem;
            right: 1rem;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }

        .main-content.expanded {
            margin-left: 80px;
        }

        .header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 1.5rem;
            border-radius: 12px;
            color: var(--text-dark);
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 1.8rem;
            font-weight: 600;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: var(--text-dark);
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }

        /* Dashboard Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .card i {
            font-size: 2.2rem;
            color: var(--primary);
            margin-bottom: 0.75rem;
        }

        .card h3 {
            font-size: 1.1rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .card p {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--secondary);
        }

        /* Appointments Table Section */
        .table-section {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .table-header h2 {
            font-size: 1.4rem;
            color: var(--text-light);
        }

        .search-bar {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-bar input {
            padding: 0.6rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 0.9rem;
            width: 200px;
        }

        .appointments-table {
            width: 100%;
            border-collapse: collapse;
        }

        .appointments-table th, .appointments-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        .appointments-table th {
            background: var(--primary);
            color: var(--text-dark);
            font-weight: 600;
            cursor: pointer;
        }

        .appointments-table th:hover {
            background: #dd6b20;
        }

        .appointments-table tr:hover {
            background: var(--hover);
        }

        .priority-emergency {
            color: #e53e3e;
            font-weight: 600;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                width: 80px;
            }
            .sidebar .logo span, .sidebar ul li a span {
                display: none;
            }
            .main-content {
                margin-left: 80px;
            }
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 1rem;
            }
            .search-bar input {
                width: 150px;
            }
            .appointments-table th, .appointments-table td {
                padding: 0.75rem;
                font-size: 0.85rem;
            }
        }
    </style>
</head>

<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
        return;
    }
%>
<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <button class="toggle-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
    <div class="logo">
        <i class="fas fa-shield-alt"></i>
        <span>MediSchedule</span>
    </div>
    <ul>
        <li><a href="<%=request.getContextPath()%>/AdminServlet" class="active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
        <li><a href="#"><i class="fas fa-user-md"></i><span>Manage Doctors</span></a></li>
        <li><a href="#"><i class="fas fa-calendar-check"></i><span>Appointments</span></a></li>
        <li><a href="#"><i class="fas fa-users"></i><span>Patients</span></a></li>
        <li><a href="#"><i class="fas fa-cog"></i><span>Settings</span></a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content" id="main-content">
    <div class="header">
        <h1>Welcome, <%= username %>!</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>

    <div class="dashboard-grid">
        <div class="card" onclick="alert('View all appointments')">
            <i class="fas fa-calendar-check"></i>
            <h3>Total Appointments</h3>
            <p>${totalAppointments}</p>
        </div>
        <div class="card" onclick="alert('Manage doctors')">
            <i class="fas fa-user-md"></i>
            <h3>Doctors</h3>
            <p>${totalDoctors}</p>
        </div>
        <div class="card" onclick="alert('View patient list')">
            <i class="fas fa-users"></i>
            <h3>Patients</h3>
            <p>${totalPatients}</p>
        </div>
        <div class="card" onclick="alert('Prioritize emergency queue')">
            <i class="fas fa-exclamation-triangle"></i>
            <h3>Emergency Queue</h3>
            <p>${emergencyQueueSize}</p>
        </div>
    </div>

    <!-- Appointments Table -->
    <div class="table-section">
        <div class="table-header">
            <h2>Appointments</h2>
            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="Search appointments..." onkeyup="searchTable()">
                <i class="fas fa-search"></i>
            </div>
        </div>
        <table class="appointments-table" id="appointmentsTable">
            <thead>
            <tr>
                <th onclick="sortTable(0)">ID <i class="fas fa-sort"></i></th>
                <th onclick="sortTable(1)">Patient ID <i class="fas fa-sort"></i></th>
                <th onclick="sortTable(2)">Doctor ID <i class="fas fa-sort"></i></th>
                <th onclick="sortTable(3)">Date & Time <i class="fas fa-sort"></i></th>
                <th onclick="sortTable(4)">Priority <i class="fas fa-sort"></i></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="appt" items="${sortedAppointments}">
                <tr>
                    <td>${appt.id}</td>
                    <td>${appt.patientId}</td>
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

<script>
    // Toggle Sidebar
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    }

    // Search Table
    function searchTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const table = document.getElementById('appointmentsTable');
        const tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            let found = false;
            const td = tr[i].getElementsByTagName('td');
            for (let j = 0; j < td.length; j++) {
                if (td[j].innerText.toLowerCase().includes(input)) {
                    found = true;
                    break;
                }
            }
            tr[i].style.display = found ? '' : 'none';
        }
    }

    // Sort Table
    function sortTable(n) {
        const table = document.getElementById('appointmentsTable');
        let rows, switching = true, i, shouldSwitch, dir = "asc", switchcount = 0;
        while (switching) {
            switching = false;
            rows = table.rows;
            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                const x = rows[i].getElementsByTagName("td")[n];
                const y = rows[i + 1].getElementsByTagName("td")[n];
                let cmpX = x.innerHTML.toLowerCase();
                let cmpY = y.innerHTML.toLowerCase();

                if (n === 0 || n === 4) { // ID or Priority (numeric)
                    cmpX = parseInt(cmpX) || cmpX;
                    cmpY = parseInt(cmpY) || cmpY;
                }

                if (dir === "asc" ? cmpX > cmpY : cmpX < cmpY) {
                    shouldSwitch = true;
                    break;
                }
            }
            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchcount++;
            } else if (switchcount === 0 && dir === "asc") {
                dir = "desc";
                switching = true;
            }
        }
    }
</script>
</body>
</html>