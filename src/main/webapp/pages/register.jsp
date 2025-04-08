<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/register.css">
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