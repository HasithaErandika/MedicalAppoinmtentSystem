<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MediSchedule - Manage Doctors</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary: #4A90E2;
                --secondary: #26A69A;
                --accent: #EF5350;
                --success: #2ECC71;
                --bg-light: #F5F6F5;
                --text-primary: #333333;
                --text-muted: #666666;
                --card-bg: #FFFFFF;
                --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                --border: #E0E0E0;
                --hover: #F9FAFB;
                --transition: all 0.3s ease;
            }

            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: var(--bg-light);
                color: var(--text-primary);
                line-height: 1.6;
                font-size: 16px;
            }

            .container {
                max-width: 1280px;
                margin: 2rem auto;
                padding: 0 1.5rem;
            }

            /* Header Improvements */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2.5rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid var(--border);
            }
            .header h1 {
                color: var(--primary);
                font-size: 2.25rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }
            .back-btn {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                padding: 0.5rem 1rem;
                border-radius: 6px;
                transition: var(--transition);
            }
            .back-btn:hover {
                background: var(--hover);
                color: #357ABD;
            }

            /* Card and Form Improvements */
            .card {
                background: var(--card-bg);
                border-radius: 16px;
                box-shadow: var(--shadow);
                padding: 2rem;
                margin-bottom: 2.5rem;
                transition: var(--transition);
            }
            .card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
            }

            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }
            .form-group {
                position: relative;
            }
            .form-group label {
                font-size: 0.95rem;
                font-weight: 500;
                margin-bottom: 0.5rem;
                color: var(--text-primary);
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }
            .form-group input {
                width: 100%;
                padding: 0.875rem;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-size: 1rem;
                background: #FFFFFF;
                transition: var(--transition);
            }
            .form-group input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
                outline: none;
            }
            .form-group input:invalid:focus {
                border-color: var(--accent);
                box-shadow: 0 0 0 3px rgba(239, 83, 80, 0.1);
            }

            /* Button Improvements */
            .btn {
                padding: 0.875rem 1.75rem;
                border: none;
                border-radius: 8px;
                font-weight: 500;
                font-size: 1rem;
                cursor: pointer;
                transition: var(--transition);
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }
            .btn-primary {
                background: var(--primary);
                color: #FFFFFF;
            }
            .btn-primary:hover {
                background: #357ABD;
                box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);
            }
            .btn-danger {
                background: var(--accent);
                color: #FFFFFF;
            }
            .btn-danger:hover {
                background: #D32F2F;
                box-shadow: 0 2px 8px rgba(239, 83, 80, 0.3);
            }
            .btn-edit {
                background: var(--secondary);
                color: #FFFFFF;
            }
            .btn-edit:hover {
                background: #00897B;
                box-shadow: 0 2px 8px rgba(38, 166, 154, 0.3);
            }

            /* Table Improvements */
            .table-container {
                overflow-x: auto;
                margin-bottom: 2rem;
            }
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: var(--card-bg);
                border-radius: 16px;
                box-shadow: var(--shadow);
                overflow: hidden;
            }
            th {
                background: var(--primary);
                color: #FFFFFF;
                font-weight: 600;
                padding: 1.25rem;
                text-align: left;
                font-size: 1.05rem;
            }
            td {
                padding: 1.25rem;
                border-bottom: 1px solid var(--border);
                vertical-align: middle;
            }
            tr {
                transition: var(--transition);
            }
            tr:hover {
                background: var(--hover);
                cursor: pointer;
            }
            .action-cell {
                display: flex;
                gap: 0.75rem;
                align-items: center;
            }

            /* Modal Improvements */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                justify-content: center;
                align-items: center;
                z-index: 1000;
                animation: fadeIn 0.3s ease;
            }
            .modal-content {
                background: var(--card-bg);
                padding: 2.5rem;
                border-radius: 16px;
                box-shadow: var(--shadow);
                width: 90%;
                max-width: 700px;
                max-height: 90vh;
                overflow-y: auto;
                animation: slideIn 0.3s ease;
            }
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }
            .modal-content h2 {
                font-size: 1.75rem;
                color: var(--primary);
            }

            /* Animations */
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            @keyframes slideIn {
                from { transform: translateY(-20px); opacity: 0; }
                to { transform: translateY(0); opacity: 1; }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .form-grid { grid-template-columns: 1fr; }
                .header { flex-direction: column; align-items: flex-start; gap: 1.5rem; }
                .container { padding: 0 1rem; }
                .btn { width: 100%; justify-content: center; }
                .action-cell { flex-direction: column; gap: 0.5rem; }
            }
        </style>
    </head>
    <body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-user-md"></i> Manage Doctors</h1>
            <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="card">
            <form action="<%=request.getContextPath()%>/ManageDoctorsServlet" method="post" class="doctor-form">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="username"><i class="fas fa-user"></i> Username</label>
                        <input type="text" id="username" name="username" required placeholder="Enter username">
                    </div>
                    <div class="form-group">
                        <label for="password"><i class="fas fa-lock"></i> Password</label>
                        <input type="password" id="password" name="password" required placeholder="Enter password">
                    </div>
                    <div class="form-group">
                        <label for="name"><i class="fas fa-id-card"></i> Name</label>
                        <input type="text" id="name" name="name" required placeholder="Enter full name">
                    </div>
                    <div class="form-group">
                        <label for="specialization"><i class="fas fa-stethoscope"></i> Specialization</label>
                        <input type="text" id="specialization" name="specialization" required placeholder="Enter specialization">
                    </div>
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" required placeholder="Enter email address">
                    </div>
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i> Phone</label>
                        <input type="tel" id="phone" name="phone" required placeholder="Enter phone number" pattern="[0-9]{10}">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i> Add Doctor</button>
            </form>
        </div>

        <div class="table-container">
            <table>
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
                <tbody>
                <c:forEach var="doctor" items="${doctors}">
                    <tr>
                        <td><c:out value="${doctor.split(',')[0]}"/></td>
                        <td><c:out value="${doctor.split(',')[2]}"/></td>
                        <td><c:out value="${doctor.split(',')[3]}"/></td>
                        <td><c:out value="${doctor.split(',')[4]}"/></td>
                        <td><c:out value="${doctor.split(',')[5]}"/></td>
                        <td class="action-cell">
                            <button class="btn btn-edit" onclick="openEditModal(
                                    '<c:out value="${doctor.split(',')[0]}"/>',
                                    '<c:out value="${doctor.split(',')[1]}"/>',
                                    '<c:out value="${doctor.split(',')[2]}"/>',
                                    '<c:out value="${doctor.split(',')[3]}"/>',
                                    '<c:out value="${doctor.split(',')[4]}"/>',
                                    '<c:out value="${doctor.split(',')[5]}"/>'
                                    )"><i class="fas fa-edit"></i> Edit</button>
                            <form action="<%=request.getContextPath()%>/ManageDoctorsServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="username" value="${doctor.split(',')[0]}">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to remove this doctor?');">
                                    <i class="fas fa-trash"></i> Remove
                                </button>
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
            <div class="modal-header">
                <h2><i class="fas fa-user-edit"></i> Edit Doctor</h2>
                <button class="modal-close" onclick="closeEditModal()">×</button>
            </div>
            <form action="<%=request.getContextPath()%>/ManageDoctorsServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="originalUsername" id="editOriginalUsername">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="editUsername"><i class="fas fa-user"></i> Username</label>
                        <input type="text" id="editUsername" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="editPassword"><i class="fas fa-lock"></i> Password</label>
                        <input type="password" id="editPassword" name="password" required>
                    </div>
                    <div class="form-group">
                        <label for="editName"><i class="fas fa-id-card"></i> Name</label>
                        <input type="text" id="editName" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="editSpecialization"><i class="fas fa-stethoscope"></i> Specialization</label>
                        <input type="text" id="editSpecialization" name="specialization" required>
                    </div>
                    <div class="form-group">
                        <label for="editEmail"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="editEmail" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="editPhone"><i class="fas fa-phone"></i> Phone</label>
                        <input type="tel" id="editPhone" name="phone" required pattern="[0-9]{10}">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(username, password, name, specialization, email, phone) {
            document.getElementById('editOriginalUsername').value = username;
            document.getElementById('editUsername').value = username;
            document.getElementById('editPassword').value = password;
            document.getElementById('editName').value = name;
            document.getElementById('editSpecialization').value = specialization;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone;
            document.getElementById('editModal').style.display = 'flex'; // Fixed typo: 'getElementOfId' to 'getElementById'
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                closeEditModal();
            }
        }
    </script>
    </body>
    </html>