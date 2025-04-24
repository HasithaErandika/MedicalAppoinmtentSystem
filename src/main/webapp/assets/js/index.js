let allSpecialties = [];
let allDoctors = [];
let allAvailability = [];
let userAppointments = []; // User's booked appointments with tokens
let pendingBooking = null; // Temporary storage for booking details

window.onload = function () {
    console.log("Initializing index page...");
    // Clear pendingBooking to prevent modal on back navigation
    pendingBooking = null;
    // Fetch specialties for booking section
    fetchSpecialties();
    // Fetch user appointments if logged in as patient
    if (document.body.dataset.loggedIn === "true" && document.body.dataset.role === "patient") {
        fetchUserAppointments();
        fetchUserAppointmentsForTokens();
        setupTabNavigation();
    }
    // Setup event listeners
    setupFormListeners();
    setupModalListeners();
    setupLoginRegisterModal();
    // Handle query parameters
    handleQueryParameters();
};

// Handle Query Parameters
function handleQueryParameters() {
    const urlParams = new URLSearchParams(window.location.search);
    const specialty = urlParams.get('specialty');
    if (specialty) {
        const specialtySelect = document.getElementById('specialty');
        if (specialtySelect) {
            // Wait for specialties to load
            const interval = setInterval(() => {
                if (allSpecialties.length > 0) {
                    specialtySelect.value = specialty;
                    updateAvailabilityTable();
                    clearInterval(interval);
                }
            }, 100);
        }
        // Clear query parameters to prevent back-button issues
        window.history.replaceState({}, document.title, `${window.contextPath}/pages/index.jsp`);
    }
}

// Tab Navigation (only for logged-in patients)
function setupTabNavigation() {
    const tabButtons = document.querySelectorAll('.tab-btn');
    if (!tabButtons.length) return; // Skip if tabs are not present (non-logged-in users)
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            const tabId = button.dataset.tab;
            // Update active tab
            tabButtons.forEach(btn => {
                btn.classList.remove('active');
                btn.setAttribute('aria-selected', 'false');
            });
            button.classList.add('active');
            button.setAttribute('aria-selected', 'true');
            // Show corresponding pane
            document.querySelectorAll('.tab-pane').forEach(pane => {
                pane.classList.remove('active');
                pane.style.display = 'none';
            });
            const activePane = document.getElementById(tabId);
            activePane.classList.add('active');
            activePane.style.display = 'block';
            // Initialize content
            if (tabId === 'bookAppointment') {
                fetchSpecialties();
            } else if (tabId === 'appointments') {
                fetchUserAppointments();
            }
        });
    });
}

// Form Listeners
function setupFormListeners() {
    const specialtySelect = document.getElementById('specialty');
    if (specialtySelect) {
        specialtySelect.addEventListener('change', updateAvailabilityTable);
    }
    const filterDoctor = document.getElementById('filterDoctor');
    const filterDate = document.getElementById('filterDate');
    if (filterDoctor) filterDoctor.addEventListener('change', filterTable);
    if (filterDate) filterDate.addEventListener('change', filterTable);
    // Appointment table sorting (only for logged-in users)
    document.querySelectorAll('#appointments .sortable').forEach(th => {
        th.addEventListener('click', () => sortTable(parseInt(th.dataset.sort)));
    });
}

