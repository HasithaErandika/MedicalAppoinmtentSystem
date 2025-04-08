package service;

import model.Appointment;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
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
        this.emergencyQueue = new PriorityQueue<>(Comparator.comparingInt(Appointment::getPriority));
        this.cachedAppointments = readAppointments();
        if (cachedAppointments != null) {
            emergencyQueue.addAll(cachedAppointments);
        } else {
            cachedAppointments = new ArrayList<>();
        }
    }

    public List<Appointment> readAppointments() throws IOException {
        return fileHandler.readAppointments();
    }

    public synchronized void bookAppointment(String patientId, String doctorId, String tokenID, String dateTime, boolean isEmergency) throws IOException {
        if (patientId == null || doctorId == null || tokenID == null || dateTime == null) {
            throw new IllegalArgumentException("Invalid appointment details");
        }
        int newId = cachedAppointments.stream().mapToInt(Appointment::getId).max().orElse(0) + 1;
        int priority = isEmergency ? 1 : 2;
        Appointment newAppointment = new Appointment(newId, patientId, doctorId, tokenID, dateTime, priority);
        cachedAppointments.add(newAppointment);
        if (isEmergency) emergencyQueue.add(newAppointment);
        writeAppointments(cachedAppointments);
        LOGGER.info("Booked appointment: " + newAppointment);
    }

    public synchronized void updateAppointment(int id, String patientId, String doctorId, String tokenID, String dateTime, int priority) throws IOException {
        boolean found = false;
        for (int i = 0; i < cachedAppointments.size(); i++) {
            if (cachedAppointments.get(i).getId() == id) {
                cachedAppointments.set(i, new Appointment(id, patientId, doctorId, tokenID, dateTime, priority));
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

    public List<Appointment> getAppointmentsByPatientId(String patientId) {
        return cachedAppointments.stream()
                .filter(appt -> appt.getPatientId().equals(patientId))
                .collect(Collectors.toList());
    }

    public List<Appointment> getSortedAppointments() {
        List<Appointment> appointments = new ArrayList<>(cachedAppointments);
        Collections.sort(appointments, Comparator.comparing(
                appt -> LocalDateTime.parse(appt.getDateTime(), DATE_TIME_FORMATTER)));
        return appointments;
    }

    public List<Appointment> getAppointmentsByDoctorId(String doctorId) {
        return cachedAppointments.stream()
                .filter(appt -> appt.getDoctorId().equals(doctorId))
                .collect(Collectors.toList());
    }
}