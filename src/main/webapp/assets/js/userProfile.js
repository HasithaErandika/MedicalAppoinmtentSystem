// Global variables
let allSpecialties = [];
let allDoctors = [];
let allAvailability = [];
let userAppointments = []; // User's booked appointments with tokens
let pendingBooking = null; // Temporary storage for booking details

// Global functions
async function loadSection(section) {
    const contentArea = document.getElementById('content-area');
    contentArea.innerHTML = '<div class="loading">Loading...</div>';
    const [baseSection, query] = section.split('?');
    const url = encodeURI(`${window.contextPath}/pages/userProfile/${baseSection}.jsp${query ? '?' + query : ''}`);
    console.log("Fetching section from:", url);
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`Failed to load ${section}: ${response.status} - ${response.statusText}`);
        const text = await response.text();
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
    fetchUserAppointmentsForTokens();
    setupConfirmButton();
    const specialtySelect = document.getElementById('specialty');
    if (specialtySelect) {
        specialtySelect.addEventListener('change', updateAvailabilityTable);
    }
    const filterDoctor = document.getElementById('filterDoctor');
    const filterDate = document.getElementById('filterDate');
    if (filterDoctor) filterDoctor.addEventListener('change', filterTable);
    if (filterDate) filterDate.addEventListener('change', filterTable);
}

function initAppointments() {
    console.log("Initializing Appointments...");
    fetchUserAppointments();
    document.querySelectorAll('#appointmentsSection .sortable').forEach(th => {
        th.addEventListener('click', () => sortTable(parseInt(th.dataset.sort)));
    });
}

function initUserDetails() {
    console.log("Initializing User Details...");
    const form = document.getElementById('detailsForm');
    const editBtn = document.getElementById('editDetailsBtn');
    const cancelBtn = document.getElementById('cancelEditBtn');

    if (form) {
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            if (validateForm(form)) form.submit();
        });
    }
    if (editBtn) editBtn.addEventListener('click', () => loadSection('userDetails?edit=true'));
    if (cancelBtn) cancelBtn.addEventListener('click', () => loadSection('userDetails'));
}

document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main-content');

    document.querySelector('.sidebar-toggle')?.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    });

    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', async (e) => {
            e.preventDefault();
            const section = link.dataset.section.trim();
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            await loadSection(section);
        });
    });

    loadSection('bookAppointment');
});

// Fetch specialties from SortServlet
async function fetchSpecialties() {
    const specialtySelect = document.getElementById('specialty');
    if (!specialtySelect) return;
    const url = `${window.contextPath}/SortServlet`;
    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) throw new Error(`Failed to fetch specialties: ${response.statusText}`);
        const data = await response.json();
        allSpecialties = data.specialties || [];
        populateSpecialties();
    } catch (error) {
        console.error("Error fetching specialties:", error);
        specialtySelect.insertAdjacentHTML('afterend', `<p class="error">Error: ${error.message}</p>`);
    }
}

function populateSpecialties() {
    const specialtySelect = document.getElementById('specialty');
    specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
    allSpecialties.forEach(specialty => {
        specialtySelect.insertAdjacentHTML('beforeend', `<option value="${specialty}">${specialty}</option>`);
    });
}

