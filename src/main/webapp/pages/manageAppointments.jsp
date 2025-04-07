<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Manage Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/manageOperations.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="ri-calendar-todo-line"></i> Manage Appointments</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="ri-arrow-left-line"></i> Back to Dashboard
        </a>
    </div>

    <c:if test="${not empty message}">
        <div class="message ${messageType == 'error' ? 'error-message' : 'success-message'}">
                ${message}
        </div>
    </c:if>

    <div class="search-container">
        <input type="text" class="search-input" id="searchInput" placeholder="Search appointments..." onkeyup="searchTable()">
        <select class="filter-select" id="yearFilter" onchange="filterTable()">
            <option value="">All Years</option>
            <option value="2024">2024</option>
            <option value="2025">2025</option>
        </select>
        <select class="filter-select" id="monthFilter" onchange="filterTable()">
            <option value="">All Months</option>
            <option value="01">January</option>
            <option value="02">February</option>
            <option value="03">March</option>
            <option value="04">April</option>
            <option value="05">May</option>
            <option value="06">June</option>
            <option value="07">July</option>
            <option value="08">August</option>
            <option value="09">September</option>
            <option value="10">October</option>
            <option value="11">November</option>
            <option value="12">December</option>
        </select>
        <select class="filter-select" id="dayFilter" onchange="filterTable()">
            <option value="">All Days</option>
            <% for (int i = 1; i <= 31; i++) { %>
            <option value="<%= String.format("%02d", i) %>"><%= String.format("%02d", i) %></option>
            <% } %>
        </select>
        <button class="btn btn-primary" onclick="sortTable()">
            <i class="ri-sort-desc"></i> Sort by Date
        </button>
    </div>

    <div class="card">
        <h2 style="margin-bottom: 1.5rem;"><i class="ri-list-check"></i> Current Appointments</h2>
        <div class="table-container">
            <table id="appointmentsTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Patient Name</th>
                    <th>Doctor Name</th>
                    <th>Token ID</th>
                    <th>Date & Time</th>
                    <th>Priority</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody id="appointmentsBody">
                <c:forEach var="appt" items="${appointments}">
                    <tr>
                        <td>${appt.id}</td>
                        <td>${appt.patientName != null ? appt.patientName : appt.patientId}</td>
                        <td>${appt.doctorName != null ? appt.doctorName : appt.doctorId}</td>
                        <td>${appt.tokenID}</td>
                        <td>${appt.dateTime}</td>
                        <td class="${appt.priority == 1 ? 'priority-emergency' : ''}">
                                ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                        </td>
                        <td>
                            <button class="btn btn-edit" onclick="openEditModal(${appt.id}, '${appt.patientId}', '${appt.doctorId}', '${appt.tokenID}', '${appt.dateTime.substring(0,10)}', '${appt.dateTime.substring(11)}', ${appt.priority == 1})">
                                <i class="ri-edit-line"></i> Edit
                            </button>
                            <form action="<%=request.getContextPath()%>/AdminServlet" method="post" style="display:inline;" onsubmit="return confirmCancel()">
                                <input type="hidden" name="action" value="cancelAppointment">
                                <input type="hidden" name="appointmentId" value="${appt.id}">
                                <button type="submit" class="btn btn-cancel"><i class="ri-close-line"></i> Cancel</button>
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
        <div class="modal-header">
            <h2><i class="ri-edit-line"></i> Edit Appointment</h2>
            <button class="modal-close" onclick="closeEditModal()">×</button>
        </div>
        <div class="modal-body">
            <form id="editForm" action="<%=request.getContextPath()%>/AdminServlet" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="updateAppointment">
                <input type="hidden" id="appointmentId" name="appointmentId">
                <div class="form-group">
                    <i class="ri-user-line"></i>
                    <label>Patient</label>
                    <select id="patientId" name="patientId" required>
                        <option value="" disabled>Select a patient</option>
                        <c:forEach var="patient" items="${patients}">
                            <option value="${patient.id}">${patient.name} (${patient.id})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-stethoscope-line"></i>
                    <label>Doctor</label>
                    <select id="doctorId" name="doctorId" required onchange="updateTimeSlots()">
                        <option value="" disabled>Select a doctor</option>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.id}">${doctor.name} (${doctor.id})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-key-2-line"></i>
                    <label>Token ID</label>
                    <input type="text" id="tokenID" name="tokenID" required>
                </div>
                <div class="form-group">
                    <i class="ri-calendar-line"></i>
                    <label>Date</label>
                    <input type="date" id="date" name="date" required onchange="updateTimeSlots()" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                <div class="form-group">
                    <i class="ri-time-line"></i>
                    <label>Time Slot</label>
                    <select id="timeSlot" name="time" required>
                        <option value="" disabled>Select a time slot</option>
                    </select>
                </div>
                <div class="form-group checkbox">
                    <input type="checkbox" id="isEmergency" name="priority" value="1">
                    <label for="isEmergency">Emergency</label>
                </div>
                <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Update Appointment</button>
            </form>
        </div>
    </div>
