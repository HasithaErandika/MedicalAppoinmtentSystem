// Global variables
let allSpecialties = [];
let allDoctors = [];
let allAvailability = [];

// Global functions
async function loadSection(section) {
    const contentArea = document.getElementById('content-area');
    contentArea.innerHTML = '<div class="loading">Loading...</div>';
    const baseSection = section.includes('?') ? section.split('?')[0] : section;
    const query = section.includes('?') ? '?' + section.split('?')[1] : '';
    const url = encodeURI(`${window.contextPath}/pages/userProfile/${baseSection}.jsp${query}`);
    console.log("Attempting to fetch section from URL:", url);
    try {
        const response = await fetch(url);
        console.log("Response status for", section, ":", response.status, "Status text:", response.statusText);
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Failed to load section ${section}: ${response.status} - ${response.statusText} - ${errorText}`);
        }
        const text = await response.text();
        console.log("Successfully loaded section", section);
        contentArea.innerHTML = text;
        initializeSection(baseSection);
    } catch (error) {
        console.error("Error loading section:", error);
        contentArea.innerHTML = `<p>Error: ${error.message}</p>`;
    }
}

function initializeSection(section) {
    if (section === 'bookAppointment') initBookAppointment();
    if (section === 'appointments') initAppointments();
    if (section === 'userDetails') initUserDetails();
}

function initBookAppointment() {
    console.log("Initializing Book Appointment...");
    fetchSpecialties();
}

function initAppointments() {
    console.log("Initializing Appointments...");
    document.querySelectorAll('th[data-sort]').forEach(th => {
        th.addEventListener('click', () => sortTable(th.dataset.sort));
    });
    fetchUserAppointments();
}

function initUserDetails() {
    console.log("Initializing User Details...");
    const form = document.getElementById('detailsForm');
    const editBtn = document.getElementById('editDetailsBtn');
    const cancelBtn = document.getElementById('cancelEditBtn');

    if (form) { // Editable mode
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            if (validateForm(form)) form.submit();
        });
    }
    if (editBtn) { // Read-only mode
        editBtn.addEventListener('click', () => {
            loadSection('userDetails?edit=true');
        });
    }
    if (cancelBtn) { // Edit mode cancel
        cancelBtn.addEventListener('click', () => {
            loadSection('userDetails');
        });
    }
    if (!form && !editBtn && !cancelBtn) {
        console.log("No interactive elements found; section may not have loaded correctly.");
    }
}

// DOMContentLoaded for initial setup
document.addEventListener('DOMContentLoaded', () => {
    const contextPath = window.contextPath;
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main-content');

    // Sidebar Toggle
    document.querySelector('.sidebar-toggle').addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    });

    // Dynamic Section Loading
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', async (e) => {
            e.preventDefault();
            const section = link.dataset.section.trim();
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            await loadSection(section);
        });
    });

    // Initial load
    initializeSection('bookAppointment');
});

async function fetchSpecialties() {
    const specialtySelect = document.getElementById('specialty');
    const url = `${window.contextPath}/SortServlet`;
    console.log("Attempting to fetch specialties from:", url);
    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        console.log("Response status:", response.status, "Status text:", response.statusText);
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Failed to fetch specialties: ${response.status} - ${response.statusText} - ${errorText}`);
        }
        const data = await response.json();
        console.log("Received specialties data:", data);
        allSpecialties = data.specialties || [];
        if (allSpecialties.length === 0) console.warn("No specialties found.");
        populateSpecialties();
    } catch (error) {
        console.error("Error fetching specialties:", error);
        specialtySelect.insertAdjacentHTML('afterend', `<p>Error: ${error.message}</p>`);
    }
}

function populateSpecialties() {
    const specialtySelect = document.getElementById('specialty');
    specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
    allSpecialties.forEach(specialty => {
        specialtySelect.insertAdjacentHTML('beforeend', `<option value="${specialty}">${specialty}</option>`);
    });
    console.log("Specialties populated:", allSpecialties);
}