// Fetch and update availability table
async function updateAvailabilityTable() {
    const specialty = document.getElementById('specialty')?.value;
    const table = document.getElementById('availabilityTable');
    const tbody = table?.querySelector('tbody');
    const filterContainer = document.getElementById('filterContainer');
    const filterDoctor = document.getElementById('filterDoctor');
    const filterDate = document.getElementById('filterDate');
    const noResults = document.getElementById('noResults');

    if (!specialty || !tbody) return;

    tbody.innerHTML = '';
    table.style.display = 'none';
    filterContainer.style.display = 'none';
    filterDoctor.innerHTML = '<option value="">All Doctors</option>';
    filterDate.innerHTML = '<option value="">All Dates</option>';
    noResults.style.display = 'none';

    document.getElementById('specialty-error').textContent = specialty ? '' : 'Please select a specialty';
    if (!specialty) return;

    try {
        const url = `${window.contextPath}/SortServlet?specialty=${encodeURIComponent(specialty)}`;
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) throw new Error(`Failed to fetch availability: ${response.statusText}`);
        const data = await response.json();
        allAvailability = data.availability || [];
        allDoctors = data.doctors || [];

        if (allAvailability.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7">No availability found</td></tr>';
            table.style.display = 'table';
            noResults.style.display = 'block';
            return;
        }

        allDoctors.forEach(doctor => {
            filterDoctor.insertAdjacentHTML('beforeend', `<option value="${doctor}">${doctor}</option>`);
        });
        const uniqueDates = [...new Set(allAvailability.map(avail => avail.date))];
        uniqueDates.forEach(date => {
            filterDate.insertAdjacentHTML('beforeend', `<option value="${date}">${date}</option>`);
        });

        allAvailability.forEach(avail => {
            const bookedAppt = userAppointments.find(appt =>
                appt.doctorId === avail.doctorId &&
                appt.date === avail.date &&
                appt.timeSlot === avail.startTime
            );
            const token = bookedAppt ? bookedAppt.token : avail.nextToken;
            const isBooked = !!bookedAppt;
            // Simulate server-side appointmentCount update locally for immediate feedback
            const updatedCount = isBooked ? avail.appointmentCount : avail.appointmentCount;
            const row = `
                <tr data-doctor="${avail.doctorName}" data-date="${avail.date}">
                    <td>${avail.doctorName}</td>
                    <td>${avail.date}</td>
                    <td>${avail.startTime}</td>
                    <td>${avail.endTime}</td>
                    <td>${updatedCount}</td>
                    <td>${token}</td>
                    <td>
                        ${!isBooked ? `<button class="book-btn" onclick="showBookingConfirmation('${avail.doctorId}', '${avail.doctorName}', '${avail.date}', '${avail.startTime}', '${avail.nextToken}')">
                            <i class="fas fa-calendar-check"></i> Book
                        </button>` : 'Booked'}
                    </td>
                </tr>
            `;
            tbody.insertAdjacentHTML('beforeend', row);
        });

        table.style.display = 'table';
        filterContainer.style.display = 'block';
    } catch (error) {
        console.error("Error fetching availability:", error);
        tbody.innerHTML = `<tr><td colspan="7">Error: ${error.message}</td></tr>`;
        table.style.display = 'table';
        noResults.style.display = 'block';
    }
}

function filterTable() {
    const filterDoctor = document.getElementById('filterDoctor')?.value;
    const filterDate = document.getElementById('filterDate')?.value;
    const rows = document.querySelectorAll('#availabilityTable tbody tr');
    const noResults = document.getElementById('noResults');
    let visibleRows = 0;

    rows.forEach(row => {
        const doctor = row.getAttribute('data-doctor');
        const date = row.getAttribute('data-date');
        const doctorMatch = !filterDoctor || doctor === filterDoctor;
        const dateMatch = !filterDate || date === filterDate;
        row.style.display = (doctorMatch && dateMatch) ? '' : 'none';
        if (doctorMatch && dateMatch) visibleRows++;
    });
    noResults.style.display = visibleRows === 0 ? 'block' : 'none';
    document.getElementById('availabilityTable').style.display = visibleRows === 0 ? 'none' : 'table';
}

function showBookingConfirmation(doctorId, doctorName, date, startTime, nextToken) {
    const modal = document.getElementById('confirmModal');
    const message = document.getElementById('confirmMessage');
    const details = document.getElementById('appointmentDetails');

    if (!modal || !message || !details) return;

    message.textContent = "Are you sure you want to book this appointment?";
    details.innerHTML = `
        <p><strong>Doctor:</strong> ${doctorName}</p>
        <p><strong>Date:</strong> ${date}</p>
        <p><strong>Start Time:</strong> ${startTime}</p>
        <p><strong>Your Token:</strong> ${nextToken}</p>
    `;

    pendingBooking = { doctorId, date, startTime, nextToken };
    modal.showModal();
}

function setupConfirmButton() {
    const confirmBtn = document.getElementById('confirmBtn');
    if (confirmBtn) {
        confirmBtn.addEventListener('click', () => {
            if (pendingBooking) {
                confirmBooking(pendingBooking.doctorId, pendingBooking.date, pendingBooking.startTime, pendingBooking.nextToken);
                pendingBooking = null;
            }
            closeModal();
        });
    }
}

