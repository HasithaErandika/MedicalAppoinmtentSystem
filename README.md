# Medical Appointment Scheduling System

## Project Overview
The **Medical Appointment Scheduling System** is a web-based application designed to streamline the process of booking and managing medical appointments. It allows **patients** to register, log in, and schedule appointments with doctors, while **admins** can oversee all users, doctors, and appointments. The system uses **file handling** for data storage (no database) and incorporates **priority queues** for emergency appointments and **bubble sort** for organizing appointment schedules.

This project demonstrates core Java concepts (OOP, Servlets), JSP for dynamic frontends, and basic algorithms, making it an excellent showcase of full-stack development skills.

---

## Features

### Patient Features
- Register and log in to the system.
- Book appointments with available doctors by selecting date and time.
- Cancel existing appointments.
- View personal appointment history.

### Admin Features
- Log in with admin credentials.
- Manage doctors (add, edit, remove).
- View and sort all appointments by date/time using bubble sort.
- Search appointments by patient name or date.
- Prioritize emergency appointments using a priority queue.

### Doctor Features (Optional)
- View personal appointment schedule.

### Technical Highlights
- **File-Based Storage**: Data stored in `patients.txt`, `doctors.txt`, and `appointments.txt`.
- **Priority Queue**: Ensures critical patients are scheduled first.
- **Bubble Sort**: Orders appointments chronologically for admin views.

---

## Project Structure
```
📁 MedicalAppointmentSystem
│── 📁 src
│   ├── 📁 main
│   │   ├── 📁 java                        # All backend logic (MVC style)
│   │   │   ├── 📁 model                   # Data/Entity Classes (Encapsulation + OOP)
│   │   │   │   ├── Patient.java           # Patient details (id, name, age, etc.)
│   │   │   │   ├── Doctor.java            # Doctor details (name, specialization)
│   │   │   │   ├── Appoinment.java       # Appointment object (priority, time, doctor, patient)
│   │   │   ├── 📁 service                  # Business Logic Layer
│   │   │   │   ├── AppointmentService.java # Appointment scheduling & sorting (Bubble Sort)
│   │   │   │   ├── FileHandler.java        # All file read/write CRUD methods
│   │   │   │   ├── DoctorAvailabilityService.java        # search doctor availability
│   │   │   ├── 📁 controller               # Servlets (Handles HTTP Requests)
│   │   │   │   ├── LoginServlet.java       # Handles user/admin login
│   │   │   │   ├── RegisterServlet.java    # Handles patient registration
│   │   │   │   ├── AppointmentServlet.java # Handles booking/canceling
│   │   │   │   ├── AdminServlet.java       # Admin dashboard (view/manage data)
│   │   │   │   ├── DataManagementServlet.java       
│   │   │   │   ├── DoctorScheduleServlet.java       
│   │   │   │   ├── ManageDoctorsServlet.java       
│   │   │   │   ├── ManagePatientsServlet.java      
│   │   │   │   ├── UserServlet.java       
│   │   ├── 📁 webapp                       # All frontend files (UI Pages + Data)
│   │   │   ├── 📁 pages                    # All JSP Pages
│   │   │   │   ├── index.jsp               # Home page (like The Odin Project)
│   │   │   │   ├── login.jsp               # Combined Login page (User/Admin)
│   │   │   │   ├── adminDashboard.jsp           # Admin Dashboard
│   │   │   │   ├── doctorDashboard.jsp     # Doctor Dashboard (if needed)
│   │   │   │   ├── appointment.jsp         # Appointment Booking Page
│   │   │   │   ├── userProfile.jsp             # Patient profile (view appointments)
│   │   │   │   ├── error.jsp                # Display errors (invalid login, etc.)
│   │   │   │   ├── dataManagement.jsp               
│   │   │   │   ├── doctorSchedule.jsp                 
│   │   │   │   ├── manageDoctors.jsp               
│   │   │   │   ├── managePatients.jsp 
│   │   │   │   ├── register.jsp                 
│   │   │   ├── 📁 assets                    # Static files (CSS, JS, Images)
│   │   │   │   ├── styles.css               # Custom styles
│   │   │   │   ├── script.js                 # Optional JS
│   │   │   ├── WEB-INF
│   │   │   │   ├── web.xml                   # Servlet Mappings
│   │   │   ├── 📁 data                      # All system data (stored in plain files)
│   │   │   │   ├── patients.txt              # Patient records
│   │   │   │   ├── doctors.txt               # Doctor records
│   │   │   │   ├── appointments.txt          # Appointments
│   │   │   │   ├── audit.txt                 # Admin credentials (username/password)
│   │   │   │   ├── doctors_availability.txt        
│── 📁 target                               # Maven build output (ignore)
│── 📄 pom.xml                              # Maven Config (dependencies)
│── 📄 README.md                            # Project description
│── 📄 report.pdf                           # Final documentation (diagrams + Git log)
│── 📄 .gitignore                           # Ignore files like target/, .idea/
```


---

## Setup Instructions

