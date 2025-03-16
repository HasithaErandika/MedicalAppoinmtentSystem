
---

# Medical Appointment Scheduling System

## Overview
The **Medical Appointment Scheduling System** is a web-based application developed as a 1st-year, 2nd-semester student project using Java Servlets and JSPs. It enables patients to book medical appointments, admins to manage system data, and incorporates priority queues for emergency scheduling and bubble sort for ordering appointments—all without a database, using plain text files for storage.

### Key Features
- **Role-Based Access**: Supports Patients (book appointments), Admins (manage system), and placeholder for Doctors.
- **Appointment Management**: Book, edit, cancel appointments with priority (emergency vs. normal).
- **Doctor Availability**: Admins manage doctor schedules; patients see available slots.
- **File-Based Storage**: Data stored in `.txt` files (patients, doctors, appointments).
- **Sorting**: Uses bubble sort to order appointments by date/time.
- **Priority Queues**: Prioritizes emergency appointments using `PriorityQueue`.

### Project Goals
- Implement **priority queues** to handle emergency appointments.
- Use **bubble sort** for sorting appointments (academic requirement).
- Demonstrate **file handling** for CRUD operations without a database.

## Project Structure
```
📁 MedicalAppointmentSystem
│── 📁 src
│   ├── 📁 main
│   │   ├── 📁 java                        # All backend logic (MVC style)
│   │   │   ├── 📁 model                   # Data/Entity Classes (Encapsulation + OOP)
│   │   │   │   ├── Patient.java           # Patient details (id, name, age, etc.)
│   │   │   │   ├── Doctor.java            # Doctor details (name, specialization)
│   │   │   │   ├── Appointment.java       # Appointment object (priority, time, doctor, patient)
│   │   │   ├── 📁 service                  # Business Logic Layer
│   │   │   │   ├── AppointmentService.java # Appointment scheduling & sorting (Bubble Sort)
│   │   │   │   ├── FileHandler.java        # All file read/write CRUD methods
│   │   │   │   ├── DoctorAvailabilityService.java # Search doctor availability
│   │   │   │   ├── BackupService.java    # Get a back up from the Admin Panel
│   │   │   │   ├── AuditService.java # Make Audits
│   │   │   ├── 📁 controller               # Servlets (Handles HTTP Requests)
│   │   │   │   ├── LoginServlet.java       # Handles user/admin login
│   │   │   │   ├── RegisterServlet.java    # Handles patient registration
│   │   │   │   ├── AppointmentServlet.java # Handles booking/canceling
│   │   │   │   ├── AdminServlet.java       # Admin dashboard (view/manage data)
│   │   │   │   ├── DataManagementServlet.java # Backup and log management
│   │   │   │   ├── DoctorScheduleServlet.java # Doctor availability management
│   │   │   │   ├── ManageDoctorsServlet.java  # CRUD for doctors
│   │   │   │   ├── ManagePatientsServlet.java # CRUD for patients
│   │   │   │   ├── UserServlet.java        # Patient dashboard
│   │   ├── 📁 webapp                       # All frontend files (UI Pages + Data)
│   │   │   ├── 📁 pages                    # All JSP Pages
│   │   │   │   ├── index.jsp               # Home page (doctor search)
│   │   │   │   ├── login.jsp               # Combined login page (user/admin)
│   │   │   │   ├── adminDashboard.jsp      # Admin dashboard
│   │   │   │   ├── doctorDashboard.jsp     # Doctor dashboard (placeholder)
│   │   │   │   ├── appointment.jsp         # Appointment management
│   │   │   │   ├── userProfile.jsp         # Patient profile (view appointments)
│   │   │   │   ├── error.jsp               # Display errors
│   │   │   │   ├── dataManagement.jsp      # Backup and audit logs
│   │   │   │   ├── doctorSchedule.jsp      # Doctor schedule management
│   │   │   │   ├── manageDoctors.jsp       # Manage doctor records
│   │   │   │   ├── managePatients.jsp      # Manage patient records
│   │   │   │   ├── register.jsp            # Patient registration
│   │   │   ├── 📁 assets                   # Static files (CSS, JS, Images)
│   │   │   │   ├── styles.css              # Custom styles
│   │   │   │   ├── script.js               # Optional JS
│   │   │   ├── WEB-INF
│   │   │   │   ├── web.xml                 # Servlet mappings
│   │   │   ├── 📁 data                     # All system data (stored in plain files)
│   │   │   │   ├── patients.txt            # Patient records
│   │   │   │   ├── doctors.txt             # Doctor records
│   │   │   │   ├── appointments.txt        # Appointments
│   │   │   │   ├── audit.txt               # Admin credentials and logs
│   │   │   │   ├── doctors_availability.txt # Doctor schedules
│── 📁 target                               # Maven build output (ignore)
│── 📄 pom.xml                              # Maven Config (dependencies)
│── 📄 README.md                            # This file
│── 📄 report.pdf                           # Final documentation (diagrams + Git log)
│── 📄 .gitignore                           # Ignore files like target/, .idea/
```

## Technologies Used
- **Backend**: Java (Servlets, JSTL)
- **Frontend**: JSP, HTML, CSS, JavaScript (AJAX, modals)
- **Build Tool**: Maven
- **Storage**: Plain text files (`.txt`)
- **External Libraries**: Font Awesome (icons)

## How It Works

