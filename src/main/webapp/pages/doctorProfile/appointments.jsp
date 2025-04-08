<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="appointments-section">
  <header class="section-header">
    <h2><i class="fas fa-calendar-alt"></i> Your Appointments</h2>
  </header>

  <div class="appointments-container">
    <c:choose>
      <c:when test="${not empty appointments}">
        <div class="table-wrapper">
          <table>
            <thead>
            <tr>
              <th data-type="number">ID</th>
              <th>Patient Name</th>
              <th data-type="date">Date & Time</th>
              <th data-type="priority">Priority</th>
              <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="appt" items="${appointments}">
              <tr>
                <td><c:out value="${appt.id}" /></td>
                <td><c:out value="${appt.patientName != null ? appt.patientName : 'Unknown'}" /></td>
                <td><c:out value="${appt.dateTime}" /></td>
                <td>
                                        <span class="priority-badge ${appt.priority == 1 ? 'emergency' : 'regular'}">
                                            <c:out value="${appt.priority == 1 ? 'Emergency' : 'Regular'}" />
                                        </span>
                </td>
                <td>
                  <form action="<%= request.getContextPath() %>/DoctorServlet" method="post" class="cancel-form">
                    <input type="hidden" name="action" value="cancelAppointment">
                    <input type="hidden" name="appointmentId" value="${appt.id}">
                    <button type="submit" class="btn btn-cancel" aria-label="Cancel Appointment ${appt.id}">
                      <i class="fas fa-times"></i> Cancel
                    </button>
                  </form>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
        </div>
      </c:when>
      <c:otherwise>
        <div class="no-appointments">
          <i class="fas fa-calendar-times"></i>
          <p>No appointments found.</p>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<style>
  .appointments-section {
    max-width: 1000px;
    margin: 0 auto;
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    padding: 2rem;
    animation: fadeIn 0.5s ease-in;
  }

  .section-header {
    margin-bottom: 1.5rem;
    border-bottom: 2px solid var(--secondary);
    padding-bottom: 0.5rem;
  }

  .section-header h2 {
    font-size: 1.5rem;
    color: var(--text);
    display: flex;
    align-items: center;
  }

  .section-header i {
    margin-right: 0.5rem;
    color: var(--secondary);
  }

  .appointments-container {
    overflow-x: auto;
  }

  .table-wrapper {
    width: 100%;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.95rem;
  }

  th, td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid #eee;
  }

  th {
    background: var(--primary);
    color: white;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.3s ease;
  }

  th:hover {
    background: #34495e;
  }

  tr {
    transition: background 0.2s ease;
  }

  tr:hover {
    background: #f5f6fa;
  }

  .priority-badge {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    border-radius: 12px;
    font-size: 0.85rem;
    font-weight: 500;
  }

  .priority-badge.emergency {
    background: var(--accent);
    color: white;
  }

  .priority-badge.regular {
    background: #2ecc71;
    color: white;
  }

  .btn-cancel {
    padding: 0.5rem 1rem;
    background: var(--accent);
    color: white;
    border: none;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.3s ease, transform 0.2s ease;
  }

  .btn-cancel:hover {
    background: #c0392b;
    transform: translateY(-2px);
  }

  .btn-cancel i {
    margin-right: 0.5rem;
  }

  .cancel-form {
    display: inline;
  }

  .no-appointments {
    text-align: center;
    padding: 2rem;
    color: #7f8c8d;
  }

  .no-appointments i {
    font-size: 2rem;
    margin-bottom: 1rem;
    color: var(--secondary);
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  @media (max-width: 768px) {
    th, td {
      padding: 0.75rem;
    }
    .appointments-container {
      overflow-x: auto;
    }
  }
</style>