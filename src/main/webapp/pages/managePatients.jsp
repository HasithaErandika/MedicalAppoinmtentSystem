<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Manage Patients</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4A90E2;
            --secondary: #26A69A;
            --accent: #EF5350;
            --bg-light: #F5F6F5;
            --text-primary: #333333;
            --card-bg: #FFFFFF;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            --border: #E0E0E0;
            --hover: #F9FAFB;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        h1 {
            color: var(--primary);
            font-size: 2rem;
            font-weight: 600;
        }
        .back-btn {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.3s ease;
        }
        .back-btn:hover {
            color: #357ABD;
        }

        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 5px rgba(74, 144, 226, 0.3);
            outline: none;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: var(--primary);
            color: #FFFFFF;
        }
        .btn-primary:hover {
            background: #357ABD;
            transform: translateY(-2px);
        }
        .btn-danger {
            background: var(--accent);
            color: #FFFFFF;
        }
        .btn-danger:hover {
            background: #D32F2F;
            transform: translateY(-2px);
        }
        .btn-edit {
            background: var(--secondary);
            color: #FFFFFF;
            margin-right: 0.5rem;
        }
        .btn-edit:hover {
            background: #00897B;
            transform: translateY(-2px);
        }

        .table-container {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow);
        }
        th {
            background: var(--primary);
            color: #FFFFFF;
            font-weight: 600;
            padding: 1rem;
            text-align: left;
        }
        th:first-child { border-top-left-radius: 12px; }
        th:last-child { border-top-right-radius: 12px; }
        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }
        tr:last-child td { border-bottom: none; }
        tr:hover { background: var(--hover); }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: var(--shadow);
            width: 90%;
            max-width: 600px;
        }
        .modal-content h2 {
            font-size: 1.5rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        .modal-close {
            float: right;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--text-primary);
            cursor: pointer;
        }
        .modal-close:hover {
            color: var(--accent);
        }

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            .container { padding: 0 0.5rem; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Manage Patients</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="card">
        <form action="<%=request.getContextPath()%>/ManagePatientsServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-grid">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required placeholder="Enter username">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required placeholder="Enter password">
                </div>
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required placeholder="Enter full name">
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="Enter email">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" required placeholder="Enter phone number" pattern="[0-9]{10}">
                </div>
                <div class="form-group">
                    <label for="dob">Date of Birth</label>
                    <input type="date" id="dob" name="dob" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Add Patient</button>
        </form>
    </div>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Username</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Date of Birth</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="patient" items="${patients}">
                <tr>
                    <td><c:out value="${patient.split(',')[0]}"/></td>
                    <td><c:out value="${patient.split(',')[2]}"/></td>
                    <td><c:out value="${patient.split(',')[3]}"/></td>
                    <td><c:out value="${patient.split(',')[4]}"/></td>
                    <td><c:out value="${patient.split(',')[5]}"/></td>
                    <td>
                        <button class="btn btn-edit" onclick="openEditModal(
                                '<c:out value="${patient.split(',')[0]}"/>',
                                '<c:out value="${patient.split(',')[1]}"/>',
                                '<c:out value="${patient.split(',')[2]}"/>',
                                '<c:out value="${patient.split(',')[3]}"/>',
                                '<c:out value="${patient.split(',')[4]}"/>',
                                '<c:out value="${patient.split(',')[5]}"/>'
                                )">Edit</button>
                        <form action="<%=request.getContextPath()%>/ManagePatientsServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="username" value="${patient.split(',')[0]}">
                            <button type="submit" class="btn btn-danger">Remove</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <button class="modal-close" onclick="closeEditModal()">×</button>
        <h2>Edit Patient</h2>
        <form action="<%=request.getContextPath()%>/ManagePatientsServlet" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="originalUsername" id="editOriginalUsername">
            <div class="form-grid">
                <div class="form-group">
                    <label for="editUsername">Username</label>
                    <input type="text" id="editUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="editPassword">Password</label>
                    <input type="password" id="editPassword" name="password" required>
                </div>
                <div class="form-group">
                    <label for="editName">Full Name</label>
                    <input type="text" id="editName" name="name" required>
                </div>
                <div class="form-group">
                    <label for="editEmail">Email Address</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="editPhone">Phone Number</label>
                    <input type="tel" id="editPhone" name="phone" required pattern="[0-9]{10}">
                </div>
                <div class="form-group">
                    <label for="editDob">Date of Birth</label>
                    <input type="date" id="editDob" name="dob" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Save Changes</button>
        </form>
    </div>
</div>

<script>
    function openEditModal(username, password, name, email, phone, dob) {
        console.log("Opening modal with:", username, password, name, email, phone, dob); // Debug
        document.getElementById('editOriginalUsername').value = username;
        document.getElementById('editUsername').value = username;
        document.getElementById('editPassword').value = password;
        document.getElementById('editName').value = name;
        document.getElementById('editEmail').value = email;
        document.getElementById('editPhone').value = phone;
        document.getElementById('editDob').value = dob;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    window.onclick = function(event) {
        const modal = document.getElementById('editModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
</script>
</body>
</html>