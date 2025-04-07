<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Doctor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/doctorDashboard.css">
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"doctor".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        return;
    }
    String section = request.getParameter("section") != null ? request.getParameter("section") : "dashboard";
%>
<div class="sidebar">
    <h2><i class="ri-stethoscope-line"></i> Doctor Panel</h2>
    <ul>
        <li><a href="<%=request.getContextPath()%>/DoctorServlet?section=dashboard" class="<%= "dashboard".equals(section) ? "active" : "" %>"><i class="ri-dashboard-line"></i> Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/DoctorServlet?section=details" class="<%= "details".equals(section) ? "active" : "" %>"><i class="ri-user-line"></i> Personal Details</a></li>
        <li><a href="<%=request.getContextPath()%>/DoctorServlet?section=appointments" class="<%= "appointments".equals(section) ? "active" : "" %>"><i class="ri-calendar-2-line"></i> Appointments</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="container">
        <div class="header">
            <h1><i class="ri-stethoscope-line"></i> Doctor Dashboard</h1>
            <form action="<%=request.getContextPath()%>/LogoutServlet" method="post">
                <button type="submit" class="logout-btn"><i class="ri-logout-box-line"></i> Logout</button>
            </form>
        </div>

        <c:if test="${not empty error}">
            <div class="message error-message">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="message success-message">${message}</div>
        </c:if>

        <c:choose>
            <c:when test="${section == 'dashboard'}">
                <jsp:include page="dashboard.jsp" />
            </c:when>
            <c:when test="${section == 'details'}">
                <jsp:include page="doctorDetails.jsp" />
            </c:when>
            <c:when test="${section == 'appointments'}">
                <jsp:include page="appointments.jsp" />
            </c:when>
            <c:otherwise>
                <p>Section not found.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="<%= request.getContextPath() %>/js/doctorDashboard.js"></script>
</body>
</html>