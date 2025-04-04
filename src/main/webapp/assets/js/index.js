let allSpecialties = [];
let allDoctors = [];
let allAvailability = [];

let contextPath = window.contextPath || "";

window.onload = function () {
    console.log("Loading specialties...");
    document.getElementById("resultsContainer").innerHTML = "<p>Loading specialties...</p>";
    fetch(`${contextPath}/SortServlet`, {
        method: "GET",
        headers: { Accept: "application/json" },
        cache: "no-store"
    })
        .then((response) => {
            if (!response.ok) {
                return response.text().then((text) => {
                    throw new Error("Failed to fetch specialties: " + response.statusText + " - " + text);
                });
            }
            return response.json();
        })
        .then((data) => {
            console.log("Raw initial data:", JSON.stringify(data, null, 2));
            // Remove or comment out this line
            // document.getElementById("debugResponse").textContent = "Raw Server Response:\n" + JSON.stringify(data, null, 2);
            allSpecialties = data.specialties || [];
            if (allSpecialties.length === 0) {
                console.warn("No specialties found in the response.");
            }
            populateSpecialties();
            document.getElementById("resultsContainer").innerHTML = "";
        })
        .catch((error) => {
            console.error("Error loading specialties:", error);
            document.getElementById("resultsContainer").innerHTML = "<p>Error loading specialties: " + error.message + "</p>";
        });
};

function populateSpecialties() {
    const specialtySelect = document.getElementById("specialty");
    specialtySelect.innerHTML = '<option value="">Select Specialty</option>';
    allSpecialties.forEach((specialty) => {
        specialtySelect.innerHTML += `<option value="${specialty}">${specialty}</option>`;
    });
    console.log("Specialty dropdown populated with:", allSpecialties);
}

function updateAvailabilityTable() {
    console.log("updateAvailabilityTable triggered");
    const specialty = document.getElementById("specialty").value;
    const table = document.getElementById("availabilityTable");
    const tbody = table.querySelector("tbody");
    const filterContainer = document.getElementById("filterContainer");
    const filterDoctor = document.getElementById("filterDoctor");
    const filterDate = document.getElementById("filterDate");

    tbody.innerHTML = "";
    table.style.display = "none";
    filterContainer.style.display = "none";
    filterDoctor.innerHTML = '<option value="">All Doctors</option>';
    filterDate.innerHTML = '<option value="">All Dates</option>';

    if (!specialty) {
        console.log("No specialty selected, hiding table and filters.");
        return;
    }

    console.log("Fetching availability for specialty:", specialty);
    fetch(`${contextPath}/SortServlet?specialty=${encodeURIComponent(specialty)}`, {
        method: "GET",
        headers: { Accept: "application/json" },
        cache: "no-store"
    })
        .then((response) => {
            if (!response.ok) {
                return response.text().then((text) => {
                    throw new Error("Failed to fetch availability: " + response.statusText + " - " + text);
                });
            }
            return response.json();
        })
        .then((data) => {
            console.log("Raw availability data:", JSON.stringify(data, null, 2));
            allAvailability = data.availability || [];
            allDoctors = data.doctors || [];

            if (allAvailability.length === 0) {
                console.warn("No availability found for specialty:", specialty);
                tbody.innerHTML = '<tr><td colspan="5">No availability found</td></tr>';
                table.style.display = "table";
                return;
            }

            // Populate doctor filter
            allDoctors.forEach((doctor) => {
                filterDoctor.innerHTML += `<option value="${doctor}">${doctor}</option>`;
            });

            // Populate date filter
            const uniqueDates = [...new Set(allAvailability.map((avail) => avail.date))].sort();
            uniqueDates.forEach((date) => {
                filterDate.innerHTML += `<option value="${date}">${date}</option>`;
            });

            // Populate table
            allAvailability.forEach((avail) => {
                const row = `
                    <tr data-doctor="${avail.name}" data-date="${avail.date}">
                        <td>${avail.name}</td>
                        <td>${avail.date}</td>
                        <td>${avail.startTime}</td>
                        <td>${avail.endTime}</td>
                        <td><button class="book-btn" onclick="bookAppointment('${avail.username}', '${avail.date}', '${avail.startTime}')">Book</button></td>
                    </tr>
                `;
                tbody.innerHTML += row;
            });

            console.log("Availability table populated with:", allAvailability);
            table.style.display = "table";
            filterContainer.style.display = "block";
        })
        .catch((error) => {
            console.error("Error loading availability:", error);
            tbody.innerHTML = `<tr><td colspan="5">Error loading availability: ${error.message}</td></tr>`;
            table.style.display = "table";
        });
}

function filterTable() {
    console.log("filterTable triggered");
    const filterDoctor = document.getElementById("filterDoctor").value;
    const filterDate = document.getElementById("filterDate").value;
    const rows = document.querySelectorAll("#availabilityTable tbody tr");

    rows.forEach((row) => {
        const doctor = row.getAttribute("data-doctor");
        const date = row.getAttribute("data-date");
        const doctorMatch = !filterDoctor || doctor === filterDoctor;
        const dateMatch = !filterDate || date === filterDate;

        row.style.display = (doctorMatch && dateMatch) ? "" : "none";
    });

    console.log("Table filtered with doctor:", filterDoctor, "and date:", filterDate);
}

function closePopup() {
    document.getElementById("resultsPopup").style.display = "none";
}

function bookAppointment(username, date, startTime) {
    if (!document.body.dataset.loggedIn) {
        alert("Please log in as a patient to book an appointment.");
        window.location.href = `${contextPath}/pages/login.jsp?role=patient`;
        return;
    }

    console.log("Booking appointment:", { username, date, startTime });
    fetch(`${contextPath}/AppointmentServlet`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            Accept: "application/json"
        },
        body: JSON.stringify({ doctorUsername: username, date, time: startTime })
    })
        .then((response) => {
            if (!response.ok) {
                return response.text().then((text) => {
                    throw new Error("Failed to book appointment: " + response.statusText + " - " + text);
                });
            }
            return response.json();
        })
        .then((data) => {
            console.log("Booking response:", data);
            if (data.success) {
                alert("Appointment booked successfully!");
                updateAvailabilityTable(); // Refresh table after booking
            } else {
                alert("Failed to book: " + data.message);
            }
        })
        .catch((error) => {
            console.error("Booking error:", error);
            alert("Error booking appointment: " + error.message);
        });
}