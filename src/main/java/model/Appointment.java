package model;

public class Appointment implements Comparable<Appointment> {
    private int id;
    private String patientId;
    private String doctorId;
    private String dateTime; // Format: "YYYY-MM-DD HH:MM"
    private int priority; // 1 = Emergency, 2 = Normal

    public Appointment(int id, String patientId, String doctorId, String dateTime, int priority) {
        this.id = id;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.dateTime = dateTime;
        this.priority = priority;
    }

    // Getters
    public int getId() { return id; }
    public String getPatientId() { return patientId; }
    public String getDoctorId() { return doctorId; }
    public String getDateTime() { return dateTime; }
    public int getPriority() { return priority; }

    // For Priority Queue: Lower priority value = higher urgency
    @Override
    public int compareTo(Appointment other) {
        return Integer.compare(this.priority, other.priority);
    }

    // For file storage: Format as a single line
    @Override
    public String toString() {
        return id + "," + patientId + "," + doctorId + "," + dateTime + "," + priority;
    }
}