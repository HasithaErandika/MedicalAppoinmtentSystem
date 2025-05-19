
## OOP Implementation

The project emphasizes **OOP principles** across its layers:

### Model Layer
- **Availability**:
    - **Encapsulation**: Private fields with getters; selective setters.
    - **Abstraction**: Simplifies time slot management.
    - **Inheritance**: Implements `Comparable<Availability>` for sorting.
    - **Polymorphism**: Custom `compareTo` for availability sorting.
- **Appointment**, **Patient**, **Doctor**:
    - **Encapsulation**: Private fields with getters/setters.
    - **Abstraction**: Represents core entities.
    - **Inheritance**: Extends `Object`.
    - **Polymorphism**: Minimal usage.

### Service Layer
- **AuditService**, **BackupService**, **DoctorAvailabilityService**, **FileHandler**:
    - **Encapsulation**: Private fields and methods.
    - **Abstraction**: Handles specific business logic.
    - **Inheritance**: Extends `Object`.
    - **Polymorphism**: None.
- **AppointmentService**:
    - **Encapsulation**: Private fields for data management.
    - **Abstraction**: Manages appointment logic with sorting and prioritization.
    - **Inheritance**: Extends `Object`.
    - **Polymorphism**: Uses `PriorityQueue` for emergency handling.

### Controller Layer
- **Servlets** (e.g., `AdminServlet`, `UserServlet`, etc.):
    - **Encapsulation**: Private fields for services and handlers.
    - **Abstraction**: Manages HTTP request/response flow.
    - **Inheritance**: Extends `HttpServlet`.
    - **Polymorphism**: Limited to `Comparable` in `SortServlet`.

**Summary**: The system demonstrates strong encapsulation and abstraction, with inheritance primarily in controllers (`HttpServlet`) and limited polymorphism (`Comparable`, `PriorityQueue`).

---

## Class Diagrams

Visualize the system's structure using the following **PlantUML** diagrams:

### Model Package
```plantuml
@startuml
class Availability {
  -doctorId: String
  -doctorName: String
  -date: String
  -startTime: String
  -endTime: String
  -appointmentCount: int
  -nextToken: String
  +getDoctorId(): String
  +getStartTimeAsLocalTime(): LocalTime
  +compareTo(other: Availability): int
}
interface Comparable<T>
Availability .|> Comparable

class Appointment {
  -id: int
  -patientId: String
  -doctorId: String
  -tokenID: String
  -dateTime: String
  -priority: int
  -patientName: String
  -doctorName: String
  +getId(): int
  +setPatientName(name: String): void
}

class Patient {
  -name: String
  -age: int
  -contact: String
  -username: String
  -password: String
  +getName(): String
}

class Doctor {
  -id: String
  -name: String
  -specialization: String
  -contact: String
  +getId(): String
}
@enduml
```

### Service Package
```plantuml
@startuml
class AuditService {
  -fileHandler: FileHandler
  +readAuditLogs(): List<String>
  +addAuditLog(log: String): void
}

class AppointmentService {
  -fileHandler: FileHandler
  - emergencyQueue: PriorityQueue<Appointment>
  -cachedAppointments: List<Appointment>
  +bookAppointment(patientId: String, ...): void
  +getSortedAppointments(): List<Appointment>
}

class BackupService {
  -basePath: String
  -auditService: AuditService
  +createBackup(username: String): void
}

class DoctorAvailabilityService {
  -fileHandler: FileHandler
  -appointmentService: AppointmentService
  +getAvailableTimeSlots(doctorId: String, date: String): List<String>
}

class FileHandler {
  -filePath: String
  +readLines(): List<String>
  +writeLines(lines: List<String>): void
  +readAppointments(): List<Appointment>
}

AuditService o--> FileHandler
AppointmentService o--> FileHandler
AppointmentService o--> "many" Appointment
BackupService o--> AuditService
DoctorAvailabilityService o--> FileHandler
DoctorAvailabilityService o--> AppointmentService
@enduml
```

### Controller Package
```plantuml
@startuml
class AdminServlet {
  -appointmentService: AppointmentService
  -availabilityService: DoctorAvailabilityService
  -doctorFileHandler: FileHandler
  -patientFileHandler: FileHandler
  +doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

class DataManagementServlet {
  -auditService: AuditService
  -backupService: BackupService
  +doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

class DoctorServlet {
  -appointmentService: AppointmentService
  -availabilityService: DoctorAvailabilityService
  -doctorFileHandler: FileHandler
  +doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

class DoctorScheduleServlet {
  -availabilityFileHandler: FileHandler
  -doctorFileHandler: FileHandler
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class LoginServlet {
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class LogoutServlet {
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class ManageAppointmentsServlet {
  -appointmentService: AppointmentService
  -availabilityService: DoctorAvailabilityService
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class ManageDoctorsServlet {
  -doctorFileHandler: FileHandler
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class ManagePatientsServlet {
  -patientFileHandler: FileHandler
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class RegisterServlet {
  -patientFileHandler: FileHandler
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class SortServlet {
  -appointmentService: AppointmentService
  +doGet(request: HttpServletRequest, response: HttpServletResponse): void
}

class UserServlet {
  -appointmentService: AppointmentService
  -availabilityService: DoctorAvailabilityService
  -doctorFileHandler: FileHandler
  -userFileHandler: FileHandler
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

class HttpServlet {
  +doGet(request: HttpServletRequest, response: HttpServletResponse): void
  +doPost(request: HttpServletRequest, response: HttpServletResponse): void
}

AdminServlet -|> HttpServlet
DataManagementServlet -|> HttpServlet
DoctorServlet -|> HttpServlet
DoctorScheduleServlet -|> HttpServlet
LoginServlet -|> HttpServlet
LogoutServlet -|> HttpServlet
ManageAppointmentsServlet -|> HttpServlet
ManageDoctorsServlet -|> HttpServlet
ManagePatientsServlet -|> HttpServlet
RegisterServlet -|> HttpServlet
SortServlet -|> HttpServlet
UserServlet -|> HttpServlet

AdminServlet o--> AppointmentService
AdminServlet o--> DoctorAvailabilityService
AdminServlet o--> FileHandler
DataManagementServlet o--> AuditService
DataManagementServlet o--> BackupService
DoctorServlet o--> AppointmentService
DoctorServlet o--> DoctorAvailabilityService
DoctorServlet o--> FileHandler
DoctorScheduleServlet o--> FileHandler
ManageAppointmentsServlet o--> AppointmentService
ManageAppointmentsServlet o--> DoctorAvailabilityService
ManageDoctorsServlet o--> FileHandler
ManagePatientsServlet o--> FileHandler
RegisterServlet o--> FileHandler
SortServlet o--> AppointmentService
UserServlet o--> AppointmentService
UserServlet o--> DoctorAvailabilityService
UserServlet o--> FileHandler
@enduml
```

To render these diagrams, use a **PlantUML** tool (e.g., [PlantUML Web Server](http://www.plantuml.com/plantuml)).

---