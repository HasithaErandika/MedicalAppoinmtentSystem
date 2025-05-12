# Medical Appointment Scheduling System

## Overview

The **Medical Appointment Scheduling System** is a web-based application developed as a first-year, second-semester group project. Built using **Java Servlets**, **JSP**, and **Maven**, it demonstrates core programming concepts including **Object-Oriented Programming (OOP)**, **priority queues** for emergency scheduling, and **bubble sort** for appointment ordering. The system uses **plain text files** for data persistence to emphasize file handling skills, avoiding the complexity of a database.

### Key Features
- **Role-Based Access**:
  - **Patients**: Register, book, view, and cancel appointments.
  - **Admins**: Manage appointments, doctors, patients, and schedules.
  - **Doctors**: Access a placeholder dashboard (login not implemented).
- **Appointment Management**: Create, update, and cancel appointments with emergency prioritization using `PriorityQueue`.
- **Doctor Availability**: Admins configure schedules; patients view available slots.
- **File-Based Storage**: Stores data in `.txt` files (patients, doctors, appointments, etc.).
- **Sorting**: Implements bubble sort to order appointments by date and time.
- **Audit Logging**: Tracks system actions for administrative oversight.

### Project Objectives
- Apply **OOP principles** (Encapsulation, Abstraction, Inheritance, Polymorphism).
- Implement **priority queues** for efficient emergency appointment handling.
- Use **bubble sort** for appointment sorting .
- Demonstrate **file handling** for CRUD operations without a database.

---

## Technologies
- **Backend**: Java 22.0.2, Jakarta Servlet API
- **Frontend**: JSP, HTML, CSS, JavaScript (AJAX)
- **Build Tool**: Maven
- **Server**: Apache Tomcat 10.1.39 or 10..+
- **Libraries**:
  - Gson 2.10.1 (JSON handling)
  - Jakarta Servlet JSP JSTL API 2.0.0
  - JUnit 3.8.1 
- **Storage**: Plain text files (`.txt`)

---

## Project Structure

```
MedicalAppointmentSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── model/
│   │   │   │   ├── Availability.java          # Doctor availability slots
│   │   │   │   ├── Appointment.java           # Appointment details
│   │   │   │   ├── Patient.java               # Patient data
│   │   │   │   ├── Doctor.java                # Doctor data
│   │   │   ├── service/
│   │   │   │   ├── AuditService.java          # Audit logging
│   │   │   │   ├── AppointmentService.java    # Appointment management
│   │   │   │   ├── BackupService.java         # Backup functionality
│   │   │   │   ├── DoctorAvailabilityService.java # Doctor slot management
│   │   │   │   ├── FileHandler.java           # File I/O operations
│   │   │   ├── controller/
│   │   │   │   ├── AdminServlet.java          # Admin dashboard
│   │   │   │   ├── DataManagementServlet.java # Backup and logs
│   │   │   │   ├── DoctorServlet.java         # Doctor dashboard
│   │   │   │   ├── DoctorScheduleServlet.java # Schedule management
│   │   │   │   ├── LoginServlet.java          # User login
│   │   │   │   ├── LogoutServlet.java         # User logout
│   │   │   │   ├── ManageAppointmentsServlet.java # Appointment CRUD
│   │   │   │   ├── ManageDoctorsServlet.java  # Doctor CRUD
│   │   │   │   ├── ManagePatientsServlet.java # Patient CRUD
│   │   │   │   ├── RegisterServlet.java       # Patient registration
│   │   │   │   ├── SortServlet.java           # Availability sorting
│   │   │   │   ├── UserServlet.java           # Patient dashboard
│   │   ├── webapp/
│   │   │   ├── pages/
│   │   │   │   ├── adminDashboard/
│   │   │   │   │   ├── adminDashboard.jsp     # Admin dashboard
│   │   │   │   │   ├── doctorSchedule.jsp     # Schedule management
│   │   │   │   │   ├── manageDoctors.jsp      # Doctor management
│   │   │   │   │   ├── managePatients.jsp     # Patient management
│   │   │   │   │   ├── dataManagement.jsp     # Backup and logs
│   │   │   │   │   ├── manageAppointments.jsp # Appointment management
│   │   │   │   ├── doctorProfile/
│   │   │   │   │   ├── doctorDashboard.jsp    # Doctor dashboard main
│   │   │   │   │   ├── appointments.jsp       # Doctor appointments
│   │   │   │   │   ├── dashboard.jsp       # Doctor sub dashboard 
│   │   │   │   │   ├── details.jsp            # Doctor details
│   │   │   │   ├── userProfile/
│   │   │   │   │   ├── userDashboard.jsp      # Patient dashboard
│   │   │   │   │   ├── userDetails.jsp        # Patient details
│   │   │   │   ├── index.jsp                  # Home page
│   │   │   │   ├── login.jsp                  # Login page
│   │   │   │   ├── register.jsp               # Registration page
│   │   │   │   ├── error.jsp                  # Error page
│   │   │   ├── assets/
│   │   │   │   ├── css/
│   │   │   │   │   ├── adminDashboard.css     # Admin styles
│   │   │   │   │   ├── doctorDashboard.css    # Doctor styles
│   │   │   │   │   ├── index.css              # Home page styles
│   │   │   │   │   ├── login.css              # Login styles
│   │   │   │   │   ├── manageOperations.css   # Management styles
│   │   │   │   │   ├── register.css           # Registration styles
│   │   │   │   │   ├── userProfile.css        # Patient styles
│   │   │   │   ├── js/
│   │   │   │   │   ├── doctorDashboard.js     # Doctor scripts
│   │   │   │   │   ├── index.js               # Home page scripts
│   │   │   │   │   ├── userProfile.js         # Patient scripts
│   │   │   │   ├── images/
│   │   │   │   │   ├── all the nessasary images.....
│   │   │   ├── data/
│   │   │   │   ├── patients.txt               # Patient records
│   │   │   │   ├── admins.txt                 # Admin records
│   │   │   │   ├── doctors.txt                # Doctor records
│   │   │   │   ├── appointments.txt           # Appointment records
│   │   │   │   ├── doctors_availability.txt   # Doctor schedules
│   │   │   │   ├── audit.txt                  # Audit logs
│   │   │   ├── WEB-INF/
│   │   │   │   ├── web.xml                    # Servlet mappings
├── target/                                        # Maven build output
├── pom.xml                                        # Maven configuration
├── README.md                                      # This file
├── .gitignore                                     # Git ignore rules
```

