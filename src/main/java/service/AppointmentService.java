package service;

import model.Appointment;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.logging.Logger;

public class AppointmentService {
    private static final Logger LOGGER = Logger.getLogger(AppointmentService.class.getName());
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private final String filePath;
    private final FileHandler fileHandler;
    private final PriorityQueue<Appointment> emergencyQueue; // Higher priority = lower number (1 = emergency)
    private List<Appointment> cachedAppointments;

    public AppointmentService(String filePath) throws IOException {
        this.filePath = filePath;
        this.fileHandler = new FileHandler(filePath);
        this.emergencyQueue = new PriorityQueue<>((a1, a2) -> Integer.compare(a1.getPriority(), a2.getPriority()));
        this.cachedAppointments = readAppointments();
        if (cachedAppointments != null) {
            emergencyQueue.addAll(cachedAppointments);
        } else {
            LOGGER.warning("No appointments loaded from file: " + filePath);
            cachedAppointments = new ArrayList<>();
        }
    }

    public List<Appointment> readAppointments() throws IOException {
        List<String> lines = fileHandler.readLines();
        if (lines == null) {
            LOGGER.warning("File read returned null for: " + filePath);
            return new ArrayList<>();
        }
        List<Appointment> appointments = new ArrayList<>();
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length == 5) {
                try {
                    int id = Integer.parseInt(parts[0].trim());
                    String patientId = parts[1].trim();
                    String doctorId = parts[2].trim();
                    String dateTime = parts[3].trim();
                    int priority = Integer.parseInt(parts[4].trim());
                    appointments.add(new Appointment(id, patientId, doctorId, dateTime, priority));
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid number format in line: " + line);
                }
            } else {
                LOGGER.warning("Skipping malformed line: " + line + " (Expected 5 parts, got " + parts.length + ")");
            }
        }
        return appointments;
    }

    public synchronized void bookAppointment(String patientId, String doctorId, String dateTime, boolean isEmergency) throws IOException {
        if (patientId == null || doctorId == null || dateTime == null || patientId.trim().isEmpty() || doctorId.trim().isEmpty() || dateTime.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid appointment details: patientId, doctorId, and dateTime must not be null or empty");
        }
        int newId = cachedAppointments.stream().mapToInt(Appointment::getId).max().orElse(0) + 1;
        int priority = isEmergency ? 1 : 2; // 1 = emergency, 2 = regular
        Appointment newAppointment = new Appointment(newId, patientId, doctorId, dateTime, priority);
        cachedAppointments.add(newAppointment);
        if (isEmergency) emergencyQueue.add(newAppointment);
        writeAppointments(cachedAppointments);
        LOGGER.info("Booked appointment: " + newAppointment);
    }

    public synchronized void updateAppointment(int id, String patientId, String doctorId, String dateTime, int priority) throws IOException {
        boolean found = false;
        for (int i = 0; i < cachedAppointments.size(); i++) {
            if (cachedAppointments.get(i).getId() == id) {
                cachedAppointments.set(i, new Appointment(id, patientId, doctorId, dateTime, priority));
                found = true;
                break;
            }
        }
        if (!found) throw new IllegalArgumentException("Appointment with ID " + id + " not found");
        emergencyQueue.clear();
        emergencyQueue.addAll(cachedAppointments);
        writeAppointments(cachedAppointments);
        LOGGER.info("Updated appointment ID: " + id);
    }

    public synchronized void cancelAppointment(int id) throws IOException {
        boolean removed = cachedAppointments.removeIf(appt -> appt.getId() == id);
        if (!removed) throw new IllegalArgumentException("Appointment with ID " + id + " not found");
        emergencyQueue.clear();
        emergencyQueue.addAll(cachedAppointments);
        writeAppointments(cachedAppointments);
        LOGGER.info("Cancelled appointment ID: " + id);
    }

    private void writeAppointments(List<Appointment> appointments) throws IOException {
        List<String> lines = new ArrayList<>();
        for (Appointment appt : appointments) {
            lines.add(String.format("%d,%s,%s,%s,%d", appt.getId(), appt.getPatientId(), appt.getDoctorId(), appt.getDateTime(), appt.getPriority()));
        }
        fileHandler.writeLines(lines);
    }

    public Appointment getNextEmergency() {
        return emergencyQueue.poll();
    }

    public List<Appointment> getAllAppointments() {
        return new ArrayList<>(cachedAppointments);
    }

    // Bubble sort implementation for appointments by date/time
    public List<Appointment> getSortedAppointments() {
        List<Appointment> list = new ArrayList<>(cachedAppointments);
        for (int i = 0; i < list.size() - 1; i++) {
            for (int j = 0; j < list.size() - i - 1; j++) {
                LocalDateTime dt1 = LocalDateTime.parse(list.get(j).getDateTime(), DATE_TIME_FORMATTER);
                LocalDateTime dt2 = LocalDateTime.parse(list.get(j + 1).getDateTime(), DATE_TIME_FORMATTER);
                if (dt1.isAfter(dt2)) {
                    Appointment temp = list.get(j);
                    list.set(j, list.get(j + 1));
                    list.set(j + 1, temp);
                }
            }
        }
        return list;
    }
}