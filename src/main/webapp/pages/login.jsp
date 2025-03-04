<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Login</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-patient: #48bb78; /* Green for Patient */
            --primary-doctor: #2c5282;  /* Blue for Doctor */
            --primary-admin: #ed8936;   /* Orange for Admin */
            --bg-light: #f7fafc;
            --text-light: #2d3748;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
            --error: #e53e3e;
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
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .login-container {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 450px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .login-header {
            margin-bottom: 2rem;
        }

        .login-header .logo {
            font-size: 1.75rem;
            font-weight: 700;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
        }

        .login-header h1 {
            font-size: 1.5rem;
            margin-top: 0.5rem;
        }

        /* Patient Styling */
        .patient .login-header .logo, .patient h1 {
            color: var(--primary-patient);
        }
        .patient .login-btn {
            background: var(--primary-patient);
        }
        .patient .login-btn:hover {
            background: #38a169;
        }

        /* Doctor Styling */
        .doctor .login-header .logo, .doctor h1 {
            color: var(--primary-doctor);
        }
        .doctor .login-btn {
            background: var(--primary-doctor);
        }
        .doctor .login-btn:hover {
            background: #2b6cb0;
        }

        /* Admin Styling */
        .admin .login-header .logo, .admin h1 {
            color: var(--primary-admin);
        }
        .admin .login-btn {
            background: var(--primary-admin);
        }
        .admin .login-btn:hover {
            background: #dd6b20;
        }

        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-light);
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            border-color: var(--primary-patient); /* Default, overridden by role */
            box-shadow: 0 0 0 3px rgba(72, 187, 120, 0.2);
            outline: none;
        }

        .doctor .form-input:focus {
            border-color: var(--primary-doctor);
            box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.2);
        }

        .admin .form-input:focus {
            border-color: var(--primary-admin);
            box-shadow: 0 0 0 3px rgba(237, 137, 54, 0.2);
        }

        .login-btn {
            width: 100%;
            padding: 0.9rem;
            border: none;
            border-radius: 25px;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .error-message {
            color: var(--error);
            margin-top: 1rem;
            font-size: 0.9rem;
        }

        .back-link {
            margin-top: 1.5rem;
            display: block;
            color: var(--text-light);
            text-decoration: none;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: var(--primary-patient); /* Default, overridden by role */
        }

        .doctor .back-link:hover {
            color: var(--primary-doctor);
        }

        .admin .back-link:hover {
            color: var(--primary-admin);
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 1.5rem;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
<%
    String role = request.getParameter("role");
    String containerClass = "";
    String iconClass = "";
    String title = "Login";

    if ("patient".equals(role)) {
        containerClass = "patient";
        iconClass = "fas fa-heartbeat";
        title = "Patient Login";
    } else if ("doctor".equals(role)) {
        containerClass = "doctor";
        iconClass = "fas fa-stethoscope";
        title = "Doctor Login";
    } else if ("admin".equals(role)) {
        containerClass = "admin";
        iconClass = "fas fa-shield-alt";
        title = "Admin Login";
    } else {
        // Default to a generic login if role is invalid
        containerClass = "patient";
        iconClass = "fas fa-heartbeat";
        title = "Login";
    }
%>
<div class="login-container <%= containerClass %>">
    <div class="login-header">
        <div class="logo">
            <i class="<%= iconClass %>"></i> MediSchedule
        </div>
        <h1><%= title %></h1>
    </div>
    <form action="<%=request.getContextPath()%>/login" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-input" placeholder="Enter username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-input" placeholder="Enter password" required>
        </div>
        <input type="hidden" name="role" value="<%= role %>">
        <button type="submit" class="login-btn">
            <i class="fas fa-sign-in-alt"></i> Login
        </button>
    </form>
    <% String error = (String) request.getAttribute("error"); if (error != null) { %>
    <p class="error-message"><%= error %></p>
    <% } %>
    <a href="<%=request.getContextPath()%>/pages/index.jsp" class="back-link">Back to Home</a>
</div>
</body>
</html>