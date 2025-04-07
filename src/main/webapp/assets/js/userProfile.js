// Global variables
let allSpecialties = [];
let allDoctors = [];
let allAvailability = [];
let userAppointments = []; // To store user's booked appointments with tokens
let pendingBooking = null; // To store booking details temporarily

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
    fetchUserAppointmentsForTokens(); // Fetch user's existing appointments
    setupConfirmButton(); // Set up confirm button listener
}

function initAppointments() {
    console.log("Initializing Appointments...");
    fetchUserAppointments();
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
    if (editBtn) {
        editBtn.addEventListener('click', () => {
            loadSection('userDetails?edit=true');
        });
    }
    if (cancelBtn) {
        cancelBtn.addEventListener('click', () => {
            loadSection('userDetails');
        });
    }
    if (!form && !editBtn && !cancelBtn) {
        console.log("No interactive elements found; section may not have loaded correctly.");
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const contextPath = window.contextPath;
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
    const specialty = document.getElementById('specialty')?.value;
    const table = document.getElementById('availabilityTable');
    const tbody = table?.querySelector('tbody');
    const filterContainer = document.getElementById('filterContainer');
    const filterDoctor = document.getElementById('filterDoctor');
    const filterDate = document.getElementById('filterDate');
    const noResults = document.getElementById('noResults');

    if (!specialty || !table || !tbody) {
        console.log("Required elements not found for updating table.");
        return;
    }

    tbody.innerHTML = '';
    table.style.display = 'none';
    filterContainer.style.display = 'none';
    filterDoctor.innerHTML = '<option value="">All Doctors</option>';
    filterDate.innerHTML = '<option value="">All Dates</option>';
    noResults.style.display = 'none';

    if (!specialty) {
        document.getElementById('specialty-error').textContent = 'Please select a specialty';
        console.log("No specialty selected.");
        return;
    }
    document.getElementById('specialty-error').textContent = '';

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
            tbody.innerHTML = '<tr><td colspan="7">No availability found</td></tr>';
            table.style.display = 'table';
            noResults.style.display = 'block';
            console.warn("No availability for specialty:", specialty);
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
                appt.doctorId === avail.username &&
                appt.date === avail.date &&
                appt.timeSlot === avail.startTime
            );
            const token = bookedAppt ? bookedAppt.token : '-';

            const row = `
                <tr data-doctor="${avail.name}" data-date="${avail.date}">
                    <td>${avail.name}</td>
                    <td>${avail.date}</td>
                    <td>${avail.startTime}</td>
                    <td>${avail.endTime}</td>
                    <td>${avail.appointmentCount}</td>
                    <td>${token}</td>
                    <td><button class="book-btn" onclick="showBookingConfirmation('${avail.username}', '${avail.name}', '${avail.date}', '${avail.startTime}', '${avail.nextToken}')">
                        <i class="fas fa-calendar-check" aria-hidden="true"></i> Book
                    </button></td>
                </tr>
            `;
            tbody.insertAdjacentHTML('beforeend', row);
        });

        table.style.display = 'table';
        filterContainer.style.display = 'block';
        console.log("Table populated with:", allAvailability);
    } catch (error) {
        console.error("Error fetching availability:", error);
        tbody.innerHTML = `<tr><td colspan="7">Error: ${error.message}</td></tr>`;
        table.style.display = 'table';
        noResults.style.display = 'block';
    }
}

function filterTable() {
    console.log("Filtering table...");
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
        if (doctorMatch && dateMatch) {
            row.style.display = '';
            visibleRows++;
        } else {
            row.style.display = 'none';
        }
    });
    noResults.style.display = visibleRows === 0 ? 'block' : 'none';
    document.getElementById('availabilityTable').style.display = visibleRows === 0 ? 'none' : 'table';
    console.log("Filtered with doctor:", filterDoctor, "date:", filterDate);
}

