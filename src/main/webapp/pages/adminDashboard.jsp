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
        /* Color Palette */
        :root {
            --primary: #4A90E2;        /* Soft Blue */
            --secondary: #26A69A;      /* Teal */
            --accent: #EF5350;         /* Soft Red */
            --bg-light: #F5F6F5;       /* Light Gray */
            --text-primary: #333333;   /* Dark Gray */
            --card-bg: #FFFFFF;        /* White */
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            --hover: #F9FAFB;
            --danger: #EF5350;
        }

        /* Base Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--card-bg);
            height: 100vh;
            position: fixed;
            padding: 2rem 1rem;
            transition: width 0.3s ease;
            z-index: 1000;
            box-shadow: var(--shadow);
        }
        .sidebar.collapsed { width: 80px; }
        .sidebar .logo {
            font-size: 1.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: var(--primary);
        }
        .sidebar.collapsed .logo span { display: none; }
        .sidebar ul { list-style: none; }
        .sidebar ul li a {
            color: var(--text-primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar ul li a:hover,
        .sidebar ul li a.active {
            background: var(--primary);
            color: #FFFFFF;
        }
        .sidebar.collapsed ul li a span { display: none; }
        .toggle-btn {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1.2rem;
            cursor: pointer;
            position: absolute;
            top: 1rem;
            right: 1rem;
            transition: all 0.3s ease;
        }
        .toggle-btn:hover { color: var(--secondary); }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 2rem;
            transition: margin-left 0.3s ease;
        }
        .main-content.expanded { margin-left: 80px; }

        /* Header */
        .header {
            background: var(--primary);
            padding: 1.5rem;
            border-radius: 12px;
            color: #FFFFFF;
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
            background: var(--secondary);
            color: #FFFFFF;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .logout-btn:hover {
            background: #00897B;
            transform: scale(1.05);
        }

        /* Dashboard Grid */
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
            overflow: hidden;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }
        .card i {
            font-size: 2.2rem;
            color: var(--secondary);
            margin-bottom: 0.75rem;
        }
        .card h3 {
            font-size: 1.1rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        .card p {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--primary);
        }

        /* Table Section */
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
            margin-bottom: 1.5rem;
        }
        .table-header h2 {
            font-size: 1.5rem;
            color: var(--primary);
        }
        .table-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        .search-bar {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: #FFFFFF;
            border: 1px solid #E0E0E0;
            border-radius: 8px;
            padding: 0.25rem 0.75rem;
        }
        .search-bar input {
            padding: 0.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            width: 200px;
            transition: all 0.3s ease;
        }
        .search-bar input:focus {
            outline: none;
            box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
        }
        .search-bar i {
            color: var(--text-primary);
        }
        .export-btn {
            padding: 0.6rem 1rem;
            background: var(--secondary);
            color: #FFFFFF;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .export-btn:hover {
            background: #00897B;
            transform: scale(1.05);
        }
        .appointments-table {
            width: 100%;
            border-collapse: collapse;
        }
        .appointments-table th,
        .appointments-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #E0E0E0;
        }
        .appointments-table th {
            background: var(--primary);
            color: #FFFFFF;
            font-weight: 600;
            cursor: pointer;
        }
        .appointments-table th:hover {
            background: #357ABD;
        }
        .appointments-table tr:hover {
            background: var(--hover);
        }
        .priority-emergency {
            color: var(--danger);
            font-weight: 600;
        }

        /* Pagination */
        .pagination {
            margin-top: 1.5rem;
            text-align: center;
        }
        .pagination button {
            padding: 0.5rem 1rem;
            margin: 0 0.25rem;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .pagination button:hover:not(:disabled) {
            background: #357ABD;
        }
        .pagination button:disabled {
            background: #E0E0E0;
            cursor: not-allowed;
        }

        /* Error Message */
        .error-message {
            color: var(--danger);
            padding: 1rem;
            background: #FEE2E2;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar { width: 80px; }
            .sidebar .logo span,
            .sidebar ul li a span { display: none; }
            .main-content { margin-left: 80px; }
            .dashboard-grid { grid-template-columns: 1fr; }
            .table-actions { flex-direction: column; gap: 0.5rem; }
        }
        @media (max-width: 480px) {
            .main-content { padding: 1rem; }
            .search-bar input { width: 150px; }
            .appointments-table th,
            .appointments-table td { padding: 0.75rem; font-size: 0.85rem; }
        }
    </style>
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
    <button class="toggle-btn" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <div class="logo"><i class="fas fa-shield-alt"></i><span>MediSchedule</span></div>
    <ul>
        <li><a href="<%=request.getContextPath()%>/AdminServlet" class="active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
        <li><a href="<%=request.getContextPath()%>/ManageDoctorsServlet"><i class="fas fa-user-md"></i><span>Manage Doctors</span></a></li>
        <li><a href="<%=request.getContextPath()%>/ManagePatientsServlet"><i class="fas fa-users"></i><span>Manage Patients</span></a></li>
        <li><a href="<%=request.getContextPath()%>/DoctorScheduleServlet"><i class="fas fa-calendar-alt"></i><span>Doctor Schedule</span></a></li>
        <li><a href="<%=request.getContextPath()%>/AppointmentServlet"><i class="fas fa-calendar-check"></i><span>Manage Appointments</span></a></li>
        <li><a href="<%=request.getContextPath()%>/DataManagementServlet"><i class="fas fa-database"></i><span>Data Management</span></a></li>
    </ul>
</div>

<div class="main-content" id="main-content">
    <div class="header">
        <h1>Welcome, <%= username %>!</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </form>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="dashboard-grid">
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/AdminServlet'">
            <i class="fas fa-calendar-check"></i>
            <h3>Total Appointments</h3>
            <p>${totalAppointments}</p>
        </div>
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/ManageDoctorsServlet'">
            <i class="fas fa-user-md"></i>
            <h3>Doctors</h3>
            <p>${totalDoctors}</p>
        </div>
        <div class="card" onclick="window.location.href='<%=request.getContextPath()%>/ManagePatientsServlet'">
            <i class="fas fa-users"></i>
            <h3>Patients</h3>
            <p>${totalPatients}</p>
        </div>
        <div class="card" onclick="alert('Emergency Queue: ${emergencyQueueSize}')">
            <i class="fas fa-exclamation-triangle"></i>
            <h3>Emergency Queue</h3>
            <p>${emergencyQueueSize}</p>
        </div>
    </div>

    <div class="table-section">
        <div class="table-header">
            <h2>Appointments</h2>
            <div class="table-actions">
                <div class="search-bar">
                    <input type="text" id="searchInput" placeholder="Search appointments..." onkeyup="searchTable()">
                    <i class="fas fa-search"></i>
                </div>
                <button class="export-btn" onclick="exportTable()">Export to CSV</button>
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
            <tbody id="appointmentsBody">
            <c:forEach var="appt" items="${sortedAppointments}" varStatus="loop">
                <tr class="appointment-row" data-page="${(loop.index div 5) + 1}">
                    <td id="${appt.id}">${appt.id}</td>
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
        <div class="pagination" id="pagination"></div>
    </div>
</div>

<script>
    const ITEMS_PER_PAGE = 5;
    let currentPage = 1;

    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    }

    function searchTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.getElementsByClassName('appointment-row');
        for (let row of rows) {
            let found = false;
            const cells = row.getElementsByTagName('td');
            for (let cell of cells) {
                if (cell.innerText.toLowerCase().includes(input)) {
                    found = true;
                    break;
                }
            }
            row.style.display = found ? '' : 'none';//
        }
        updatePagination();
    }

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
                if (n === 0 || n === 4) {
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
        updatePagination();
    }

    function updatePagination() {
        const rows = Array.from(document.getElementsByClassName('appointment-row')).filter(row => row.style.display !== 'none');
        const totalPages = Math.ceil(rows.length / ITEMS_PER_PAGE);
        const pagination = document.getElementById('pagination');
        pagination.innerHTML = '';

        if (totalPages <= 1) return;

        const prevBtn = document.createElement('button');
        prevBtn.innerText = 'Previous';
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => { currentPage--; showPage(); };
        pagination.appendChild(prevBtn);

        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement('button');
            btn.innerText = i;
            btn.disabled = i === currentPage;
            btn.onclick = () => { currentPage = i; showPage(); };
            pagination.appendChild(btn);
        }

        const nextBtn = document.createElement('button');
        nextBtn.innerText = 'Next';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.onclick = () => { currentPage++; showPage(); };
        pagination.appendChild(nextBtn);

        showPage();
    }

    function showPage() {
        const rows = document.getElementsByClassName('appointment-row');
        for (let row of rows) {
            const page = parseInt(row.getAttribute('data-page'));
            row.style.display = (page === currentPage && row.style.display !== 'none') ? '' : 'none';
        }
        updatePaginationButtons();
    }

    function updatePaginationButtons() {
        const buttons = document.getElementById('pagination').getElementsByTagName('button');
        const totalPages = Math.ceil(Array.from(document.getElementsByClassName('appointment-row')).filter(row => row.style.display !== 'none').length / ITEMS_PER_PAGE);
        buttons[0].disabled = currentPage === 1; // Previous
        buttons[buttons.length - 1].disabled = currentPage === totalPages; // Next
        for (let i = 1; i < buttons.length - 1; i++) {
            buttons[i].disabled = parseInt(buttons[i].innerText) === currentPage;
        }
    }

    function exportTable() {
        const table = document.getElementById('appointmentsTable');
        let csv = [];
        for (let row of table.rows) {
            if (row.style.display !== 'none') {
                let rowData = [];
                for (let cell of row.cells) {
                    rowData.push('"' + cell.innerText.replace(/"/g, '""') + '"');
                }
                csv.push(rowData.join(','));
            }
        }
        const csvContent = 'data:text/csv;charset=utf-8,' + csv.join('\n');
        const link = document.createElement('a');
        link.setAttribute('href', encodeURI(csvContent));
        link.setAttribute('download', 'appointments.csv');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    window.onload = () => updatePagination();
</script>
</body>
</html>

