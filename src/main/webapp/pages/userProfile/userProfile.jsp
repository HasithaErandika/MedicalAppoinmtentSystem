<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - User Profile</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/userProfile.css">
</head>
<body>
<c:if test="${empty sessionScope.username || sessionScope.role != 'patient'}">
    <c:redirect url="/pages/login.jsp?role=patient"/>
</c:if>

<div class="sidebar" id="sidebar" role="navigation" aria-label="Main navigation">
    <button class="sidebar-toggle" aria-label="Toggle sidebar">
        <i class="fas fa-bars"></i>
    </button>
    <div class="logo">
        <i class="fas fa-heartbeat" aria-hidden="true"></i>
        <span>MediSchedule</span>
    </div>
    <nav>
        <ul>
            <li><a href="#" data-section="bookAppointment" class="nav-link active"><i class="fas fa-calendar-check"></i><span>Book Appointment</span></a></li>
            <li><a href="#" data-section="appointments" class="nav-link"><i class="fas fa-list"></i><span>My Appointments</span></a></li>
            <li><a href="#" data-section="userDetails" class="nav-link"><i class="fas fa-user"></i><span>User Details</span></a></li>
            <li><form action="<%= request.getContextPath() %>/LogoutServlet" method="post"><a href="#" onclick="this.parentNode.submit();"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a></form></li>
        </ul>
    </nav>
</div>

<main class="main-content" id="main-content" aria-live="polite">
    <div class="container">
        <header class="dashboard-header">
            <div class="user-info">
                <div class="avatar">${sessionScope.username.charAt(0)}</div>
                <h1>Welcome, ${sessionScope.username}!</h1>
            </div>
            <div class="date"><%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %></div>
        </header>

        <c:if test="${not empty message}">
            <div class="toast ${messageType}" role="alert">
                <i class="fas ${messageType == 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
                    ${message}
            </div>
        </c:if>

        <section id="content-area" class="content-area">
            <jsp:include page="${param.section != null ? param.section : 'bookAppointment.jsp'}" />
        </section>
    </div>
</main>

<div class="modal" id="confirmModal" role="dialog" aria-labelledby="modal-title">
    <div class="modal-content">
        <button class="close-modal" aria-label="Close modal" onclick="closeModal()">×</button>
        <h2 id="modal-title">Confirm Booking</h2>
        <p id="confirmMessage"></p>
        <div class="modal-actions">
            <button class="btn-secondary" onclick="closeModal()">Cancel</button>
            <button class="btn-primary" onclick="submitBooking()">Confirm</button>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.js"></script>
<script src="<%= request.getContextPath() %>/assets/js/userProfile.js"></script>
<script>
    // Pass contextPath to the external JS file
    window.contextPath = '<%= request.getContextPath() %>';
</script>
</body>
</html>