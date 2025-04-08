<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="dashboard-container">
  <div class="dashboard-grid">
    <div class="card" title="Total number of appointments scheduled" data-metric="${totalAppointments != null ? totalAppointments : 0}">
      <i class="fas fa-calendar-alt card-icon"></i>
      <h3>Total Appointments</h3>
      <p class="metric"><c:out value="${totalAppointments != null ? totalAppointments : 0}" /></p>
    </div>
    <div class="card" title="Appointments scheduled in the future" data-metric="${upcomingAppointments != null ? upcomingAppointments : 0}">
      <i class="fas fa-calendar-plus card-icon"></i>
      <h3>Upcoming</h3>
      <p class="metric"><c:out value="${upcomingAppointments != null ? upcomingAppointments : 0}" /></p>
    </div>
    <div class="card" title="High-priority appointments" data-metric="${emergencyAppointments != null ? emergencyAppointments : 0}">
      <i class="fas fa-exclamation-triangle card-icon"></i>
      <h3>Emergency</h3>
      <p class="metric"><c:out value="${emergencyAppointments != null ? emergencyAppointments : 0}" /></p>
    </div>
    <div class="card" title="Appointments scheduled for today" data-metric="${todayAppointments != null ? todayAppointments : 0}">
      <i class="fas fa-calendar-day card-icon"></i>
      <h3>Today</h3>
      <p class="metric"><c:out value="${todayAppointments != null ? todayAppointments : 0}" /></p>
    </div>
    <div class="card" title="Appointments completed" data-metric="${completedAppointments != null ? completedAppointments : 0}">
      <i class="fas fa-check-double card-icon"></i>
      <h3>Completed</h3>
      <p class="metric"><c:out value="${completedAppointments != null ? completedAppointments : 0}" /></p>
    </div>
  </div>

  <div class="charts-section">
    <div class="chart-card">
      <h2><i class="fas fa-chart-bar"></i> Appointment Categories</h2>
      <div class="chart-container">
        <canvas id="categoryChart"></canvas>
      </div>
    </div>
    <div class="chart-card">
      <h2><i class="fas fa-chart-line"></i> Appointment Trends</h2>
      <div class="chart-container">
        <canvas id="trendChart"></canvas>
      </div>
    </div>
  </div>
</div>

<style>
  .dashboard-container {
    max-width: 1200px;
    margin: 0 auto;
  }

  .dashboard-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
  }

  .card {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    text-align: center;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
  }

  .card-icon {
    font-size: 2rem;
    color: var(--secondary);
    margin-bottom: 1rem;
  }

  .card h3 {
    font-size: 1.2rem;
    margin: 0.5rem 0;
    color: var(--text);
  }

  .card .metric {
    font-size: 2rem;
    font-weight: 700;
    color: var(--primary);
    margin: 0;
  }

  .charts-section {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
  }

  .chart-card {
    background: white;
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .chart-card h2 {
    font-size: 1.3rem;
    margin: 0 0 1rem;
    color: var(--text);
    display: flex;
    align-items: center;
  }

  .chart-card h2 i {
    margin-right: 0.5rem;
    color: var(--secondary);
  }

  .chart-container {
    position: relative;
    height: 300px;
  }

  @media (max-width: 768px) {
    .charts-section {
      grid-template-columns: 1fr;
    }
  }
</style>

<script>
  // Chart initialization moved to doctorDashboard.js, but data is prepared here
  window.dashboardData = {
    appointments: [
      <c:forEach var="appt" items="${appointments}" varStatus="loop">
      { id: '${appt.id}', patientId: '${appt.patientId}', dateTime: '${appt.dateTime}', priority: ${appt.priority} }${loop.last ? '' : ','}
      </c:forEach>
    ],
    categoryData: {
      total: ${totalAppointments != null ? totalAppointments : 0},
      upcoming: ${upcomingAppointments != null ? upcomingAppointments : 0},
      emergency: ${emergencyAppointments != null ? emergencyAppointments : 0},
      today: ${todayAppointments != null ? todayAppointments : 0},
      completed: ${completedAppointments != null ? completedAppointments : 0}
    }
  };
</script>