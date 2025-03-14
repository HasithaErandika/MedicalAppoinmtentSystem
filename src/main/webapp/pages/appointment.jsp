<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Manage Appointments</title>
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
            --success: #26A69A;
            --danger: #EF5350;
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
        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-weight: 500;
        }
        .message.success { background: #E6F4EA; color: var(--success); }
        .message.error { background: #FEE2E2; color: var(--danger); }

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
        .btn-edit {
            background: var(--secondary);
            color: #FFFFFF;
            margin-right: 0.5rem;
        }
        .btn-edit:hover {
            background: #00897B;
            transform: translateY(-2px);
        }
        .btn-cancel {
            background: var(--accent);
            color: #FFFFFF;
        }
        .btn-cancel:hover {
            background: #D32F2F;
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
        .priority-emergency { color: var(--accent); font-weight: 600; }

        /* Modal Styles */
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
        .close-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 1.5rem;
            color: var(--text-primary);
            cursor: pointer;
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
        .form-group.checkbox {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .form-group.checkbox input { width: auto; }

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
        <h1>Manage Appointments</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div class="message <%= request.getAttribute("messageType") %>">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="card">
        <h2 style="margin-bottom: 1.5rem;">Current Appointments</h2>
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Patient Name</th>
                    <th>Doctor Name</th>
                    <th>Date & Time</th>
                    <th>Priority</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="appt" items="${appointments}">
                    <tr>
                        <td>${appt.id}</td>
                        <td>
                            <c:forEach var="patient" items="${patients}">
                                <c:if test="${patient.split(',')[0] == appt.patientId}">
                                    <c:out value="${patient.split(',')[2]}"/>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <c:forEach var="doctor" items="${doctors}">
                                <c:if test="${doctor.split(',')[0] == appt.doctorId}">
                                    <c:out value="${doctor.split(',')[2]}"/>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>${appt.dateTime}</td>
                        <td class="${appt.priority == 1 ? 'priority-emergency' : ''}">
                                ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                        </td>
                        <td>
                            <button class="btn btn-edit" onclick="openEditModal(${appt.id}, '${appt.patientId}', '${appt.doctorId}', '${appt.dateTime.substring(0,10)}', '${appt.dateTime.substring(11)}', ${appt.priority == 1})">Edit</button>
                            <form action="<%=request.getContextPath()%>/AppointmentServlet" method="post" style="display:inline;" onsubmit="return confirmCancel()">
                                <input type="hidden" name="action" value="cancel">
                                <input type="hidden" name="appointmentId" value="${appt.id}">
                                <button type="submit" class="btn btn-cancel">Cancel</button>
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
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeEditModal()">×</span>
        <h2>Edit Appointment</h2>
        <form id="editForm" action="<%=request.getContextPath()%>/AppointmentServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="appointmentId" name="appointmentId">
            <div class="form-grid">
                <div class="form-group">
                    <label for="patientId">Patient</label>
                    <select id="patientId" name="patientId" required>
                        <option value="" disabled>Select a patient</option>
                        <c:forEach var="patient" items="${patients}">
                            <option value="${patient.split(',')[0]}">${patient.split(',')[2]} (${patient.split(',')[0]})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="doctorId">Doctor</label>
                    <select id="doctorId" name="doctorId" required onchange="updateTimeSlots()">
                        <option value="" disabled>Select a doctor</option>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.split(',')[0]}">${doctor.split(',')[2]} (${doctor.split(',')[0]})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date" required onchange="updateTimeSlots()" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                <div class="form-group">
                    <label for="timeSlot">Time Slot</label>
                    <select id="timeSlot" name="timeSlot" required>
                        <option value="" disabled>Select a time slot</option>
                    </select>
                </div>
                <div class="form-group checkbox">
                    <input type="checkbox" id="isEmergency" name="isEmergency">
                    <label for="isEmergency">Emergency</label>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Update Appointment</button>
        </form>
    </div>
</div>

<script>
    function openEditModal(id, patientId, doctorId, date, timeSlot, isEmergency) {
        document.getElementById('appointmentId').value = id;
        document.getElementById('patientId').value = patientId;
        document.getElementById('doctorId').value = doctorId;
        document.getElementById('date').value = date;
        document.getElementById('isEmergency').checked = isEmergency;

        const timeSlotSelect = document.getElementById('timeSlot');
        timeSlotSelect.innerHTML = '<option value="" disabled>Select a time slot</option>';
        updateTimeSlots().then(() => {
            timeSlotSelect.value = timeSlot; // Set the original time slot after fetching
        });

        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    function updateTimeSlots() {
        return new Promise((resolve, reject) => {
            const doctorId = document.getElementById('doctorId').value;
            const date = document.getElementById('date').value;
            const timeSlotSelect = document.getElementById('timeSlot');
            timeSlotSelect.innerHTML = '<option value="" disabled>Select a time slot</option>';

            if (doctorId && date) {
                fetch('<%=request.getContextPath()%>/AppointmentServlet?action=getTimeSlots&doctorId=' + doctorId + '&date=' + date)
                    .then(response => response.json())
                    .then(slots => {
                        slots.forEach(slot => {
                            const option = document.createElement('option');
                            option.value = slot;
                            option.text = slot;
                            timeSlotSelect.appendChild(option);
                        });
                        resolve();
                    })
                    .catch(error => {
                        console.error('Error fetching time slots:', error);
                        reject(error);
                    });
            } else {
                resolve();
            }
        });
    }

    function validateForm() {
        const patientId = document.getElementById('patientId').value;
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlot = document.getElementById('timeSlot').value;

        if (!patientId || !doctorId || !date || !timeSlot) {
            alert('Please fill in all required fields.');
            return false;
        }
        return true;
    }

    function confirmCancel() {
        return confirm('Are you sure you want to cancel this appointment?');
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