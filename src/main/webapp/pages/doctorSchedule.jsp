<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Doctor Schedule</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/manageOperations.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="ri-calendar-line"></i> Doctor Schedule</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="ri-arrow-left-line"></i> Back to Dashboard
        </a>
    </div>

    <div class="card">
        <button class="btn btn-primary" onclick="openAddModal()">
            <i class="ri-calendar-check-line"></i> Add Availability
        </button>
    </div>

    <div class="search-container">
        <input type="text" class="search-input" id="searchInput" placeholder="Search schedules..." onkeyup="searchTable()">
        <select class="filter-select" id="yearFilter" onchange="filterTable()">
            <option value="">All Years</option>
            <option value="2024">2024</option>
            <option value="2025">2025</option>
            <!-- Add more years as needed -->
        </select>
        <select class="filter-select" id="monthFilter" onchange="filterTable()">
            <option value="">All Months</option>
            <option value="01">January</option>
            <option value="02">February</option>
            <option value="03">March</option>
            <option value="04">April</option>
            <option value="05">May</option>
            <option value="06">June</option>
            <option value="07">July</option>
            <option value="08">August</option>
            <option value="09">September</option>
            <option value="10">October</option>
            <option value="11">November</option>
            <option value="12">December</option>
        </select>
        <button class="btn btn-primary" onclick="sortTable()">
            <i class="ri-sort-desc"></i> Sort by Date
        </button>
    </div>

    <div class="card">
        <h2 style="margin-bottom: 1.5rem;"><i class="ri-time-line"></i> Current Availability</h2>
        <div class="table-container">
            <table id="scheduleTable">
                <thead>
                <tr>
                    <th>Doctor Name</th>
                    <th>Date</th>
                    <th>Time Slot</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody id="scheduleBody">
                <c:forEach var="avail" items="${availability}">
                    <tr>
                        <td>
                            <c:forEach var="doctor" items="${doctors}">
                                <c:if test="${doctor.split(',')[0] == avail.split(',')[0]}">
                                    <c:out value="${doctor.split(',')[2]}"/>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td><c:out value="${avail.split(',')[1]}"/></td>
                        <td><c:out value="${avail.split(',')[2]}"/> - <c:out value="${avail.split(',')[3]}"/></td>
                        <td>
                            <button class="btn btn-edit" onclick="openEditModal(
                                    '<c:out value="${avail.split(',')[0]}"/>',
                                    '<c:out value="${avail.split(',')[1]}"/>',
                                    '<c:out value="${avail.split(',')[2]}"/>',
                                    '<c:out value="${avail.split(',')[3]}"/>'
                                    )"><i class="ri-edit-line"></i> Edit</button>
                            <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="doctorId" value="${avail.split(',')[0]}">
                                <input type="hidden" name="date" value="${avail.split(',')[1]}">
                                <input type="hidden" name="startTime" value="${avail.split(',')[2]}">
                                <input type="hidden" name="endTime" value="${avail.split(',')[3]}">
                                <button type="submit" class="btn btn-danger"><i class="ri-delete-bin-line"></i> Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Modal -->
