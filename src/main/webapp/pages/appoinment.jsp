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
            --primary: #ed8936; --secondary: #2c5282; --accent: #48bb78;
            --bg-light: #f4f7fa; --text-light: #2d3748; --text-dark: #ffffff;
            --card-bg: #ffffff; --shadow: 0 4px 15px rgba(0,0,0,0.1);
            --danger: #e53e3e;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg-light); padding: 2rem; }
        .container { max-width: 1200px; margin: 0 auto; background: var(--card-bg); padding: 2rem; border-radius: 12px; box-shadow: var(--shadow); }
        h1 { color: var(--primary); font-size: 1.8rem; margin-bottom: 1.5rem; }
        .form-section { margin-bottom: 2rem; background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: var(--shadow); }
        .form-group { margin-bottom: 1rem; display: flex; flex-direction: column; }
        .form-group label { font-weight: 500; color: var(--text-light); margin-bottom: 0.5rem; }
        .form-group input, .form-group select { width: 100%; padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 8px; font-size: 0.9rem; }
        .form-group.checkbox { display: flex; flex-direction: row; align-items: center; gap: 0.5rem; }
        button { padding: 0.75rem 1.5rem; background: var(--primary); color: var(--text-dark); border: none; border-radius: 8px; cursor: pointer; transition: all 0.3s ease; }
        button:hover { background: #dd6b20; transform: scale(1.05); }
        .table-section { background: var(--card-bg); padding: 1.5rem; border-radius: 12px; box-shadow: var(--shadow); }
        h2 { color: var(--text-light); font-size: 1.4rem; margin-bottom: 1rem; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background: var(--primary); color: var(--text-dark); font-weight: 600; }
        tr:hover { background: #edf2f7; }
        .action-btn { padding: 0.5rem 1rem; border: none; border-radius: 5px; cursor: pointer; color: white; }
        .edit-btn { background: var(--accent); }
        .edit-btn:hover { background: #38a169; }
        .cancel-btn { background: var(--danger); }
        .cancel-btn:hover { background: #c53030; }
        .back-btn { display: inline-block; margin-top: 1rem; color: var(--primary); text-decoration: none; }
        .back-btn:hover { text-decoration: underline; }
        .priority-emergency { color: var(--danger); font-weight: 600; }
        @media (max-width: 768px) { .container { padding: 1rem; } .form-group { margin-bottom: 0.75rem; } .form-group input, .form-group select { font-size: 0.85rem; } }
    </style>
</head>
<body>
<div class="container">
    <h1>Manage Appointments</h1>

    <% if (request.getAttribute("message") != null) { %>
    <div style="color: ${request.getAttribute('messageType') == 'error' ? 'var(--danger)' : 'var(--accent)'}; padding: 1rem; background: ${request.getAttribute('messageType') == 'error' ? '#fee2e2' : '#d1fae5'}; border-radius: 8px; margin-bottom: 1rem;">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="form-section">
        <form action="<%=request.getContextPath()%>/AppointmentServlet" method="post">
            <input type="hidden" name="action" value="${editAppointment != null ? 'update' : 'add'}">
            <input type="hidden" name="appointmentId" value="${editAppointment != null ? editAppointment.id : ''}">
            <div class="form-group">
                <label for="patientId">Patient ID</label>
                <select id="patientId" name="patientId" required>
                    <option value="">Select Patient</option>
                    <c:forEach var="patient" items="${patients}">
                        <option value="${patient.split(',')[0]}" ${editAppointment != null && editAppointment.patientId == patient.split(',')[0] ? 'selected' : ''}>${patient.split(',')[0]} - ${patient.split(',')[2]}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="doctorId">Doctor ID</label>
                <select id="doctorId" name="doctorId" required onchange="updateAdminTimeSlots()">
                    <option value="">Select Doctor</option>
                    <c:forEach var="doctor" items="${doctors}">
                        <option value="${doctor.split(',')[0]}" ${editAppointment != null && editAppointment.doctorId == doctor.split(',')[0] ? 'selected' : ''}>${doctor.split(',')[0]} - ${doctor.split(',')[2]}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="date">Date</label>
                <input type="date" id="date" name="date" value="${editAppointment != null ? editAppointment.dateTime.substring(0,10) : ''}" required onchange="updateAdminTimeSlots()">
            </div>
            <div class="form-group">
                <label for="timeSlot">Time Slot</label>
                <select id="timeSlot" name="timeSlot" required>
                    <option value="">Select Time Slot</option>
                    <c:if test="${editAppointment != null}">
                        <option value="${editAppointment.dateTime.substring(11)}" selected>${editAppointment.dateTime.substring(11)}</option>
                    </c:if>
                </select>
            </div>
            <div class="form-group checkbox">
                <input type="checkbox" id="isEmergency" name="isEmergency" ${editAppointment != null && editAppointment.priority == 1 ? 'checked' : ''}>
                <label for="isEmergency">Emergency</label>
            </div>
            <button type="submit">${editAppointment != null ? 'Update Appointment' : 'Add Appointment'}</button>
        </form>
    </div>

    <div class="table-section">
        <h2>Current Appointments</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Patient ID</th>
                <th>Doctor ID</th>
                <th>Date & Time</th>
                <th>Priority</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="appt" items="${appointments}">
                <tr>
                    <td>${appt.id}</td>
                    <td>${appt.patientId}</td>
                    <td>${appt.doctorId}</td>
                    <td>${appt.dateTime}</td>
                    <td class="${appt.priority == 1 ? 'priority-emergency' : ''}">
                            ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                    </td>
                    <td>
                        <form action="<%=request.getContextPath()%>/AppointmentServlet" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="appointmentId" value="${appt.id}">
                            <button type="submit" class="action-btn edit-btn">Edit</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/AppointmentServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="appointmentId" value="${appt.id}">
                            <button type="submit" class="action-btn cancel-btn">Cancel</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">Back to Dashboard</a>
</div>

<script>
    function updateAdminTimeSlots() {
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlotSelect = document.getElementById('timeSlot');
        timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';

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
                })
                .catch(error => console.error('Error fetching time slots:', error));
        }
    }
</script>
</body>
</html>