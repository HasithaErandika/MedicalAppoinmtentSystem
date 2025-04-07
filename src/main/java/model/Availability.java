package model;

import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.logging.Logger;

public class Availability implements Comparable<Availability> {
    private static final Logger LOGGER = Logger.getLogger(Availability.class.getName());

    private String doctorId;
    private String doctorName;
    private String date;
    private String startTime;
    private String endTime;
    private int appointmentCount;
    private String nextToken;

    public Availability(String doctorId, String doctorName, String date, String startTime, String endTime) {
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.appointmentCount = 0;
        this.nextToken = "TOK001";
    }

    // Getters
    public String getDoctorId() { return doctorId; }
    public String getDoctorName() { return doctorName; }
    public String getDate() { return date; }
    public String getStartTime() { return startTime; }
    public String getEndTime() { return endTime; }
    public int getAppointmentCount() { return appointmentCount; }
    public String getNextToken() { return nextToken; }

    // Setters (for fields that might change)
    public void setAppointmentCount(int appointmentCount) { this.appointmentCount = appointmentCount; }
    public void setNextToken(String nextToken) { this.nextToken = nextToken; }

    public LocalTime getStartTimeAsLocalTime() {
        try {
            return LocalTime.parse(startTime);
        } catch (DateTimeParseException e) {
            LOGGER.warning("Invalid start time format: " + startTime + ", defaulting to 00:00");
            return LocalTime.of(0, 0);
        }
    }

    @Override
    public int compareTo(Availability other) {
        int dateComparison = this.date.compareTo(other.date);
        if (dateComparison != 0) return dateComparison;
        return this.getStartTimeAsLocalTime().compareTo(other.getStartTimeAsLocalTime());
    }

    @Override
    public String toString() {
        return "Availability{" +
                "doctorId='" + doctorId + '\'' +
                ", doctorName='" + doctorName + '\'' +
                ", date='" + date + '\'' +
                ", startTime='" + startTime + '\'' +
                ", endTime='" + endTime + '\'' +
                ", appointmentCount=" + appointmentCount +
                ", nextToken='" + nextToken + '\'' +
                '}';
    }
}