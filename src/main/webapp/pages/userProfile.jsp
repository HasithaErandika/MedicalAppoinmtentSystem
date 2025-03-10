<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Patient Profile</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c5282; --secondary: #48bb78; --accent: #ed8936;
            --bg-light: #f7fafc; --text-light: #2d3748; --text-dark: #e2e8f0;
            --card-bg: #ffffff; --shadow: 0 6px 20px rgba(0,0,0,0.08);
            --danger: #e53e3e;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: var(--bg-light); color: var(--text-light); padding: 2rem; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { background: var(--primary); color: var(--text-dark); padding: 1.5rem; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; box-shadow: var(--shadow); }
        h1 { font-size: 1.8rem; }
        .logout-btn { background: var(--accent); color: var(--text-dark); padding: 0.6rem 1.2rem; border: none; border-radius: 20px; cursor: pointer; }
        .logout-btn:hover { background: #dd6b20; }
        .form-section { background: var(--card-bg); padding: 2rem; border-radius: 12px; box-shadow: var(--shadow); margin-bottom: 2rem; }
        h2 { font-size: 1.4rem; color: var(--primary); margin-bottom: 1rem; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 0.5rem; }
        .form-group select, .form-group input { width: 100%; padding: 0.75rem; border: 2px solid #e2e8f0; border-radius: 8px; }
        .form-group.checkbox { display: flex; align-items: center; gap: 0.5rem; }
        button { background: var(--secondary); color: var(--text-dark); padding: 0.75rem 1.5rem; border: none; border-radius: 8px; cursor: pointer; }
        button:hover { background: #38a169; }
        .table-section { background: var(--card-bg); padding: 2rem; border-radius: 12px; box-shadow: var(--shadow); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: var(--primary); color: var(--text-dark); }
        tr:hover { background: #edf2f7; }
        .priority-emergency { color: var(--danger); font-weight: 600; }
        @media (max-width: 768px) { .container { padding: 1rem; } }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"patient".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=patient");
        return;
    }
%>
<div class="container">
    <div class="header">
        <h1>Welcome, <%= username %>!</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </form>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div style="color: ${request.getAttribute('messageType') == 'error' ? 'var(--danger)' : 'var(--secondary)'}; padding: 1rem; background: ${request.getAttribute('messageType') == 'error' ? '#fee2e2' : '#d1fae5'}; border-radius: 8px; margin-bottom: 1rem;">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="form-section">
        <h2>Book an Appointment</h2>
        <form action="<%=request.getContextPath()%>/UserServlet" method="post">
            <input type="hidden" name="action" value="book">
            <div class="form-group">
                <label for="doctorId">Doctor</label>
                <select id="doctorId" name="doctorId" required onchange="updateTimeSlots()">
                    <option value="">Select Doctor</option>
                    <c:forEach var="doctor" items="${filteredDoctors}">
                        <option value="${doctor.split(',')[0]}">${doctor.split(',')[0]} - ${doctor.split(',')[2]} (${doctor.split(',')[4]})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="date">Date</label>
                <input type="date" id="date" name="date" value="${param.date}" required onchange="updateTimeSlots()">
            </div>
            <div class="form-group">
                <label for="timeSlot">Available Time Slot</label>
                <select id="timeSlot" name="timeSlot" required>
                    <option value="">Select Time Slot</option>
                </select>
            </div>
            <div class="form-group checkbox">
                <input type="checkbox" id="isEmergency" name="isEmergency">
                <label for="isEmergency">Emergency</label>
            </div>
            <button type="submit">Book Appointment</button>
        </form>
    </div>

    <div class="table-section">
        <h2>Your Appointments</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Doctor ID</th>
                <th>Date & Time</th>
                <th>Priority</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="appt" items="${appointments}">
                <tr>
                    <td>${appt.id}</td>
                    <td>${appt.doctorId}</td>
                    <td>${appt.dateTime}</td>
                    <td class="${appt.priority == 1 ? 'priority-emergency' : ''}">
                            ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
    function updateTimeSlots() {
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlotSelect = document.getElementById('timeSlot');
        timeSlotSelect.innerHTML = '<option value="">Select Time Slot</option>';

        if (doctorId && date) {
            fetch('<%=request.getContextPath()%>/UserServlet?action=getTimeSlots&doctorId=' + doctorId + '&date=' + date)
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