async function updateAvailabilityTable() {
    console.log("Updating availability table...");
    const specialty = document.getElementById('specialty').value;
    const table = document.getElementById('availabilityTable');
    const tbody = table.querySelector('tbody');
    const filterContainer = document.getElementById('filterContainer');
    const filterDoctor = document.getElementById('filterDoctor');
    const filterDate = document.getElementById('filterDate');

    tbody.innerHTML = '';
    table.style.display = 'none';
    filterContainer.style.display = 'none';
    filterDoctor.innerHTML = '<option value="">All Doctors</option>';
    filterDate.innerHTML = '<option value="">All Dates</option>';

    if (!specialty) {
        console.log("No specialty selected.");
        return;
    }

    try {
        const url = `${window.contextPath}/SortServlet?specialty=${encodeURIComponent(specialty)}`;
        console.log("Fetching availability from:", url);
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Failed to fetch availability: ${response.status} - ${response.statusText} - ${errorText}`);
        }
        const data = await response.json();
        console.log("Availability data:", data);
        allAvailability = data.availability || [];
        allDoctors = data.doctors || [];

        if (allAvailability.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5">No availability found</td></tr>';
            table.style.display = 'table';
            console.warn("No availability for specialty:", specialty);
            return;
        }

        allDoctors.forEach(doctor => {
            filterDoctor.insertAdjacentHTML('beforeend', `<option value="${doctor}">${doctor}</option>`);
        });
        const uniqueDates = [...new Set(allAvailability.map(avail => avail.date))].sort();
        uniqueDates.forEach(date => {
            filterDate.insertAdjacentHTML('beforeend', `<option value="${date}">${date}</option>`);
        });

        allAvailability.forEach(avail => {
            const row = `
                <tr data-doctor="${avail.name}" data-date="${avail.date}">
                    <td>${avail.name}</td>
                    <td>${avail.date}</td>
                    <td>${avail.startTime}</td>
                    <td>${avail.endTime}</td>
                    <td><button class="book-btn" onclick="bookAppointment('${avail.username}', '${avail.date}', '${avail.startTime}')">Book</button></td>
                </tr>
            `;
            tbody.insertAdjacentHTML('beforeend', row);
        });

        table.style.display = 'table';
        filterContainer.style.display = 'block';
        console.log("Table populated with:", allAvailability);
    } catch (error) {
        console.error("Error fetching availability:", error);
        tbody.innerHTML = `<tr><td colspan="5">Error: ${error.message}</td></tr>`;
        table.style.display = 'table';
    }
}

function filterTable() {
    console.log("Filtering table...");
    const filterDoctor = document.getElementById('filterDoctor').value;
    const filterDate = document.getElementById('filterDate').value;
    const rows = document.querySelectorAll('#availabilityTable tbody tr');

    rows.forEach(row => {
        const doctor = row.getAttribute('data-doctor');
        const date = row.getAttribute('data-date');
        const doctorMatch = !filterDoctor || doctor === filterDoctor;
        const dateMatch = !filterDate || date === filterDate;
        row.style.display = (doctorMatch && dateMatch) ? '' : 'none';
    });
    console.log("Filtered with doctor:", filterDoctor, "date:", filterDate);
}

function bookAppointment(doctorId, date, startTime) {
    console.log("Booking:", { doctorId, date, startTime });
    fetch(`${window.contextPath}/user`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        body: new URLSearchParams({
            action: 'book',
            doctorId: doctorId,
            date: date,
            timeSlot: startTime,
            isEmergency: 'off'
        })
    })
        .then(response => {
            if (!response.ok) throw new Error(`Booking failed: ${response.statusText}`);
            return response.text();
        })
        .then(() => {
            alert("Appointment booked successfully!");
            updateAvailabilityTable();
        })
        .catch(error => {
            console.error("Booking error:", error);
            alert(`Error booking appointment: ${error.message}`);
        });
}

function sortTable(col) {
    const table = document.querySelector('#appointmentsSection table tbody');
    const rows = Array.from(table.rows);
    const th = document.querySelector(`th[data-sort="${col}"]`);
    const isAsc = !th.classList.contains('asc');
    rows.sort((a, b) => {
        const x = a.cells[col].textContent;
        const y = b.cells[col].textContent;
        return isAsc ? x.localeCompare(y) : y.localeCompare(x);
    });
    rows.forEach(row => table.appendChild(row));
    th.classList.toggle('asc', isAsc);
}

async function fetchUserAppointments() {
    console.log("Fetching user appointments...");
    const table = document.querySelector('#appointmentsSection table tbody');
    const url = `${window.contextPath}/user?action=getAppointments`;
    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`Failed to fetch appointments: ${response.status} - ${response.statusText} - ${errorText}`);
        }
        const appointments = await response.json();
        console.log("User appointments:", appointments);

        table.innerHTML = '';
        if (appointments.length === 0) {
            table.innerHTML = '<tr><td colspan="4">No appointments found</td></tr>';
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
    }
}

function validateForm(form) {
    let isValid = true;
    form.querySelectorAll('[aria-required="true"]').forEach(input => {
        const error = document.getElementById(`${input.id}-error`);
        if (!input.value) {
            error.textContent = `${input.name} is required`;
            error.style.display = 'block';
            isValid = false;
        } else {
            error.style.display = 'none';
        }
    });
    return isValid;
}

function closeModal() {
    document.getElementById('confirmModal').style.display = 'none';
}

function submitBooking() {
    closeModal();
}