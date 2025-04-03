<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<section class="dashboard-card" id="bookAppointmentSection" aria-labelledby="book-appointment-title">
    <h2 id="book-appointment-title">Schedule Your Appointment</h2>
    <form id="bookForm" class="form-grid" novalidate>
        <div class="form-group">
            <label for="specialty">Specialty</label>
            <select id="specialty" name="specialty" required aria-required="true" aria-describedby="specialty-error" onchange="updateAvailabilityTable()">
                <option value="">Select Specialty</option>
                <!-- Populate dynamically via JS or backend -->
            </select>
            <span class="error-message" id="specialty-error"></span>
        </div>
        <div id="filterContainer" class="filter-container" style="display: none;">
            <div class="form-grid filters">
                <div class="form-group">
                    <label for="filterDoctor">Doctor Name</label>
                    <select id="filterDoctor" name="doctorId" onchange="filterTable()">
                        <option value="">All Doctors</option>
                        <!-- Populate dynamically via JS -->
                    </select>
                </div>
                <div class="form-group">
                    <label for="filterDate">Preferred Date</label>
                    <select id="filterDate" name="date" onchange="filterTable()">
                        <option value="">All Dates</option>
                        <!-- Populate dynamically via JS -->
                    </select>
                </div>
            </div>
        </div>
        <div id="availabilityTableContainer" class="table-container">
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
                <!-- Populated dynamically via JS -->
                </tbody>
            </table>
            <div id="noResults" class="no-results" style="display: none;">No available appointments found.</div>
        </div>
    </form>
</section>

<style>
    :root {
        --primary: #2F855A;        /* Forest Green */
        --secondary: #38B2AC;      /* Teal */
        --accent: #E53E3E;         /* Red */
        --bg-light: #F7FAF9;       /* Light background */
        --text-primary: #1A4731;   /* Dark green */
        --text-muted: #6B7280;     /* Gray */
        --card-bg: #FFFFFF;        /* White cards */
        --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        --border: #D1D5DB;         /* Neutral border */
        --hover: #E6FFFA;          /* Light green hover */
        --transition: all 0.3s ease;
        --border-radius: 10px;
    }

    .dashboard-card {
        padding: 1.5rem;
        background: var(--card-bg);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        max-width: 900px;
        margin: 0 auto;
        animation: fadeIn 0.3s ease;
    }

    h2 {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    h2::before {
        content: "\e0a0"; /* Remixicon calendar-check-line */
        font-family: "remixicon";
        color: var(--primary);
    }

    /* Form Grid */
    .form-grid {
        display: grid;
        gap: 1.25rem;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    label {
        font-weight: 500;
        color: var(--text-primary);
        font-size: 0.95rem;
    }

    select {
        padding: 0.75rem;
        border: 1px solid var(--border);
        border-radius: var(--border-radius);
        font-size: 1rem;
        color: var(--text-primary);
        background: #fff;
        transition: var(--transition);
        cursor: pointer;
    }

    select:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(47, 133, 90, 0.2);
        outline: none;
    }

    .error-message {
        font-size: 0.85rem;
        color: var(--accent);
        min-height: 1rem;
    }

    /* Filter Container */
    .filter-container {
        padding: 1rem;
        background: var(--bg-light);
        border-radius: var(--border-radius);
        margin-top: 1rem;
        animation: slideIn 0.3s ease;
    }

    .filters {
        grid-template-columns: 1fr 1fr;
        gap: 1.5rem;
    }

    /* Table Container */
    .table-container {
        margin-top: 1.5rem;
        overflow-x: auto;
    }

    .availability-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.95rem;
    }

    .availability-table th, .availability-table td {
        padding: 1rem;
        border-bottom: 1px solid var(--border);
        text-align: left;
    }

    .availability-table th {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: #FFFFFF;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .availability-table tr {
        transition: var(--transition);
    }

    .availability-table tr:hover {
        background: var(--hover);
    }

    .book-btn {
        background: var(--primary);
        color: #FFFFFF;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: var(--border-radius);
        cursor: pointer;
        font-weight: 500;
        transition: var(--transition);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .book-btn:hover {
        background: #276749;
        box-shadow: var(--shadow);
        transform: translateY(-2px);
    }

    .no-results {
        text-align: center;
        color: var(--text-muted);
        padding: 1rem;
        font-style: italic;
    }

    /* Animations */
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .dashboard-card {
            padding: 1rem;
            max-width: 100%;
        }
        .filters {
            grid-template-columns: 1fr;
            gap: 1rem;
        }
        .availability-table th, .availability-table td {
            padding: 0.75rem;
            font-size: 0.9rem;
        }
        .book-btn {
            width: 100%;
            justify-content: center;
        }
    }
</style>

<script>
    // Placeholder functions (replace with actual backend integration)
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
            return;
        }
        document.getElementById('specialty-error').textContent = '';

        // Simulate fetching data (replace with actual AJAX call)
        const mockData = [
            { doctor: 'Dr. Smith', date: '2025-04-10', start: '09:00', end: '09:30' },
            { doctor: 'Dr. Jones', date: '2025-04-11', start: '14:00', end: '14:30' }
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
                        <i class="ri-calendar-check-line"></i> Book
                    </button></td>
                `;
                tbody.appendChild(row);
            });

            // Populate filter dropdowns (simulated)
            const filterDoctor = document.getElementById('filterDoctor');
            const filterDate = document.getElementById('filterDate');
            filterDoctor.innerHTML = '<option value="">All Doctors</option>' +
                mockData.map(slot => `<option value="${slot.doctor}">${slot.doctor}</option>`).join('');
            filterDate.innerHTML = '<option value="">All Dates</option>' +
                mockData.map(slot => `<option value="${slot.date}">${slot.date}</option>`).join('');
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
        // Simulate booking (replace with actual logic)
        alert(`Booking confirmed with ${doctor} on ${date} at ${start}`);
        // Optionally trigger modal from userProfile.jsp
        // const modal = document.getElementById('confirmModal');
        // document.getElementById('confirmMessage').textContent = `Book with ${doctor} on ${date} at ${start}?`;
        // modal.style.display = 'flex';
    }
</script>