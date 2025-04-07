package model;

import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.logging.Logger;

public class Availability implements Comparable<Availability> {
    private static final Logger LOGGER = Logger.getLogger(Availability.class.getName());
    private String doctorId;
    private String date;
    private String startTime;
    private String endTime;
    private int appointmentCount;
    private String nextToken;

    public Availability(String doctorId, String date, String startTime, String endTime) {
        this.doctorId = doctorId;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.appointmentCount = 0;
        this.nextToken = "TOK001";
    }

    // Getters and Setters
    public String getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public int getAppointmentCount() {
        return appointmentCount;
    }

    public void setAppointmentCount(int appointmentCount) {
        this.appointmentCount = appointmentCount;
    }

    public String getNextToken() {
        return nextToken;
    }

    public void setNextToken(String nextToken) {
        this.nextToken = nextToken;
    }

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
        return doctorId + "," + date + "," + startTime + "," + endTime + "," + appointmentCount + "," + nextToken;
    }
}