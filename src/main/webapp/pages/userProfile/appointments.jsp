<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="dashboard-card appointments-section" id="appointmentsSection" aria-labelledby="appointments-title">
    <header class="section-header">
        <h2 id="appointments-title">
            <i class="fas fa-calendar-alt" aria-hidden="true"></i> Your Upcoming Appointments
        </h2>
    </header>

    <div class="table-container">
        <table role="grid" class="appointments-table" aria-label="Upcoming Appointments">
            <thead>
            <tr>
                <th scope="col" data-sort="0" class="sortable" onclick="sortTable(0)">
                    ID <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="1" class="sortable" onclick="sortTable(1)">
                    Doctor <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="2" class="sortable" onclick="sortTable(2)">
                    Date & Time <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
                <th scope="col" data-sort="3" class="sortable" onclick="sortTable(3)">
                    Priority <i class="fas fa-sort" aria-hidden="true"></i>
                </th>
            </tr>
            </thead>
            <tbody>
            <!-- Table body will be populated dynamically by JavaScript -->
            </tbody>
        </table>
        <div class="no-appointments" id="noAppointmentsMessage" style="display: none;">
            <i class="fas fa-calendar-times" aria-hidden="true"></i>
            <p>No upcoming appointments found.</p>
        </div>
    </div>
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

    .appointments-section {
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

    .table-container {
        overflow-x: auto;
        border-radius: var(--border-radius);
        background: var(--card-bg);
        box-shadow: var(--shadow);
    }

    .appointments-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        font-size: 1rem;
    }

    .appointments-table th,
    .appointments-table td {
        padding: calc(var(--spacing-unit) * 1.25);
        text-align: left;
        border-bottom: 1px solid var(--border);
    }

    .appointments-table th {
        background: var(--primary);
        color: #FFFFFF;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .appointments-table th:first-child {
        border-top-left-radius: var(--border-radius);
    }

    .appointments-table th:last-child {
        border-top-right-radius: var(--border-radius);
    }

    .sortable {
        cursor: pointer;
        transition: var(--transition);
        user-select: none;
    }

    .sortable:hover {
        background: #1E3A8A;
    }

    .sortable i {
        font-size: 0.9rem;
        margin-left: 0.5rem;
        transition: transform 0.2s ease;
        opacity: 0.8;
    }

    .sortable.asc i {
        transform: rotate(180deg);
    }

    .sortable.desc i {
        transform: rotate(0deg);
    }

    .appointments-table tr {
        transition: var(--transition);
    }

    .appointments-table tr:hover {
        background: var(--hover);
        box-shadow: inset 0 0 0 1px var(--secondary);
    }

    .appointments-table td {
        color: var(--text-primary);
    }

    .priority-high {
        color: var(--accent);
        font-weight: 600;
        background: rgba(229, 62, 62, 0.1);
        border-radius: 6px;
        padding: 0.25rem 0.75rem;
        display: inline-block;
    }

    .priority-normal {
        color: var(--secondary);
        font-weight: 500;
        background: rgba(56, 178, 172, 0.1);
        border-radius: 6px;
        padding: 0.25rem 0.75rem;
        display: inline-block;
    }

    .no-appointments {
        text-align: center;
        padding: calc(var(--spacing-unit) * 2);
        color: var(--text-muted);
        font-style: italic;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.75rem;
    }

    .no-appointments i {
        font-size: 1.75rem;
        color: var(--text-muted);
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(15px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 768px) {
        .appointments-section {
            padding: var(--spacing-unit);
            max-width: 100%;
        }

        .appointments-table th,
        .appointments-table td {
            padding: var(--spacing-unit);
            font-size: 0.9rem;
        }

        .section-header h2 {
            font-size: 1.5rem;
        }

        .priority-high,
        .priority-normal {
            padding: 0.2rem 0.5rem;
            font-size: 0.85rem;
        }
    }

    @media (max-width: 480px) {
        .appointments-table th,
        .appointments-table td {
            font-size: 0.85rem;
            padding: 0.75rem;
        }

        .sortable i {
            margin-left: 0.25rem;
        }
    }
</style>

<script>
    // Sorting function
    function sortTable(col) {
        const table = document.querySelector('#appointmentsSection table tbody');
        const rows = Array.from(table.rows);
        const th = document.querySelector(`th[data-sort="${col}"]`);
        const isAsc = !th.classList.contains('asc');

        // Remove sort classes from all headers except the current one
        document.querySelectorAll('.sortable').forEach(header => {
            if (header !== th) {
                header.classList.remove('asc', 'desc');
            }
        });

        // Toggle sort direction
        th.classList.remove('asc', 'desc');
        th.classList.add(isAsc ? 'asc' : 'desc');

        rows.sort((a, b) => {
            const x = a.cells[col].textContent.trim();
            const y = b.cells[col].textContent.trim();

            if (col === 0) { // ID (numeric)
                return isAsc ? parseInt(x) - parseInt(y) : parseInt(y) - parseInt(x);
            } else if (col === 2) { // Date & Time (date)
                return isAsc ? new Date(x) - new Date(y) : new Date(y) - new Date(x);
            } else if (col === 3) { // Priority (Emergency > Normal)
                const priorityOrder = { 'Emergency': 1, 'Normal': 0 };
                return isAsc ? priorityOrder[x] - priorityOrder[y] : priorityOrder[y] - priorityOrder[x];
            } else { // Doctor (string)
                return isAsc ? x.localeCompare(y) : y.localeCompare(x);
            }
        });

        rows.forEach(row => table.appendChild(row));
    }

    // Fetch user appointments
    async function fetchUserAppointments() {
        console.log("Fetching user appointments...");
        const table = document.querySelector('#appointmentsSection table tbody');
        const noAppointmentsMessage = document.getElementById('noAppointmentsMessage');
        const url = `${window.contextPath}/user?action=getAppointments`;

        try {
            const response = await fetch(url, {
                method: 'GET',
                headers: { Accept: 'application/json' },
                cache: 'no-store',
                credentials: 'same-origin' // Include cookies for session
            });

            if (!response.ok) {
                const errorText = await response.text();
                throw new Error(`Failed to fetch appointments: ${response.status} - ${response.statusText} - ${errorText}`);
            }

            const appointments = await response.json();
            console.log("User appointments:", appointments);

            table.innerHTML = '';
            noAppointmentsMessage.style.display = 'none';

            if (appointments.length === 0) {
                noAppointmentsMessage.style.display = 'flex';
                return;
            }

            appointments.forEach(appt => {
                const row = `
                    <tr>
                        <td>${appt.id}</td>
                        <td>${appt.doctorId}</td>
                        <td>${appt.dateTime}</td>
                        <td class="${appt.priority == 1 ? 'priority-high' : 'priority-normal'}">
                            ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                        </td>
                    </tr>
                `;
                table.insertAdjacentHTML('beforeend', row);
            });
        } catch (error) {
            console.error("Error fetching appointments:", error);
            table.innerHTML = `<tr><td colspan="4">Error: ${error.message}</td></tr>`;
            noAppointmentsMessage.style.display = 'none';
        }
    }

    // Fetch appointments when the page loads
    document.addEventListener('DOMContentLoaded', fetchUserAppointments);
</script>