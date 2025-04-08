document.addEventListener('DOMContentLoaded', () => {
    const sidebarLinks = document.querySelectorAll('.sidebar-nav .nav-link');
    const contentArea = document.getElementById('content-area');
    const currentSection = new URLSearchParams(window.location.search).get('section') || 'dashboard';

    // Log initial state
    console.log(`Initial section: ${currentSection}`);

    // Load the section content and initialize it
    loadSection(currentSection);

    // Sidebar navigation
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

    // Fix duplicate "Dr." in welcome message
    const doctorNameElement = document.querySelector('.doctor-name');
    if (doctorNameElement) {
        let doctorName = doctorNameElement.textContent.trim();
        if (doctorName.startsWith('Dr.')) {
            doctorNameElement.textContent = doctorName.replace('Dr.', '').trim();
        }
    }
});

/**
 * Loads a section via AJAX and updates the content area
 * @param {string} section - The section to load (dashboard, details, appointments)
 */
function loadSection(section) {
    console.log(`Loading section: ${section}`);
    const spinner = contentArea.querySelector('.loading-spinner');
    if (spinner) spinner.classList.add('active'); // Show spinner

    fetch(`${window.contextPath}/DoctorServlet?section=${section}`, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
        .then(response => {
            if (!response.ok) throw new Error(`HTTP error! Status: ${response.status}`);
            return response.text();
        })
        .then(html => {
            console.log(`Section ${section} loaded successfully`);
            contentArea.innerHTML = html;
            if (spinner) spinner.classList.remove('active'); // Hide spinner
            const doctorName = contentArea.querySelector('.doctor-name')?.textContent || 'Not found';
            console.log(`Doctor Name: ${doctorName}`);
            initializeSection(section);
        })
        .catch(error => {
            console.error(`Error loading ${section}:`, error);
            contentArea.innerHTML = `<div class="alert alert-danger">Error loading ${section}: ${error.message}. Please try again later.</div>`;
            if (spinner) spinner.classList.remove('active'); // Hide spinner on error
        });
}

/**
 * Initializes functionality for the loaded section
 * @param {string} section - The section to initialize
 */
function initializeSection(section) {
    console.log(`Initializing section: ${section}`);
    switch (section) {
        case 'dashboard': initDashboard(); break;
        case 'details': initDetails(); break;
        case 'appointments': initAppointments(); break;
        default: console.warn(`Unknown section: ${section}`);
    }
}

/**
 * Initializes the dashboard section with charts
 */
function initDashboard() {
    console.log("Initializing Dashboard...");
    const cards = document.querySelectorAll('.dashboard-grid .card');
    cards.forEach(card => {
        card.addEventListener('click', () => {
            const metric = card.dataset.metric || 'N/A';
            const title = card.querySelector('h3')?.textContent || 'Card';
            console.log(`Clicked ${title}: ${metric}`);
        });
    });
}

/**
 * Processes appointment data for trend chart
 * @param {Array} appointments - List of appointment objects
 * @returns {Object} Labels and counts for the chart
 */
function processTrendData(appointments) {
    const today = new Date();
    const labels = [];
    const counts = [];
    for (let i = 6; i >= 0; i--) {
        const date = new Date(today);
        date.setDate(today.getDate() - i);
        const dateStr = date.toISOString().split('T')[0];
        labels.push(dateStr);
        const count = appointments.filter(appt => appt.dateTime.startsWith(dateStr)).length;
        counts.push(count);
    }
    return { labels, counts };
}

/**
 * Initializes the details section with form handling and popup
 */
function initDetails() {
    console.log("Initializing Details...");
    const editBtn = document.getElementById('editDetailsBtn');
    const cancelBtn = document.getElementById('cancelEditBtn');
    const editPopup = document.getElementById('editPopup');
    const detailsView = document.getElementById('detailsView');
    const form = document.querySelector('#detailsForm');

    if (editBtn && cancelBtn && editPopup && detailsView) {
        editBtn.addEventListener('click', () => {
            detailsView.style.opacity = '0';
            setTimeout(() => {
                detailsView.style.display = 'none';
                editPopup.style.display = 'flex';
            }, 300);
        });

        cancelBtn.addEventListener('click', () => {
            editPopup.style.display = 'none';
            detailsView.style.opacity = '0';
            setTimeout(() => {
                detailsView.style.display = 'block';
                detailsView.style.opacity = '1';
            }, 50);
        });
    }

    if (!form) {
        console.warn("Details form not found in DOM");
        return;
    }

    form.addEventListener('submit', (e) => {
        e.preventDefault();
        const name = form.querySelector('#name')?.value;
        const contact = form.querySelector('#contact')?.value;
        const specialization = form.querySelector('#specialization')?.value;
        if (!name || !contact || !specialization) {
            showMessage('Please fill in all required fields.', 'danger');
            return;
        }

        const formData = new FormData(form);
        fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
            .then(response => {
                if (!response.ok) throw new Error('Update failed');
                return response.text();
            })
            .then(html => {
                contentArea.innerHTML = html;
                showMessage('Details updated successfully!', 'success');
                initializeSection('details');
            })
            .catch(error => {
                console.error('Error submitting form:', error);
                showMessage(`Error updating details: ${error.message}`, 'danger');
            });
    });
}

/**
 * Initializes the appointments section with sorting and cancellation
 */
function initAppointments() {
    console.log("Initializing Appointments...");
    const tableHeaders = document.querySelectorAll('.appointments-section table th');
    tableHeaders.forEach(th => {
        th.addEventListener('click', () => sortTable(th.cellIndex, th.dataset.type));
    });

    const cancelButtons = document.querySelectorAll('.btn-cancel');
    cancelButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            if (!confirm('Are you sure you want to cancel this appointment?')) return;

            const form = btn.closest('form');
            fetch(form.action, {
                method: 'POST',
                body: new FormData(form),
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
                .then(response => {
                    if (!response.ok) throw new Error('Cancellation failed');
                    return response.text();
                })
                .then(html => {
                    contentArea.innerHTML = html;
                    showMessage('Appointment canceled successfully!', 'success');
                    initializeSection('appointments');
                })
                .catch(error => {
                    console.error('Error canceling appointment:', error);
                    showMessage(`Error canceling appointment: ${error.message}`, 'danger');
                });
        });
    });
}

