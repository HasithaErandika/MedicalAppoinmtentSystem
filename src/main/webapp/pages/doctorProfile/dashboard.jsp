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

<style>

</style>

<script>
  // Prepare dashboard data
  const dashboardData = {
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
  console.log('Dashboard Data:', dashboardData);

  // Check if there's data to display
  if (!dashboardData.appointments.length && !Object.values(dashboardData.categoryData).some(val => val > 0)) {
    document.querySelector('.charts-section').innerHTML = '<p class="no-data">No appointment data available to display charts.</p>';
  } else {
    // Initialize charts when DOM is ready
    document.addEventListener('DOMContentLoaded', () => {
      // Category Chart
      const categoryCtx = document.getElementById('categoryChart').getContext('2d');
      new Chart(categoryCtx, {
        type: 'bar',
        data: {
          labels: ['Total', 'Upcoming', 'Emergency', 'Today', 'Completed'],
          datasets: [{
            label: 'Appointments',
            data: [
              dashboardData.categoryData.total,
              dashboardData.categoryData.upcoming,
              dashboardData.categoryData.emergency,
              dashboardData.categoryData.today,
              dashboardData.categoryData.completed
            ],
            backgroundColor: ['#2c3e50', '#38b2ac', '#e53e3e', '#667eea', '#2ecc71'],
            borderColor: ['#2c3e50', '#38b2ac', '#e53e3e', '#667eea', '#2ecc71'],
            borderWidth: 1
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: { beginAtZero: true, title: { display: true, text: 'Appointments' }, ticks: { stepSize: 1 } },
            x: { title: { display: true, text: 'Category' } }
          },
          plugins: {
            legend: { position: 'top' },
            title: { display: true, text: 'Appointment Categories', font: { size: 16 } }
          }
        }
      });

      // Trend Chart
      const trendCtx = document.getElementById('trendChart').getContext('2d');
      const trendData = processTrendData(dashboardData.appointments);
      new Chart(trendCtx, {
        type: 'line',
        data: {
          labels: trendData.labels,
          datasets: [{
            label: 'Appointments',
            data: trendData.counts,
            fill: true,
            borderColor: '#38b2ac',
            backgroundColor: 'rgba(56, 178, 172, 0.2)',
            tension: 0.3,
            pointBackgroundColor: '#38b2ac',
            pointBorderColor: '#fff',
            pointHoverRadius: 6
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: { beginAtZero: true, title: { display: true, text: 'Appointments' }, ticks: { stepSize: 1 } },
            x: { title: { display: true, text: 'Date' } }
          },
          plugins: {
            legend: { position: 'top' },
            title: { display: true, text: 'Appointment Trends (Last 7 Days)', font: { size: 16 } }
          }
        }
      });
    });
  }

  // Process trend data for the line chart
  function processTrendData(appointments) {
    const today = new Date();
    const labels = [];
    const counts = [];
    for (let i = 6; i >= 0; i--) {
      const date = new Date(today);
      date.setDate(today.getDate() - i);
      const dateStr = date.toISOString().split('T')[0];
      labels.push(dateStr);
      const count = appointments.filter(appt => appt.dateTime.startsWith(dateStr)).length;
      counts.push(count);
    }
    return { labels, counts };
  }
</script>