<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Doctor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/doctorDashboard.css">
</head>
<body>
<c:if test="${empty sessionScope.username || sessionScope.role != 'doctor'}">
    <c:redirect url="/pages/login.jsp?role=doctor"/>
</c:if>

<aside class="sidebar" id="sidebar" aria-label="Main navigation">
    <button class="sidebar-toggle" aria-label="Toggle sidebar" type="button">
        <i class="fas fa-bars"></i>
    </button>
    <div class="logo">
        <i class="fas fa-stethoscope" aria-hidden="true"></i>
        <span>MediSchedule</span>
    </div>
    <nav class="sidebar-nav">
        <ul>
            <li>
                <a href="#" data-section="dashboard" class="nav-link ${param.section == null || param.section == 'dashboard' ? 'active' : ''}">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            <li>
                <a href="#" data-section="details" class="nav-link ${param.section == 'details' ? 'active' : ''}">
                    <i class="fas fa-user-md"></i>
                    <span>Personal Details</span>
                </a>
            </li>
            <li>
                <a href="#" data-section="appointments" class="nav-link ${param.section == 'appointments' ? 'active' : ''}">
                    <i class="fas fa-calendar-check"></i>
                    <span>Appointments</span>
                </a>
            </li>
            <li>
                <form action="<%= request.getContextPath() %>/LogoutServlet" method="post" class="logout-form">
                    <a href="#" onclick="this.parentNode.submit();" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </form>
            </li>
        </ul>
    </nav>
</aside>

<main class="main-content" id="main-content" aria-live="polite">
    <div class="container">
        <header class="dashboard-header">
            <div class="user-info">
                <div class="avatar" aria-hidden="true">
                    <c:out value="${not empty sessionScope.username ? sessionScope.username.substring(0, 1).toUpperCase() : 'D'}" />
                </div>
                <h1>Welcome,
                    <span class="doctor-name">
                            <c:choose>
                                <c:when test="${not empty doctor.name}">
                                    <c:out value="${doctor.name}" />
                                </c:when>
                                <c:when test="${not empty sessionScope.username}">
                                    <c:out value="${sessionScope.username}" />
                                </c:when>
                                <c:otherwise>
                                    Doctor
                                </c:otherwise>
                            </c:choose>
                        </span>!
                </h1>
            </div>
            <time class="date" datetime="<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />">
                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy" />
            </time>
        </header>

        <c:if test="${not empty message}">
            <div class="toast ${messageType == 'error' ? 'error' : ''}" role="alert" aria-live="assertive">
                <i class="fas ${messageType == 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
                <span><c:out value="${message}" /></span>
            </div>
            <c:remove var="message" scope="request" />
            <c:remove var="messageType" scope="request" />
        </c:if>

        <section id="content-area" class="content-area">
            <div class="loading-spinner">
                <i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: var(--secondary);"></i>
            </div>
        </section>
    </div>
</main>

<script src="<%= request.getContextPath() %>/assets/js/doctorDashboard.js"></script>
<script>
    window.contextPath = '<%= request.getContextPath() %>';

    // Sidebar toggle functionality
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main-content');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    toggleBtn.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('collapsed');
    });
</script>
</body>
</html>