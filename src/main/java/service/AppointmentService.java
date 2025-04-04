package service;

import model.Appointment;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class AppointmentService {
    private static final Logger LOGGER = Logger.getLogger(AppointmentService.class.getName());
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private final String filePath;
    private final FileHandler fileHandler;
    private final PriorityQueue<Appointment> emergencyQueue;
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
        return fileHandler.readAppointments();
    }

    public synchronized void bookAppointment(String patientId, String doctorId, String dateTime, boolean isEmergency) throws IOException {
        if (patientId == null || doctorId == null || dateTime == null || patientId.trim().isEmpty() || doctorId.trim().isEmpty() || dateTime.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid appointment details: patientId, doctorId, and dateTime must not be null or empty");
        }
        int newId = cachedAppointments.stream().mapToInt(Appointment::getId).max().orElse(0) + 1;
        int priority = isEmergency ? 1 : 2;
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
        fileHandler.writeAppointments(appointments);
    }

    public Appointment getNextEmergency() {
        return emergencyQueue.poll();
    }

    public List<Appointment> getAllAppointments() {
        return new ArrayList<>(cachedAppointments);
    }

    public List<Appointment> getSortedAppointments() throws IOException {
        List<Appointment> appointments = getAllAppointments();
        appointments.sort((a1, a2) -> LocalDateTime.parse(a1.getDateTime(), DATE_TIME_FORMATTER)
                .compareTo(LocalDateTime.parse(a2.getDateTime(), DATE_TIME_FORMATTER)));
        return appointments;
    }

    public List<Appointment> getAppointmentsByDoctorId(String doctorId) {
        return cachedAppointments.stream()
                .filter(appt -> appt.getDoctorId().equals(doctorId))
                .collect(Collectors.toList());
    }
}