---

## System Architecture

The application follows the **Model-View-Controller (MVC)** pattern:
- **Model**: Represents data entities (`Appointment`, `Patient`, `Doctor`, `Availability`).
- **View**: renamed as Services to add all the services given from this web application in backend (`FileHandler.java`, `AppointmentService.java`, etc.).
- **Controller**: Servlets handle HTTP requests and coordinate with services (`AdminServlet`, `UserServlet`, etc.).

### Data Flow
1. **Frontend**: JSP pages send HTTP requests to servlets.
2. **Controller**: Servlets process requests and invoke service-layer logic.
3. **Service**: Services (e.g., `AppointmentService`) manage business logic and interact with `FileHandler` for file I/O.
4. **Storage**: Data is read from and written to `.txt` files in the `data/` directory.

### Example Workflow: Booking an Appointment
1. A patient logs in via `LoginServlet`, validated against `patients.txt`.
2. The patient navigates to `index.jsp` and selects a slot using `SortServlet`.
3. The booking request is processed by `UserServlet`, which calls `AppointmentService.bookAppointment()`.
4. `AppointmentService` uses a `PriorityQueue` to prioritize emergency appointments and updates `appointments.txt`.
5. Admins view sorted appointments (via bubble sort) on `manageAppointments.jsp`.

---


## Technical Highlights

- **Priority Queues**:
  - `AppointmentService` leverages `PriorityQueue` to prioritize emergency appointments (priority=1).
- **Bubble Sort**:
  - Implemented in `AppointmentService` for sorting appointments by date and time:
    ```java
    public List<Appointment> getSortedAppointments() {
        List<Appointment> list = getAllAppointments();
        for (int i = 0; i < list.size() - 1; i++) {
            for (int j = 0; j < list.size() - i - 1; j++) {
                LocalDateTime time1 = LocalDateTime.parse(list.get(j).getDateTime(), DATE_TIME_FORMATTER);
                LocalDateTime time2 = LocalDateTime.parse(list.get(j + 1).getDateTime(), DATE_TIME_FORMATTER);
                if (time1.isAfter(time2)) {
                    Appointment temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                }
            }
        }
        return list;
    }
    ```
- **File Handling**:
  - `FileHandler` abstracts CRUD operations for `.txt` files, ensuring data persistence.

---

## Limitations
- **Security**: Passwords stored in plain text, lacking encryption.
- **Scalability**: File-based storage is inefficient for large datasets.
---

## Future Enhancements
- Implement secure password storage using BCrypt or similar.
- Transition to a lightweight database like SQLite for improved scalability.
- Enhance the UI with real-time updates using WebSockets or modern JavaScript frameworks.

---

## Contributors
- Hasitha Erandika
- Ashen Geeth
- Thilina Senevirathne
- Kaushalya Alwis
- Abhishek Bogahawaththa
- Maleesha Wickramaarachchi

---

## License
Educational Use Only License

This project was developed as part of a university group project and is intended strictly for **educational purposes only**.

Permission is hereby granted to use, copy, and modify this project for **non-commercial, educational use** only.  
Commercial use, distribution, or derivative commercial work based on this project is **strictly prohibited**.

This project is provided "as is" without warranty of any kind, express or implied, including but not limited to the warranties of merchantability or fitness for a particular purpose. In no event shall the authors be held liable for any claim, damages, or other liability arising from the use of this project.

For any use beyond the scope of this license, please contact the authors for permission.
