
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
' Model Classes
class Appointment {
  -int id
  -String patientId
  -String doctorId
  -String tokenID
  -String dateTime
  -int priority
  -String patientName
  -String doctorName
  +getId(): int
  +getPatientId(): String
  +getDoctorId(): String
  +getTokenID(): String
  +setTokenID(tokenID: String)
  +getDateTime(): String
  +getPriority(): int
  +getPatientName(): String
  +setPatientName(patientName: String)
  +getDoctorName(): String
  +setDoctorName(doctorName: String)
  +toString(): String
}

class Availability {
  -String doctorId
  -String doctorName
  -String date
  -String startTime
  -String endTime
  -int appointmentCount
  -String nextToken
  +getDoctorId(): String
  +getDoctorName(): String
  +getDate(): String
  +getStartTime(): String
  +getEndTime(): String
  +getAppointmentCount(): int
  +getNextToken(): String
  +setAppointmentCount(appointmentCount: int)
  +setNextToken(nextToken: String)
  +getStartTimeAsLocalTime(): LocalTime
  +compareTo(other: Availability): int
  +toString(): String
}

class Doctor {
  -String id
  -String name
  -String specialization
  -String contact
  +getId(): String
  +getName(): String
  +getSpecialization(): String
  +getContact(): String
  +toString(): String
}

class Patient {
  -String name
  -int age
  -String contact
  -String username
  -String password
  +getName(): String
  +getAge(): int
  +getContact(): String
  +getUsername(): String
  +getPassword(): String
  +toString(): String
}

' Model Relationships
Appointment "1" --> "1" Patient : references via patientId
Appointment "1" --> "1" Doctor : references via doctorId
Availability "1" --> "1" Doctor : references via doctorId

' Notes
note right of Appointment
  patientName and doctorName may be redundant;
  consider fetching from Patient and Doctor.
end note

note right of Availability
  Implements Comparable<Availability> for sorting.
  doctorName may be redundant.
end note

@enduml
```

### Service Package
```plantuml
@startuml
' Model Classes (Referenced)
class Appointment {
  -int id
  -String patientId
  -String doctorId
  -String tokenID
  -String dateTime
  -int priority
  -String patientName
  -String doctorName
}

' Service Classes
class FileHandler {
  -String filePath
  +FileHandler(filePath: String)
  +readAppointments(): List<Appointment>
  +writeAppointments(appointments: List<Appointment>)
  +readLines(): List<String>
  +writeLines(lines: List<String>)
  +getPatientNameByUsername(username: String, patientFilePath: String): String
}

class AuditService {
  -FileHandler fileHandler
  +AuditService(fileHandler: FileHandler)
  +readAuditLogs(): List<String>
  +clearAuditLogs()
  +addAuditLog(log: String)
}

class BackupService {
  -String basePath
  -AuditService auditService
  +BackupService(basePath: String, auditService: AuditService)
  +createBackup(username: String)
}

class DoctorAvailabilityService {
  -FileHandler fileHandler
  -AppointmentService appointmentService
  +DoctorAvailabilityService(filePath: String, appointmentService: AppointmentService)
  +readAvailability(): List<String>
  +hasAvailability(doctorId: String, date: String): boolean
  +getAvailableTimeSlots(doctorId: String, date: String): List<String>
  +isTimeSlotAvailable(doctorId: String, dateTime: String): boolean
}

class AppointmentService {
  -String filePath
  -FileHandler fileHandler
  -PriorityQueue<Appointment> emergencyQueue
  -List<Appointment> cachedAppointments
  -String patientFilePath
  +AppointmentService(filePath: String)
  +readAppointments(): List<Appointment>
  +bookAppointment(patientId: String, doctorId: String, tokenID: String, dateTime: String, isEmergency: boolean)
  +updateAppointment(id: int, patientId: String, doctorId: String, tokenID: String, dateTime: String, priority: int)
  +cancelAppointment(id: int)
  +getNextEmergency(): Appointment
  +getAllAppointments(): List<Appointment>
  +getAppointmentsByPatientId(patientId: String): List<Appointment>
  +getSortedAppointments(): List<Appointment>
  +getAppointmentsByDoctorId(doctorId: String): List<Appointment>
}

' Service-Model Relationships
AppointmentService o--> "many" Appointment : manages
DoctorAvailabilityService --> Appointment : uses
FileHandler --> Appointment : reads/writes

' Service-Service Relationships
AppointmentService --> FileHandler : uses
DoctorAvailabilityService --> FileHandler : uses
DoctorAvailabilityService --> AppointmentService : uses
BackupService --> AuditService : uses
AuditService --> FileHandler : uses

' Notes
note right of AppointmentService
  Uses PriorityQueue for emergency appointments.
  Synchronized methods for thread safety.
end note

