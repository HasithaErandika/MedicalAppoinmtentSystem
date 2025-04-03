package model;

public class Appointment {
    private int id;
    private String patientId;
    private String doctorId;
    private String dateTime;
    private int priority;
    private String patientName;
    private String doctorName;

    public Appointment(int id, String patientId, String doctorId, String dateTime, int priority) {
        this.id = id;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.dateTime = dateTime;
        this.priority = priority;
    }

    // Getters and setters
    public int getId() { return id; }
    public String getPatientId() { return patientId; }
    public String getDoctorId() { return doctorId; }
    public String getDateTime() { return dateTime; }
    public int getPriority() { return priority; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    @Override
    public String toString() {
        return "Appointment{id=" + id + ", patientId='" + patientId + "', doctorId='" + doctorId + "', dateTime='" + dateTime + "', priority=" + priority + "}";
    }
}