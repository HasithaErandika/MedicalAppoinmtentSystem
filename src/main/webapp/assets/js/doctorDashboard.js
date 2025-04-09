document.addEventListener('DOMContentLoaded', () => {
    const sidebarLinks = document.querySelectorAll('.sidebar-nav .nav-link');
    const contentArea = document.getElementById('content-area');
    const currentSection = new URLSearchParams(window.location.search).get('section') || 'dashboard';

    console.log(`Initial section: ${currentSection}`);
    loadSection(currentSection);

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

    const doctorNameElement = document.querySelector('.doctor-name');
    if (doctorNameElement) {
        let doctorName = doctorNameElement.textContent.trim();
        console.log(`Original doctor name: ${doctorName}`);

        if (/^doctor\d+$/.test(doctorName)) {
            doctorName = "Doctor"; // Fallback to generic "Doctor" if username-like
            console.warn("Doctor name appears to be a username; using fallback: 'Doctor'");
        } else if (doctorName.startsWith('Dr.')) {
            doctorName = doctorName.replace('Dr.', '').trim(); // Remove "Dr." if present
        }

        doctorNameElement.textContent = doctorName;
        console.log(`Updated doctor name: ${doctorName}`);
    } else {
        console.warn("Doctor name element not found in DOM");
    }
});

function loadSection(section) {
    console.log(`Loading section: ${section}`);
    const spinner = contentArea.querySelector('.loading-spinner');
    if (spinner) spinner.classList.add('active');

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
            if (spinner) spinner.classList.remove('active');
            initializeSection(section);
        })
        .catch(error => {
            console.error(`Error loading ${section}:`, error);
            contentArea.innerHTML = `<div class="alert alert-danger">Error loading ${section}: ${error.message}. Please try again later.</div>`;
            if (spinner) spinner.classList.remove('active');
        });
}

function initializeSection(section) {
    console.log(`Initializing section: ${section}`);
    switch (section) {
        case 'dashboard': initDashboard(); break;
        case 'details': initDetails(); break;
        case 'appointments': initAppointments(); break;
        default: console.warn(`Unknown section: ${section}`);
    }
}

function initDashboard() {
    console.log("Initializing Dashboard... (Confirmed)");
    const cards = document.querySelectorAll('.dashboard-grid .card');
    cards.forEach(card => {
        card.addEventListener('click', () => {
            const metric = card.dataset.metric || 'N/A';
            const title = card.querySelector('h3')?.textContent || 'Card';
            console.log(`Clicked ${title}: ${metric}`);
        });
    });

    const categoryChartCanvas = document.getElementById('categoryChart');
    const trendChartCanvas = document.getElementById('trendChart');
    console.log("Category Chart Canvas:", categoryChartCanvas);
    console.log("Trend Chart Canvas:", trendChartCanvas);

    if (!categoryChartCanvas || !trendChartCanvas) {
        console.warn("Chart canvases not found in DOM");
        return;
    }

    const dashboardData = {
        categoryData: {
            total: parseInt(document.querySelector('.card[title="Total number of appointments scheduled"]').dataset.metric) || 0,
            upcoming: parseInt(document.querySelector('.card[title="Appointments scheduled in the future"]').dataset.metric) || 0,
            emergency: parseInt(document.querySelector('.card[title="High-priority appointments"]').dataset.metric) || 0,
            today: parseInt(document.querySelector('.card[title="Appointments scheduled for today"]').dataset.metric) || 0,
            completed: parseInt(document.querySelector('.card[title="Appointments completed"]').dataset.metric) || 0
        },
        appointments: window.dashboardData?.appointments || []
    };
    console.log('Dashboard Data:', dashboardData);

    if (!Object.values(dashboardData.categoryData).some(val => val > 0)) {
        document.querySelector('.charts-section').innerHTML = '<p class="no-data">No appointment data available to display charts.</p>';
        return;
    }

    const categoryCtx = categoryChartCanvas.getContext('2d');
    new Chart(categoryCtx, {
        type: 'bar',
        data: {
            labels: ['Total', 'Upcoming', 'Emergency', 'Today', 'Completed'],
            datasets: [{
                label: 'Appointments',
                data: Object.values(dashboardData.categoryData),
                backgroundColor: ['#2c3e50', '#38b2ac', '#e53e3e', '#667eea', '#2ecc71'],
                borderColor: ['#2c3e50', '#38b2ac', '#e53e3e', '#667eea', '#2ecc71'],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true, title: { display: true, text: 'Appointments' }, ticks: { stepSize: 1 } },
                x: { title: { display: true, text: 'Category' } }
            },
            plugins: {
                legend: { position: 'top' },
                title: { display: true, text: 'Appointment Categories', font: { size: 16 } }
            }
        }
    });

    const trendCtx = trendChartCanvas.getContext('2d');
    const trendData = processTrendData(dashboardData.appointments);
    new Chart(trendCtx, {
        type: 'line',
        data: {
            labels: trendData.labels,
            datasets: [{
                label: 'Appointments',
                data: trendData.counts,
                fill: true,
                borderColor: '#38b2ac',
                backgroundColor: 'rgba(56, 178, 172, 0.2)',
                tension: 0.3,
                pointBackgroundColor: '#38b2ac',
                pointBorderColor: '#fff',
                pointHoverRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true, title: { display: true, text: 'Appointments' }, ticks: { stepSize: 1 } },
                x: { title: { display: true, text: 'Date' } }
            },
            plugins: {
                legend: { position: 'top' },
                title: { display: true, text: 'Appointment Trends (Last 7 Days)', font: { size: 16 } }
            }
        }
    });
}

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

