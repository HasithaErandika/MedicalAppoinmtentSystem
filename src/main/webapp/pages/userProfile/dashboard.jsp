<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="dashboard-card" id="dashboardSection" aria-labelledby="dashboard-title">
  <h2 id="dashboard-title">Your Dashboard</h2>
  <div class="dashboard-content">
    <div class="stats-grid">
      <div class="stat-card">
        <h3>Total Appointments</h3>
        <p class="stat-value">${appointments != null ? appointments.size() : 0}</p>
      </div>
      <div class="stat-card">
        <h3>Upcoming This Week</h3>
        <p class="stat-value">
          <c:set var="upcoming" value="0"/>
          <c:forEach var="appt" items="${appointments}">
            <c:if test="${appt.patientId == sessionScope.username}">
              <%-- Simple check for "this week"; replace with actual logic --%>
              <c:set var="upcoming" value="${upcoming + 1}"/>
            </c:if>
          </c:forEach>
          ${upcoming}
        </p>
      </div>
      <div class="stat-card">
        <h3>Emergency Bookings</h3>
        <p class="stat-value">
          <c:set var="emergency" value="0"/>
          <c:forEach var="appt" items="${appointments}">
            <c:if test="${appt.patientId == sessionScope.username && appt.priority == 1}">
              <c:set var="emergency" value="${emergency + 1}"/>
            </c:if>
          </c:forEach>
          ${emergency}
        </p>
      </div>
    </div>
    <div class="chart-container">
      <canvas id="appointmentChart" aria-label="Weekly Appointment Chart"></canvas>
    </div>
  </div>
</section>

<style>
  .dashboard-card {
    padding: 1.5rem;
    background: var(--card-bg);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow);
    max-width: 900px;
    margin: 0 auto;
    animation: fadeIn 0.3s ease;
  }

  h2 {
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  h2::before {
    content: "\e0e0"; /* Remixicon dashboard-line */
    font-family: "remixicon";
    color: var(--primary);
  }

  .dashboard-content {
    display: flex;
    flex-direction: column;
    gap: 2rem;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
  }

  .stat-card {
    background: var(--bg-light);
    padding: 1rem;
    border-radius: var(--border-radius);
    text-align: center;
    transition: var(--transition);
  }

  .stat-card:hover {
    background: var(--hover);
    transform: translateY(-4px);
    box-shadow: var(--shadow);
  }

  .stat-card h3 {
    font-size: 1.1rem;
    color: var(--text-primary);
    margin-bottom: 0.5rem;
  }

  .stat-value {
    font-size: 1.75rem;
    font-weight: 600;
    color: var(--primary);
  }

  .chart-container {
    padding: 1rem;
    background: var(--card-bg);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow);
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }

  @media (max-width: 768px) {
    .dashboard-card {
      padding: 1rem;
      max-width: 100%;
    }
    .stats-grid {
      grid-template-columns: 1fr;
    }
  }
</style>