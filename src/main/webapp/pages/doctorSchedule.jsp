<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Doctor Schedule</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #ed8936;
            --secondary: #2c5282;
            --success: #48bb78;
            --danger: #e53e3e;
            --bg-light: #f7fafc;
            --text-dark: #1a202c;
            --text-muted: #718096;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
            --border: #e2e8f0;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1100px;
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
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
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

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.2s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
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

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th {
            background: var(--secondary);
            color: white;
            font-weight: 600;
            padding: 1rem;
            text-align: left;
        }

        th:first-child { border-top-left-radius: 6px; }
        th:last-child { border-top-right-radius: 6px; }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tr:last-child td { border-bottom: none; }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background: #c53030;
        }

        .back-btn {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .back-btn:hover {
            color: #dd6b20;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .header { flex-direction: column; align-items: flex-start; gap: 1rem; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Doctor Schedule</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="card">
        <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-grid">
                <div class="form-group">
                    <label for="doctorId">Doctor ID</label>
                    <input type="text" id="doctorId" name="doctorId" required placeholder="Enter Doctor ID">
                </div>
                <div class="form-group">
                    <label for="day">Day</label>
                    <select id="day" name="day" required>
                        <option value="" disabled selected>Select day</option>
                        <c:forEach var="day" items="${days}">
                            <option value="${day}">${day}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="startTime">Start Time</label>
                    <select id="startTime" name="startTime" required>
                        <option value="" disabled selected>Select start time</option>
                        <option value="09:00 AM">9:00 AM</option>
                        <option value="10:00 AM">10:00 AM</option>
                        <option value="01:00 PM">1:00 PM</option>
                        <option value="03:30 PM">3:30 PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="endTime">End Time</label>
                    <select id="endTime" name="endTime" required>
                        <option value="" disabled selected>Select end time</option>
                        <option value="11:00 AM">11:00 AM</option>
                        <option value="12:00 PM">12:00 PM</option>
                        <option value="03:30 PM">3:30 PM</option>
                        <option value="05:30 PM">5:30 PM</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Add Availability</button>
        </form>
    </div>

    <div class="card">
        <h2 style="margin-bottom: 1.5rem;">Current Availability</h2>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Doctor ID</th>
                    <th>Day</th>
                    <th>Time Slot</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="avail" items="${availability}">
                    <tr>
                        <td>${avail.split(',')[0]}</td>
                        <td>${avail.split(',')[1]}</td>
                        <td>${avail.split(',')[2]} - ${avail.split(',')[3]}</td>
                        <td>
                            <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="doctorId" value="${avail.split(',')[0]}">
                                <input type="hidden" name="day" value="${avail.split(',')[1]}">
                                <input type="hidden" name="startTime" value="${avail.split(',')[2]}">
                                <input type="hidden" name="endTime" value="${avail.split(',')[3]}">
                                <button type="submit" class="btn btn-danger">Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>