function initAppointments() {
    console.log("Initializing Appointments...");
    const tableHeaders = document.querySelectorAll('.appointments-section table th');
    tableHeaders.forEach(th => {
        th.addEventListener('click', () => sortTable(th.cellIndex, th.dataset.type));
    });
}

function showCancelModal(appointmentId, patientName, dateTime) {
    const modal = document.getElementById('cancelModal');
    const message = document.getElementById('cancelMessage');
    const details = document.getElementById('cancelAppointmentDetails');

    if (!modal || !message || !details) {
        console.error("Cancel modal elements not found.");
        return;
    }

    message.textContent = "Are you sure you want to cancel this appointment?";
    details.innerHTML = `
        <p><strong>Patient:</strong> ${patientName}</p>
        <p><strong>Date & Time:</strong> ${dateTime}</p>
    `;

    const confirmBtn = document.getElementById('cancelModalConfirmBtn');
    const newConfirmBtn = confirmBtn.cloneNode(true); // Clone to avoid event stacking
    confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);
    newConfirmBtn.onclick = () => {
        cancelAppointment(appointmentId);
        closeCancelModal();
    };

    document.body.classList.add('modal-open');
    modal.showModal();
}

function closeCancelModal() {
    const modal = document.getElementById('cancelModal');
    if (modal) {
        modal.close();
        document.body.classList.remove('modal-open');
    }
}

function cancelAppointment(appointmentId) {
    fetch(`${window.contextPath}/DoctorServlet`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: new URLSearchParams({
            action: 'cancelAppointment',
            appointmentId: appointmentId
        })
    })
        .then(response => {
            if (!response.ok) throw new Error(`Cancellation failed: ${response.statusText}`);
            return response.text(); // DoctorServlet returns HTML due to forwarding
        })
        .then(html => {
            showMessage('Appointment canceled successfully!', 'success');
            loadSection('appointments'); // Reload the appointments section
        })
        .catch(error => {
            console.error('Error canceling appointment:', error);
            showMessage(`Error canceling appointment: ${error.message}`, 'danger');
        });
}

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

function showMessage(text, type) {
    const alert = document.createElement('div');
    alert.className = `alert alert-${type} fade-out`;
    alert.textContent = text;
    contentArea.insertBefore(alert, contentArea.firstChild);
    setTimeout(() => alert.remove(), 3000);
}

// Global reference to content area
const contentArea = document.getElementById('content-area');