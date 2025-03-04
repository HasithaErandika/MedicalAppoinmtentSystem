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
    <title>MediSchedule - Patient Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #48bb78; /* Patient green */
            --bg-light: #f7fafc;
            --text-light: #2d3748;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-light);
            min-height: 100vh;
            padding: 2rem;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            color: var(--primary);
        }
        .header h1 {
            font-size: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .logout-btn {
            background: var(--primary);
            color: white;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .logout-btn:hover {
            background: #38a169;
        }
        .dashboard-grid {
            display: grid;
            gap: 2rem;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        }
        .card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
        }
        .card h2 {
            font-size: 1.25rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
        }
        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
        }
        .action-btn {
            background: var(--primary);
            color: white;
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            margin-top: 1rem;
        }
        .action-btn:hover {
            background: #38a169;
        }
        .card ul {
            list-style: none;
        }
        .card li {
            padding: 0.5rem 0;
            border-bottom: 1px solid #e2e8f0;
        }
        .cancel-btn {
            background: #e53e3e;
            color: white;
            padding: 0.4rem 0.8rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-left: 0.5rem;
        }
        .cancel-btn:hover {
            background: #c53030;
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"patient".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        return;
    }
%>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-heartbeat"></i> Patient Dashboard</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </form>
    </div>
    <div class="dashboard-grid">
        <div class="card">
            <h2>Your Profile</h2>
            <form action="<%=request.getContextPath()%>/UpdateProfileServlet" method="post">
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="name" class="form-input" value="John Doe" required>
                </div>
                <div class="form-group">
                    <label>Age</label>
                    <input type="number" name="age" class="form-input" value="30" required>
                </div>
                <div class="form-group">
                    <label>Contact</label>
                    <input type="text" name="contact" class="form-input" value="555-1234" required>
                </div>
                <button type="submit" class="action-btn">Update Profile</button>
            </form>
        </div>
        <div class="card">
            <h2>Book Appointment</h2>
            <form action="<%=request.getContextPath()%>/AppointmentServlet" method="post">
                <div class="form-group">
                    <label>Doctor</label>
                    <select name="doctor" class="form-input" required>
                        <option value="Dr. Smith">Dr. Smith - Cardiology</option>
                        <option value="Dr. Jones">Dr. Jones - Neurology</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Date</label>
                    <input type="datetime-local" name="date" class="form-input" required>
                </div>
                <button type="submit" class="action-btn">Book Now</button>
            </form>
        </div>
        <div class="card">
            <h2>Your Appointments</h2>
            <ul>
                <li>Dr. Smith, 2025-03-06 10:00 <button class="cancel-btn">Cancel</button></li>
                <li>Dr. Jones, 2025-03-07 14:00 <button class="cancel-btn">Cancel</button></li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
