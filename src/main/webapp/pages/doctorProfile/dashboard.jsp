<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="dashboard-container">
  <!-- Summary Cards -->
  <div class="dashboard-grid">
    <div class="card" title="Total number of appointments scheduled">
      <i class="ri-calendar-2-line"></i>
      <h3>Total Appointments</h3>
      <p class="metric">${totalAppointments != null ? totalAppointments : 0}</p>
    </div>
    <div class="card" title="Appointments scheduled in the future">
      <i class="ri-calendar-todo-line"></i>
      <h3>Upcoming</h3>
      <p class="metric">${upcomingAppointments != null ? upcomingAppointments : 0}</p>
    </div>
    <div class="card" title="High-priority appointments">
      <i class="ri-alert-line"></i>
      <h3>Emergency</h3>
      <p class="metric">${emergencyAppointments != null ? emergencyAppointments : 0}</p>
    </div>
    <div class="card" title="Appointments scheduled for today">
      <i class="ri-calendar-event-line"></i>
      <h3>Today</h3>
      <p class="metric">${todayAppointments != null ? todayAppointments : 0}</p>
    </div>
    <div class="card" title="Appointments completed">
      <i class="ri-check-double-line"></i>
      <h3>Completed</h3>
      <p class="metric">${completedAppointments != null ? completedAppointments : 0}</p>
    </div>
  </div>

  <!-- Charts Section -->
  <div class="charts-section">
    <div class="chart-card">
      <h2><i class="ri-bar-chart-line"></i> Appointment Categories</h2>
      <div class="chart-container">
        <canvas id="categoryChart"></canvas>
      </div>
    </div>
    <div class="chart-card">
      <h2><i class="ri-line-chart-line"></i> Appointment Trends</h2>
      <div class="chart-container">
        <canvas id="trendChart"></canvas>
      </div>
    </div>
  </div>
</div>

<style>
  :root {
    --primary: #2C5282;
    --secondary: #38B2AC;
    --accent: #E53E3E;
    --bg-light: #F7FAFC;
    --text-primary: #2D3748;
    --text-muted: #718096;
    --card-bg: #FFFFFF;
    --shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
    --border: #E2E8F0;
    --hover: #EDF2F7;
    --transition: all 0.3s ease;
    --border-radius: 12px;
    --spacing-unit: 1rem;
  }

  .dashboard-container {
    padding: var(--spacing-unit);
  }

  .dashboard-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: var(--spacing-unit);
    margin-bottom: calc(var(--spacing-unit) * 2);
  }

  .card {
    background: var(--card-bg);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow);
    padding: var(--spacing-unit);
    text-align: center;
    transition: var(--transition);
    cursor: default;
  }

  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    background: var(--hover);
  }

  .card i {
    font-size: 2rem;
    color: var(--secondary);
    margin-bottom: 0.5rem;
  }

  .card h3 {
    font-size: 1.1rem;
    color: var(--text-primary);
    margin: 0.5rem 0;
  }

  .card .metric {
    font-size: 1.8rem;
    font-weight: 600;
    color: var(--primary);
    margin: 0;
  }

  .charts-section {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: var(--spacing-unit);
  }

  .chart-card {
    background: var(--card-bg);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow);
    padding: var(--spacing-unit);
  }

  .chart-card h2 {
    font-size: 1.5rem;
    color: var(--text-primary);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: var(--spacing-unit);
  }

  .chart-card h2 i {
    color: var(--secondary);
  }

  .chart-container {
    position: relative;
    height: 300px;
    width: 100%;
  }

  @media (max-width: 768px) {
    .charts-section {
      grid-template-columns: 1fr;
    }
  }

  @media (max-width: 480px) {
    .dashboard-grid {
      grid-template-columns: 1fr;
    }

    .card .metric {
      font-size: 1.5rem;
    }
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const appointments = [
      <c:forEach var="appt" items="${appointments}" varStatus="loop">
      { id: '${appt.id}', patientId: '${appt.patientId}', dateTime: '${appt.dateTime}', priority: ${appt.priority} }${loop.last ? '' : ','}
      </c:forEach>
    ];

    // Category Chart (Bar)
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
          backgroundColor: [
            'rgba(44, 82, 130, 0.8)',
            'rgba(56, 178, 172, 0.8)',
            'rgba(229, 62, 62, 0.8)',
            'rgba(102, 126, 234, 0.8)',
            'rgba(46, 204, 113, 0.8)'
          ],
          borderColor: [
            'rgba(44, 82, 130, 1)',
            'rgba(56, 178, 172, 1)',
            'rgba(229, 62, 62, 1)',
            'rgba(102, 126, 234, 1)',
            'rgba(46, 204, 113, 1)'
          ],
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
          title: { display: true, text: 'Appointment Categories', font: { size: 16 } },
          tooltip: { enabled: true }
        }
      }
    });

    // Trend Chart (Line)
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
          pointHoverRadius: 5,
          pointHoverBackgroundColor: 'rgba(56, 178, 172, 1)'
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
          title: { display: true, text: 'Appointment Trends (Last 7 Days)', font: { size: 16 } },
          tooltip: { enabled: true }
        }
      }
    });
  });

  // Process appointments for trend data (last 7 days)
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