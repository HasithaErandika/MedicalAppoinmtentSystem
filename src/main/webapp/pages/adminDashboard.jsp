<%--
  Created by IntelliJ IDEA.
  User: hasit
  Date: 2/28/2025
  Time: 6:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #ed8936; /* Admin orange */
            --secondary: #2c5282; /* Blue accent */
            --bg-light: #f7fafc;
            --bg-dark: #1a202c;
            --text-light: #2d3748;
            --text-dark: #e2e8f0;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
            --sidebar-bg: #2d3748;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-light);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background: var(--sidebar-bg);
            color: var(--text-dark);
            position: fixed;
            height: 100%;
            padding: 2rem 1rem;
            box-shadow: var(--shadow);
            transition: width 0.3s ease;
        }

        .sidebar .logo {
            font-size: 1.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
            color: var(--primary);
        }

        .sidebar ul {
            list-style: none;
        }

        .sidebar ul li {
            margin-bottom: 1.5rem;
        }

        .sidebar ul li a {
            color: var(--text-dark);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .sidebar ul li a:hover, .sidebar ul li a.active {
            background: var(--primary);
            color: white;
            transform: translateX(5px);
        }

        /* Main Content */
        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 2rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            padding: 1.5rem;
            border-radius: 15px;
            color: white;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 1.75rem;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }

        /* Dashboard Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: var(--primary);
            transition: height 0.3s ease;
        }

        .card:hover::before {
            height: 100%;
            opacity: 0.1;
        }

        .card i {
            font-size: 2.5rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .card h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
        }

        .card p {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
        }

        .card .action-btn {
            margin-top: 1rem;
            background: var(--primary);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .card .action-btn:hover {
            background: #dd6b20;
            transform: scale(1.05);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                width: 80px;
            }
            .sidebar .logo span, .sidebar ul li a span {
                display: none;
            }
            .main-content {
                margin-left: 80px;
            }
        }

        @media (max-width: 480px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }
            .main-content {
                margin-left: 0;
            }
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
        return;
    }
%>
<!-- Sidebar -->
<div class="sidebar">
    <div class="logo">
        <i class="fas fa-shield-alt"></i>
        <span>MediSchedule</span>
    </div>
    <ul>
        <li><a href="#" class="active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a></li>
        <li><a href="#"><i class="fas fa-user-md"></i><span>Manage Doctors</span></a></li>
        <li><a href="#"><i class="fas fa-calendar-check"></i><span>Appointments</span></a></li>
        <li><a href="#"><i class="fas fa-users"></i><span>Patients</span></a></li>
        <li><a href="#"><i class="fas fa-cog"></i><span>Settings</span></a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="header">
        <h1>Welcome, <%= username %>!</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </form>
    </div>

    <div class="dashboard-grid">
        <div class="card">
            <i class="fas fa-calendar-check"></i>
            <h3>Total Appointments</h3>
            <p>42</p>
            <a href="#" class="action-btn">View All</a>
        </div>
        <div class="card">
            <i class="fas fa-user-md"></i>
            <h3>Doctors</h3>
            <p>15</p>
            <a href="#" class="action-btn">Manage</a>
        </div>
        <div class="card">
            <i class="fas fa-users"></i>
            <h3>Patients</h3>
            <p>87</p>
            <a href="#" class="action-btn">View List</a>
        </div>
        <div class="card">
            <i class="fas fa-exclamation-triangle"></i>
            <h3>Emergency Queue</h3>
            <p>3</p>
            <a href="#" class="action-btn">Prioritize</a>
        </div>
    </div>
</div>
</body>
</html>