@enduml
```

### Controller Package
```plantuml
@startuml
' Service Classes (Referenced)
class AppointmentService {
  +bookAppointment(patientId: String, doctorId: String, tokenID: String, dateTime: String, isEmergency: boolean)
  +updateAppointment(id: int, patientId: String, doctorId: String, tokenID: String, dateTime: String, priority: int)
  +cancelAppointment(id: int)
  +getAllAppointments(): List<Appointment>
  +getAppointmentsByPatientId(patientId: String): List<Appointment>
  +getSortedAppointments(): List<Appointment>
  +getAppointmentsByDoctorId(doctorId: String): List<Appointment>
}

class DoctorAvailabilityService {
  +readAvailability(): List<String>
  +hasAvailability(doctorId: String, date: String): boolean
  +getAvailableTimeSlots(doctorId: String, date: String): List<String>
  +isTimeSlotAvailable(doctorId: String, dateTime: String): boolean
}

class AuditService {
  +readAuditLogs(): List<String>
  +clearAuditLogs()
  +addAuditLog(log: String)
}

class BackupService {
  +createBackup(username: String)
}

class FileHandler {
  +readAppointments(): List<Appointment>
  +writeAppointments(appointments: List<Appointment>)
  +readLines(): List<String>
  +writeLines(lines: List<String>)
  +getPatientNameByUsername(username: String, patientFilePath: String): String
}

' Controller Classes
class LoginServlet {
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
  -validateCredentials(username: String, password: String, role: String, request: HttpServletRequest): boolean
}

class LogoutServlet {
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
}

class RegisterServlet {
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
  -sanitizeInput(input: String): String
}

class AdminServlet {
  -AppointmentService appointmentService
  -DoctorAvailabilityService availabilityService
  -FileHandler doctorFileHandler
  -FileHandler patientFileHandler
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
}

class DoctorServlet {
  -AppointmentService appointmentService
  -DoctorAvailabilityService availabilityService
  -FileHandler doctorFileHandler
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
  -getDoctorByUsername(username: String): Doctor
  -updateDoctorDetails(doctor: Doctor, password: String)
}

class UserServlet {
  -AppointmentService appointmentService
  -DoctorAvailabilityService availabilityService
  -FileHandler doctorFileHandler
  -FileHandler userFileHandler
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
}

class ManageAppointmentsServlet {
  -AppointmentService appointmentService
  -DoctorAvailabilityService availabilityService
  -String doctorsFilePath
  -String patientsFilePath
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
  -readUsers(filePath: String, isDoctor: boolean): List<User>
  -generateTokenID(): String
}

class ManagePatientsServlet {
  -FileHandler patientFileHandler
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
}

class ManageDoctorsServlet {
  -FileHandler doctorFileHandler
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
}

class DoctorScheduleServlet {
  -FileHandler availabilityFileHandler
  -FileHandler doctorFileHandler
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
  -handleAdd(request: HttpServletRequest, availability: List<String>)
  -handleRemove(request: HttpServletRequest, availability: List<String>)
  -handleEdit(request: HttpServletRequest, availability: List<String>)
}

class DataManagementServlet {
  -AuditService auditService
  -BackupService backupService
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  +doPost(request: HttpServletRequest, response: HttpServletResponse)
}

class SortServlet {
  -AppointmentService appointmentService
  +init()
  +doGet(request: HttpServletRequest, response: HttpServletResponse)
  -loadDoctorDetails(request: HttpServletRequest): Map<String, Doctor>
  -loadAvailabilities(request: HttpServletRequest, doctorDetails: Map<String, Doctor>): List<Availability>
}

' Inner Classes for UserServlet
class SuccessResponse {
  -boolean success
  -String message
  +SuccessResponse(success: boolean, message: String)
}

class ErrorResponse {
  -String error
  +ErrorResponse(error: String)
}

' Controller-Service Relationships
AdminServlet --> AppointmentService : uses
AdminServlet --> DoctorAvailabilityService : uses
AdminServlet --> FileHandler : uses
DoctorServlet --> AppointmentService : uses
DoctorServlet --> DoctorAvailabilityService : uses
DoctorServlet --> FileHandler : uses
UserServlet --> AppointmentService : uses
UserServlet --> DoctorAvailabilityService : uses
UserServlet --> FileHandler : uses
ManageAppointmentsServlet --> AppointmentService : uses
ManageAppointmentsServlet --> DoctorAvailabilityService : uses
ManagePatientsServlet --> FileHandler : uses
ManageDoctorsServlet --> FileHandler : uses
DoctorScheduleServlet --> FileHandler : uses
DataManagementServlet --> AuditService : uses
DataManagementServlet --> BackupService : uses
SortServlet --> AppointmentService : uses
LoginServlet --> FileHandler : uses
RegisterServlet --> FileHandler : uses

' Inner Class Relationships
UserServlet o--> SuccessResponse : contains
UserServlet o--> ErrorResponse : contains

@enduml
```

To render these diagrams, use a **PlantUML** tool (e.g., [PlantUML Web Server](http://www.plantuml.com/plantuml)).

---