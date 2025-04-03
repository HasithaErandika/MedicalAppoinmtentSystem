<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Manage Patients</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/manageOperations.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="ri-user-heart-line"></i> Manage Patients</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="ri-arrow-left-line"></i> Back to Dashboard
        </a>
    </div>

    <!-- Add Patient Button -->
    <div class="card">
        <button class="btn btn-primary" onclick="openAddModal()">
            <i class="ri-user-add-line"></i> Add New Patient
        </button>
    </div>

    <!-- Search and Sort Controls -->
    <div class="search-container">
        <input type="text" class="search-input" id="searchInput" placeholder="Search patients..." onkeyup="searchTable()">
        <button class="btn btn-primary" onclick="sortTable()">
            <i class="ri-sort-desc"></i> Sort (Newest First)
        </button>
    </div>

    <div class="card">
        <h2><i class="ri-pie-chart-line"></i> Age Distribution</h2>
        <div class="chart-container">
            <canvas id="ageChart"></canvas>
        </div>
    </div>

    <!-- Patients Table -->
    <div class="table-container">
        <table id="patientsTable">
            <thead>
            <tr>
                <th>Username</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Date of Birth</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="patientsBody">
            <c:forEach var="patient" items="${patients}">
                <tr>
                    <td><c:out value="${patient.split(',')[0]}"/></td>
                    <td><c:out value="${patient.split(',')[2]}"/></td>
                    <td><c:out value="${patient.split(',')[3]}"/></td>
                    <td><c:out value="${patient.split(',')[4]}"/></td>
                    <td><c:out value="${patient.split(',')[5]}"/></td>
                    <td class="action-cell">
                        <button class="btn btn-edit" onclick="openEditModal(
                                '<c:out value="${patient.split(',')[0]}"/>',
                                '<c:out value="${patient.split(',')[1]}"/>',
                                '<c:out value="${patient.split(',')[2]}"/>',
                                '<c:out value="${patient.split(',')[3]}"/>',
                                '<c:out value="${patient.split(',')[4]}"/>',
                                '<c:out value="${patient.split(',')[5]}"/>'
                                )"><i class="ri-edit-line"></i> Edit</button>
                        <form action="<%=request.getContextPath()%>/ManagePatientsServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="username" value="${patient.split(',')[0]}">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to remove this patient?');">
                                <i class="ri-delete-bin-line"></i> Remove
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Patient Modal -->
<div class="modal" id="addModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="ri-user-add-line"></i> Add New Patient</h2>
            <button class="modal-close" onclick="closeAddModal()">×</button>
        </div>
        <form action="<%=request.getContextPath()%>/ManagePatientsServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-grid">
                <div class="form-group">
                    <label for="addUsername"><i class="ri-user-line"></i> Username</label>
                    <input type="text" id="addUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="addPassword"><i class="ri-lock-line"></i> Password</label>
                    <input type="password" id="addPassword" name="password" required>
                </div>
                <div class="form-group">
                    <label for="addName"><i class="ri-profile-line"></i> Full Name</label>
                    <input type="text" id="addName" name="name" required>
                </div>
                <div class="form-group">
                    <label for="addEmail"><i class="ri-mail-line"></i> Email</label>
                    <input type="email" id="addEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="addPhone"><i class="ri-phone-line"></i> Phone</label>
                    <input type="tel" id="addPhone" name="phone" required pattern="[0-9]{10}">
                </div>
                <div class="form-group">
                    <label for="addDob"><i class="ri-calendar-line"></i> Date of Birth</label>
                    <input type="date" id="addDob" name="dob" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary"><i class="ri-add-line"></i> Add Patient</button>
        </form>
    </div>
</div>

