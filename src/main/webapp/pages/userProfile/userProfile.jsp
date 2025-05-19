<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MediSchedule – User Profile</title>

    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" />

    <!-- Date Picker -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.css" />

    <!-- Custom Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/userProfile.css" />
</head>
<body>

<!-- 🔐 Authentication Check -->
<c:if test="${empty sessionScope.username || sessionScope.role != 'patient'}">
    <c:redirect url="/pages/login.jsp?role=patient" />
</c:if>

<!-- 🚀 Trigger backend init if needed -->
<c:if test="${empty sessionScope.fullname}">
    <%
        response.sendRedirect(request.getContextPath() + "/user?action=init");
    %>
</c:if>

<!-- 🧭 Sidebar -->
<aside class="sidebar" id="sidebar" aria-label="Sidebar navigation">
    <button class="sidebar-toggle" aria-label="Toggle navigation">
        <i class="fas fa-bars"></i>
    </button>
    <div class="logo">
        <i class="fas fa-heartbeat"></i> <span>MediSchedule</span>
    </div>
    <nav>
        <ul class="sidebar-nav">
            <li>
                <a href="#" data-section="userDetails" class="nav-link">
                    <i class="fas fa-user"></i> <span>My Details</span>
                </a>
            </li>
            <li>
                <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="logout-form">
                    <a href="#" onclick="this.closest('form').submit();" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                    </a>
                </form>
            </li>
        </ul>
    </nav>
</aside>

<!-- 🧩 Main Content -->
<main class="main-content" id="main-content">
    <div class="container">
        <!-- 🔷 Welcome Header -->
        <header class="dashboard-header">
            <div class="user-info">
                <div class="avatar" title="User Avatar">
                    <c:out value="${not empty sessionScope.username ? sessionScope.username.substring(0, 1).toUpperCase() : 'U'}" />
                </div>
                <h1>
                    Welcome,
                    <span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.fullname}">
                                <c:out value="${sessionScope.fullname}" />
                            </c:when>
                            <c:when test="${not empty sessionScope.username}">
                                <c:out value="${sessionScope.username}" />
                            </c:when>
                            <c:otherwise>User</c:otherwise>
                        </c:choose>
                    </span>!
                </h1>
            </div>
            <time class="date" datetime="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %>
            </time>
        </header>

        <!-- ✅ Toast Messages -->
        <c:if test="${not empty message}">
            <div class="toast ${messageType}" role="alert" aria-live="assertive">
                <i class="fas ${messageType == 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
                <span><c:out value="${message}" /></span>
            </div>
            <c:remove var="message" scope="request" />
            <c:remove var="messageType" scope="request" />
        </c:if>

        <!-- 📝 Profile Content Placeholder -->
        <div id="userProfileContainer">
            <!-- AJAX loads user profile content here -->
        </div>

    </div>
</main>

<!-- 📜 Scripts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/flatpickr/4.6.13/flatpickr.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/userProfile.js"></script>
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
</body>
</html>