### Prerequisites
- **Java**: JDK 11 or higher
- **Maven**: 3.6.x or higher (bundled with IntelliJ or installed manually)
- **IDE**: IntelliJ IDEA (recommended for Smart Tomcat plugin)
- **Web Server**: Apache Tomcat 10.1.x (Jakarta EE 9 compatible)

### Installation
1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd MedicalAppointmentSystem
   ```

2. **Install Dependencies**:
    - Open the project in IntelliJ IDEA.
    - Open `pom.xml` and let IntelliJ sync dependencies, or run:
      ```bash
      mvn clean install
      ```

3. **Configure Tomcat**:
    - In IntelliJ: `Run > Edit Configurations` > Add "Smart Tomcat".
    - Select Tomcat 10.1.x installation directory.
    - Deploy `MedicalAppointmentSystem:war exploded`.
    - Set "Application context" to `/MedicalAppointmentSystem`.

4. **Populate Data Files**:
    - Add sample data to `src/main/webapp/data/`:
        - `patients.txt`: `patient1,pass123,John Doe,30,555-1234`
        - `doctors.txt`: `doctor1,pass456,Dr. Smith,Cardiology`
        - `admins.txt`: `admin1,pass789`

5. **Run the Application**:
    - Click the "Run" button in IntelliJ (▶️).
    - Access at: `http://localhost:8080/MedicalAppointmentSystem/`.

---

## Usage
1. **Home Page (`index.jsp`)**:
    - Hover over "Login" in the navbar.
    - Select "Patient Login," "Doctor Login," or "Admin Login" from the dropdown.

2. **Login Page (`login.jsp`)**:
    - **Patient**: Enter `patient1`/`pass123` for a green-themed interface.
    - **Doctor**: Enter `doctor1`/`pass456` for a blue-themed interface.
    - **Admin**: Enter `admin1`/`pass789` for an orange-themed interface.
    - Submit to log in (redirects to respective dashboards, not yet implemented).

3. **Admin Dashboard** (planned):
    - View and manage appointments, doctors, and patients.

---

## Technologies Used
| Component         | Technology/Concept           |
|-------------------|------------------------------|
| **Backend**       | Java (Servlets, OOP)         |
| **Frontend**      | JSP, CSS, Font Awesome       |
| **Storage**       | File Handling (`.txt` files) |
| **Algorithms**    | Priority Queue, Bubble Sort  |
| **Build Tool**    | Maven                        |
| **Server**        | Apache Tomcat 10.1 (Smart Tomcat) |

---

## Current Status
- **Completed**:
    - Home page (`index.jsp`) with role selection.
    - Role-specific login interfaces (`login.jsp`).
    - Login functionality (`LoginServlet`) with file-based authentication.
- **Pending**:
    - Patient profile page (`profile.jsp`).
    - Doctor dashboard (`doctorDashboard.jsp`).
    - Admin dashboard (`dashboard.jsp`).
    - Appointment booking, cancellation, and management features.
    - Priority queue and bubble sort implementation.

---

## Troubleshooting
- **404 Error ("File Not Found")**:
    - Ensure `index.jsp` and `login.jsp` are in `src/main/webapp/pages/`.
    - Verify `target/MedicalAppointmentSystem/` contains all JSPs and `WEB-INF/classes/controller/LoginServlet.class`.
    - Check IntelliJ Tomcat config: "Application context" = `/MedicalAppointmentSystem`.

- **Servlet Not Found**:
    - Confirm `LoginServlet.java` is in `src/main/java/controller/` with `package controller;`.
    - Remove `@WebServlet` annotation if present to rely on `web.xml`.

- **File Access Errors**:
    - Update `LoginServlet` file paths to use `request.getServletContext().getRealPath("/data/")`.

---

## Future Enhancements
- Implement full CRUD operations for appointments.
- Add registration functionality for patients.
- Create dashboards for patients, doctors, and admins.
- Enhance security with password hashing.
- Replace file storage with a database (e.g., MySQL).

---

## Contributing
1. Fork the repository.
2. Create a branch: `git checkout -b feature-name`.
3. Commit changes: `git commit -m "Add feature"`.
4. Push to your fork: `git push origin feature-name`.
5. Submit a pull request.

---

## License
This project is unlicensed and free for educational use. Please attribute the original author if reused.

---

## Contact
For questions or feedback, feel free to reach out via email or GitHub issues.

---

```
### How to Use
1. **Copy the Content**: Copy the above text into a file named `README.md` in your project’s root directory (`MedicalAppointmentSystem/`).
2. **Customize**:
   - Replace `<repository-url>` with your actual GitHub repo URL if applicable.
   - Update the "Contact" section with your email or GitHub handle.
   - Add any additional sections (e.g., screenshots, credits) if desired.
3. **Preview**: Use a Markdown viewer (e.g., IntelliJ’s Markdown plugin or GitHub) to ensure it renders correctly.

This `README.md` provides a professional, structured overview of your project in proper Markdown syntax. Let me know if you’d like to add more details or adjust anything!
```