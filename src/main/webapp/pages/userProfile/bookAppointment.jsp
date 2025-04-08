<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="dashboard-card book-appointment-section" id="bookAppointmentSection" aria-labelledby="book-appointment-title">
    <header class="section-header">
        <h2 id="book-appointment-title">
            <i class="fas fa-calendar-plus" aria-hidden="true"></i> Schedule Your Appointment
        </h2>
    </header>

    <form id="bookForm" class="appointment-form" novalidate>
        <div class="form-field">
            <label for="specialty" class="form-label">Specialty</label>
            <select id="specialty" name="specialty" class="form-select" required aria-required="true" aria-describedby="specialty-error" onchange="updateAvailabilityTable()">
                <option value="">Select Specialty</option>
            </select>
            <span class="error-text" id="specialty-error" aria-live="polite"></span>
        </div>

        <div id="filterContainer" class="filter-section" style="display: none;">
            <div class="filter-grid">
                <div class="form-field">
                    <label for="filterDoctor" class="form-label">Doctor Name</label>
                    <select id="filterDoctor" name="doctorId" class="form-select" onchange="filterTable()">
                        <option value="">All Doctors</option>
                    </select>
                </div>
                <div class="form-field">
                    <label for="filterDate" class="form-label">Preferred Date</label>
                    <select id="filterDate" name="date" class="form-select" onchange="filterTable()">
                        <option value="">All Dates</option>
                    </select>
                </div>
            </div>
        </div>

        <div id="availabilityTableContainer" class="table-section">
            <table id="availabilityTable" class="availability-table" style="display: none;" aria-label="Doctor Availability">
                <thead>
                <tr>
                    <th scope="col">Doctor Name</th>
                    <th scope="col">Date</th>
                    <th scope="col">Start Time</th>
                    <th scope="col">End Time</th>
                    <th scope="col">Appointments Booked</th>
                    <th scope="col">Your Token</th>
                    <th scope="col">Action</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
            <div id="noResults" class="no-results" style="display: none;">
                <i class="fas fa-calendar-times" aria-hidden="true"></i>
                <p>No available appointments found.</p>
            </div>
        </div>
    </form>
</section>

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/userProfile.css">