<div class="modal" id="addModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="ri-calendar-check-line"></i> Add Availability</h2>
            <button class="modal-close" onclick="closeAddModal()">×</button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <i class="ri-user-line"></i>
                    <label>Doctor</label>
                    <select name="doctorId" required>
                        <option value="" disabled selected>Select a doctor</option>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.split(',')[0]}">${doctor.split(',')[2]}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-calendar-line"></i>
                    <label>Date</label>
                    <input type="date" id="addDate" name="date" required>
                </div>
                <div class="form-group">
                    <i class="ri-time-line"></i>
                    <label>Start Time</label>
                    <select name="startTime" required>
                        <option value="" disabled selected>Select start time</option>
                        <option value="09:00">09:00 AM</option>
                        <option value="10:00">10:00 AM</option>
                        <option value="13:00">01:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-time-line"></i>
                    <label>End Time</label>
                    <select name="endTime" required>
                        <option value="" disabled selected>Select end time</option>
                        <option value="11:00">11:00 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                        <option value="17:30">05:30 PM</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary"><i class="ri-add-line"></i> Add Availability</button>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal" id="editModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="ri-edit-line"></i> Edit Availability</h2>
            <button class="modal-close" onclick="closeEditModal()">×</button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/DoctorScheduleServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="originalDoctorId" id="editOriginalDoctorId">
                <input type="hidden" name="originalDate" id="editOriginalDate">
                <input type="hidden" name="originalStartTime" id="editOriginalStartTime">
                <input type="hidden" name="originalEndTime" id="editOriginalEndTime">
                <div class="form-group">
                    <i class="ri-user-line"></i>
                    <label>Doctor</label>
                    <select id="editDoctorId" name="doctorId" required>
                        <c:forEach var="doctor" items="${doctors}">
                            <option value="${doctor.split(',')[0]}">${doctor.split(',')[2]}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-calendar-line"></i>
                    <label>Date</label>
                    <input type="date" id="editDate" name="date" required>
                </div>
                <div class="form-group">
                    <i class="ri-time-line"></i>
                    <label>Start Time</label>
                    <select id="editStartTime" name="startTime" required>
                        <option value="09:00">09:00 AM</option>
                        <option value="10:00">10:00 AM</option>
                        <option value="13:00">01:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                    </select>
                </div>
                <div class="form-group">
                    <i class="ri-time-line"></i>
                    <label>End Time</label>
                    <select id="editEndTime" name="endTime" required>
                        <option value="11:00">11:00 AM</option>
                        <option value="12:00">12:00 PM</option>
                        <option value="15:30">03:30 PM</option>
                        <option value="17:30">05:30 PM</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Changes</button>
            </form>
        </div>
    </div>
</div>

<script>
    // Modal functions
    function openAddModal() {
        document.getElementById('addModal').style.display = 'flex';
    }

    function closeAddModal() {
        document.getElementById('addModal').style.display = 'none';
    }

    function openEditModal(doctorId, date, startTime, endTime) {
        document.getElementById('editOriginalDoctorId').value = doctorId;
        document.getElementById('editOriginalDate').value = date;
        document.getElementById('editOriginalStartTime').value = startTime;
        document.getElementById('editOriginalEndTime').value = endTime;
        document.getElementById('editDoctorId').value = doctorId;
        document.getElementById('editDate').value = date;
        document.getElementById('editStartTime').value = startTime;
        document.getElementById('editEndTime').value = endTime;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Disable weekends
    function disableWeekends(inputId) {
        const dateInput = document.getElementById(inputId);
        dateInput.addEventListener('input', function() {
            const selectedDate = new Date(this.value);
            const day = selectedDate.getDay();
            if (day === 0 || day === 1) {
                alert('Please select a date from Tuesday to Saturday.');
                this.value = '';
            }
        });
    }

    disableWeekends('addDate');
    disableWeekends('editDate');

    const today = new Date().toISOString().split('T')[0];
    document.getElementById('addDate').setAttribute('min', today);
    document.getElementById('editDate').setAttribute('min', today);

    // Search function
    function searchTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const year = document.getElementById('yearFilter').value;
        const month = document.getElementById('monthFilter').value;
        const table = document.getElementById('scheduleTable');
        const tr = table.getElementsByTagName('tr');

        for (let i = 1; i < tr.length; i++) {
            const td = tr[i].getElementsByTagName('td');
            const doctorName = td[0].textContent.toLowerCase();
            const date = td[1].textContent;
            const [dateYear, dateMonth] = date.split('-');

            let matchesSearch = doctorName.includes(input) || date.includes(input);
            let matchesYear = !year || dateYear === year;
            let matchesMonth = !month || dateMonth === month;

            tr[i].style.display = (matchesSearch && matchesYear && matchesMonth) ? '' : 'none';
        }
    }

    // Filter function
    function filterTable() {
        searchTable(); // Reuse search function for filtering
    }

    // Sort function by date
    function sortTable() {
        const table = document.getElementById('scheduleTable');
        const tbody = document.getElementById('scheduleBody');
        const rows = Array.from(tbody.getElementsByTagName('tr'));

        rows.sort((a, b) => {
            const dateA = new Date(a.cells[1].textContent);
            const dateB = new Date(b.cells[1].textContent);
            return dateB - dateA; // Newest first
        });

        while (tbody.firstChild) {
            tbody.removeChild(tbody.firstChild);
        }
        rows.forEach(row => tbody.appendChild(row));
    }

    window.onclick = function(event) {
        const addModal = document.getElementById('addModal');
        const editModal = document.getElementById('editModal');
        if (event.target === addModal) {
            closeAddModal();
        } else if (event.target === editModal) {
            closeEditModal();
        }
    }
</script>
</body>
</html>