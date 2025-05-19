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

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/doctorDashboard.css">