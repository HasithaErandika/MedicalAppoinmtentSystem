<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="dashboard-card appointments-section" id="appointmentsSection" aria-labelledby="appointments-title">
    <header class="section-header">
        <h2 id="appointments-title">
            <i class="fas fa-calendar-alt" aria-hidden="true"></i> Your Appointments
        </h2>
    </header>

    <div class="table-container">
        <table role="grid" class="appointments-table" aria-label="Your Appointments">
            <thead>
            <tr>
                <th scope="col" data-sort="0" class="sortable" onclick="sortTable(0)">
                    ID <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="1" class="sortable" onclick="sortTable(1)">
                    Doctor <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="2" class="sortable" onclick="sortTable(2)">
                    Token <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="3" class="sortable" onclick="sortTable(3)">
                    Date & Time <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="4" class="sortable" onclick="sortTable(4)">
                    Priority <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
            </tr>
            </thead>
            <tbody>
            <!-- Table body will be populated dynamically by UserProfile.js -->
            </tbody>
        </table>
        <div class="no-appointments" id="noAppointmentsMessage" style="display: none;">
            <i class="fas fa-calendar-times" aria-hidden="true"></i>
            <p>No appointments found.</p>
        </div>
    </div>
</section>

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/userProfile.css">