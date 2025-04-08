<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Details - MediSchedule</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/index.css">
</head>
<body>
<nav>
    <div class="container nav-content">
        <a href="<%=request.getContextPath()%>/pages/index.jsp" class="logo">
            <i class="fas fa-heartbeat"></i> MediSchedule
        </a>
        <div class="nav-actions">
            <a href="<%=request.getContextPath()%>/UserServlet" class="dropdown-btn">
                <i class="fas fa-user"></i> Profile
            </a>
            <form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;">
                <button type="submit" class="register-btn"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </form>
        </div>
    </div>
</nav>

<section class="booking-details">
    <div class="container">
        <h2>Confirm Your Appointment</h2>
        <%
            // Retrieve query parameters from URL
            String doctorUsername = request.getParameter("doctorUsername");
            String date = request.getParameter("date");
            String startTime = request.getParameter("startTime");
            String patientId = (String) session.getAttribute("userId"); // Set by LoginServlet

            if (doctorUsername == null || date == null || startTime == null || patientId == null) {
                response.sendRedirect(request.getContextPath() + "/pages/error.jsp?message=Missing+booking+details+or+not+logged+in");
                return;
            }
        %>
        <div class="booking-info">
            <p><strong>Doctor:</strong> <%= doctorUsername %></p>
            <p><strong>Date:</strong> <%= date %></p>
            <p><strong>Start Time:</strong> <%= startTime %></p>
            <p><strong>Patient ID:</strong> <%= patientId %></p>
        </div>

        <form action="<%=request.getContextPath()%>/AppointmentServlet" method="post">
            <input type="hidden" name="action" value="book">
            <input type="hidden" name="doctorUsername" value="<%= doctorUsername %>">
            <input type="hidden" name="date" value="<%= date %>">
            <input type="hidden" name="startTime" value="<%= startTime %>">
            <input type="hidden" name="patientId" value="<%= patientId %>">
            <div class="form-group">
                <label for="reason">Reason for Visit</label>
                <textarea id="reason" name="reason" class="form-input" required></textarea>
            </div>
            <div class="form-group select-wrapper">
                <label for="priority">Priority</label>
                <select id="priority" name="priority" class="form-input" required>
                    <option value="0">Normal</option>
                    <option value="1">Emergency</option>
                </select>
            </div>
            <button type="submit" class="cta-btn">Confirm Booking</button>
        </form>
    </div>
</section>

<footer>
    <div class="container footer-content">
        <p>© 2025 MediSchedule - Healthcare Simplified</p>
        <div class="footer-links">
            <a href="#">Privacy</a><a href="#">Terms</a><a href="#">Support</a>
        </div>
    </div>
</footer>
</body>
</html>