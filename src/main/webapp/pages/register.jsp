<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        :root {
            --primary: #5A67D8;
            --secondary: #48BB78;
            --accent: #F56565;
            --bg-light: #F7FAFC;
            --text-primary: #1A202C;
            --card-bg: #FFFFFF;
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            --border: #E2E8F0;
            --hover: #EBF4FF;
            --success: #48BB78;
            --danger: #F56565;
            --input-focus: rgba(90, 103, 216, 0.2);
            --progress-fill: #5A67D8;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, var(--bg-light) 0%, #EDF2F7 100%);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }

        .container {
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: var(--shadow);
            padding: 3rem;
            width: 100%;
            max-width: 520px;
            position: relative;
            transition: transform 0.2s ease;
        }
        .container:hover { transform: translateY(-2px); }

        .progress-bar {
            width: 100%;
            height: 6px;
            background: var(--border);
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .progress-fill {
            width: 0%;
            height: 100%;
            background: var(--progress-fill);
            transition: width 0.3s ease;
        }

        .header {
            text-align: center;
            margin-bottom: 2.5rem;
        }
        .header h1 {
            color: var(--primary);
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.025em;
        }
        .header p {
            color: #718096;
            font-size: 1rem;
            font-weight: 400;
        }

        .message {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            font-size: 0.95rem;
            font-weight: 500;
            text-align: center;
            animation: fadeIn 0.4s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .message.success { background: rgba(72, 187, 120, 0.1); color: var(--success); }
        .message.error { background: rgba(245, 101, 101, 0.1); color: var(--danger); }

        .form-grid {
            display: grid;
            gap: 1.5rem;
        }
        .form-group {
            position: relative;
        }
        .form-group label {
            font-size: 0.95rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .form-group input {
            width: 100%;
            padding: 1rem 3rem 1rem 2.5rem;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 1rem;
            background: #F9FAFB;
            transition: all 0.3s ease;
        }
        .form-group i {
            position: absolute;
            left: 1rem;
            top: 2.75rem;
            color: #A0AEC0;
            font-size: 1.1rem;
            transition: color 0.3s ease;
        }
        .form-group .status-icon {
            position: absolute;
            right: 1rem;
            top: 2.75rem;
            font-size: 1.1rem;
            opacity: 0;
            transition: opacity 0.2s ease;
        }
        .form-group input:focus {
            border-color: var(--primary);
            background: #FFFFFF;
            box-shadow: 0 0 0 4px var(--input-focus);
            outline: none;
        }
        .form-group input:focus + i { color: var(--primary); }
        .form-group input.valid {
            border-color: var(--success);
        }
        .form-group input.invalid:not(:placeholder-shown) {
            border-color: var(--danger);
        }
        .form-group .valid + i + .status-icon.ri-check-line {
            color: var(--success);
            opacity: 1;
        }
        .form-group .invalid:not(:placeholder-shown) + i + .status-icon.ri-close-line {
            color: var(--danger);
            opacity: 1;
        }
        .form-group .error-text {
            color: var(--danger);
            font-size: 0.85rem;
            margin-top: 0.25rem;
            padding-left: 2.5rem;
            display: none;
        }
        .form-group input.invalid:not(:placeholder-shown) + i + .status-icon + .error-text {
            display: block;
        }

        .btn {
            padding: 1rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            background: var(--primary);
            color: #FFFFFF;
            width: 100%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn:hover {
            background: #434190;
            box-shadow: 0 4px 12px rgba(90, 103, 216, 0.2);
        }

        .footer {
            text-align: center;
            margin-top: 2rem;
            font-size: 0.95rem;
            color: #718096;
        }
        .footer a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }
        .footer a:hover { color: #434190; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 480px) {
            .container { padding: 2rem; }
            .header h1 { font-size: 1.75rem; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="progress-bar">
        <div class="progress-fill"></div>
    </div>

    <div class="header">
        <h1>Join MediSchedule</h1>
        <p>Create your account to get started</p>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div class="message <%= request.getAttribute("messageType") %>">
        <i class="ri-<%= "success".equals(request.getAttribute("messageType")) ? "checkbox-circle" : "alert" %>-line"></i>
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <form action="<%=request.getContextPath()%>/RegisterServlet" method="post" onsubmit="return validateForm()">
        <div class="form-grid">
            <div class="form-group">
                <label><i class="ri-user-line"></i> Username</label>
                <input type="text" id="username" name="username" required placeholder="Enter username" minlength="4">
                <i class="ri-check-line status-icon"></i>
                <i class="ri-close-line status-icon"></i>
                <span class="error-text">Username must be at least 4 characters</span>
            </div>
            <div class="form-group">
                <label><i class="ri-lock-line"></i> Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}">
                <i class="ri-check-line status-icon"></i>
                <i class="ri-close-line status-icon"></i>
                <span class="error-text">Password must be 8+ characters with a number, uppercase, and lowercase</span>
            </div>
            <div class="form-group">
                <label><i class="ri-profile-line"></i> Full Name</label>
                <input type="text" id="name" name="name" required placeholder="Enter full name" pattern="[A-Za-z\s]{2,}">
                <i class="ri-check-line status-icon"></i>
                <i class="ri-close-line status-icon"></i>
                <span class="error-text">Please enter a valid name</span>
            </div>
            <div class="form-group">
                <label><i class="ri-mail-line"></i> Email Address</label>
                <input type="email" id="email" name="email" required placeholder="Enter email">
                <i class="ri-check-line status-icon"></i>
                <i class="ri-close-line status-icon"></i>
                <span class="error-text">Please enter a valid email address</span>
            </div>
            <div class="form-group">
                <label><i class="ri-phone-line"></i> Phone Number</label>
                <input type="tel" id="phone" name="phone" required placeholder="Enter phone number" pattern="[0-9]{10}">
                <i class="ri-check-line status-icon"></i>
                <i class="ri-close-line status-icon"></i>
                <span class="error-text">Phone number must be 10 digits</span>
            </div>
            <div class="form-group">
                <label><i class="ri-calendar-line"></i> Date of Birth</label>
                <input type="date" id="dob" name="dob" required max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                <i class="ri-check-line status-icon"></i>
                <i class="ri-close-line status-icon"></i>
                <span class="error-text">Please select a valid date</span>
            </div>
        </div>
        <button type="submit" class="btn"><i class="ri-user-add-line"></i> Create Account</button>
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
                input.classList.add('valid');
                input.classList.remove('invalid');
            }
        });
        return isValid;
    }

    function updateProgress() {
        const inputs = document.querySelectorAll('input');
        const totalFields = inputs.length;
        let filledFields = 0;

        inputs.forEach(input => {
            if (input.value.trim() !== '' && input.checkValidity()) {
                filledFields++;
            }
        });

        const progress = (filledFields / totalFields) * 100;
        document.querySelector('.progress-fill').style.width = `${progress}%`;
    }

    function validateInput(input) {
        if (input.value.trim() === '') {
            input.classList.remove('valid', 'invalid');
            input.nextElementSibling.style.opacity = '0'; // Check icon
            input.nextElementSibling.nextElementSibling.style.opacity = '0'; // Close icon
        } else if (input.checkValidity()) {
            input.classList.add('valid');
            input.classList.remove('invalid');
            input.nextElementSibling.style.opacity = '1'; // Show check icon
            input.nextElementSibling.nextElementSibling.style.opacity = '0'; // Hide close icon
        } else {
            input.classList.add('invalid');
            input.classList.remove('valid');
            input.nextElementSibling.style.opacity = '0'; // Hide check icon
            input.nextElementSibling.nextElementSibling.style.opacity = '1'; // Show close icon
        }
        updateProgress();
    }

    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', () => validateInput(input));
        input.addEventListener('blur', () => validateInput(input));
    });

    // Initial validation state
    document.querySelectorAll('input').forEach(input => validateInput(input));
</script>
</body>
</html>