### User Roles and Flow
1. **Patients**:
    - **Register**: Via `register.jsp` → `RegisterServlet` → `patients.txt`.
    - **Login**: Via `login.jsp` → `LoginServlet`.
    - **Book Appointment**: Via `userProfile.jsp` or `index.jsp` → `AppointmentServlet`.
    - **View Appointments**: On `userProfile.jsp`.

2. **Admins**:
    - **Login**: Via `login.jsp` → `LoginServlet` (checks `audit.txt`).
    - **Dashboard**: `adminDashboard.jsp` → `AdminServlet` (stats, sorted appointments).
    - **Manage Appointments**: `appointment.jsp` → `AppointmentServlet`.
    - **Manage Doctors**: `manageDoctors.jsp` → `ManageDoctorsServlet`.
    - **Manage Patients**: `managePatients.jsp` → `ManagePatientsServlet`.
    - **Set Schedules**: `doctorSchedule.jsp` → `DoctorScheduleServlet`.
    - **Data Management**: `dataManagement.jsp` → `DataManagementServlet` (backups, logs).

3. **Doctors**:
    - No direct UI; availability managed by admins.

### Data Flow
- **Frontend**: JSPs send HTTP requests to servlets.
- **Controller**: Servlets process requests, call service classes.
- **Service**: Business logic (e.g., `AppointmentService`) uses `FileHandler` for file I/O.
- **Model**: Data stored as objects (e.g., `Patient`) and serialized to `.txt` files.

### Example: Booking an Appointment
1. Patient logs in (`login.jsp` → `LoginServlet`).
2. Goes to `userProfile.jsp`, selects doctor/date.
3. AJAX call to `AppointmentServlet` (`getTimeSlots`) fetches slots from `doctors_availability.txt` via `DoctorAvailabilityService`.
4. Submits booking (`AppointmentServlet` → `AppointmentService`).
5. `AppointmentService` assigns ID, sets priority, and writes to `appointments.txt`.
6. Admin views sorted list in `appointment.jsp`.

## Setup Instructions

### Prerequisites
- **Java**: JDK 8 or higher
- **Maven**: For dependency management
- **Servlet Container**: Apache Tomcat 9.x or similar

### Steps
1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd MedicalAppointmentSystem
   ```

2. **Install Dependencies**:
    - Ensure `pom.xml` includes:
      ```xml
      <dependencies>
          <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>5.0.0</version>
            <scope>provided</scope>
          </dependency>
          <dependency>
            <groupId>jakarta.servlet.jsp.jstl</groupId>
            <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
            <version>2.0.0</version>
          </dependency>
          <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>jakarta.servlet.jsp.jstl</artifactId>
            <version>2.0.0</version>
          </dependency>
          <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>3.8.1</version>
            <scope>test</scope>
          </dependency>
          <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.10.1</version>
          </dependency>
        </dependencies>
      ```
    - Run:
      ```bash
      mvn clean install
      ```

3. **Deploy to Tomcat**:
    - Copy the generated `.war` file from `target/` to `Tomcat/webapps/`.
    - Start Tomcat:
      ```bash
      <tomcat-dir>/bin/startup.sh  # Linux/Mac
      <tomcat-dir>/bin/startup.bat # Windows
      ```

4. **Access the Application**:
    - Open `http://localhost:8080/MedicalAppointmentSystem` in a browser.

5. **Initial Data**:
    - Populate `data/` files manually or via the app:
        - `patients.txt`: `id,name,age,contact,password,dob`
        - `doctors.txt`: `id,name,specialization,contact`
        - `audit.txt`: `admin,admin123` (default admin credentials)

## Usage
- **Patient**:
    - Register at `/pages/register.jsp`.
    - Login at `/pages/login.jsp`.
    - Book appointments via `/pages/userProfile.jsp`.

- **Admin**:
    - Login at `/pages/login.jsp` (e.g., `admin/admin123`).
    - View dashboard at `/pages/adminDashboard.jsp`.
    - Manage data via respective JSPs (`manageDoctors.jsp`, etc.).

## Project Highlights
- **Priority Queues**: `AppointmentService.java` uses `PriorityQueue` to prioritize emergencies (`priority=1`).
- **Bubble Sort**: Implemented in `AppointmentService.java`:
  ```java
  public List<Appointment> getSortedAppointments() {
      List<Appointment> list = getAllAppointments();
      for (int i = 0; i < list.size() - 1; i++) {
          for (int j = 0; j < list.size() - i - 1; j++) {
              if (list.get(j).getDateTime().isAfter(list.get(j + 1).getDateTime())) {
                  Appointment temp = list.get(j);
                  list.set(j, list.get(j + 1));
                  list.set(j + 1, temp);
              }
          }
      }
      return list;
  }
  ```
- **File Handling**: `FileHandler.java` manages all `.txt` file operations with synchronized methods.

## Limitations
- **No Doctor UI**: Doctors can’t log in or manage schedules.
- **Security**: Plain-text passwords (recommend hashing with `SecurityUtil`).
- **Scalability**: File-based storage lacks concurrency control for multi-user scenarios.

## Future Improvements
- Add doctor login and dashboard (`doctorDashboard.jsp`).
- Implement password hashing.
- Replace file storage with a lightweight database (e.g., SQLite).
- Enhance UI with more interactivity (e.g., real-time updates).

## Contributors
- Ashen Geeth
- Thilina Senevirathne
- Kaushalya Alwis
- Abhishek Bogahawaththa
- Maleesha Wickramaarachchi

## License
This project is for educational purposes and not licensed for commercial use.

---
