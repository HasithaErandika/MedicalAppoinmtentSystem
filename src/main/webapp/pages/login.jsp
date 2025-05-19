<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/login.css">
</head>
<body class="<%= "patient".equals(request.getParameter("role")) ? "patient" : "doctor".equals(request.getParameter("role")) ? "doctor" : "admin".equals(request.getParameter("role")) ? "admin" : "patient" %>">
<%
    String role = request.getParameter("role");
    String containerClass = "";
    String iconClass = "";
    String title = "Login";
    String subtitle = "Sign in to manage your appointments";

    if ("patient".equals(role)) {
        containerClass = "patient";
        iconClass = "ri-heart-pulse-line";
        title = "Patient Login";
        subtitle = "Access your appointments and health records";
    } else if ("doctor".equals(role)) {
        containerClass = "doctor";
        iconClass = "ri-stethoscope-line";
        title = "Doctor Login";
        subtitle = "Manage your schedule and patient records";
    } else if ("admin".equals(role)) {
        containerClass = "admin";
        iconClass = "ri-shield-user-line";
        title = "Admin Login";
        subtitle = "Oversee system operations and users";
    } else {
        containerClass = "patient"; // Default to patient
        iconClass = "ri-heart-pulse-line";
        title = "Patient Login";
        subtitle = "Access your appointments and health records"; // Consistent default subtitle
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
            <i class="ri-user-line"></i>
            <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <i class="ri-lock-line"></i>
            <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
        </div>
        <input type="hidden" name="role" value="<%= role != null ? role : "patient" %>">
        <button type="submit" class="login-btn">
            <i class="ri-login-box-line"></i> Sign In
        </button>
    </form>
    <% String error = (String) request.getAttribute("error"); if (error != null) { %>
    <div class="error-message">
        <i class="ri-alert-line"></i> <%= error %>
    </div>
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

<!-- Popup for Failed Login -->
<div class="overlay" id="popupOverlay"></div>
<div class="popup <%= containerClass %>" id="loginPopup">
    <h2>Login Again</h2>
    <p>Your Password or Username is Wrong</p>
    <button onclick="closePopup()">Try Again</button>
</div>

<script>
    function showPopup() {
        document.getElementById('popupOverlay').style.display = 'block';
        document.getElementById('loginPopup').style.display = 'block';
    }

    function closePopup() {
        document.getElementById('popupOverlay').style.display = 'none';
        document.getElementById('loginPopup').style.display = 'none';
    }

    <% if (request.getAttribute("error") != null) { %>
    showPopup();
    <% } %>
</script>
</body>
</html>