function showBookingConfirmation(doctorId, doctorName, date, startTime, nextToken) {
    console.log("Showing booking confirmation for:", { doctorId, doctorName, date, startTime, nextToken });
    const modal = document.getElementById('confirmModal');
    const message = document.getElementById('confirmMessage');
    const details = document.getElementById('appointmentDetails');

    if (!modal || !message || !details) {
        console.error("Modal elements not found.");
        return;
    }

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
        confirmBtn.addEventListener('click', (e) => {
            e.preventDefault(); // Prevent any default behavior
            if (pendingBooking) {
                confirmBooking(pendingBooking.doctorId, pendingBooking.date, pendingBooking.startTime, pendingBooking.nextToken);
                pendingBooking = null;
            }
            closeModal();
        });
    } else {
        console.error("Confirm button not found.");
    }
}

function confirmBooking(doctorId, date, startTime, nextToken) {
    console.log("Confirming booking:", { doctorId, date, startTime, nextToken });
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
            isEmergency: 'off',
            token: nextToken
        })
    })
        .then(response => {
            console.log("Fetch response status:", response.status);
            if (!response.ok) throw new Error(`Booking failed: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            console.log("Booking response:", data);
            if (data.success) {
                alert(`Appointment booked successfully! Your token: ${nextToken}`);
                userAppointments.push({ doctorId, date, timeSlot: startTime, token: nextToken });
                updateAvailabilityTable(); // Update table in place
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
    console.log("Fetching user appointments for tokens...");
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
        console.log("User appointments for tokens:", appointments);
        userAppointments = appointments.map(appt => ({
            doctorId: appt.doctorId,
            date: appt.date,
            timeSlot: appt.timeSlot || appt.dateTime?.split(' ')[1],
            token: appt.token
        }));
        updateAvailabilityTable();
    } catch (error) {
        console.error("Error fetching appointments for tokens:", error);
        userAppointments = [];
    }
}

// ... (Previous unchanged code) ...

function initAppointments() {
    console.log("Initializing Appointments...");
    fetchUserAppointments();
}

async function fetchUserAppointments() {
    console.log("Fetching user appointments...");
    const table = document.querySelector('#appointmentsSection table tbody');
    const noAppointmentsMessage = document.getElementById('noAppointmentsMessage');

    if (!table || !noAppointmentsMessage) {
        console.error("Appointments table or noAppointmentsMessage element not found.");
        return;
    }

    const url = `${window.contextPath}/user?action=getAppointments`;
    const currentDate = new Date('2025-04-07'); // Fixed date as per context

    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store',
            credentials: 'same-origin'
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
            const apptDateTime = new Date(appt.dateTime || `${appt.date} ${appt.timeSlot}`);
            const isUpcoming = apptDateTime >= currentDate;
            const rowClass = isUpcoming ? 'upcoming-appointment' : 'past-appointment';

            const row = `
                <tr class="${rowClass}">
                    <td>${appt.id}</td>
                    <td>${appt.doctorId}</td>
                    <td>${appt.token}</td>
                    <td>${appt.dateTime || `${appt.date} ${appt.timeSlot}`}</td>
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
    console.log("Sorting table by column:", col);
    const table = document.querySelector('#appointmentsSection table tbody');
    const rows = Array.from(table.rows);
    const th = document.querySelector(`#appointmentsSection th[data-sort="${col}"]`);
    const isAsc = !th.classList.contains('asc');

    document.querySelectorAll('#appointmentsSection .sortable').forEach(header => {
        if (header !== th) {
            header.classList.remove('asc', 'desc');
        }
    });

    th.classList.remove('asc', 'desc');
    th.classList.add(isAsc ? 'asc' : 'desc');

    rows.sort((a, b) => {
        const x = a.cells[col].textContent.trim();
        const y = b.cells[col].textContent.trim();

        if (col === 0) { // ID (numeric)
            return isAsc ? parseInt(x) - parseInt(y) : parseInt(y) - parseInt(x);
        } else if (col === 2) { // Token (string)
            return isAsc ? x.localeCompare(y) : y.localeCompare(x);
        } else if (col === 3) { // Date & Time (date)
            return isAsc ? new Date(x) - new Date(y) : new Date(y) - new Date(x);
        } else if (col === 4) { // Priority (Emergency > Normal)
            const priorityOrder = { 'Emergency': 1, 'Normal': 0 };
            return isAsc ? priorityOrder[x] - priorityOrder[y] : priorityOrder[y] - priorityOrder[x];
        } else { // Doctor (string)
            return isAsc ? x.localeCompare(y) : y.localeCompare(x);
        }
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