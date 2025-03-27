<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Patient Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5; /* Indigo */
            --secondary: #10B981; /* Emerald */
            --accent: #F43F5E; /* Rose */
            --bg-light: #F3F4F6; /* Gray-100 */
            --card-bg: #FFFFFF;
            --text-dark: #111827; /* Gray-900 */
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --hover: #E0E7FF; /* Light Indigo */
        }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
        }
        .sidebar {
            background: var(--card-bg);
            box-shadow: var(--shadow);
            transition: width 0.3s ease;
            width: 260px;
            position: fixed;
            height: 100vh;
            z-index: 1000;
        }
        .sidebar.collapsed { width: 80px; }
        .sidebar .logo { color: var(--primary); font-weight: 700; font-size: 1.5rem; }
        .sidebar nav a {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar nav a:hover, .sidebar nav a.active {
            background: var(--primary);
            color: white;
            transform: scale(1.03);
        }
        .sidebar.collapsed span { display: none; }
        .main-content { margin-left: 260px; transition: margin-left 0.3s ease; }
        .main-content.expanded { margin-left: 80px; }
        .dashboard-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: var(--shadow);
            padding: 2rem;
            transition: all 0.3s ease;
        }
        .dashboard-card:hover { box-shadow: 0 12px 20px rgba(0, 0, 0, 0.15); }
        .form-group select, .form-group input {
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 0.75rem;
            width: 100%;
            transition: all 0.3s ease;
        }
        .form-group select:focus, .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(79, 70, 229, 0.2);
            outline: none;
        }
        .time-slot {
            padding: 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            border: 1px solid #E5E7EB;
            text-align: center;
            transition: all 0.3s ease;
        }
        .time-slot:hover { background: var(--hover); }
        .time-slot.selected { background: var(--primary); color: white; border-color: var(--primary); }
        .btn-primary {
            background: var(--primary);
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-primary:hover { background: #4338CA; transform: translateY(-2px); }
        .avatar {
            background: var(--primary);
            color: white;
            border-radius: 50%;
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 1.25rem;
        }
        .message { padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; }
        .message.success { background: #D1FAE5; color: var(--secondary); }
        .message.error { background: #FEE2E2; color: var(--accent); }
        table { border-collapse: separate; border-spacing: 0; }
        th { background: var(--primary); color: white; font-weight: 600; position: sticky; top: 0; z-index: 10; }
        td { border-bottom: 1px solid #E5E7EB; }
        tr:hover { background: var(--hover); }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 2000;
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
        }
        .close-modal {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--text-dark);
        }

        @media (max-width: 768px) {
            .sidebar { width: 80px; }
            .sidebar span { display: none; }
            .main-content { margin-left: 80px; padding: 1rem; }
            .dashboard-card { padding: 1.5rem; }
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"user".equals(role)) { // Adjusted to match UserServlet's USER_ROLE
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=user");
        return;
    }
%>
<div class="sidebar p-6" id="sidebar">
    <button class="absolute top-4 right-4 text-primary text-xl" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <div class="logo mb-10 flex items-center"><i class="fas fa-heartbeat mr-3"></i><span>MediSchedule</span></div>
    <nav>
        <ul>
            <li class="mb-4"><a href="<%=request.getContextPath()%>/UserServlet" class="block p-3 rounded-lg active"><i class="fas fa-calendar-check mr-3"></i><span>Book Appointment</span></a></li>
            <li class="mb-4"><a href="#" onclick="toggleAppointments()" class="block p-3 rounded-lg"><i class="fas fa-list mr-3"></i><span>My Appointments</span></a></li>
            <li><form action="<%=request.getContextPath()%>/LogoutServlet" method="post"><a href="#" onclick="this.parentNode.submit();" class="block p-3 rounded-lg"><i class="fas fa-sign-out-alt mr-3"></i><span>Logout</span></a></form></li>
        </ul>
    </nav>
</div>

<div class="main-content p-8 flex-1" id="main-content">
    <div class="max-w-6xl mx-auto">
        <div class="flex items-center justify-between mb-8">
            <div class="flex items-center">
                <div class="avatar mr-4"><%= username.charAt(0) %></div>
                <h1 class="text-2xl font-bold">Hello, <%= username %>!</h1>
            </div>
            <div class="text-gray-600 text-sm"><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></div>
        </div>

        <c:if test="${not empty message}">
            <div class="message ${messageType} flex items-center">
                <i class="fas ${messageType == 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'} mr-2"></i>
                    ${message}
            </div>
        </c:if>

        <div class="dashboard-card">
            <h2 class="text-xl font-semibold text-primary mb-6">Schedule Your Appointment</h2>
            <form action="<%=request.getContextPath()%>/UserServlet" method="post" id="bookForm" class="space-y-6">
                <input type="hidden" name="action" value="book">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="form-group">
                        <label class="block font-medium mb-2 text-gray-700">Specialty</label>
                        <select id="specialty" name="specialty" class="w-full" onchange="updateDoctors()">
                            <option value="">Select Specialty</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="block font-medium mb-2 text-gray-700">Doctor</label>
                        <select id="doctorId" name="doctorId" class="w-full" onchange="updateAvailability()">
                            <option value="">Select Doctor</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="block font-medium mb-2 text-gray-700">Date</label>
                        <input type="text" id="date" name="date" class="w-full" placeholder="Select a date" required>
                    </div>
                    <div class="form-group">
                        <label class="block font-medium mb-2 text-gray-700">Time Slot</label>
                        <div id="timeSlots" class="grid grid-cols-2 gap-2"></div>
                        <input type="hidden" id="timeSlot" name="timeSlot" required>
                    </div>
                </div>
                <div class="flex items-center space-x-4">
                    <input type="checkbox" id="isEmergency" name="isEmergency" class="h-5 w-5 text-primary focus:ring-primary rounded">
                    <label for="isEmergency" class="text-gray-700">Emergency Booking</label>
                </div>
                <button type="submit" class="btn-primary"><i class="fas fa-calendar-plus mr-2"></i>Book Appointment</button>
            </form>
        </div>

        <div class="dashboard-card mt-8 hidden" id="appointmentsSection">
            <h2 class="text-xl font-semibold text-primary mb-6">Your Upcoming Appointments</h2>
            <div class="overflow-x-auto">
                <table class="w-full text-left" id="appointmentsTable">
                    <thead>
                    <tr>
                        <th class="p-4 rounded-tl-lg" onclick="sortTable(0)">ID <i class="fas fa-sort"></i></th>
                        <th class="p-4" onclick="sortTable(1)">Doctor <i class="fas fa-sort"></i></th>
                        <th class="p-4" onclick="sortTable(2)">Date & Time <i class="fas fa-sort"></i></th>
                        <th class="p-4 rounded-tr-lg" onclick="sortTable(3)">Priority <i class="fas fa-sort"></i></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="appt" items="${appointments}">
                        <tr class="border-b">
                            <td class="p-4">${appt.id}</td>
                            <td class="p-4">${appt.doctorId}</td>
                            <td class="p-4">${appt.dateTime}</td>
                            <td class="p-4 ${appt.priority == 1 ? 'text-red-600 font-semibold' : 'text-gray-600'}">${appt.priority == 1 ? 'Emergency' : 'Normal'}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal" id="confirmModal">
        <div class="modal-content">
            <button class="close-modal" onclick="closeModal()">×</button>
            <h2 class="text-xl font-semibold text-primary mb-4">Confirm Booking</h2>
            <p id="confirmMessage" class="mb-6 text-gray-700"></p>
            <div class="flex justify-end space-x-4">
                <button class="btn-primary bg-gray-500 hover:bg-gray-600" onclick="closeModal()">Cancel</button>
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

    function toggleAppointments() {
        const section = document.getElementById('appointmentsSection');
        section.classList.toggle('hidden');
    }

    function updateDoctors() {
        const specialty = document.getElementById('specialty').value;
        const doctorSelect = document.getElementById('doctorId');
        doctorSelect.innerHTML = '<option value="">Select Doctor</option>';

        if (specialty) {
            fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${encodeURIComponent(specialty)}`)
                .then(response => response.json())
                .then(data => {
                    console.log('Doctors:', data);
                    if (data.doctors && data.doctors.length > 0) {
                        data.doctors.forEach(name => {
                            const option = document.createElement('option');
                            option.value = name; // Use name as value for now; adjust if doctorId is needed
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
            fetch(`<%=request.getContextPath()%>/UserServlet?action=getTimeSlots&doctorId=${encodeURIComponent(doctorName)}&date=${encodeURIComponent(date)}`)
                .then(response => response.json())
                .then(slots => {
                    console.log('Time Slots:', slots);
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
                        timeSlotsDiv.innerHTML = '<p class="text-gray-500">No available slots</p>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching time slots:', error);
                    timeSlotsDiv.innerHTML = '<p class="text-red-500">Error loading slots</p>';
                });
        }
    }

    function sortTable(n) {
        const table = document.getElementById('appointmentsTable');
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
            Specialty: ${specialty}<br>
            Doctor: ${doctorId}<br>
            Date: ${date}<br>
            Time: ${timeSlot}<br>
            Emergency: ${isEmergency ? 'Yes' : 'No'}
        `;
        document.getElementById('confirmModal').style.display = 'flex';
        return false; // Prevent form submission until confirmed
    }

    function closeModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    function submitBooking() {
        document.getElementById('bookForm').onsubmit = null; // Remove confirmation
        document.getElementById('bookForm').submit();
    }

    window.onload = () => {
        fetch('<%=request.getContextPath()%>/SortServlet')
            .then(response => response.json())
            .then(data => {
                const specialtySelect = document.getElementById('specialty');
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
    };
</script>
</body>
</html>