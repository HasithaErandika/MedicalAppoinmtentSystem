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
            --primary-patient: #48BB78; /* Green for Patient */
            --primary-doctor: #2C5282;  /* Blue for Doctor */
            --primary-admin: #ED8936;   /* Orange for Admin */
            --bg-light: #F7FAFC;
            --text-primary: #2D3748;
            --text-secondary: #718096;
            --card-bg: #FFFFFF;
            --shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
            --error: #E53E3E;
            --input-bg: #F9FAFB;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, var(--bg-light) 0%, #E2E8F0 100%);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1.5rem;
        }

        .login-container {
            background: var(--card-bg);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 480px;
            text-align: center;
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.5s ease;
        }

        .login-header {
            margin-bottom: 2.5rem;
            position: relative;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: 50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(74, 144, 226, 0.1) 0%, transparent 70%);
            transform: translateX(-50%);
            z-index: -1;
        }

        .login-header .logo {
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.75rem;
            transition: transform 0.3s ease;
        }

        .login-header .logo:hover {
            transform: scale(1.05);
        }

        .login-header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            margin-top: 0.75rem;
            color: inherit;
        }

        /* Role-specific Styling */
        .patient { --primary: var(--primary-patient); }
        .doctor { --primary: var(--primary-doctor); }
        .admin { --primary: var(--primary-admin); }

        .patient .login-header .logo, .patient h1 { color: var(--primary-patient); }
        .doctor .login-header .logo, .doctor h1 { color: var(--primary-doctor); }
        .admin .login-header .logo, .admin h1 { color: var(--primary-admin); }

        .patient .login-btn { background: var(--primary-patient); }
        .patient .login-btn:hover { background: #38A169; }
        .doctor .login-btn { background: var(--primary-doctor); }
        .doctor .login-btn:hover { background: #2B6CB0; }
        .admin .login-btn { background: var(--primary-admin); }
        .admin .login-btn:hover { background: #DD6B20; }

        .form-group {
            margin-bottom: 1.75rem;
            text-align: left;
            position: relative;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
            font-size: 0.95rem;
        }

        .form-input {
            width: 100%;
            padding: 0.9rem 1rem;
            border: 1px solid #E2E8F0;
            border-radius: 10px;
            background: var(--input-bg);
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(72, 187, 120, 0.15);
            background: #FFFFFF;
            outline: none;
        }

        .form-input::placeholder {
            color: var(--text-secondary);
        }

        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 60%;
            transform: translateY(-50%);
            cursor: pointer;
            color: var(--text-secondary);
            transition: color 0.3s ease;
        }

        .toggle-password:hover {
            color: var(--primary);
        }

        .login-btn {
            width: 100%;
            padding: 1rem;
            border: none;
            border-radius: 50px;
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
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        .login-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .error-message {
            color: var(--error);
            margin-top: 1rem;
            font-size: 0.9rem;
            background: rgba(229, 62, 62, 0.1);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            animation: slideIn 0.3s ease;
        }

        .back-link {
            margin-top: 2rem;
            display: block;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: var(--primary);
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 480px) {
            .login-container {
                padding: 2rem;
                max-width: 100%;
                margin: 1rem;
            }
            .login-header .logo { font-size: 1.5rem; }
            .login-header h1 { font-size: 1.25rem; }
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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
    <form action="<%=request.getContextPath()%>/login" method="post" id="loginForm">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
            <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
        </div>
        <input type="hidden" name="role" value="<%= role %>">
        <button type="submit" class="login-btn" id="loginBtn">
            <i class="fas fa-sign-in-alt"></i> Login
        </button>
    </form>
    <% String error = (String) request.getAttribute("error"); if (error != null) { %>
    <p class="error-message"><%= error %></p>
    <% } %>
    <a href="<%=request.getContextPath()%>/pages/index.jsp" class="back-link">Back to Home</a>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.querySelector('.toggle-password');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    const form = document.getElementById('loginForm');
    const loginBtn = document.getElementById('loginBtn');
    form.addEventListener('submit', () => {
        loginBtn.disabled = true;
        loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Logging in...';
    });
</script>
</body>
</html>