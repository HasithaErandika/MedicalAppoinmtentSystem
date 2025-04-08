// doctorDashboard.js
document.addEventListener('DOMContentLoaded', () => {
    const section = '<%= request.getParameter("section") != null ? request.getParameter("section") : "dashboard" %>';
    initializeSection(section);
});

function initializeSection(section) {
    if (section === 'dashboard') initDashboard();
    if (section === 'details') initDetails();
    if (section === 'appointments') initAppointments();
}

function initDashboard() {
    console.log("Initializing Dashboard...");
    // Chart initialization is now handled in dashboard.jsp
    // Optional: Add interactivity to cards if desired
    document.querySelectorAll('.dashboard-grid .card')?.forEach(card => {
        card.addEventListener('click', () => {
            const metric = card.querySelector('.metric').textContent;
            const title = card.querySelector('h3').textContent;
            console.log(`Clicked ${title}: ${metric}`);
            // Could add a modal or alert here if needed
        });
    });
}

function initDetails() {
    console.log("Initializing Details...");
    const form = document.querySelector('#detailsForm');
    if (form) {
        form.addEventListener('submit', (e) => {
            // Let the form submit naturally to DoctorServlet
            console.log("Submitting details form...");
        });
    }
}

function initAppointments() {
    console.log("Initializing Appointments...");
    document.querySelectorAll('.section table th')?.forEach(th => {
        th.addEventListener('click', () => sortTable(th.cellIndex));
    });

    document.querySelectorAll('.btn-cancel')?.forEach(btn => {
        btn.addEventListener('click', (e) => {
            // Let the form submit naturally to DoctorServlet
            console.log("Cancel button clicked...");
        });
    });
}

function sortTable(col) {
    const tbody = document.querySelector('.section table tbody');
    if (!tbody) return;
    const rows = Array.from(tbody.rows);
    const isAsc = !tbody.dataset.sort || tbody.dataset.sort !== `${col}-asc`;
    tbody.dataset.sort = isAsc ? `${col}-asc` : `${col}-desc`;

    rows.sort((a, b) => {
        const x = a.cells[col].textContent.trim();
        const y = b.cells[col].textContent.trim();
        if (col === 0) return isAsc ? parseInt(x) - parseInt(y) : parseInt(y) - parseInt(x); // ID
        if (col === 2) return isAsc ? new Date(x) - new Date(y) : new Date(y) - new Date(x); // DateTime
        if (col === 3) {
            const priorityOrder = { 'Emergency': 1, 'Regular': 0 };
            return isAsc ? priorityOrder[x] - priorityOrder[y] : priorityOrder[y] - priorityOrder[x]; // Priority
        }
        return isAsc ? x.localeCompare(y) : y.localeCompare(x); // PatientName
    });

    rows.forEach(row => tbody.appendChild(row));
}

window.contextPath = '<%= request.getContextPath() %>';