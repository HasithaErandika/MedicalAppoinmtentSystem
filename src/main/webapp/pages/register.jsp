<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Register</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4A90E2;       /* Professional blue */
            --secondary: #26A69A;     /* Teal for contrast */
            --accent: #EF5350;        /* Red for errors */
            --bg-light: #F7F9FC;      /* Softer background */
            --text-primary: #2D3748;  /* Darker gray for readability */
            --card-bg: #FFFFFF;
            --shadow: 0 8px 24px rgba(0, 0, 0, 0.08); /* Subtle shadow */
            --border: #E2E8F0;        /* Light gray border */
            --hover: #EDF2F7;         /* Light hover effect */
            --success: #38A169;       /* Green for success */
            --danger: #E53E3E;        /* Softer red for errors */
            --input-focus: rgba(74, 144, 226, 0.15); /* Focus ring */
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            background: var(--bg-light);
            color: var(--text-primary);
            line-height: 1.6;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 1rem;
        }

        .container {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: var(--shadow);
            padding: 2.5rem;
            width: 100%;
            max-width: 480px;
            position: relative;
            overflow: hidden;
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .header h1 {
            color: var(--primary);
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .header p {
            color: #718096;
            font-size: 0.9rem;
        }

        .message {
            padding: 0.75rem 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            font-weight: 500;
            text-align: center;
            animation: slideIn 0.3s ease;
        }
        .message.success { background: #F0FFF4; color: var(--success); }
        .message.error { background: #FFF5F5; color: var(--danger); }

        .form-grid {
            display: grid;
            gap: 1.25rem;
        }
        .form-group {
            position: relative;
        }
        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        .form-group input {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            background: #F9FAFB;
            transition: all 0.2s ease;
        }
        .form-group input:focus {
            border-color: var(--primary);
            background: #FFFFFF;
            box-shadow: 0 0 0 4px var(--input-focus);
            outline: none;
        }
        .form-group input:invalid:not(:placeholder-shown) {
            border-color: var(--danger);
        }
        .form-group .error-text {
            color: var(--danger);
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: none;
        }
        .form-group input:invalid:not(:placeholder-shown) + .error-text {
            display: block;
        }

        .btn {
            padding: 0.875rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            background: var(--primary);
            color: #FFFFFF;
            width: 100%;
            transition: all 0.3s ease;
        }
        .btn:hover {
            background: #2B6CB0;
            transform: translateY(-1px);
        }
        .btn:active {
            transform: translateY(0);
        }

        .footer {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: #718096;
        }
        .footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }
        .footer a:hover {
            color: #2B6CB0;
            text-decoration: underline;
        }

        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @media (max-width: 480px) {
            .container { padding: 1.5rem; max-width: 100%; }
            .header h1 { font-size: 1.5rem; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Join MediSchedule</h1>
        <p>Create your account to get started</p>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div class="message <%= request.getAttribute("messageType") %>">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/RegisterServlet" method="post" onsubmit="return validateForm()">
        <div class="form-grid">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required placeholder="Enter username" minlength="4">
                <span class="error-text">Username must be at least 4 characters</span>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Password must be at least 8 characters, including a number, uppercase, and lowercase letter">
                <span class="error-text">Password must be 8+ characters with a number, uppercase, and lowercase</span>
            </div>
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required placeholder="Enter full name" pattern="[A-Za-z\s]{2,}">
                <span class="error-text">Please enter a valid name</span>
            </div>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="Enter email">
                <span class="error-text">Please enter a valid email address</span>
            </div>
            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" required placeholder="Enter phone number" pattern="[0-9]{10}" title="Phone number must be 10 digits">
                <span class="error-text">Phone number must be 10 digits</span>
            </div>
            <div class="form-group">
                <label for="dob">Date of Birth</label>
                <input type="date" id="dob" name="dob" required max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                <span class="error-text">Please select a valid date</span>
            </div>
        </div>
        <button type="submit" class="btn">Create Account</button>
    </form>

    <div class="footer">
        Already have an account? <a href="<%=request.getContextPath()%>/pages/login.jsp">Sign in</a>
    </div>
</div>

<script>
    function validateForm() {
        const inputs = document.querySelectorAll('input');
        let isValid = true;

        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.classList.add('invalid');
                isValid = false;
            } else {
                input.classList.remove('invalid');
            }
        });

        return isValid;
    }

    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', () => {
            if (input.checkValidity()) {
                input.classList.remove('invalid');
            }
        });
    });
</script>
</body>
</html>