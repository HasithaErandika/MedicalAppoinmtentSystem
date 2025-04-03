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
            --text-primary: #2D3748;   /* Darker Gray */
            --card-bg: #FFFFFF;        /* White */
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --hover: #EDF2F7;          /* Light Blue-Gray */
            --danger: #EF5350;         /* Red */
            --success: #38A169;        /* Green */
            --border: #E2E8F0;         /* Light Border */
        }

        /* Base Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
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
            height: 100vh;
            position: fixed;
            padding: 2rem 1rem;
            transition: width 0.3s ease;
            box-shadow: var(--shadow);
            z-index: 1000;
        }
        .sidebar.collapsed { width: 80px; }
        .sidebar .logo {
            font-size: 1.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: var(--primary);
            margin-bottom: 2.5rem;
        }
        .sidebar.collapsed .logo span { display: none; }
        .sidebar ul { list-style: none; }
        .sidebar ul li a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: var(--text-primary);
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        .sidebar ul li a:hover, .sidebar ul li a.active {
            background: var(--primary);
            color: #FFFFFF;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1);
        }
        .sidebar.collapsed ul li a span { display: none; }
        .toggle-btn {
            background: none;
            border: none;
            color: var(--primary);
            font-size: 1.25rem;
            cursor: pointer;
            position: absolute;
            top: 1.5rem;
            right: 1rem;
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
            background: linear-gradient(135deg, var(--primary), #357ABD);
            padding: 1.5rem 2rem;
            border-radius: 12px;
            color: #FFFFFF;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .header h1 {
            font-size: 1.75rem;
            font-weight: 600;
        }
        .logout-btn {
            background: var(--secondary);
            color: #FFFFFF;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        .logout-btn:hover {
            background: #00897B;
            transform: translateY(-2px);
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
            border-left: 4px solid var(--secondary);
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        .card i {
            font-size: 2rem;
            color: var(--secondary);
            margin-bottom: 0.75rem;
        }
        .card h3 {
            font-size: 1rem;
            font-weight: 500;
            color: var(--text-primary);
        }
        .card p {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--primary);
        }

        /* Table Section */
        .table-section {
            background: var(--card-bg);
            padding: 2rem;
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
            font-weight: 600;
        }
        .table-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        .search-bar {
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 0.25rem 0.75rem;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        .search-bar:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
        }
        .search-bar input {
            border: none;
            padding: 0.5rem;
            font-size: 0.9rem;
            width: 220px;
            background: transparent;
        }
        .search-bar input:focus { outline: none; }
        .search-bar i { color: var(--text-primary); }
        .btn {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        .export-btn {
            background: var(--secondary);
            color: #FFFFFF;
        }
        .export-btn:hover {
            background: #00897B;
            transform: translateY(-2px);
        }
        .appointments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        .appointments-table th,
        .appointments-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        .appointments-table th {
            background: var(--primary);
            color: #FFFFFF;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .appointments-table th:hover {
            background: #357ABD;
            cursor: pointer;
        }
        .appointments-table tr:hover {
            background: var(--hover);
        }
        .priority-emergency { color: var(--danger); font-weight: 600; }
        .action-btn {
            padding: 0.4rem 0.8rem;
            margin: 0 0.25rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        .cancel-btn { background: var(--danger); color: #FFFFFF; }
        .cancel-btn:hover { background: #C62828; }
        .edit-btn { background: var(--primary); color: #FFFFFF; }
        .edit-btn:hover { background: #357ABD; }

        /* Pagination */
        .pagination {
            margin-top: 1.5rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
        }
        .pagination button {
            padding: 0.5rem 1rem;
            background: var(--primary);
            color: #FFFFFF;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .pagination button:hover:not(:disabled) { background: #357ABD; }
        .pagination button:disabled {
            background: var(--border);
            color: #A0AEC0;
            cursor: not-allowed;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            width: 90%;
            max-width: 500px;
            position: relative;
        }
        .modal-content h2 {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: var(--primary);
        }
        .modal-content label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        .modal-content input, .modal-content select {
            width: 100%;
            padding: 0.75rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .modal-content .btn {
            width: 100%;
            padding: 0.75rem;
        }
        .close-modal {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--text-primary);
            cursor: pointer;
        }

        /* Messages */
        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            text-align: center;
        }
        .error-message { background: #FEE2E2; color: var(--danger); }
        .success-message { background: #D4EDDA; color: var(--success); }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar { width: 80px; }
            .sidebar .logo span, .sidebar ul li a span { display: none; }
            .main-content { margin-left: 80px; padding: 1rem; }
            .dashboard-grid { grid-template-columns: 1fr; }
            .table-actions { flex-direction: column; gap: 0.75rem; }
            .appointments-table { font-size: 0.9rem; }
        }
        @media (max-width: 480px) {
            .search-bar input { width: 150px; }
            .appointments-table th, .appointments-table td { padding: 0.5rem; font-size: 0.8rem; }
            .action-btn { padding: 0.3rem 0.6rem; font-size: 0.75rem; }
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
        <li><a href="<%=request.getContextPath()%>/ManageAppointmentsServlet"><i class="fas fa-calendar-check"></i><span>Manage Appointments</span></a></li>
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

    <c:if test="${not empty error}">
        <div class="message error-message">${error}</div>
    </c:if>
    <c:if test="${not empty message}">
        <div class="message success-message">${message}</div>
    </c:if>

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
                <button class="btn export-btn" onclick="exportTable()">Export to CSV</button>
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
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="appointmentsBody">
            <c:forEach var="appt" items="${sortedAppointments}" varStatus="loop">
                <tr class="appointment-row" data-page="${(loop.index div 5) + 1}">
                    <td>${appt.id}</td>
                    <td>${appt.patientId}</td>
                    <td>${appt.doctorId}</td>
                    <td>${appt.dateTime}</td>
                    <td class="${appt.priority == 1 ? 'priority-emergency' : ''}">
                            ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                    </td>
                    <td>
                        <button class="action-btn edit-btn" onclick="openEditModal('${appt.id}', '${appt.patientId}', '${appt.doctorId}', '${appt.dateTime}', '${appt.priority}')">Edit</button>
                        <form action="<%=request.getContextPath()%>/AdminServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this appointment?');">
                            <input type="hidden" name="action" value="cancelAppointment">
                            <input type="hidden" name="appointmentId" value="${appt.id}">
                            <button type="submit" class="action-btn cancel-btn">Cancel</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="pagination" id="pagination"></div>
    </div>

    <!-- Edit Appointment Modal -->
    <div class="modal" id="editModal">
        <div class="modal-content">
            <button class="close-modal" onclick="closeEditModal()">&times;</button>
            <h2>Edit Appointment</h2>
            <form id="editForm" action="<%=request.getContextPath()%>/AdminServlet" method="post">
                <input type="hidden" name="action" value="updateAppointment">
                <input type="hidden" name="appointmentId" id="editId">
                <label for="editPatientId">Patient ID</label>
                <input type="text" name="patientId" id="editPatientId" required>
                <label for="editDoctorId">Doctor ID</label>
                <input type="text" name="doctorId" id="editDoctorId" required>
                <label for="editDateTime">Date & Time (yyyy-MM-dd HH:mm)</label>
                <input type="text" name="dateTime" id="editDateTime" required>
                <label for="editPriority">Priority</label>
                <select name="priority" id="editPriority" required>
                    <option value="1">Emergency</option>
                    <option value="2">Normal</option>
                </select>
                <button type="submit" class="btn" style="background: var(--success);">Update Appointment</button>
            </form>
        </div>
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
            row.style.display = found ? '' : 'none';
        }
        currentPage = 1;
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
                    cmpX = parseInt(cmpX) || (cmpX === 'emergency' ? 1 : 2);
                    cmpY = parseInt(cmpY) || (cmpY === 'emergency' ? 1 : 2);
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

        if (totalPages <= 1) {
            showPage();
            return;
        }

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
        const rows = Array.from(document.getElementsByClassName('appointment-row'));
        const start = (currentPage - 1) * ITEMS_PER_PAGE;
        const end = start + ITEMS_PER_PAGE;
        rows.forEach((row, index) => {
            row.style.display = (index >= start && index < end && row.style.display !== 'none') ? '' : 'none';
        });
    }

    function exportTable() {
        const table = document.getElementById('appointmentsTable');
        let csv = ['ID,Patient ID,Doctor ID,Date & Time,Priority'];
        for (let row of table.rows) {
            if (row.style.display !== 'none' && row.parentNode.tagName === 'TBODY') {
                let rowData = [];
                for (let cell of row.cells) {
                    rowData.push('"' + cell.innerText.replace(/"/g, '""') + '"');
                }
                csv.push(rowData.slice(0, 5).join(',')); // Exclude Actions column
            }
        }
        const csvContent = 'data:text/csv;charset=utf-8,' + csv.join('\n');
        const link = document.createElement('a');
        link.setAttribute('href', encodeURI(csvContent));
        link.setAttribute('download', 'appointments_' + new Date().toISOString().slice(0,10) + '.csv');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    function openEditModal(id, patientId, doctorId, dateTime, priority) {
        document.getElementById('editId').value = id;
        document.getElementById('editPatientId').value = patientId;
        document.getElementById('editDoctorId').value = doctorId;
        document.getElementById('editDateTime').value = dateTime;
        document.getElementById('editPriority').value = priority;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    window.onload = () => updatePagination();
</script>
</body>

</html>

