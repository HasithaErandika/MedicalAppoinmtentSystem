<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="dashboard-container">
  <div class="dashboard-grid">
    <div class="card" title="Total number of appointments scheduled">
      <i class="fas fa-calendar-alt"></i>
      <h3>Total Appointments</h3>
      <p class="metric"><c:out value="${totalAppointments != null ? totalAppointments : 0}" /></p>
    </div>
    <div class="card" title="Appointments scheduled in the future">
      <i class="fas fa-calendar-plus"></i>
      <h3>Upcoming</h3>
      <p class="metric"><c:out value="${upcomingAppointments != null ? upcomingAppointments : 0}" /></p>
    </div>
    <div class="card" title="High-priority appointments">
      <i class="fas fa-exclamation-triangle"></i>
      <h3>Emergency</h3>
      <p class="metric"><c:out value="${emergencyAppointments != null ? emergencyAppointments : 0}" /></p>
    </div>
    <div class="card" title="Appointments scheduled for today">
      <i class="fas fa-calendar-day"></i>
      <h3>Today</h3>
      <p class="metric"><c:out value="${todayAppointments != null ? todayAppointments : 0}" /></p>
    </div>
    <div class="card" title="Appointments completed">
      <i class="fas fa-check-double"></i>
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

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const appointments = [
      <c:forEach var="appt" items="${appointments}" varStatus="loop">
      { id: '${appt.id}', patientId: '${appt.patientId}', dateTime: '${appt.dateTime}', priority: ${appt.priority} }${loop.last ? '' : ','}
      </c:forEach>
    ];

    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
    new Chart(categoryCtx, {
      type: 'bar',
      data: {
        labels: ['Total', 'Upcoming', 'Emergency', 'Today', 'Completed'],
        datasets: [{
          label: 'Appointments',
          data: [
            ${totalAppointments != null ? totalAppointments : 0},
            ${upcomingAppointments != null ? upcomingAppointments : 0},
            ${emergencyAppointments != null ? emergencyAppointments : 0},
            ${todayAppointments != null ? todayAppointments : 0},
            ${completedAppointments != null ? completedAppointments : 0}
          ],
          backgroundColor: ['rgba(44, 82, 130, 0.8)', 'rgba(56, 178, 172, 0.8)', 'rgba(229, 62, 62, 0.8)', 'rgba(102, 126, 234, 0.8)', 'rgba(46, 204, 113, 0.8)'],
          borderColor: ['rgba(44, 82, 130, 1)', 'rgba(56, 178, 172, 1)', 'rgba(229, 62, 62, 1)', 'rgba(102, 126, 234, 1)', 'rgba(46, 204, 113, 1)'],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: { beginAtZero: true, title: { display: true, text: 'Number of Appointments' }, ticks: { stepSize: 1 } },
          x: { title: { display: true, text: 'Category' } }
        },
        plugins: {
          legend: { display: true, position: 'top' },
          title: { display: true, text: 'Appointment Categories', font: { size: 16 } }
        }
      }
    });

    const trendData = processTrendData(appointments);
    const trendCtx = document.getElementById('trendChart').getContext('2d');
    new Chart(trendCtx, {
      type: 'line',
      data: {
        labels: trendData.labels,
        datasets: [{
          label: 'Appointments',
          data: trendData.counts,
          fill: false,
          borderColor: 'rgba(56, 178, 172, 1)',
          backgroundColor: 'rgba(56, 178, 172, 0.2)',
          tension: 0.1,
          pointBackgroundColor: 'rgba(56, 178, 172, 1)',
          pointBorderColor: '#fff',
          pointHoverRadius: 5
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: { beginAtZero: true, title: { display: true, text: 'Number of Appointments' }, ticks: { stepSize: 1 } },
          x: { title: { display: true, text: 'Date' } }
        },
        plugins: {
          legend: { display: true, position: 'top' },
          title: { display: true, text: 'Appointment Trends (Last 7 Days)', font: { size: 16 } }
        }
      }
    });
  });

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