</div>

<script>
    function openEditModal(id, patientId, doctorId, tokenID, date, timeSlot, isEmergency) {
        document.getElementById('appointmentId').value = id;
        document.getElementById('patientId').value = patientId;
        document.getElementById('doctorId').value = doctorId;
        document.getElementById('tokenID').value = tokenID;
        document.getElementById('date').value = date;
        document.getElementById('isEmergency').checked = isEmergency;

        const timeSlotSelect = document.getElementById('timeSlot');
        timeSlotSelect.innerHTML = '<option value="" disabled>Select a time slot</option>';
        updateTimeSlots().then(() => {
            timeSlotSelect.value = timeSlot;
        });

        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    function updateTimeSlots() {
        return new Promise((resolve) => {
            const doctorId = document.getElementById('doctorId').value;
            const date = document.getElementById('date').value;
            const timeSlotSelect = document.getElementById('timeSlot');
            timeSlotSelect.innerHTML = '<option value="" disabled>Select a time slot</option>';

            if (doctorId && date) {
                // Mock time slots (replace with actual fetch if DoctorAvailabilityService provides an endpoint)
                const mockSlots = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '14:00', '14:30', '15:00'];
                mockSlots.forEach(slot => {
                    const option = document.createElement('option');
                    option.value = slot;
                    option.text = slot;
                    timeSlotSelect.appendChild(option);
                });
                resolve();
            } else {
                resolve();
            }
        });
    }

    function validateForm() {
        const patientId = document.getElementById('patientId').value;
        const doctorId = document.getElementById('doctorId').value;
        const tokenID = document.getElementById('tokenID').value;
        const date = document.getElementById('date').value;
        const timeSlot = document.getElementById('timeSlot').value;

        if (!patientId || !doctorId || !tokenID || !date || !timeSlot) {
            alert('Please fill in all required fields, including Token ID.');
            return false;
        }

        // Combine date and time for submission
        const dateTime = date + ' ' + timeSlot;
        const form = document.getElementById('editForm');
        const hiddenDateTime = document.createElement('input');
        hiddenDateTime.type = 'hidden';
        hiddenDateTime.name = 'dateTime';
        hiddenDateTime.value = dateTime;
        form.appendChild(hiddenDateTime);

        return true;
    }

    function confirmCancel() {
        return confirm('Are you sure you want to cancel this appointment?');
    }

    function searchTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const year = document.getElementById('yearFilter').value;
        const month = document.getElementById('monthFilter').value;
        const day = document.getElementById('dayFilter').value;
        const table = document.getElementById('appointmentsTable');
        const tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            const td = tr[i].getElementsByTagName('td');
            const id = td[0].textContent.toLowerCase();
            const patientName = td[1].textContent.toLowerCase();
            const doctorName = td[2].textContent.toLowerCase();
            const tokenID = td[3].textContent.toLowerCase();
            const dateTime = td[4].textContent;
            const [datePart] = dateTime.split(' ');
            const [yearPart, monthPart, dayPart] = datePart.split('-');

            let matchesSearch = id.includes(input) || patientName.includes(input) || doctorName.includes(input) || tokenID.includes(input) || dateTime.includes(input);
            let matchesYear = !year || yearPart === year;
            let matchesMonth = !month || monthPart === month;
            let matchesDay = !day || dayPart === day;

            tr[i].style.display = (matchesSearch && matchesYear && matchesMonth && matchesDay) ? '' : 'none';
        }
    }

    function filterTable() {
        searchTable();
    }

    function sortTable() {
        const table = document.getElementById('appointmentsTable');
        const tbody = document.getElementById('appointmentsBody');
        const rows = Array.from(tbody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            const dateTimeA = new Date(a.cells[4].textContent);
            const dateTimeB = new Date(b.cells[4].textContent);
            return dateTimeB - dateTimeA; // Newest first
        });

        while (tbody.firstChild) {
            tbody.removeChild(tbody.firstChild);
        }
        rows.forEach(row => tbody.appendChild(row));
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