// Modal Listeners
function setupModalListeners() {
    const confirmBtn = document.getElementById('confirmBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    const successCloseBtn = document.getElementById('successCloseBtn');
    const cancelModalConfirmBtn = document.getElementById('cancelModalConfirmBtn');
    const cancelModalCancelBtn = document.getElementById('cancelModalCancelBtn');

    if (confirmBtn) {
        confirmBtn.addEventListener('click', () => {
            if (pendingBooking) {
                confirmBooking(pendingBooking.doctorId, pendingBooking.doctorName, pendingBooking.date, pendingBooking.startTime, pendingBooking.nextToken);
                pendingBooking = null;
            }
            closeModal();
        });
    }
    if (cancelBtn) {
        cancelBtn.addEventListener('click', () => {
            pendingBooking = null;
            closeModal();
        });
    }
    if (successCloseBtn) {
        successCloseBtn.addEventListener('click', () => {
            closeSuccessModal();
        });
    }
    if (cancelModalCancelBtn) {
        cancelModalCancelBtn.addEventListener('click', closeCancelModal);
    }
}

// Login/Register Modal
function setupLoginRegisterModal() {
    const loginBtn = document.getElementById('loginModalBtn');
    const registerBtn = document.getElementById('registerModalBtn');
    const cancelBtn = document.getElementById('cancelLoginModalBtn');

    if (loginBtn) {
        loginBtn.addEventListener('click', () => {
            closeLoginRegisterModal();
            window.location.href = `${window.contextPath}/pages/login.jsp?role=patient`;
        });
    }
    if (registerBtn) {
        registerBtn.addEventListener('click', () => {
            closeLoginRegisterModal();
            window.location.href = `${window.contextPath}/pages/register.jsp`;
        });
    }
    if (cancelBtn) {
        cancelBtn.addEventListener('click', closeLoginRegisterModal);
    }
}

// Fetch Specialties
async function fetchSpecialties() {
    const specialtySelect = document.getElementById('specialty');
    if (!specialtySelect) return;
    try {
        const response = await fetch(`${window.contextPath}/SortServlet`, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) {
            return response.text().then(text => {
                throw new Error(`Failed to fetch specialties: ${response.statusText} - ${text}`);
            });
        }
        const data = await response.json();
        allSpecialties = data.specialties || [];
        if (allSpecialties.length === 0) {
            console.warn("No specialties found in the response.");
        }
        populateSpecialties();
    } catch (error) {
        console.error("Error fetching specialties:", error);
        showToast(`Error loading specialties: ${error.message}`, 'error');
    }
}

function populateSpecialties() {
    const specialtySelect = document.getElementById('specialty');
    specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
    allSpecialties.forEach(specialty => {
        specialtySelect.insertAdjacentHTML('beforeend', `<option value="${specialty}">${specialty}</option>`);
    });
}

// Update Availability Table
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
        const response = await fetch(`${window.contextPath}/SortServlet?specialty=${encodeURIComponent(specialty)}`, {
            method: 'GET',
            headers: { Accept: 'application/json' },
            cache: 'no-store'
        });
        if (!response.ok) {
            return response.text().then(text => {
                throw new Error(`Failed to fetch availability: ${response.statusText} - ${text}`);
            });
        }
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
                        ${!isBooked ?
                `<button class="book-btn" onclick="handleBookClick('${avail.doctorId}', '${avail.doctorName}', '${avail.date}', '${avail.startTime}', '${avail.nextToken}', event)">
                                <i class="fas fa-calendar-check"></i> Book
                            </button>` :
                'Booked'}
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
        showToast(`Error fetching availability: ${error.message}`, 'error');
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

// Handle Book Button Click
function handleBookClick(doctorId, doctorName, date, startTime, nextToken, event) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    if (document.body.dataset.loggedIn !== "true" || document.body.dataset.role !== "patient") {
        showLoginRegisterModal();
        return;
    }
    showBookingConfirmation(doctorId, doctorName, date, startTime, nextToken, event);
}

// Booking Confirmation Modal
function showBookingConfirmation(doctorId, doctorName, date, startTime, nextToken, event) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    const modal = document.getElementById('confirmModal');
    const message = document.getElementById('confirmMessage');
    const details = document.getElementById('appointmentDetails');

    if (!modal || !message || !details) {
        console.error("Booking modal elements not found. Ensure modal is present in DOM.");
        showToast("Unable to show booking confirmation. Please try again.", 'error');
        return;
    }

    message.textContent = "Are you sure you want to book this appointment?";
    details.innerHTML = `
        <p><strong>Doctor:</strong> ${doctorName}</p>
        <p><strong>Date:</strong> ${date}</p>
        <p><strong>Start Time:</strong> ${startTime}</p>
        <p><strong>Your Token:</strong> ${nextToken}</p>
    `;

    pendingBooking = { doctorId, doctorName, date, startTime, nextToken };
    document.body.classList.add('modal-open');
    modal.showModal();
}

function closeModal() {
    const modal = document.getElementById('confirmModal');
    if (modal) {
        modal.close();
        document.body.classList.remove('modal-open');
    }
}

// Success Modal
function showSuccessModal(doctorName, date, startTime, nextToken) {
    const modal = document.getElementById('successModal');
    const message = document.getElementById('successMessage');
    const details = document.getElementById('successAppointmentDetails');

    if (!modal || !message || !details) {
        console.error("Success modal elements not found.");
        showToast("Booking confirmed, but unable to show confirmation modal.", 'error');
        return;
    }

    message.textContent = "You have successfully confirmed your booking!";
    details.innerHTML = `
        <p><strong>Doctor:</strong> ${doctorName}</p>
        <p><strong>Date:</strong> ${date}</p>
        <p><strong>Start Time:</strong> ${startTime}</p>
        <p><strong>Your Token:</strong> ${nextToken}</p>
    `;

    document.body.classList.add('modal-open');
    modal.showModal();
}

function closeSuccessModal() {
    const modal = document.getElementById('successModal');
    if (modal) {
        modal.close();
        document.body.classList.remove('modal-open');
    }
}

function confirmBooking(doctorId, doctorName, date, startTime, nextToken) {
    const button = document.querySelector(`button[onclick*="handleBookClick('${doctorId}', '${doctorName}', '${date}', '${startTime}', '${nextToken}')"]`);
    if (button) {
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Booking...';
    }

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
                userAppointments.push({ doctorId, date, timeSlot: startTime, token: nextToken });
                updateAvailabilityTable();
                fetchUserAppointments(); // Refresh appointments tab
                showSuccessModal(doctorName, date, startTime, nextToken);
                // Clear query parameters
                window.history.replaceState({}, document.title, `${window.contextPath}/pages/index.jsp`);
            } else {
                showToast("Booking failed: " + (data.message || "Unknown error"), 'error');
            }
        })
        .catch(error => {
            console.error("Booking error:", error);
            showToast(`Error booking appointment: ${error.message}`, 'error');
        })
        .finally(() => {
            if (button) {
                button.disabled = false;
                button.innerHTML = '<i class="fas fa-calendar-check"></i> Book';
            }
        });
}

