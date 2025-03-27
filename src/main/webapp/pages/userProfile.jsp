<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Patient Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/userProfile.css">
</head>

<body>

<%
    // Session checks and defaults
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"patient".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=patient");
        return;
    }

    // User profile data
    String fullName = (String) session.getAttribute("fullName") != null ? (String) session.getAttribute("fullName") : "John Doe";
    String email = (String) session.getAttribute("email") != null ? (String) session.getAttribute("email") : "john.doe@example.com";
    String phone = (String) session.getAttribute("phone") != null ? (String) session.getAttribute("phone") : "123-456-7890";
%>

<!-- Sidebar Section -->
<div class="sidebar" id="sidebar">
    <button class="absolute top-5 right-5 text-primary text-xl hover:text-primary-hover transition-all duration-300" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <div class="logo"><i class="fas fa-heartbeat"></i><span>MediSchedule</span></div>
    <nav>
        <ul>
            <li class="mb-4"><a href="<%= request.getContextPath() %>/user" class="active"><i class="fas fa-calendar-check"></i><span>Book Appointment</span></a></li>
            <li class="mb-4"><a href="#" onclick="toggleAppointments()"><i class="fas fa-list"></i><span>My Appointments</span></a></li>
            <li class="mb-4"><a href="#" onclick="toggleUserDetails()"><i class="fas fa-user"></i><span>User Details</span></a></li>
            <li><form action="<%= request.getContextPath() %>/LogoutServlet" method="post"><a href="#" onclick="this.parentNode.submit();"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></form></li>
        </ul>
    </nav>
</div>

