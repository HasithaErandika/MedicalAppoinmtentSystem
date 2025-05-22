
## Setup Instructions

### Prerequisites
- **Java**: JDK 22.0.2
- **Maven**: 3.8.x or higher
- **Servlet Container**: Apache Tomcat 10.1.39

### Installation Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/HasithaErandika/MedicalAppointmentSystem.git
   cd MedicalAppointmentSystem
   ```

2. **Configure Dependencies**:
   Ensure `pom.xml` includes the following:
   ```xml
   <dependencies>
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
   Install dependencies:
   ```bash
   mvn clean install
   ```

3. **Deploy to Tomcat**:
- Copy `target/MedicalAppointmentSystem.war` to `<tomcat-dir>/webapps/`.
- Start Tomcat:
  ```bash
  <tomcat-dir>/bin/startup.sh  # Linux/Mac
  <tomcat-dir>/bin/startup.bat # Windows
  ```

4. **Access the Application**:
- Open: `http://localhost:8080/MedicalAppointmentSystem`

5. **Initialize Data**:
   Populate the `data/` directory with initial files:
- `patients.txt`: Format: `username,password,name,email,phone,dob`
- `admins.txt`: Default: `admin,admin123`
- `doctors.txt`: Format: `username,password,name,specialization,email,phone`
- `appointments.txt`: Initially empty
- `doctors_availability.txt`: Initially empty
- `audit.txt`: Initially empty

---

## Usage

- **Patients**:
    - Register: `/pages/register.jsp`
    - Login: `/pages/login.jsp`
    - Book/View Appointments: `/pages/userProfile/userDashboard.jsp`
- **Admins**:
    - Login: `/pages/login.jsp` (e.g., `admin/admin123`)
    - Manage System: `/pages/adminDashboard/adminDashboard.jsp`
- **Doctors**:
    - View Dashboard: `/pages/doctorProfile/doctorDashboard.jsp` (no login implemented)

---
