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
        .form-group input, .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-group input:focus, .form-group select:focus {
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
                    <label for="doctorId">Doctor</label>
                    <select id="doctorId" name="doctorId" required>
                        <option value="" disabled selected>Select a doctor</option>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.split(',')[0]}">${doctor.split(',')[2]}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date" required>
                </div>
                <div class="form-group">
                    <label for="startTime">Start Time</label>
                    <select id="startTime" name="startTime" required>
                        <option value="" disabled selected>Select start time</option>
                        <option value="09:00">09:00 AM</option>
                        <option value="10:00">10:00 AM</option>
                        <option value="13:00">01:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="endTime">End Time</label>
                    <select id="endTime" name="endTime" required>
                        <option value="" disabled selected>Select end time</option>
                        <option value="11:00">11:00 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                        <option value="17:30">05:30 PM</option>
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
                    <th>Doctor Name</th>
                    <th>Date</th>
                    <th>Time Slot</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="avail" items="${availability}">
                    <tr>
                        <td>
                            <c:forEach var="doctor" items="${doctors}">
                                <c:if test="${doctor.split(',')[0] == avail.split(',')[0]}">
                                    <c:out value="${doctor.split(',')[2]}"/>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td><c:out value="${avail.split(',')[1]}"/></td>
                        <td><c:out value="${avail.split(',')[2]}"/> - <c:out value="${avail.split(',')[3]}"/></td>
                        <td>
                            <button class="btn btn-edit" onclick="openEditModal(
                                    '<c:out value="${avail.split(',')[0]}"/>',
                                    '<c:out value="${avail.split(',')[1]}"/>',
                                    '<c:out value="${avail.split(',')[2]}"/>',
                                    '<c:out value="${avail.split(',')[3]}"/>'
                                    )">Edit</button>
                            <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="doctorId" value="${avail.split(',')[0]}">
                                <input type="hidden" name="date" value="${avail.split(',')[1]}">
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

<!-- Edit Modal -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <button class="modal-close" onclick="closeEditModal()">×</button>
        <h2>Edit Availability</h2>
        <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="originalDoctorId" id="editOriginalDoctorId">
            <input type="hidden" name="originalDate" id="editOriginalDate">
            <input type="hidden" name="originalStartTime" id="editOriginalStartTime">
            <input type="hidden" name="originalEndTime" id="editOriginalEndTime">
            <div class="form-grid">
                <div class="form-group">
                    <label for="editDoctorId">Doctor</label>
                    <select id="editDoctorId" name="doctorId" required>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.split(',')[0]}">${doctor.split(',')[2]}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="editDate">Date</label>
                    <input type="date" id="editDate" name="date" required>
                </div>
                <div class="form-group">
                    <label for="editStartTime">Start Time</label>
                    <select id="editStartTime" name="startTime" required>
                        <option value="09:00">09:00 AM</option>
                        <option value="10:00">10:00 AM</option>
                        <option value="13:00">01:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="editEndTime">End Time</label>
                    <select id="editEndTime" name="endTime" required>
                        <option value="11:00">11:00 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                        <option value="17:30">05:30 PM</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Save Changes</button>
        </form>
    </div>
</div>

<script>
    // Disable Mondays (1) and Sundays (0) in the date picker
    function disableWeekends(inputId) {
        const dateInput = document.getElementById(inputId);
        dateInput.addEventListener('input', function() {
            const selectedDate = new Date(this.value);
            const day = selectedDate.getDay();
            if (day === 0 || day === 1) { // Sunday or Monday
                alert('Please select a date from Tuesday to Saturday.');
                this.value = '';
            }
        });
    }

    // Apply to both date inputs
    disableWeekends('date');
    disableWeekends('editDate');

    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('date').setAttribute('min', today);
    document.getElementById('editDate').setAttribute('min', today);

    function openEditModal(doctorId, date, startTime, endTime) {
        console.log("Opening modal with:", doctorId, date, startTime, endTime); // Debug
        document.getElementById('editOriginalDoctorId').value = doctorId;
        document.getElementById('editOriginalDate').value = date;
        document.getElementById('editOriginalStartTime').value = startTime;
        document.getElementById('editOriginalEndTime').value = endTime;
        document.getElementById('editDoctorId').value = doctorId;
        document.getElementById('editDate').value = date;
        document.getElementById('editStartTime').value = startTime;
        document.getElementById('editEndTime').value = endTime;
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