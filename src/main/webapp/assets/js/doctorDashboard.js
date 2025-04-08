// doctorDashboard.js
document.addEventListener('DOMContentLoaded', () => {
    const sidebarLinks = document.querySelectorAll('.sidebar-nav .nav-link');
    const contentArea = document.getElementById('content-area');
    const currentSection = new URLSearchParams(window.location.search).get('section') || 'dashboard';

    initializeSection(currentSection);

    sidebarLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const section = link.getAttribute('data-section');
            history.pushState({}, '', `${window.contextPath}/DoctorServlet?section=${section}`);
            sidebarLinks.forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            loadSection(section);
        });
    });
});

function loadSection(section) {
    console.log(`Loading section: ${section}`);
    fetch(`${window.contextPath}/DoctorServlet?section=${section}`, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            return response.text();
        })
        .then(html => {
            console.log(`Section ${section} loaded successfully`);
            document.getElementById('content-area').innerHTML = html;
            initializeSection(section);
        })
        .catch(error => {
            console.error(`Error loading ${section}:`, error);
            document.getElementById('content-area').innerHTML = `<p>Error loading ${section}: ${error.message}. Please try again.</p>`;
        });
}

function initializeSection(section) {
    if (section === 'dashboard') initDashboard();
    if (section === 'details') initDetails();
    if (section === 'appointments') initAppointments();
}

function initDashboard() {
    console.log("Initializing Dashboard...");
    document.querySelectorAll('.dashboard-grid .card')?.forEach(card => {
        card.addEventListener('click', () => {
            const metric = card.querySelector('.metric')?.textContent || 'N/A';
            const title = card.querySelector('h3')?.textContent || 'Card';
            console.log(`Clicked ${title}: ${metric}`);
        });
    });
}

function initDetails() {
    console.log("Initializing Details...");
    const form = document.querySelector('#detailsForm');
    if (form) {
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            const formData = new FormData(form);
            fetch(form.action, {
                method: 'POST',
                body: formData,
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
                .then(response => response.text())
                .then(html => {
                    document.getElementById('content-area').innerHTML = html;
                    initializeSection('details');
                })
                .catch(error => console.error('Error submitting form:', error));
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
            e.preventDefault();
            const form = btn.closest('form');
            fetch(form.action, {
                method: 'POST',
                body: new FormData(form),
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
                .then(response => response.text())
                .then(html => {
                    document.getElementById('content-area').innerHTML = html;
                    initializeSection('appointments');
                })
                .catch(error => console.error('Error canceling appointment:', error));
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
        if (col === 0) return isAsc ? parseInt(x) - parseInt(y) : parseInt(y) - parseInt(x);
        if (col === 2) return isAsc ? new Date(x) - new Date(y) : new Date(y) - new Date(x);
        if (col === 3) {
            const priorityOrder = { 'Emergency': 1, 'Regular': 0 };
            return isAsc ? priorityOrder[x] - priorityOrder[y] : priorityOrder[y] - priorityOrder[x];
        }
        return isAsc ? x.localeCompare(y) : y.localeCompare(x);
    });

    rows.forEach(row => tbody.appendChild(row));
}