function confirmBooking(doctorId, date, startTime, nextToken) {
    fetch(`${window.contextPath}/user`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        body: new URLSearchParams({
            action: 'book',
            doctorId,
            date,
            timeSlot: startTime,
            token: nextToken,
            isEmergency: 'off'
        })
    })
        .then(response => {
            if (!response.ok) throw new Error(`Booking failed: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            if (data.success) {
                alert(`Appointment booked successfully! Token: ${nextToken}`);
                // Update userAppointments with the new booking
                userAppointments.push({ doctorId, date, timeSlot: startTime, token: nextToken });
                // Refresh availability to get updated appointmentCount from server
                updateAvailabilityTable();
            } else {
                alert("Booking failed: " + (data.message || "Unknown error"));
            }
        })
        .catch(error => {
            console.error("Booking error:", error);
            alert(`Error booking appointment: ${error.message}`);
        });
}

async function fetchUserAppointmentsForTokens() {
    const url = `${window.contextPath}/user?action=getAppointments`;
    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) throw new Error(`Failed to fetch appointments: ${response.statusText}`);
        const appointments = await response.json();
        userAppointments = appointments.map(appt => ({
            doctorId: appt.doctorId,
            date: appt.dateTime.split(' ')[0],
            timeSlot: appt.dateTime.split(' ')[1],
            token: appt.tokenID
        }));
        console.log("User appointments loaded:", userAppointments);
        updateAvailabilityTable(); // Refresh table after loading appointments
    } catch (error) {
        console.error("Error fetching appointments:", error);
        userAppointments = [];
        updateAvailabilityTable(); // Still update table to clear any stale data
    }
}

async function fetchUserAppointments() {
    const table = document.querySelector('#appointmentsSection table tbody');
    const noAppointmentsMessage = document.getElementById('noAppointmentsMessage');
    if (!table || !noAppointmentsMessage) return;

    const url = `${window.contextPath}/user?action=getAppointments`;
    const currentDate = new Date('2025-04-07'); // Matches your context date

    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store',
            credentials: 'same-origin'
        });
        if (!response.ok) throw new Error(`Failed to fetch appointments: ${response.statusText}`);
        const appointments = await response.json();

        table.innerHTML = '';
        noAppointmentsMessage.style.display = appointments.length === 0 ? 'flex' : 'none';

        appointments.forEach(appt => {
            const dateTime = appt.dateTime;
            const apptDateTime = new Date(dateTime);
            const isUpcoming = apptDateTime >= currentDate;
            const rowClass = isUpcoming ? 'upcoming-appointment' : 'past-appointment';
            const row = `
                <tr class="${rowClass}">
                    <td>${appt.id}</td>
                    <td>${appt.doctorId}</td> <!-- Doctor name not available yet; see note -->
                    <td>${appt.tokenID}</td>
                    <td>${dateTime}</td>
                    <td class="${appt.priority == 1 ? 'priority-high' : 'priority-normal'}">
                        ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                    </td>
                </tr>
            `;
            table.insertAdjacentHTML('beforeend', row);
        });
    } catch (error) {
        console.error("Error fetching appointments:", error);
        table.innerHTML = `<tr><td colspan="5">Error: ${error.message}</td></tr>`;
        noAppointmentsMessage.style.display = 'none';
    }
}

function sortTable(col) {
    const table = document.querySelector('#appointmentsSection table tbody');
    const rows = Array.from(table.rows);
    const th = document.querySelector(`#appointmentsSection th[data-sort="${col}"]`);
    const isAsc = !th.classList.contains('asc');

    document.querySelectorAll('#appointmentsSection .sortable').forEach(header => {
        if (header !== th) header.classList.remove('asc', 'desc');
    });
    th.classList.toggle('asc', isAsc);
    th.classList.toggle('desc', !isAsc);

    rows.sort((a, b) => {
        const x = a.cells[col].textContent.trim();
        const y = b.cells[col].textContent.trim();
        if (col === 0) return isAsc ? parseInt(x) - parseInt(y) : parseInt(y) - parseInt(x); // ID
        if (col === 3) return isAsc ? new Date(x) - new Date(y) : new Date(y) - new Date(x); // DateTime
        if (col === 4) {
            const priorityOrder = { 'Emergency': 1, 'Normal': 0 };
            return isAsc ? priorityOrder[x] - priorityOrder[y] : priorityOrder[y] - priorityOrder[x]; // Priority
        }
        return isAsc ? x.localeCompare(y) : y.localeCompare(x); // DoctorId, Token
    });

    rows.forEach(row => table.appendChild(row));
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
    const modal = document.getElementById('confirmModal');
    if (modal) modal.close();
}