<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="section">
  <h2><i class="ri-calendar-2-line"></i> Your Appointments</h2>
  <c:choose>
    <c:when test="${not empty appointments}">
      <table>
        <thead>
        <tr>
          <th>ID</th>
          <th>Patient Name</th>
          <th>Date & Time</th>
          <th>Priority</th>
          <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="appt" items="${appointments}">
          <tr>
            <td>${appt.id}</td>
            <td>${appt.patientName != null ? appt.patientName : 'Unknown'}</td>
            <td>${appt.dateTime}</td>
            <td>${appt.priority == 1 ? 'Emergency' : 'Regular'}</td>
            <td>
              <form action="<%=request.getContextPath()%>/DoctorServlet" method="post" style="display:inline;">
                <input type="hidden" name="action" value="cancelAppointment">
                <input type="hidden" name="appointmentId" value="${appt.id}">
                <button type="submit" class="btn btn-cancel"><i class="ri-close-line"></i> Cancel</button>
              </form>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </c:when>
    <c:otherwise>
      <p>No appointments found.</p>
    </c:otherwise>
  </c:choose>
</div>