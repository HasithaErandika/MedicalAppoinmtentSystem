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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5; /* Indigo */
            --secondary: #10B981; /* Emerald */
            --accent: #F43F5E; /* Rose */
            --bg-light: #F3F4F6; /* Gray-100 */
            --card-bg: #FFFFFF;
            --text-dark: #111827; /* Gray-900 */
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            min-height: 100vh;
        }
        .sidebar {
            background: var(--card-bg);
            box-shadow: var(--shadow);
            transition: width 0.3s ease;
        }
        .sidebar.collapsed { width: 80px; }
        .sidebar .logo { color: var(--primary); font-weight: 700; }
        .sidebar nav a:hover, .sidebar nav a.active {
            background: var(--primary);
            color: white;
            transform: scale(1.05);
            transition: all 0.2s ease;
        }
        .sidebar.collapsed span { display: none; }
        .dashboard-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: var(--shadow);
            padding: 2rem;
            animation: fadeInUp 0.5s ease;
        }
        .form-group select, .form-group input {
            border: 2px solid #E5E7EB;
            border-radius: 8px;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        .form-group select:focus, .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(79, 70, 229, 0.2);
        }
        .time-slot {
            padding: 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid #E5E7EB;
        }
        .time-slot:hover { background: #E0E7FF; }
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
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
    </style>
</head>
<body class="flex">
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"patient".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=patient");
        return;
    }
%>
<div class="sidebar fixed h-full w-64 p-6" id="sidebar">
    <button class="absolute top-4 right-4 text-primary text-xl" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    <div class="logo text-2xl mb-10 flex items-center"><i class="fas fa-heartbeat mr-3"></i><span>MediSchedule</span></div>
    <nav>
        <ul>
            <li class="mb-4"><a href="#" class="block p-3 rounded-lg active"><i class="fas fa-calendar-check mr-3"></i><span>Book Appointment</span></a></li>
            <li class="mb-4"><a href="<%=request.getContextPath()%>/UserServlet?action=appointments" class="block p-3 rounded-lg"><i class="fas fa-list mr-3"></i><span>My Appointments</span></a></li>
            <li class="mb-4"><a href="<%=request.getContextPath()%>/UserServlet?action=profile" class="block p-3 rounded-lg"><i class="fas fa-user mr-3"></i><span>Profile</span></a></li>
            <li><form action="<%=request.getContextPath()%>/LogoutServlet" method="post"><a href="#" onclick="this.parentNode.submit();" class="block p-3 rounded-lg"><i class="fas fa-sign-out-alt mr-3"></i><span>Logout</span></a></form></li>
        </ul>
    </nav>
</div>

<div class="main-content ml-64 p-8 flex-1" id="main-content">
    <div class="max-w-6xl mx-auto">
        <div class="flex items-center justify-between mb-8">
            <div class="flex items-center">
                <div class="avatar mr-4"><%= username.charAt(0) %></div>
                <h1 class="text-3xl font-bold text-gray-800">Hello, <%= username %>!</h1>
            </div>
            <div class="text-gray-600"><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></div>
        </div>

        <% if (request.getAttribute("message") != null) { %>
        <div class="p-4 rounded-lg mb-6 <%= "error".equals(request.getAttribute("messageType")) ? "bg-red-100 text-red-700" : "bg-green-100 text-green-700" %> animate__animated animate__fadeIn">
            <i class="fas <%= "error".equals(request.getAttribute("messageType")) ? "fa-exclamation-circle" : "fa-check-circle" %> mr-2"></i>
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <div class="dashboard-card">
            <h2 class="text-2xl font-semibold text-primary mb-6">Schedule Your Appointment</h2>
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
                    <input type="checkbox" id="isEmergency" name="isEmergency" class="h-5 w-5 text-primary focus:ring-primary">
                    <label for="isEmergency" class="text-gray-700">Emergency Booking</label>
                </div>
                <button type="submit" class="btn-primary"><i class="fas fa-calendar-plus mr-2"></i>Book Appointment</button>
            </form>
        </div>

        <div class="dashboard-card mt-8" style="display: none;" id="appointmentsSection">
            <h2 class="text-2xl font-semibold text-primary mb-6">Your Upcoming Appointments</h2>
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                    <tr class="bg-primary text-white">
                        <th class="p-4 rounded-tl-lg">ID</th>
                        <th class="p-4">Doctor</th>
                        <th class="p-4">Date & Time</th>
                        <th class="p-4 rounded-tr-lg">Priority</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="appt" items="${appointments}">
                        <tr class="border-b hover:bg-gray-50 transition-colors">
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
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.js"></script>
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('ml-64');
        mainContent.classList.toggle('ml-20');
    }

    function updateDoctors() {
        const specialty = document.getElementById('specialty').value;
        const doctorSelect = document.getElementById('doctorId');
        doctorSelect.innerHTML = '<option value="">Select Doctor</option>';

        if (specialty) {
            fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${encodeURIComponent(specialty)}`)
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(data => {
                    console.log('Doctors response:', data);
                    if (data.doctors && data.doctors.length > 0) {
                        data.doctors.forEach(doctor => {
                            const option = document.createElement('option');
                            option.value = doctor;
                            option.text = doctor;
                            doctorSelect.appendChild(option);
                        });
                        updateAvailability(); // Trigger next step
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
        const specialty = document.getElementById('specialty').value;
        const doctorId = document.getElementById('doctorId').value;
        const date = document.getElementById('date').value;
        const timeSlotsDiv = document.getElementById('timeSlots');
        timeSlotsDiv.innerHTML = '';

        if (specialty && doctorId && date) {
            fetch(`<%=request.getContextPath()%>/SortServlet?specialty=${encodeURIComponent(specialty)}&doctor=${encodeURIComponent(doctorId)}&date=${encodeURIComponent(date)}`)
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(data => {
                    console.log('Availability response:', data);
                    if (data.availability && data.availability.length > 0) {
                        data.availability.forEach(doc => {
                            const slot = document.createElement('div');
                            slot.className = 'time-slot';
                            slot.textContent = `${doc.startTime} - ${doc.endTime}`;
                            slot.onclick = () => {
                                document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                                slot.classList.add('selected');
                                document.getElementById('timeSlot').value = `${doc.startTime}-${doc.endTime}`;
                            };
                            timeSlotsDiv.appendChild(slot);
                        });
                    } else {
                        timeSlotsDiv.innerHTML = '<p class="text-gray-500">No available slots</p>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching availability:', error);
                    timeSlotsDiv.innerHTML = '<p class="text-red-500">Error loading slots</p>';
                });
        }
    }

    window.onload = () => {
        fetch('<%=request.getContextPath()%>/SortServlet')
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                console.log('Specialties response:', data);
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
    };
</script>
</body>
</html>