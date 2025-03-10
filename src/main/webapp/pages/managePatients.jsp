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
            --primary: #ed8936;
            --danger: #e53e3e;
            --bg-light: #f7fafc;
            --text-dark: #1a202c;
            --text-muted: #718096;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
            --border: #e2e8f0;
            --hover: #edf2f7;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1000px;
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

        .card {
            background: var(--card-bg);
            border-radius: 10px;
            box-shadow: var(--shadow);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.2s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(237, 137, 54, 0.2);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: #dd6b20;
            transform: translateY(-1px);
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #c53030;
            transform: translateY(-1px);
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--card-bg);
            border-radius: 10px;
            box-shadow: var(--shadow);
        }

        th {
            background: var(--primary);
            color: white;
            font-weight: 600;
            padding: 1rem;
            text-align: left;
        }

        th:first-child { border-top-left-radius: 10px; }
        th:last-child { border-top-right-radius: 10px; }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:last-child td { border-bottom: none; }
        tr:hover { background: var(--hover); }

        .back-btn {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.2s ease;
        }

        .back-btn:hover {
            color: #dd6b20;
        }

        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            .container { padding: 0 0.5rem; }
            td { padding: 0.75rem; }
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
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" required placeholder="Enter full name">
                </div>
                <div class="form-group">
                    <label for="age">Age</label>
                    <input type="number" id="age" name="age" required placeholder="Enter age" min="1" max="150">
                </div>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="tel" id="phone" name="phone" required placeholder="Enter phone number" pattern="[0-9]{10}">
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
                <th>Age</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="patient" items="${patients}">
                <tr>
                    <td>${patient.split(',')[0]}</td>
                    <td>${patient.split(',')[2]}</td>
                    <td>${patient.split(',')[3]}</td>
                    <td>${patient.split(',')[4]}</td>
                    <td>
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
</body>
</html>