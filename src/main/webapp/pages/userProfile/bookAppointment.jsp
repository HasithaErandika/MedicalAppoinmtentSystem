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
                <option value="cardiology">Cardiology</option>
                <option value="neurology">Neurology</option>
                <option value="orthopedics">Orthopedics</option>
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
                    <th scope="col">Action</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
            <div id="noResults" class="no-results" style="display: none;">
                <i class="fas fa-calendar-times" aria-hidden="true"></i>
                <p>No available appointments found.</p>
            </div>
        </div>
    </form>
</section>

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

    .book-appointment-section {
        background: var(--card-bg);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        padding: calc(var(--spacing-unit) * 2);
        max-width: 1100px;
        margin: 0 auto;
        animation: fadeIn 0.4s ease-out;
    }

    .section-header {
        margin-bottom: calc(var(--spacing-unit) * 1.5);
        padding-bottom: var(--spacing-unit);
        border-bottom: 1px solid var(--border);
    }

    .section-header h2 {
        font-size: 1.75rem;
        font-weight: 600;
        color: var(--primary);
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .section-header h2 i {
        color: var(--secondary);
    }

    .appointment-form {
        display: flex;
        flex-direction: column;
        gap: calc(var(--spacing-unit) * 1.5);
    }

    .form-field {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .form-label {
        font-weight: 500;
        color: var(--text-primary);
        font-size: 0.95rem;
    }

    .form-select {
        padding: 0.75rem;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 1rem;
        color: var(--text-primary);
        background: var(--card-bg);
        transition: var(--transition);
        cursor: pointer;
        appearance: none;
        background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="%232D3748" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>');
        background-repeat: no-repeat;
        background-position: right 0.75rem center;
        width: 100%;
    }

    .form-select:focus {
        border-color: var(--secondary);
        box-shadow: 0 0 8px rgba(56, 178, 172, 0.2);
        outline: none;
    }

    .form-select:invalid {
        color: var(--text-muted);
    }

    .error-text {
        color: var(--accent);
        font-size: 0.85rem;
        min-height: 1rem;
    }

    .filter-section {
        padding: var(--spacing-unit);
        background: var(--bg-light);
        border-radius: var(--border-radius);
        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
        animation: slideIn 0.3s ease-out;
    }

    .filter-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: calc(var(--spacing-unit) * 1.5);
    }

    .table-section {
        margin-top: calc(var(--spacing-unit) * 1.5);
        overflow-x: auto;
        border-radius: var(--border-radius);
        background: var(--card-bg);
        box-shadow: var(--shadow);
    }

    .availability-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        font-size: 1rem;
    }

    .availability-table th,
    .availability-table td {
        padding: calc(var(--spacing-unit) * 1.25);
        text-align: left;
        border-bottom: 1px solid var(--border);
    }

    .availability-table th {
        background: var(--primary);
        color: #FFFFFF;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .availability-table th:first-child {
        border-top-left-radius: var(--border-radius);
    }

    .availability-table th:last-child {
        border-top-right-radius: var(--border-radius);
    }

    .availability-table tr {
        transition: var(--transition);
    }

    .availability-table tr:hover {
        background: var(--hover);
        box-shadow: inset 0 0 0 1px var(--secondary);
    }

    .availability-table td {
        color: var(--text-primary);
    }

    .book-btn {
        background: var(--secondary);
        color: #FFFFFF;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 500;
        transition: var(--transition);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .book-btn:hover {
        background: #2B928C;
        box-shadow: 0 4px 12px rgba(56, 178, 172, 0.3);
        transform: translateY(-2px);
    }

    .no-results {
        text-align: center;
        padding: calc(var(--spacing-unit) * 2);
        color: var(--text-muted);
        font-style: italic;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.75rem;
    }

    .no-results i {
        font-size: 1.75rem;
        color: var(--text-muted);
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(15px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideIn {
        from { opacity: 0; transform: translateY(-15px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 768px) {
        .book-appointment-section {
            padding: var(--spacing-unit);
            max-width: 100%;
        }

        .filter-grid {
            grid-template-columns: 1fr;
            gap: var(--spacing-unit);
        }

        .availability-table th,
        .availability-table td {
            padding: var(--spacing-unit);
            font-size: 0.9rem;
        }

        .book-btn {
            width: 100%;
            justify-content: center;
        }

        .section-header h2 {
            font-size: 1.5rem;
        }
    }

    @media (max-width: 480px) {
        .availability-table th,
        .availability-table td {
            font-size: 0.85rem;
            padding: 0.75rem;
        }

        .book-btn {
            padding: 0.5rem;
            font-size: 0.9rem;
        }
    }
</style>

<script>
    function updateAvailabilityTable() {
        const specialty = document.getElementById('specialty').value;
        const filterContainer = document.getElementById('filterContainer');
        const table = document.getElementById('availabilityTable');
        const tbody = table.querySelector('tbody');
        const noResults = document.getElementById('noResults');

        if (!specialty) {
            document.getElementById('specialty-error').textContent = 'Please select a specialty';
            filterContainer.style.display = 'none';
            table.style.display = 'none';
            noResults.style.display = 'none';
            return;
        }
        document.getElementById('specialty-error').textContent = '';

        // Simulate fetching data (replace with actual AJAX call)
        const mockData = [
            { doctor: 'Dr. Smith', date: '2025-04-10', start: '09:00', end: '09:30' },
            { doctor: 'Dr. Jones', date: '2025-04-11', start: '14:00', end: '14:30' },
            { doctor: 'Dr. Smith', date: '2025-04-12', start: '10:00', end: '10:30' }
        ];

        filterContainer.style.display = 'block';
        table.style.display = 'table';
        tbody.innerHTML = '';

        if (mockData.length === 0) {
            noResults.style.display = 'block';
            table.style.display = 'none';
        } else {
            noResults.style.display = 'none';
            mockData.forEach(slot => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${slot.doctor}</td>
                    <td>${slot.date}</td>
                    <td>${slot.start}</td>
                    <td>${slot.end}</td>
                    <td><button class="book-btn" onclick="bookAppointment('${slot.doctor}', '${slot.date}', '${slot.start}')">
                        <i class="fas fa-calendar-check" aria-hidden="true"></i> Book
                    </button></td>
                `;
                tbody.appendChild(row);
            });

            // Populate filter dropdowns
            const filterDoctor = document.getElementById('filterDoctor');
            const filterDate = document.getElementById('filterDate');
            const uniqueDoctors = [...new Set(mockData.map(slot => slot.doctor))];
            const uniqueDates = [...new Set(mockData.map(slot => slot.date))];
            filterDoctor.innerHTML = '<option value="">All Doctors</option>' +
                uniqueDoctors.map(doc => `<option value="${doc}">${doc}</option>`).join('');
            filterDate.innerHTML = '<option value="">All Dates</option>' +
                uniqueDates.map(date => `<option value="${date}">${date}</option>`).join('');
        }
    }

    function filterTable() {
        const doctor = document.getElementById('filterDoctor').value;
        const date = document.getElementById('filterDate').value;
        const rows = document.querySelectorAll('#availabilityTable tbody tr');
        const noResults = document.getElementById('noResults');
        let visibleRows = 0;

        rows.forEach(row => {
            const rowDoctor = row.cells[0].textContent;
            const rowDate = row.cells[1].textContent;
            const matchesDoctor = !doctor || rowDoctor === doctor;
            const matchesDate = !date || rowDate === date;

            if (matchesDoctor && matchesDate) {
                row.style.display = '';
                visibleRows++;
            } else {
                row.style.display = 'none';
            }
        });

        noResults.style.display = visibleRows === 0 ? 'block' : 'none';
        document.getElementById('availabilityTable').style.display = visibleRows === 0 ? 'none' : 'table';
    }

    function bookAppointment(doctor, date, start) {
        const modal = document.getElementById('confirmModal');
        if (modal) {
            document.getElementById('confirmMessage').textContent = `Confirm booking with ${doctor} on ${date} at ${start}?`;
            modal.showModal(); // Use native dialog method
        } else {
            alert(`Booking confirmed with ${doctor} on ${date} at ${start}`);
        }
    }
</script>