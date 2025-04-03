<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Your Profile</title>
    <!-- Remixicon CDN -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
    <!-- Flatpickr CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #2F855A;        /* Forest Green */
            --secondary: #38B2AC;      /* Teal */
            --accent: #E53E3E;         /* Red */
            --bg-light: #F7FAF9;       /* Softer light green-gray for calm effect */
            --text-primary: #1A4731;   /* Dark green */
            --text-muted: #6B7280;     /* Softer gray */
            --card-bg: #FFFFFF;        /* White cards */
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.05); /* Subtle shadow */
            --border: #D1D5DB;         /* Neutral gray border */
            --hover: #E6FFFA;          /* Light green hover */
            --transition: all 0.3s ease;
            --border-radius: 10px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--primary);
            color: #FFFFFF;
            padding: 2rem 1.5rem;
            position: fixed;
            height: 100%;
            transition: var(--transition);
            z-index: 1000;
        }

        .sidebar .logo {
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .sidebar ul {
            list-style: none;
        }

        .sidebar ul li a {
            color: #FFFFFF;
            text-decoration: none;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.9rem 1rem;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .sidebar ul li a:hover,
        .sidebar ul li a.active {
            background: var(--secondary);
            transform: translateX(4px);
        }

        .sidebar-toggle {
            display: none;
            background: none;
            border: none;
            color: #FFFFFF;
            font-size: 1.5rem;
            cursor: pointer;
            margin-bottom: 1rem;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 2rem;
            flex-grow: 1;
            transition: var(--transition);
        }

        .container {
            max-width: 1280px;
            margin: 0 auto;
        }

        .dashboard-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            padding: 1.75rem;
            border-radius: var(--border-radius);
            color: #FFFFFF;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .dashboard-header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .avatar {
            width: 48px;
            height: 48px;
            background: var(--secondary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        /* Toast Notifications */
        .toast {
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: var(--shadow);
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }

        .error {
            background: #FEE2E2;
            color: var(--accent);
        }

        .success {
            background: #D1FAE5;
            color: var(--primary);
        }

        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }

        .modal-content {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            max-width: 480px;
            width: 90%;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; scale: 0.95; }
            to { opacity: 1; scale: 1; }
        }

        .close-modal {
            float: right;
            border: none;
            background: none;
            font-size: 1.75rem;
            cursor: pointer;
            color: var(--text-muted);
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
        }

        /* Buttons */
        .btn-primary, .btn-secondary {
            padding: 0.75rem 1.75rem;
            border-radius: var(--border-radius);
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: var(--primary);
            color: #FFFFFF;
        }

        .btn-primary:hover {
            background: #276749;
            box-shadow: var(--shadow);
        }

        .btn-secondary {
            background: var(--accent);
            color: #FFFFFF;
        }

        .btn-secondary:hover {
            background: #C53030;
            box-shadow: var(--shadow);
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .sidebar {
                width: 220px;
            }
            .main-content {
                margin-left: 220px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 1rem;
                display: none;
            }
            .sidebar.active {
                display: block;
            }
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
            .sidebar-toggle {
                display: block;
            }
            .dashboard-header {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<c:if test="${empty sessionScope.username || sessionScope.role != 'patient'}">
    <c:redirect url="/pages/login.jsp?role=patient"/>
</c:if>

<!-- Sidebar -->
<div class="sidebar" id="sidebar" role="navigation" aria-label="Main navigation">
    <button class="sidebar-toggle" aria-label="Toggle sidebar" onclick="toggleSidebar()">
        <i class="ri-menu-line"></i>
    </button>
    <div class="logo">
        <i class="ri-heart-pulse-line" aria-hidden="true"></i>
        <span>MediSchedule</span>
    </div>
    <nav>
        <ul>
            <li><a href="#" data-section="dashboard" class="nav-link" onclick="loadSection('dashboard')"><i class="ri-dashboard-line"></i><span>Dashboard</span></a></li>
            <li><a href="#" data-section="bookAppointment" class="nav-link" onclick="loadSection('bookAppointment')"><i class="ri-calendar-check-line"></i><span>Book Appointment</span></a></li>
            <li><a href="<%= request.getContextPath() %>/appointments" data-section="appointments" class="nav-link"><i class="ri-list-check"></i><span>My Appointments</span></a></li>
            <li><a href="#" data-section="userDetails" class="nav-link" onclick="loadSection('userDetails')"><i class="ri-user-line"></i><span>User Details</span></a></li>
            <li><form action="<%= request.getContextPath() %>/LogoutServlet" method="post"><a href="#" onclick="this.parentNode.submit();"><i class="ri-logout-box-line"></i><span>Logout</span></a></form></li>
        </ul>
    </nav>
</div>

<!-- Main Content -->
<main class="main-content" id="main-content" aria-live="polite">
    <div class="container">
        <header class="dashboard-header">
            <div class="user-info">
                <div class="avatar">${sessionScope.username.charAt(0)}</div>
                <h1>Welcome, ${sessionScope.username}!</h1>
            </div>
            <div class="date"><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></div>
        </header>

        <c:if test="${not empty message}">
            <div class="toast ${messageType}" id="toastMessage" role="alert" aria-live="assertive">
                <i class="ri-${messageType == 'error' ? 'alert' : 'checkbox-circle'}-line"></i>
                    ${message}
            </div>
        </c:if>

        <section id="content-area" class="content-area">
            <jsp:include page="${param.section != null ? param.section : 'dashboard.jsp'}" />
        </section>
    </div>
</main>

<!-- Modal -->
<div class="modal" id="confirmModal" role="dialog" aria-labelledby="modal-title" aria-hidden="true">
    <div class="modal-content">
        <button class="close-modal" aria-label="Close modal" onclick="closeModal()">×</button>
        <h2 id="modal-title">Confirm Your Booking</h2>
        <p id="confirmMessage"></p>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn-primary" onclick="submitBooking()">Confirm</button>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.js"></script>
<script src="<%= request.getContextPath() %>/assets/js/userProfile.js"></script>
<script>
    window.contextPath = '<%= request.getContextPath() %>';

    // Toggle Sidebar for Mobile
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        sidebar.classList.toggle('active');
    }

    // Load Section
    function loadSection(section) {
        const url = `<%= request.getContextPath() %>/pages/userProfile.jsp?section=${section}.jsp`;
        window.location.href = url;
    }

    // Handle active link
    document.addEventListener('DOMContentLoaded', function() {
        const currentSection = '<%= request.getParameter("section") != null ? request.getParameter("section") : "dashboard.jsp" %>';
        const links = document.querySelectorAll('.nav-link');
        links.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('data-section') === currentSection.replace('.jsp', '')) {
                link.classList.add('active');
            }
        });

        // Fade out toast message after 3 seconds
        const toast = document.getElementById('toastMessage');
        if (toast && toast.classList.contains('success')) {
            setTimeout(() => {
                toast.style.opacity = '0';
                setTimeout(() => toast.style.display = 'none', 300);
            }, 3000);
        }

        // Chart.js Example (for dashboard)
        if (document.getElementById('appointmentChart')) {
            const ctx = document.getElementById('appointmentChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                    datasets: [{
                        label: 'Appointments',
                        data: [5, 8, 3, 7, 4],
                        backgroundColor: 'rgba(47, 133, 90, 0.6)',
                        borderColor: 'rgba(47, 133, 90, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: { y: { beginAtZero: true } },
                    plugins: { legend: { display: false } }
                }
            });
        }
    });

    function closeModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    function submitBooking() {
        // Add booking submission logic here
        closeModal();
    }
</script>
</body>
</html>