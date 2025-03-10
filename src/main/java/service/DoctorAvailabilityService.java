package service;

import model.Appointment;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class DoctorAvailabilityService {
    private final FileHandler fileHandler;
    private final AppointmentService appointmentService;

    public DoctorAvailabilityService(String filePath, AppointmentService appointmentService) {
        this.fileHandler = new FileHandler(filePath);
        this.appointmentService = appointmentService;
    }

    public List<String> readAvailability() throws IOException {
        return fileHandler.readLines() != null ? fileHandler.readLines() : new ArrayList<>();
    }

    public boolean hasAvailability(String doctorId, String date) {
        try {
            List<String> availability = readAvailability();
            LocalDate localDate = LocalDate.parse(date);
            String dayOfWeek = localDate.getDayOfWeek().toString();

            for (String line : availability) {
                String[] parts = line.split(",");
                if (parts[0].equals(doctorId) && parts[1].equalsIgnoreCase(dayOfWeek)) {
                    return true;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getAvailableTimeSlots(String doctorId, String date) {
        List<String> slots = new ArrayList<>();
        try {
            List<String> availability = readAvailability();
            List<Appointment> appointments = appointmentService.readAppointments();
            LocalDate localDate = LocalDate.parse(date);
            String dayOfWeek = localDate.getDayOfWeek().toString();

            for (String line : availability) {
                String[] parts = line.split(",");
                if (parts[0].equals(doctorId) && parts[1].equalsIgnoreCase(dayOfWeek)) {
                    LocalTime start = LocalTime.parse(parts[2]);
                    LocalTime end = LocalTime.parse(parts[3]);
                    LocalTime current = start;

                    while (current.isBefore(end)) {
                        String slot = current.format(DateTimeFormatter.ofPattern("HH:mm"));
                        boolean isBooked = appointments.stream()
                                .anyMatch(appt -> appt.getDoctorId().equals(doctorId) && appt.getDateTime().equals(date + " " + slot));
                        if (!isBooked) {
                            slots.add(slot);
                        }
                        current = current.plusMinutes(30); // 30-minute slots
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return slots;
    }

    public boolean isTimeSlotAvailable(String doctorId, String dateTime) {
        try {
            String[] parts = dateTime.split(" ");
            String date = parts[0];
            String time = parts[1];
            List<String> slots = getAvailableTimeSlots(doctorId, date);
            return slots.contains(time);
        } catch (Exception e) {
            return false;
        }
    }
}