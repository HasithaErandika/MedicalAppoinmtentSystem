
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="dashboard-card" id="appointmentsSection" aria-labelledby="appointments-title">
    <h2 id="appointments-title">Your Upcoming Appointments</h2>
    <div class="table-wrapper">
        <table role="grid" aria-label="Upcoming Appointments">
            <thead>
            <tr>
                <th scope="col" data-sort="0">ID <i class="fas fa-sort"></i></th>
                <th scope="col" data-sort="1">Doctor <i class="fas fa-sort"></i></th>
                <th scope="col" data-sort="2">Date & Time <i class="fas fa-sort"></i></th>
                <th scope="col" data-sort="3">Priority <i class="fas fa-sort"></i></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="appt" items="${appointments}">
                <tr>
                    <td>${appt.id}</td>
                    <td>${appt.doctorId}</td>
                    <td>${appt.dateTime}</td>
                    <td class="${appt.priority == 1 ? 'priority-high' : 'priority-normal'}">
                            ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</section>