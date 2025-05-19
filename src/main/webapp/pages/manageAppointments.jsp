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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .search-container { margin-bottom: 20px; display: flex; gap: 10px; }
        .filter-select { width: auto; }
        .table-container { margin-top: 20px; }
        .priority-emergency { color: red; font-weight: bold; }
        .modal .form-group { margin-bottom: 15px; }
        .modal .form-group i { margin-right: 10px; }
        .modal .checkbox { display: flex; align-items: center; }
    </style>
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
        <input type="text" class="form-control search-input" id="searchInput" placeholder="Search appointments...">
        <select class="form-select filter-select" id="yearFilter" onchange="filterTable()">
            <option value="">All Years</option>
            <option value="2024">2024</option>
            <option value="2025">2025</option>
        </select>
        <select class="form-select filter-select" id="monthFilter" onchange="filterTable()">
            <option value="">All Months</option>
            <c:forEach var="month" begin="1" end="12">
                <option value="${String.format('%02d', month)}">${new java.text.SimpleDateFormat("MMMM").format(new java.util.Date(0, month - 1, 1))}</option>
            </c:forEach>
        </select>
        <select class="form-select filter-select" id="dayFilter" onchange="filterTable()">
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
            <table id="appointmentsTable" class="table table-striped">
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
                            <button class="btn btn-edit btn-sm"
                                    data-bs-toggle="modal"
                                    data-bs-target="#editModal"
                                    data-id="${appt.id}"
                                    data-patient="${appt.patientId}"
                                    data-doctor="${appt.doctorId}"
                                    data-token="${appt.tokenID}"
                                    data-datetime="${appt.dateTime}"
                                    data-priority="${appt.priority}">
                                <i class="ri-edit-line"></i> Edit
                            </button>
                            <form action="<%=request.getContextPath()%>/AdminServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this appointment?')">
                                <input type="hidden" name="action" value="cancelAppointment">
                                <input type="hidden" name="appointmentId" value="${appt.id}">
                                <button type="submit" class="btn btn-cancel btn-sm"><i class="ri-close-line"></i> Cancel</button>
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
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel"><i class="ri-edit-line"></i> Edit Appointment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editForm" action="<%=request.getContextPath()%>/AdminServlet" method="post" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="updateAppointment">
                    <input type="hidden" id="appointmentId" name="appointmentId">
                    <div class="form-group">
                        <i class="ri-user-line"></i>
                        <label>Patient</label>
                        <select class="form-control" id="patientId" name="patientId" required>
                            <option value="" disabled>Select a patient</option>
                            <c:forEach var="patient" items="${patients}">
                                <option value="${patient.id}">${patient.name} (${patient.id})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <i class="ri-stethoscope-line"></i>
                        <label>Doctor</label>
                        <select class="form-control" id="doctorId" name="doctorId" required onchange="updateTimeSlots()">
                            <option value="" disabled>Select a doctor</option>
                            <c:forEach var="doctor" items="${doctors}">
                                <option value="${doctor.id}">${doctor.name} (${doctor.id})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <i class="ri-key-2-line"></i>
                        <label>Token ID</label>
                        <input type="text" class="form-control" id="tokenID" name="tokenID" required>
                    </div>
                    <div class="form-group">
                        <i class="ri-calendar-line"></i>
                        <label>Date</label>
                        <input type="date" class="form-control" id="date" name="date" required onchange="updateTimeSlots()" min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>
                    <div class="form-group">
                        <i class="ri-time-line"></i>
                        <label>Time Slot</label>
                        <select class="form-control" id="timeSlot" name="time" required>
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
</div>

<script>
    $(document).ready(function() {
        // Modal handling for Edit
        $('.btn-edit').on('click', function() {
            let id = $(this).data('id');
            let patient = $(this).data('patient');
            let doctor = $(this).data('doctor');
            let token = $(this).data('token');
            let dateTime = $(this).data('datetime').split(' ');
            let priority = $(this).data('priority');

            $('#appointmentId').val(id);
            $('#patientId').val(patient);
            $('#doctorId').val(doctor);
            $('#tokenID').val(token);
            $('#date').val(dateTime[0]);
            $('#isEmergency').prop('checked', priority == 1);

            updateTimeSlots().then(() => {
                $('#timeSlot').val(dateTime[1]);
            });
        });

        // Search and filter
        function filterTable() {
            const input = $('#searchInput').val().toLowerCase();
            const year = $('#yearFilter').val();
            const month = $('#monthFilter').val();
            const day = $('#dayFilter').val();
            $('#appointmentsBody tr').each(function() {
                const td = $(this).find('td');
                const id = td.eq(0).text().toLowerCase();
                const patientName = td.eq(1).text().toLowerCase();
                const doctorName = td.eq(2).text().toLowerCase();
                const tokenID = td.eq(3).text().toLowerCase();
                const dateTime = td.eq(4).text();
                const [datePart] = dateTime.split(' ');
                const [yearPart, monthPart, dayPart] = datePart.split('-');

                let matchesSearch = id.includes(input) || patientName.includes(input) || doctorName.includes(input) || tokenID.includes(input) || dateTime.includes(input);
                let matchesYear = !year || yearPart === year;
                let matchesMonth = !month || monthPart === month;
                let matchesDay = !day || dayPart === day;

                $(this).toggle(matchesSearch && matchesYear && matchesMonth && matchesDay);
            });
        }

        $('#searchInput').on('keyup', filterTable);

        // Sort by Date
        function sortTable() {
            const rows = $('#appointmentsBody tr').get();
            rows.sort((a, b) => {
                const dateTimeA = new Date($(a).find('td:eq(4)').text());
                const dateTimeB = new Date($(b).find('td:eq(4)').text());
                return dateTimeB - dateTimeA; // Newest first
            });
            $.each(rows, (index, row) => $('#appointmentsBody').append(row));
        }
    });

    function updateTimeSlots() {
        return new Promise((resolve) => {
            const doctorId = $('#doctorId').val();
            const date = $('#date').val();
            const timeSlotSelect = $('#timeSlot');
            timeSlotSelect.empty().append('<option value="" disabled>Select a time slot</option>');

            if (doctorId && date) {
                const mockSlots = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '14:00', '14:30', '15:00'];
                mockSlots.forEach(slot => {
                    timeSlotSelect.append($('<option>', { value: slot, text: slot }));
                });
                resolve();
            } else {
                resolve();
            }
        });
    }

    function validateForm() {
        const patientId = $('#patientId').val();
        const doctorId = $('#doctorId').val();
        const tokenID = $('#tokenID').val();
        const date = $('#date').val();
        const timeSlot = $('#timeSlot').val();

        if (!patientId || !doctorId || !tokenID || !date || !timeSlot) {
            alert('Please fill in all required fields, including Token ID.');
            return false;
        }


        const dateTime = date + ' ' + timeSlot;
        $('#editForm').append($('<input>').attr({ type: 'hidden', name: 'dateTime', value: dateTime }));
        return true;
    }
</script>
</body>
</html>