// Fetch User Appointments
async function fetchUserAppointments() {
    const table = document.querySelector('#appointments table tbody');
    const noAppointmentsMessage = document.getElementById('noAppointmentsMessage');
    if (!table || !noAppointmentsMessage) return;

    try {
        const response = await fetch(`${window.contextPath}/user?action=getAppointments`, {
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
            const currentDate = new Date('2025-04-23'); // Current date
            const isUpcoming = apptDateTime >= currentDate;
            const rowClass = isUpcoming ? 'upcoming-appointment' : 'past-appointment';
            const row = `
                <tr class="${rowClass}">
                    <td>${appt.id}</td>
                    <td>${appt.doctorId}</td>
                    <td>${appt.tokenID}</td>
                    <td>${dateTime}</td>
                    <td class="${appt.priority == 1 ? 'priority-high' : 'priority-normal'}">
                        ${appt.priority == 1 ? 'Emergency' : 'Normal'}
                    </td>
                    <td>
                        ${isUpcoming ? `<button class="cancel-appointment-btn" onclick="showCancelModal(${appt.id}, '${appt.doctorId}', '${dateTime}', '${appt.tokenID}')">Cancel</button>` : '-'}
                    </td>
                </tr>
            `;
            table.insertAdjacentHTML('beforeend', row);
        });
    } catch (error) {
        console.error("Error fetching appointments:", error);
        table.innerHTML = `<tr><td colspan="6">Error: ${error.message}</td></tr>`;
        noAppointmentsMessage.style.display = 'none';
        showToast(`Error fetching appointments: ${error.message}`, 'error');
    }
}

async function fetchUserAppointmentsForTokens() {
    try {
        const response = await fetch(`${window.contextPath}/user?action=getAppointments`, {
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
        updateAvailabilityTable();
    } catch (error) {
        console.error("Error fetching appointments:", error);
        userAppointments = [];
        updateAvailabilityTable();
        showToast(`Error fetching appointments: ${error.message}`, 'error');
    }
}

// Cancel Appointment Modal
function showCancelModal(appointmentId, doctorId, dateTime, tokenID) {
    const modal = document.getElementById('cancelModal');
    const message = document.getElementById('cancelMessage');
    const details = document.getElementById('cancelAppointmentDetails');

    if (!modal || !message || !details) {
        console.error("Cancel modal elements not found.");
        showToast("Unable to show cancellation confirmation. Please try again.", 'error');
        return;
    }

    message.textContent = "Are you sure you want to cancel this appointment?";
    details.innerHTML = `
        <p><strong>Doctor:</strong> ${doctorId}</p>
        <p><strong>Date & Time:</strong> ${dateTime}</p>
        <p><strong>Token:</strong> ${tokenID}</p>
    `;

    const confirmBtn = document.getElementById('cancelModalConfirmBtn');
    const newConfirmBtn = confirmBtn.cloneNode(true);
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
    fetch(`${window.contextPath}/user`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        body: new URLSearchParams({
            action: 'cancelAppointment',
            appointmentId: appointmentId
        })
    })
        .then(response => {
            if (!response.ok) throw new Error(`Cancellation failed: ${response.statusText}`);
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showToast('Appointment cancelled successfully', 'success');
                fetchUserAppointments();
                fetchUserAppointmentsForTokens();
            } else {
                showToast('Failed to cancel appointment: ' + (data.message || 'Unknown error'), 'error');
            }
        })
        .catch(error => {
            console.error("Cancellation error:", error);
            showToast(`Error cancelling appointment: ${error.message}`, 'error');
        });
}

// Sort Appointments Table
function sortTable(col) {
    const table = document.querySelector('#appointments table tbody');
    const rows = Array.from(table.rows);
    const th = document.querySelector(`#appointments th[data-sort="${col}"]`);
    const isAsc = !th.classList.contains('asc');

    document.querySelectorAll('#appointments .sortable').forEach(header => {
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

// Login/Register Modal Functions
function showLoginRegisterModal() {
    const modal = document.getElementById('loginRegisterModal');
    if (!modal) {
        console.error("Login/Register modal not found.");
        showToast("Unable to show login/register prompt. Please try again.", 'error');
        return;
    }
    document.body.classList.add('modal-open');
    modal.showModal();
}

function closeLoginRegisterModal() {
    const modal = document.getElementById('loginRegisterModal');
    if (modal) {
        modal.close();
        document.body.classList.remove('modal-open');
    }
}

// Toast Notification
function showToast(message, type) {
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
        <i class="fas ${type === 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
        <span>${message}</span>
    `;
    const container = document.querySelector('.appointment-section .container') || document.body;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}