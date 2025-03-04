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
            --primary: #2c5282;
            --secondary: #48bb78;
            --accent: #ed8936;
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
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .login-container h1 {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 1.5rem;
        }
        .login-container .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 1rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }
        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
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
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44,82,130,0.2);
            outline: none;
        }
        .login-btn {
            background: var(--primary);
            color: white;
            padding: 0.8rem;
            border: none;
            border-radius: 25px;
            width: 100%;
            font-size: 1rem;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }
        .login-btn:hover {
            background: #2b6cb0;
            transform: translateY(-2px);
        }
        .error-message {
            color: #e53e3e;
            margin-top: 1rem;
            font-size: 0.9rem;
        }
        .back-link {
            margin-top: 1rem;
            display: block;
            color: var(--primary);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .back-link:hover {
            color: var(--accent);
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="logo">
        <i class="fas fa-heartbeat"></i> MediSchedule
    </div>
    <h1>Login</h1>
    <form action="<%=request.getContextPath()%>/login" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-input" placeholder="Enter username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-input" placeholder="Enter password" required>
        </div>
        <div class="form-group">
            <label for="role">Role</label>
            <select id="role" name="role" class="form-input" required>
                <option value="" disabled selected>Select your role</option>
                <option value="patient">Patient</option>
                <option value="doctor">Doctor</option>
                <option value="admin">Admin</option>
            </select>
        </div>
        <button type="submit" class="login-btn">
            <i class="fas fa-sign-in-alt"></i> Login
        </button>
    </form>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p class="error-message"><%= error %></p>
    <% } %>
    <a href="<%=request.getContextPath()%>/pages/index.jsp" class="back-link">Back to Home</a>
</div>
</body>
</html>