/**
 * Sorts the appointments table based on column index and data type
 * @param {number} col - Column index to sort
 * @param {string} dataType - Optional data type (number, date, priority)
 */
function sortTable(col, dataType) {
    const tbody = document.querySelector('.appointments-section table tbody');
    if (!tbody) {
        console.warn('Table body not found for sorting');
        return;
    }

    const rows = Array.from(tbody.rows);
    const isAsc = tbody.dataset.sort !== `${col}-asc`;
    tbody.dataset.sort = isAsc ? `${col}-asc` : `${col}-desc`;

    rows.sort((a, b) => {
        const x = a.cells[col].textContent.trim();
        const y = b.cells[col].textContent.trim();

        switch (dataType) {
            case 'number':
                return isAsc ? parseInt(x) - parseInt(y) : parseInt(y) - parseInt(x);
            case 'date':
                return isAsc ? new Date(x) - new Date(y) : new Date(y) - new Date(x);
            case 'priority':
                const priorityOrder = { 'Emergency': 1, 'Regular': 0 };
                return isAsc ? (priorityOrder[x] || 0) - (priorityOrder[y] || 0) : (priorityOrder[y] || 0) - (priorityOrder[x] || 0);
            default:
                return isAsc ? x.localeCompare(y) : y.localeCompare(x);
        }
    });

    rows.forEach(row => tbody.appendChild(row));
}

/**
 * Displays a temporary message to the user
 * @param {string} text - Message text
 * @param {string} type - Message type (success, danger)
 */
function showMessage(text, type) {
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} fade-out`;
    alert.textContent = text;
    contentArea.insertBefore(alert, contentArea.firstChild);
    setTimeout(() => alert.remove(), 3000);
}

// Global reference to content area
const contentArea = document.getElementById('content-area');