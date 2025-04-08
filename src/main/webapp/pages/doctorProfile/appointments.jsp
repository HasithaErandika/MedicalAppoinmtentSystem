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


<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/doctorDashboard.css">