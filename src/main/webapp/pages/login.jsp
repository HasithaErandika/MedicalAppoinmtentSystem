<%--
  Created by IntelliJ IDEA.
  User: hasit
  Date: 2/28/2025
  Time: 6:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Login & Signup</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #2c5282;
            --secondary: #48bb78;
            --accent: #ed8936;
            --bg-light: #f7fafc;
            --bg-dark: #1a202c;
            --text-light: #2d3748;
            --text-dark: #e2e8f0;
            --card-bg: #ffffff;
            --shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        [data-theme="dark"] {
            --primary: #63b3ed;
            --secondary: #68d391;
            --bg-light: #1a202c;
            --text-light: #e2e8f0;
            --card-bg: #2d3748;
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
            transition: all 0.3s ease;
        }

        .container {
            max-width: 480px;
            width: 100%;
        }

        .auth-card {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 15px;
            box-shadow: var(--shadow);
            border: 2px solid var(--primary);
        }

        .auth-card h1 {
            text-align: center;
            color: var(--primary);
            font-size: 1.75rem;
            margin-bottom: 1.5rem;
        }

        .tab-switcher {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            background: #edf2f7;
            border-radius: 25px;
            padding: 0.3rem;
        }

        .tab-btn {
            flex: 1;
            padding: 0.75rem;
            text-align: center;
            cursor: pointer;
            border-radius: 20px;
            transition: all 0.3s ease;
            color: var(--text-light);
        }

        .tab-btn.active {
            background: var(--secondary);
            color: white;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44,82,130,0.2);
            outline: none;
        }

        .role-select {
            margin-bottom: 1.5rem;
        }

        .submit-btn {
            background: var(--primary);
            color: white;
            padding: 0.8rem;
            border: none;
            border-radius: 25px;
            width: 100%;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            background: #2b6cb0;
            transform: translateY(-2px);
        }

        .toggle-link {
            text-align: center;
            margin-top: 1rem;
        }

        .toggle-link a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 500;
        }

        .toggle-link a:hover {
            text-decoration: underline;
        }

        .extra-fields {
            display: none;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .auth-card {
                padding: 1.5rem;
            }
            .tab-switcher {
                flex-direction: column;
            }
            .tab-btn {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="auth-card">
        <h1>MediSchedule Access</h1>

        <!-- Tab Switcher -->
        <div class="tab-switcher">
            <div class="tab-btn active" onclick="showForm('login')">Login</div>
            <div class="tab-btn" onclick="showForm('signup')">Sign Up</div>
        </div>

        <!-- Login Form -->
        <form id="login-form" action="/login" method="POST">
            <div class="role-select form-group">
                <label for="role">User Type</label>
                <select id="role-login" name="role" class="form-input" onchange="toggleLoginFields()">
                    <option value="patient">Patient</option>
                    <option value="doctor">Doctor</option>
                    <option value="admin">Admin</option>
                </select>
            </div>
            <div class="form-group">
                <label for="username">Username/Email</label>
                <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="submit-btn">Login</button>
            <div class="toggle-link">
                <p>New user? <a href="#" onclick="showForm('signup'); return false;">Sign Up</a></p>
            </div>
        </form>

        <!-- Signup Form -->
        <form id="signup-form" action="/signup" method="POST" style="display: none;">
            <div class="role-select form-group">
                <label for="role-signup">User Type</label>
                <select id="role-signup" name="role" class="form-input" onchange="toggleSignupFields()">
                    <option value="patient">Patient</option>
                    <option value="doctor">Doctor</option>
                    <option value="admin">Admin</option>
                </select>
            </div>
            <div class="form-group">
                <label for="signup-username">Username</label>
                <input type="text" id="signup-username" name="username" class="form-input" placeholder="Choose a username" required>
            </div>
            <div class="form-group">
                <label for="signup-email">Email</label>
                <input type="email" id="signup-email" name="email" class="form-input" placeholder="Enter your email" required>
            </div>
            <div class="form-group">
                <label for="signup-password">Password</label>
                <input type="password" id="signup-password" name="password" class="form-input" placeholder="Create a password" required>
            </div>
            <!-- Extra Fields for Specific Roles -->
            <div class="extra-fields" id="patient-fields">
                <div class="form-group">
                    <label for="full-name">Full Name</label>
                    <input type="text" id="full-name" name="fullName" class="form-input" placeholder="Enter your full name">
                </div>
            </div>
            <div class="extra-fields" id="doctor-fields">
                <div class="form-group">
                    <label for="license">Medical License</label>
                    <input type="text" id="license" name="license" class="form-input" placeholder="Enter your license number">
                </div>
                <div class="form-group">
                    <label for="specialty">Specialty</label>
                    <input type="text" id="specialty" name="specialty" class="form-input" placeholder="e.g., Cardiology">
                </div>
            </div>
            <div class="extra-fields" id="admin-fields">
                <div class="form-group">
                    <label for="admin-code">Admin Code</label>
                    <input type="text" id="admin-code" name="adminCode" class="form-input" placeholder="Enter admin authorization code">
                </div>
            </div>
            <button type="submit" class="submit-btn">Sign Up</button>
            <div class="toggle-link">
                <p>Already have an account? <a href="#" onclick="showForm('login'); return false;">Login</a></p>
            </div>
        </form>
    </div>
</div>

<script>
    function showForm(type) {
        const loginForm = document.getElementById('login-form');
        const signupForm = document.getElementById('signup-form');
        const loginTab = document.querySelector('.tab-btn:nth-child(1)');
        const signupTab = document.querySelector('.tab-btn:nth-child(2)');

        if (type === 'login') {
            loginForm.style.display = 'block';
            signupForm.style.display = 'none';
            loginTab.classList.add('active');
            signupTab.classList.remove('active');
        } else {
            loginForm.style.display = 'none';
            signupForm.style.display = 'block';
            loginTab.classList.remove('active');
            signupTab.classList.add('active');
            toggleSignupFields(); // Ensure correct fields show on signup tab click
        }
    }

    function toggleLoginFields() {
        // No extra fields needed for login, but this can be expanded if required
    }

    function toggleSignupFields() {
        const role = document.getElementById('role-signup').value;
        const patientFields = document.getElementById('patient-fields');
        const doctorFields = document.getElementById('doctor-fields');
        const adminFields = document.getElementById('admin-fields');

        patientFields.style.display = role === 'patient' ? 'block' : 'none';
        doctorFields.style.display = role === 'doctor' ? 'block' : 'none';
        adminFields.style.display = role === 'admin' ? 'block' : 'none';
    }

    // Initialize form visibility
    showForm('login');
</script>
</head>
<body>
</body>
</html>