<!-- Edit Patient Modal -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="ri-edit-line"></i> Edit Patient</h2>
            <button class="modal-close" onclick="closeEditModal()">×</button>
        </div>
        <form action="<%=request.getContextPath()%>/ManagePatientsServlet" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="originalUsername" id="editOriginalUsername">
            <div class="form-grid">
                <div class="form-group">
                    <label for="editUsername"><i class="ri-user-line"></i> Username</label>
                    <input type="text" id="editUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="editPassword"><i class="ri-lock-line"></i> Password</label>
                    <input type="password" id="editPassword" name="password" required>
                </div>
                <div class="form-group">
                    <label for="editName"><i class="ri-profile-line"></i> Full Name</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                <div class="form-group">
                    <label for="editEmail"><i class="ri-mail-line"></i> Email</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="editPhone"><i class="ri-phone-line"></i> Phone</label>
                    <input type="tel" id="editPhone" name="phone" required pattern="[0-9]{10}">
                </div>
                <div class="form-group">
                    <label for="editDob"><i class="ri-calendar-line"></i> Date of Birth</label>
                    <input type="date" id="editDob" name="dob" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Changes</button>
        </form>
    </div>
</div>

<script>
    // Add Modal functions
    function openAddModal() {
        document.getElementById('addModal').style.display = 'flex';
    }

    function closeAddModal() {
        document.getElementById('addModal').style.display = 'none';
    }

    // Edit Modal functions
    function openEditModal(username, password, name, email, phone, dob) {
        document.getElementById('editModal').style.display = 'flex';
        document.getElementById('editOriginalUsername').value = username;
        document.getElementById('editUsername').value = username;
        document.getElementById('editPassword').value = password;
        document.getElementById('editName').value = name;
        document.getElementById('editEmail').value = email;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editDob').value = dob;
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Search function
    function searchTable() {
        const input = document.getElementById('searchInput');
        const filter = input.value.toLowerCase();
        const table = document.getElementById('patientsTable');
        const tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            let found = false;
            const td = tr[i].getElementsByTagName('td');
            for (let j = 0; j < td.length - 1; j++) { // Exclude action column
                const cell = td[j];
                if (cell) {
                    const txtValue = cell.textContent || cell.innerText;
                    if (txtValue.toLowerCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
            }
            tr[i].style.display = found ? '' : 'none';
        }
    }

    // Sort function (newest first based on Date of Birth)
    function sortTable() {
        const table = document.getElementById('patientsTable');
        const tbody = document.getElementById('patientsBody');
        const rows = Array.from(tbody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            const dateA = new Date(a.cells[4].textContent);
            const dateB = new Date(b.cells[4].textContent);
            return dateB - dateA; // Newest first
        });

        while (tbody.firstChild) {
            tbody.removeChild(tbody.firstChild);
        }
        rows.forEach(row => tbody.appendChild(row));
    }

    window.onclick = function(event) {
        const addModal = document.getElementById('addModal');
        const editModal = document.getElementById('editModal');
        if (event.target === addModal) {
            closeAddModal();
        } else if (event.target === editModal) {
            closeEditModal();
        }
    }

    // Age Distribution Chart
    const patientsData = [
        <c:forEach var="patient" items="${patients}">
        '<c:out value="${patient.split(',')[5]}"/>',
        </c:forEach>
    ];

    function calculateAge(dob) {
        const birthDate = new Date(dob);
        const today = new Date();
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        return age;
    }

    const ageGroups = {
        '0-12': 0,
        '12-20': 0,
        '20-35': 0,
        '35-60': 0,
        '60+': 0
    };

    patientsData.forEach(dob => {
        const age = calculateAge(dob);
        if (age <= 12) ageGroups['0-12']++;
        else if (age <= 20) ageGroups['12-20']++;
        else if (age <= 35) ageGroups['20-35']++;
        else if (age <= 60) ageGroups['35-60']++;
        else ageGroups['60+']++;
    });

    const ctx = document.getElementById('ageChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(ageGroups),
            datasets: [{
                label: 'Number of Patients',
                data: Object.values(ageGroups),
                backgroundColor: [
                    'rgba(74, 144, 226, 0.8)',
                    'rgba(38, 166, 154, 0.8)',
                    'rgba(239, 83, 80, 0.8)',
                    'rgba(156, 39, 176, 0.8)',
                    'rgba(255, 159, 64, 0.8)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Number of Patients'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Age Groups'
                    }
                }
            }
        }
    });
</script>
</body>
</html>