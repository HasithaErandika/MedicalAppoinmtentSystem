<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Login</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-patient: #34C759;
            --primary-doctor: #2C6EBF;
            --primary-admin: #F59E0B;
            --bg-light: #F0F4F8;
            --text-primary: #1F2A44;
            --text-secondary: #64748B;
            --card-bg: #FFFFFF;
            --shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            --error: #EF4444;
            --border-radius: 12px;
            --success: #10B981;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, var(--bg-light) 0%, rgba(44, 110, 191, 0.1) 100%);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .login-container {
            background: var(--card-bg);
            padding: 2.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 480px;
            text-align: center;
            animation: fadeIn 0.5s ease-in-out;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .login-header {
            margin-bottom: 2rem;
        }

        .login-header .logo {
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .login-header h1 {
            font-size: 1.5rem;
            font-weight: 600;
        }

        .login-header p {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .patient .logo, .patient h1 { color: var(--primary-patient); }
        .patient .login-btn { background: var(--primary-patient); }
        .patient .login-btn:hover { background: #2DB84C; }
        .patient .form-input:focus { border-color: var(--primary-patient); box-shadow: 0 0 0 3px rgba(52, 199, 89, 0.2); }
        .patient .link:hover { color: var(--primary-patient); }

        .doctor .logo, .doctor h1 { color: var(--primary-doctor); }
        .doctor .login-btn { background: var(--primary-doctor); }
        .doctor .login-btn:hover { background: #255DA3; }
        .doctor .form-input:focus { border-color: var(--primary-doctor); box-shadow: 0 0 0 3px rgba(44, 110, 191, 0.2); }
        .doctor .link:hover { color: var(--primary-doctor); }

        .admin .logo, .admin h1 { color: var(--primary-admin); }
        .admin .login-btn { background: var(--primary-admin); }
        .admin .login-btn:hover { background: #D97706; }
        .admin .form-input:focus { border-color: var(--primary-admin); box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2); }
        .admin .link:hover { color: var(--primary-admin); }

        .form-group {
            position: relative;
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-group label {
            font-size: 0.9rem;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-input {
            width: 100%;
            padding: 0.9rem 1rem 0.9rem 2.75rem;
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            font-size: 1rem;
            background: #F9FAFB;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            background: #FFFFFF;
        }

        .form-group i {
            position: absolute;
            left: 1rem;
            top: 2.5rem;
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .login-btn {
            width: 100%;
            padding: 1rem;
            border: none;
            border-radius: var(--border-radius);
            color: #FFFFFF;
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
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }

        .error-message {
            color: var(--error);
            margin: 1rem 0;
            font-size: 0.85rem;
            background: rgba(239, 68, 68, 0.1);
            padding: 0.75rem;
            border-radius: 8px;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .links {
            margin-top: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
        }

        .link {
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 480px) {
            .login-container { padding: 2rem; max-width: 100%; }
            .login-header .logo { font-size: 1.75rem; }
            .login-header h1 { font-size: 1.25rem; }
            .links { flex-direction: column; gap: 1rem; }
        }
    </style>
</head>
<body>
<%
    String role = request.getParameter("role");
    String containerClass = "";
    String iconClass = "";
    String title = "Login";
    String subtitle = "Sign in to manage your appointments";

    if ("patient".equals(role)) {
        containerClass = "patient";
        iconClass = "fas fa-heartbeat";
        title = "Patient Login";
        subtitle = "Access your appointments and health records";
    } else if ("doctor".equals(role)) {
        containerClass = "doctor";
        iconClass = "fas fa-stethoscope";
        title = "Doctor Login";
        subtitle = "Manage your schedule and patient records";
    } else if ("admin".equals(role)) {
        containerClass = "admin";
        iconClass = "fas fa-shield-alt";
        title = "Admin Login";
        subtitle = "Oversee system operations and users";
    } else {
        containerClass = "patient"; // Default to patient
        iconClass = "fas fa-heartbeat";
        title = "Patient Login";
    }
%>
<div class="login-container <%= containerClass %>">
    <div class="login-header">
        <div class="logo">
            <i class="<%= iconClass %>"></i> MediSchedule
        </div>
        <h1><%= title %></h1>
        <p><%= subtitle %></p>
    </div>
    <form action="<%=request.getContextPath()%>/login" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <i class="fas fa-user"></i>
            <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <i class="fas fa-lock"></i>
            <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
        </div>
        <input type="hidden" name="role" value="<%= role != null ? role : "patient" %>">
        <button type="submit" class="login-btn">
            <i class="fas fa-sign-in-alt"></i> Sign In
        </button>
    </form>
    <% String error = (String) request.getAttribute("error"); if (error != null) { %>
    <p class="error-message"><%= error %></p>
    <% } %>
    <div class="links">
        <% if ("patient".equals(role) || "doctor".equals(role)) { %>
        <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="link">Forgot Password?</a>
        <a href="<%=request.getContextPath()%>/pages/register.jsp?role=<%= role %>" class="link">Create Account</a>
        <% } else if ("admin".equals(role)) { %>
        <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="link">Forgot Password?</a>
        <% } else { %>
        <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="link">Forgot Password?</a>
        <a href="<%=request.getContextPath()%>/pages/register.jsp?role=patient" class="link">Create Account</a>
        <% } %>
    </div>
</div>
</body>
</html>