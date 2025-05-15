<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Manage Doctors</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/manageOperations.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="ri-stethoscope-line"></i> Manage Doctors</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="ri-arrow-left-line"></i> Back to Dashboard
        </a>
    </div>

    <div class="main-content">
        <div>
            <div class="card">
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="ri-user-add-line"></i> Add New Doctor
                </button>
            </div>

            <div class="search-container">
                <input type="text" class="search-input" id="searchInput" placeholder="Search doctors..." onkeyup="searchTable()">
                <button class="btn btn-primary" onclick="sortTable()">
                    <i class="ri-sort-desc"></i> Sort (Newest First)
                </button>
            </div>

            <div class="card">
                <h2><i class="ri-pie-chart-line"></i> Specialization Distribution</h2>
                <div class="chart-container">
                    <canvas id="specializationChart"></canvas>
                </div>
            </div>

            <div class="table-container">
                <table id="doctorsTable">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Name</th>
                        <th>Specialization</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="doctorsBody">
                    <c:forEach var="doctor" items="${doctors}">
                        <tr>
                            <td><c:out value="${doctor.split(',')[0]}"/></td>
                            <td><c:out value="${doctor.split(',')[2]}"/></td>
                            <td><c:out value="${doctor.split(',')[3]}"/></td>
                            <td><c:out value="${doctor.split(',')[4]}"/></td>
                            <td><c:out value="${doctor.split(',')[5]}"/></td>
                            <td>
                                <button class="btn btn-edit" onclick="openEditModal(
                                        '<c:out value="${doctor.split(',')[0]}"/>',
                                        '<c:out value="${doctor.split(',')[1]}"/>',
                                        '<c:out value="${doctor.split(',')[2]}"/>',
                                        '<c:out value="${doctor.split(',')[3]}"/>',
                                        '<c:out value="${doctor.split(',')[4]}"/>',
                                        '<c:out value="${doctor.split(',')[5]}"/>'
                                        )"><i class="ri-edit-line"></i> Edit</button>
                                <form action="<%=request.getContextPath()%>/ManageDoctorsServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="username" value="${doctor.split(',')[0]}">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure?');">
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
    </div>
</div>

<!-- Add Doctor Modal -->
<div class="modal" id="addModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="ri-user-add-line"></i> Add New Doctor</h2>
            <button class="modal-close" onclick="closeAddModal()">×</button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/ManageDoctorsServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <i class="ri-user-line"></i>
                    <label>Username</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <i class="ri-lock-line"></i>
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <i class="ri-profile-line"></i>
                    <label>Name</label>
                    <input type="text" name="name" required>
                </div>
                <div class="form-group">
                    <i class="ri-heart-pulse-line"></i>
                    <label>Specialization</label>
                    <input type="text" name="specialization" required>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-mail-line"></i>
                    <label>Email</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <i class="ri-phone-line"></i>
                    <label>Phone</label>
                    <input type="tel" name="phone" required pattern="[0-9]{10}">
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="ri-add-line"></i> Add Doctor
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="ri-user-settings-line"></i> Edit Doctor</h2>
            <button class="modal-close" onclick="closeEditModal()">×</button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/ManageDoctorsServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="originalUsername" id="editOriginalUsername">
                <div class="form-group">
                    <i class="ri-user-line"></i>
                    <label>Username</label>
                    <input type="text" id="editUsername" name="username" required>
                </div>
                <div class="form-group">
                    <i class="ri-lock-line"></i>
                    <label>Password</label>
                    <input type="password" id="editPassword" name="password" required>
                </div>
                <div class="form-group">
                    <i class="ri-profile-line"></i>
                    <label>Name</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                <div class="form-group">
                    <i class="ri-heart-pulse-line"></i>
                    <label>Specialization</label>
                    <input type="text" id="editSpecialization" name="specialization" required>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-mail-line"></i>
                    <label>Email</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <i class="ri-phone-line"></i>
                    <label>Phone</label>
                    <input type="tel" id="editPhone" name="phone" required pattern="[0-9]{10}">
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="ri-save-line"></i> Save Changes
                </button>
            </form>
        </div>
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
    function openEditModal(username, password, name, specialization, email, phone) {
        document.getElementById('editOriginalUsername').value = username;
        document.getElementById('editUsername').value = username;
        document.getElementById('editPassword').value = password;
        document.getElementById('editName').value = name;
        document.getElementById('editSpecialization').value = specialization;
        document.getElementById('editEmail').value = email;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Search function
    function searchTable() {
        const input = document.getElementById('searchInput');
        const filter = input.value.toLowerCase();
        const table = document.getElementById('doctorsTable');
        const tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            let found = false;
            const td = tr[i].getElementsByTagName('td');
            for (let j = 0; j < td.length - 1; j++) {
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

    // Sort function (assuming newer entries have more recent phone numbers as a proxy)
    function sortTable() {
        const table = document.getElementById('doctorsTable');
        const tbody = document.getElementById('doctorsBody');
        const rows = Array.from(tbody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            const phoneA = a.cells[4].textContent;
            const phoneB = b.cells[4].textContent;
            return phoneB.localeCompare(phoneA); // Newest first (assuming higher numbers are newer)
        });

        while (tbody.firstChild) {
            tbody.removeChild(tbody.firstChild);
        }
        rows.forEach(row => tbody.appendChild(row));
    }

    // Specialization Pie Chart
    const doctorsData = [
        <c:forEach var="doctor" items="${doctors}">
        '<c:out value="${doctor.split(',')[3]}"/>',
        </c:forEach>
    ];

    const specializationCount = doctorsData.reduce((acc, curr) => {
        acc[curr] = (acc[curr] || 0) + 1;
        return acc;
    }, {});

    const ctx = document.getElementById('specializationChart').getContext('2d');
    new Chart(ctx, {
        type: 'pie',
        data: {
            labels: Object.keys(specializationCount),
            datasets: [{
                data: Object.values(specializationCount),
                backgroundColor: [
                    'rgba(74, 144, 226, 0.8)',
                    'rgba(38, 166, 154, 0.8)',
                    'rgba(239, 83, 80, 0.8)',
                    'rgba(156, 39, 176, 0.8)',
                    'rgba(255, 159, 64, 0.8)',
                    'rgba(46, 204, 113, 0.8)'
                ],
                borderWidth: 2,
                borderColor: '#FFFFFF'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        font: { size: 12 }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 10,
                    cornerRadius: 8
                },
                title: {
                    display: true,
                    text: 'Doctors by Specialization',
                    font: { size: 16 }
                }
            }
        }
    });

    window.onclick = function(event) {
        const addModal = document.getElementById('addModal');
        const editModal = document.getElementById('editModal');
        if (event.target === addModal) {
            closeAddModal();
        } else if (event.target === editModal) {
            closeEditModal();
        }
    }
</script>
</body>
</html>