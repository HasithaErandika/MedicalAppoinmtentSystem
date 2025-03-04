<%--
  Created by IntelliJ IDEA.
  User: hasit
  Date: 3/4/2025
  Time: 4:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Doctor Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c5282; /* Doctor blue */
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
            background: #2b6cb0;
        }
        .schedule-card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
        }
        .schedule-card h2 {
            font-size: 1.25rem;
            color: var(--primary);
            margin-bottom: 1rem;
        }
        .schedule-card ul {
            list-style: none;
        }
        .schedule-card li {
            padding: 0.5rem 0;
            border-bottom: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"doctor".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        return;
    }
%>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-stethoscope"></i> Doctor Dashboard</h1>
        <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
            <button type="submit" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
        </form>
    </div>
    <div class="schedule-card">
        <h2>Your Schedule</h2>
        <ul>
            <!-- Placeholder data -->
            <li>Patient: John Doe, Date: 2025-03-06 10:00</li>
            <li>Patient: Jane Roe, Date: 2025-03-06 11:00</li>
        </ul>
    </div>
</div>
</body>
</html>
