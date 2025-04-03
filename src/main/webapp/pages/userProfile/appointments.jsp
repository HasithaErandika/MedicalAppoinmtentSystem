<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="dashboard-card" id="appointmentsSection" aria-labelledby="appointments-title">
    <h2 id="appointments-title">Your Upcoming Appointments</h2>
    <div class="table-wrapper">
        <table role="grid" class="appointments-table" aria-label="Upcoming Appointments">
            <thead>
            <tr>
                <th scope="col" data-sort="0" class="sortable" onclick="sortTable(0)">ID <i class="ri-arrow-up-down-line"></i></th>
                <th scope="col" data-sort="1" class="sortable" onclick="sortTable(1)">Doctor <i class="ri-arrow-up-down-line"></i></th>
                <th scope="col" data-sort="2" class="sortable" onclick="sortTable(2)">Date & Time <i class="ri-arrow-up-down-line"></i></th>
                <th scope="col" data-sort="3" class="sortable" onclick="sortTable(3)">Priority <i class="ri-arrow-up-down-line"></i></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="appt" items="${appointments}">
                <c:if test="${appt.patientId == sessionScope.username}">
                    <tr>
                        <td>${appt.id}</td>
                        <td>${appt.doctorId}</td>
                        <td>${appt.dateTime}</td>
                        <td class="${appt.priority == 1 ? 'priority-high' : 'priority-normal'}">
                                ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${empty appointments || appointments.stream().noneMatch(appt -> appt.patientId == sessionScope.username)}">
            <div class="no-results">No upcoming appointments found.</div>
        </c:if>
    </div>
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

    .table-wrapper {
        overflow-x: auto;
        margin-top: 1rem;
    }

    .appointments-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.95rem;
    }

    .appointments-table th, .appointments-table td {
        padding: 1rem;
        border-bottom: 1px solid var(--border);
        text-align: left;
    }

    .appointments-table th {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: #FFFFFF;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        cursor: pointer;
        user-select: none;
    }

    .sortable {
        position: relative;
        transition: var(--transition);
    }

    .sortable:hover {
        background: linear-gradient(135deg, #276749, #2D9CDB);
    }

    .sortable i {
        font-size: 0.9rem;
        vertical-align: middle;
        margin-left: 0.25rem;
        transition: transform 0.2s ease;
    }

    .sortable.asc i {
        transform: rotate(180deg); /* Up arrow */
    }

    .sortable.desc i {
        transform: rotate(0deg); /* Down arrow */
    }

    .appointments-table tr {
        transition: var(--transition);
    }

    .appointments-table tr:hover {
        background: var(--hover);
    }

    .priority-high {
        color: var(--accent);
        font-weight: 500;
    }

    .priority-normal {
        color: var(--text-muted);
    }

    .no-results {
        text-align: center;
        color: var(--text-muted);
        padding: 1rem;
        font-style: italic;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 768px) {
        .dashboard-card {
            padding: 1rem;
            max-width: 100%;
        }
        .appointments-table th, .appointments-table td {
            padding: 0.75rem;
            font-size: 0.9rem;
        }
    }
</style>

<script>
    let sortDirection = [0, 0, 0, 0]; // 0: unsorted, 1: ascending, -1: descending

    function sortTable(columnIndex) {
        const table = document.querySelector('.appointments-table');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        const th = table.querySelectorAll('th')[columnIndex];
        const isAscending = sortDirection[columnIndex] === 1 ? -1 : 1;

        // Toggle sort direction
        sortDirection = sortDirection.map((dir, idx) => idx === columnIndex ? isAscending : 0);

        // Update sort icons
        table.querySelectorAll('.sortable').forEach((header, idx) => {
            header.classList.remove('asc', 'desc');
            if (idx === columnIndex) {
                header.classList.add(isAscending === 1 ? 'asc' : 'desc');
            }
        });

        // Sort rows
        rows.sort((a, b) => {
            const aValue = a.cells[columnIndex].textContent.trim();
            const bValue = b.cells[columnIndex].textContent.trim();

            // ID (numeric)
            if (columnIndex === 0) {
                return isAscending * (parseInt(aValue) - parseInt(bValue));
            }

            // Doctor (string)
            if (columnIndex === 1) {
                return isAscending * aValue.localeCompare(bValue);
            }

            // Date & Time (date)
            if (columnIndex === 2) {
                return isAscending * (new Date(aValue) - new Date(bValue));
            }

            // Priority (Emergency > Normal)
            if (columnIndex === 3) {
                const priorityOrder = { 'Emergency': 1, 'Normal': 0 };
                return isAscending * (priorityOrder[aValue] - priorityOrder[bValue]);
            }

            return 0; // Default case
        });

        // Re-append sorted rows
        rows.forEach(row => tbody.appendChild(row));
    }
</script>