<!-- Main Content Section -->
<div class="main-content" id="main-content">
    <div class="max-w-7xl mx-auto">

        <!-- Header Section -->
        <div class="flex items-center justify-between mb-10">
            <div class="flex items-center gap-5">
                <div class="avatar"><%= username.charAt(0) %></div>
                <h1 class="text-3xl font-extrabold tracking-tight">Welcome, <%= username %>!</h1>
            </div>
            <div class="text-secondary text-sm font-medium"><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></div>
        </div>

        <!-- Message Display (if any) -->
        <c:if test="${not empty message}">
            <div class="message ${messageType}">
                <i class="fas ${messageType == 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
                    ${message}
            </div>
        </c:if>

        <!-- Book Appointment Section -->
        <div class="dashboard-card" id="bookAppointmentSection">
            <h2 class="text-2xl font-bold text-primary mb-8">Schedule Your Appointment</h2>
            <form action="<%= request.getContextPath() %>/user" method="post" id="bookForm" class="space-y-8">
                <input type="hidden" name="action" value="book">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="form-group">
                        <label>Specialty</label>
                        <select id="specialty" name="specialty" onchange="updateDoctors()"></select>
                    </div>
                    <div class="form-group">
                        <label>Doctor</label>
                        <select id="doctorId" name="doctorId" onchange="updateAvailability()"></select>
                    </div>
                    <div class="form-group">
                        <label>Date</label>
                        <input type="text" id="date" name="date" placeholder="Select a date" required>
                    </div>
                    <div class="form-group">
                        <label>Time Slot</label>
                        <div id="timeSlots" class="grid grid-cols-2 gap-3"></div>
                        <input type="hidden" id="timeSlot" name="timeSlot" required>
                    </div>
                </div>
                <div class="flex items-center gap-5">
                    <input type="checkbox" id="isEmergency" name="isEmergency" class="h-6 w-6 text-primary rounded focus:ring-primary">
                    <label for="isEmergency" class="text-secondary font-medium">Emergency Booking</label>
                </div>
                <button type="submit" class="btn-primary"><i class="fas fa-calendar-plus mr-3"></i>Book Appointment</button>
            </form>
        </div>

        <!-- Upcoming Appointments Section -->
        <div class="dashboard-card mt-10 hidden" id="appointmentsSection">
            <h2 class="text-2xl font-bold text-primary mb-8">Your Upcoming Appointments</h2>
            <div class="overflow-x-auto">
                <table>
                    <thead>
                    <tr>
                        <th onclick="sortTable(0)">ID <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(1)">Doctor <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(2)">Date & Time <i class="fas fa-sort"></i></th>
                        <th onclick="sortTable(3)">Priority <i class="fas fa-sort"></i></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="appt" items="${appointments}">
                        <tr>
                            <td>${appt.id}</td>
                            <td>${appt.doctorId}</td>
                            <td>${appt.dateTime}</td>
                            <td class="${appt.priority == 1 ? 'text-error font-semibold' : 'text-secondary'}">${appt.priority == 1 ? 'Emergency' : 'Normal'}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- User Details Section -->
        <div class="dashboard-card mt-10 hidden" id="userDetailsSection">
            <h2 class="text-2xl font-bold text-primary mb-8">Your Details</h2>
            <form action="<%= request.getContextPath() %>/user" method="post" id="detailsForm" class="space-y-8 relative">
                <div class="progress" id="detailsProgress"></div>
                <input type="hidden" name="action" value="updateDetails">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" value="<%= username %>" disabled class="bg-gray-100 cursor-not-allowed text-secondary">
                    </div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="<%= fullName %>" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="email" name="email" value="<%= email %>" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="tel" id="phone" name="phone" value="<%= phone %>" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" placeholder="123-456-7890" required>
                    </div>
                </div>
                <div class="flex justify-end gap-5">
                    <button type="button" class="btn-secondary" onclick="toggleUserDetails()">Cancel</button>
                    <button type="submit" class="btn-primary" id="saveDetailsBtn"><i class="fas fa-save mr-3"></i>Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Confirmation Modal for Booking -->
    <div class="modal" id="confirmModal">
        <div class="modal-content">
            <button class="close-modal" onclick="closeModal()">×</button>
            <h2 class="text-2xl font-bold text-primary mb-6">Confirm Booking</h2>
            <p id="confirmMessage" class="mb-8 text-secondary font-medium leading-relaxed"></p>
            <div class="flex justify-end gap-5">
                <button class="btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn-primary" onclick="submitBooking()">Confirm</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.js"></script>
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    }

    function showSection(sectionId, tabName) {
        const sections = ['bookAppointmentSection', 'appointmentsSection', 'userDetailsSection'];
        sections.forEach(id => document.getElementById(id).classList.add('hidden'));
        document.getElementById(sectionId).classList.remove('hidden');
        updateSidebarActive(tabName);
    }

    function toggleAppointments() {
        showSection('appointmentsSection', 'My Appointments');
    }

    function toggleUserDetails() {
        showSection('userDetailsSection', 'User Details');
    }

    function updateSidebarActive(tabName) {
        document.querySelectorAll('.sidebar nav a').forEach(link => {
            link.classList.remove('active');
            if (link.querySelector('span')?.textContent === tabName) {
                link.classList.add('active');
            }
        });
    }

    function updateDoctors() {
        const specialty = document.getElementById('specialty').value;
        const doctorSelect = document.getElementById('doctorId');
        doctorSelect.innerHTML = '<option value="">Select Doctor</option>';

        if (specialty) {
            fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${encodeURIComponent(specialty)}`)
                .then(response => response.json())
                .then(data => {
                    if (data.doctors && data.doctors.length > 0) {
                        data.doctors.forEach(name => {
                            const option = document.createElement('option');
                            option.value = name;
                            option.text = name;
                            doctorSelect.appendChild(option);
                        });
                        updateAvailability();
                    } else {
                        doctorSelect.innerHTML = '<option value="">No doctors available</option>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching doctors:', error);
                    doctorSelect.innerHTML = '<option value="">Error loading doctors</option>';
                });
        }
    }

    function updateAvailability() {
        const doctorName = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlotsDiv = document.getElementById('timeSlots');
        timeSlotsDiv.innerHTML = '';

        if (doctorName && date) {
            fetch(`<%=request.getContextPath()%>/user?action=getTimeSlots&doctorId=${encodeURIComponent(doctorName)}&date=${encodeURIComponent(date)}`)
                .then(response => response.json())
                .then(slots => {
                    if (slots && slots.length > 0) {
                        slots.forEach(slot => {
                            const div = document.createElement('div');
                            div.className = 'time-slot';
                            div.textContent = slot;
                            div.onclick = () => {
                                document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                                div.classList.add('selected');
                                document.getElementById('timeSlot').value = slot;
                            };
                            timeSlotsDiv.appendChild(div);
                        });
                    } else {
                        timeSlotsDiv.innerHTML = '<p class="text-secondary font-medium">No available slots</p>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching time slots:', error);
                    timeSlotsDiv.innerHTML = '<p class="text-error font-medium">Error loading slots</p>';
                });
        }
    }

    function sortTable(n) {
        const table = document.querySelector('#appointmentsSection table');
        let rows, switching = true, i, shouldSwitch, dir = "asc", switchcount = 0;
        while (switching) {
            switching = false;
            rows = table.rows;
            for (i = 1; i < (rows.length - 1); i++) {
                shouldSwitch = false;
                const x = rows[i].getElementsByTagName("td")[n];
                const y = rows[i + 1].getElementsByTagName("td")[n];
                let cmpX = x.innerHTML.toLowerCase();
                let cmpY = y.innerHTML.toLowerCase();
                if (n === 0) { // ID
                    cmpX = parseInt(cmpX);
                    cmpY = parseInt(cmpY);
                } else if (n === 3) { // Priority
                    cmpX = cmpX === 'emergency' ? 1 : 2;
                    cmpY = cmpY === 'emergency' ? 1 : 2;
                }
                if (dir === "asc" ? cmpX > cmpY : cmpX < cmpY) {
                    shouldSwitch = true;
                    break;
                }
            }
            if (shouldSwitch) {
                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                switching = true;
                switchcount++;
            } else if (switchcount === 0 && dir === "asc") {
                dir = "desc";
                switching = true;
            }
        }
    }

    function openConfirmModal() {
        const specialty = document.getElementById('specialty').value;
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlot = document.getElementById('timeSlot').value;
        const isEmergency = document.getElementById('isEmergency').checked;

        if (!specialty || !doctorId || !date || !timeSlot) {
            alert('Please fill all fields before booking.');
            return false;
        }

        document.getElementById('confirmMessage').innerHTML = `
            <strong class="text-primary">Specialty:</strong> ${specialty}<br>
            <strong class="text-primary">Doctor:</strong> ${doctorId}<br>
            <strong class="text-primary">Date:</strong> ${date}<br>
            <strong class="text-primary">Time:</strong> ${timeSlot}<br>
            <strong class="text-primary">Emergency:</strong> ${isEmergency ? 'Yes' : 'No'}
        `;
        document.getElementById('confirmModal').style.display = 'flex';
        return false;
    }

    function closeModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    function submitBooking() {
        document.getElementById('bookForm').onsubmit = null;
        document.getElementById('bookForm').submit();
    }

    function showProgressBar(formId, progressId) {
        const progress = document.getElementById(progressId);
        progress.style.width = '100%';
        setTimeout(() => progress.style.width = '0', 1000);
    }

    window.onload = () => {
        fetch('<%=request.getContextPath()%>/SortServlet')
            .then(response => response.json())
            .then(data => {
                const specialtySelect = document.getElementById('specialty');
                specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
                if (data.specialties && data.specialties.length > 0) {
                    data.specialties.forEach(specialty => {
                        const option = document.createElement('option');
                        option.value = specialty;
                        option.text = specialty;
                        specialtySelect.appendChild(option);
                    });
                } else {
                    specialtySelect.innerHTML = '<option value="">No specialties available</option>';
                }
            })
            .catch(error => {
                console.error('Error loading specialties:', error);
                document.getElementById('specialty').innerHTML = '<option value="">Error loading specialties</option>';
            });

        flatpickr('#date', {
            dateFormat: 'Y-m-d',
            minDate: 'today',
            onChange: (selectedDates, dateStr) => updateAvailability()
        });

        document.getElementById('bookForm').onsubmit = openConfirmModal;
        document.getElementById('detailsForm').onsubmit = (e) => {
            e.preventDefault();
            showProgressBar('detailsForm', 'detailsProgress');
            setTimeout(() => document.getElementById('detailsForm').submit(), 300);
        };

        // Initially show Book Appointment section
        showSection('bookAppointmentSection', 'Book Appointment');
    };
</script>
</body>
</html>