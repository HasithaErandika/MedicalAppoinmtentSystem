<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section class="dashboard-card" id="bookAppointmentSection" aria-labelledby="book-appointment-title">
    <h2 id="book-appointment-title">Schedule Your Appointment</h2>
    <form id="bookForm" class="form-grid" novalidate>
        <div class="form-group">
            <label for="specialty">Specialty</label>
            <select id="specialty" name="specialty" aria-required="true" onchange="updateAvailabilityTable()">
                <option value="">Select Specialty</option>
            </select>
            <span class="error-message" id="specialty-error"></span>
        </div>
        <div id="filterContainer" style="display: none;">
            <div class="form-grid">
                <div class="form-group">
                    <label for="filterDoctor">Doctor Name</label>
                    <select id="filterDoctor" name="doctorId" onchange="filterTable()">
                        <option value="">All Doctors</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="filterDate">Preferred Date</label>
                    <select id="filterDate" name="date" onchange="filterTable()">
                        <option value="">All Dates</option>
                    </select>
                </div>
            </div>
        </div>
        <div id="availabilityTableContainer">
            <table id="availabilityTable" class="availability-table" style="display: none;">
                <thead>
                <tr>
                    <th>Doctor Name</th>
                    <th>Date</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </form>
</section>
<style>
    .availability-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .availability-table th, .availability-table td {
        padding: 12px;
        border-bottom: 1px solid #E5E7EB;
        text-align: left;
    }
    .availability-table th {
        background: var(--gradient);
        color: white;
    }
    .book-btn {
        background: var(--primary);
        color: white;
        padding: 8px 16px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    .book-btn:hover {
        background: var(--primary-hover);
        transform: translateY(-2px);
    }
</style>