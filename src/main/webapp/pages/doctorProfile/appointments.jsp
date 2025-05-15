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
                <td><c:out value="${patientNames[appt.patientId] != null ? patientNames[appt.patientId] : 'Unknown'}" /></td>
                <td><c:out value="${appt.dateTime}" /></td>
                <td>
                  <span class="priority-badge ${appt.priority == 1 ? 'emergency' : 'regular'}">
                    <c:out value="${appt.priority == 1 ? 'Emergency' : 'Regular'}" />
                  </span>
                </td>
                <td>
                  <button class="btn btn-cancel" onclick="showCancelModal(${appt.id}, '${patientNames[appt.patientId] != null ? patientNames[appt.patientId] : 'Unknown'}', '${appt.dateTime}')" aria-label="Cancel Appointment ${appt.id}">
                    <i class="fas fa-times"></i> Cancel
                  </button>
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

  <!-- Cancel Confirmation Modal -->
  <dialog id="cancelModal" class="modal" aria-labelledby="cancel-modal-title">
    <div class="modal-content">
      <h3 id="cancel-modal-title">Confirm Cancellation</h3>
      <p id="cancelMessage">Are you sure you want to cancel this appointment?</p>
      <div id="cancelAppointmentDetails" class="appointment-details"></div>
      <div class="modal-actions">
        <button id="cancelModalCancelBtn" class="cancel-btn" type="button" onclick="closeCancelModal()">No, Keep</button>
        <button id="cancelModalConfirmBtn" class="confirm-btn" type="button">Yes, Cancel</button>
      </div>
    </div>
  </dialog>
</div>

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/doctorDashboard.css">