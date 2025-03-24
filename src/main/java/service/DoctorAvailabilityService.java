package service;

import model.Appointment;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class DoctorAvailabilityService {
    private static final Logger LOGGER = Logger.getLogger(DoctorAvailabilityService.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private final FileHandler fileHandler;
    private final AppointmentService appointmentService;

    public DoctorAvailabilityService(String filePath, AppointmentService appointmentService) {
        this.fileHandler = new FileHandler(filePath);
        this.appointmentService = appointmentService;
    }

    public List<String> readAvailability() throws IOException {
        List<String> lines = fileHandler.readLines();
        if (lines == null) {
            LOGGER.warning("No availability data found in file: " + fileHandler);
            return new ArrayList<>();
        }
        return lines;
    }

    public boolean hasAvailability(String doctorId, String date) throws IOException {
        if (doctorId == null || date == null || doctorId.trim().isEmpty() || date.trim().isEmpty()) {
            throw new IllegalArgumentException("doctorId and date must not be null or empty");
        }
        List<String> availability = readAvailability();
        LocalDate localDate = LocalDate.parse(date, DATE_FORMATTER);
        String dayOfWeek = localDate.getDayOfWeek().toString();

        for (String line : availability) {
            String[] parts = line.split(",");
            if (parts.length >= 4 && parts[0].equals(doctorId) && parts[1].equalsIgnoreCase(dayOfWeek)) {
                return true;
            }
        }
        return false;
    }

    public List<String> getAvailableTimeSlots(String doctorId, String date) throws IOException {
        if (doctorId == null || date == null || doctorId.trim().isEmpty() || date.trim().isEmpty()) {
            throw new IllegalArgumentException("doctorId and date must not be null or empty");
        }
        List<String> slots = new ArrayList<>();
        List<String> availability = readAvailability();
        List<Appointment> appointments = appointmentService.getAllAppointments();
        LocalDate localDate = LocalDate.parse(date, DATE_FORMATTER);
        String dayOfWeek = localDate.getDayOfWeek().toString();

        for (String line : availability) {
            String[] parts = line.split(",");
            if (parts.length >= 4 && parts[0].equals(doctorId) && parts[1].equalsIgnoreCase(dayOfWeek)) {
                LocalTime start = LocalTime.parse(parts[2]);
                LocalTime end = LocalTime.parse(parts[3]);
                LocalTime current = start;

                while (current.isBefore(end)) {
                    String slot = current.format(TIME_FORMATTER);
                    boolean isBooked = appointments.stream()
                            .anyMatch(appt -> appt.getDoctorId().equals(doctorId) && appt.getDateTime().equals(date + " " + slot));
                    if (!isBooked) {
                        slots.add(slot);
                    }
                    current = current.plusMinutes(30); // 30-minute slots
                }
            }
        }
        return slots;
    }

    public boolean isTimeSlotAvailable(String doctorId, String dateTime) throws IOException {
        if (dateTime == null || doctorId == null || dateTime.trim().isEmpty() || doctorId.trim().isEmpty()) {
            return false;
        }
        String[] parts = dateTime.split(" ");
        if (parts.length != 2) {
            LOGGER.warning("Invalid dateTime format: " + dateTime + ". Expected 'yyyy-MM-dd HH:mm'");
            return false;
        }
        String date = parts[0];
        String time = parts[1];
        List<String> slots = getAvailableTimeSlots(doctorId, date);
        return slots.contains(time);
    }
}