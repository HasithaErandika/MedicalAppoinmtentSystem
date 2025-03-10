package service;

import model.Appointment;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;

public class AppointmentService {
    private final String filePath;
    private final FileHandler fileHandler;
    private PriorityQueue<Appointment> emergencyQueue;

    public AppointmentService(String filePath) {
        this.filePath = filePath;
        this.fileHandler = new FileHandler(filePath);
        this.emergencyQueue = new PriorityQueue<>((a1, a2) -> Integer.compare(a2.getPriority(), a1.getPriority()));
        try {
            List<Appointment> appointments = readAppointments();
            if (appointments != null) {
                emergencyQueue.addAll(appointments);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<Appointment> readAppointments() throws IOException {
        List<String> lines = fileHandler.readLines();
        if (lines == null) return new ArrayList<>();
        List<Appointment> appointments = new ArrayList<>();
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length == 5) {
                int id = Integer.parseInt(parts[0]);
                String patientId = parts[1];
                String doctorId = parts[2];
                String dateTime = parts[3];
                int priority = Integer.parseInt(parts[4]);
                appointments.add(new Appointment(id, patientId, doctorId, dateTime, priority));
            }
        }
        return appointments;
    }

    public void bookAppointment(String patientId, String doctorId, String dateTime, boolean isEmergency) throws IOException {
        List<Appointment> appointments = readAppointments();
        int newId = appointments.stream().mapToInt(Appointment::getId).max().orElse(0) + 1;
        Appointment newAppointment = new Appointment(newId, patientId, doctorId, dateTime, isEmergency ? 1 : 2);
        appointments.add(newAppointment);
        if (isEmergency) emergencyQueue.add(newAppointment);
        writeAppointments(appointments);
    }

    public void updateAppointment(int id, String patientId, String doctorId, String dateTime, int priority) throws IOException {
        List<Appointment> appointments = readAppointments();
        for (int i = 0; i < appointments.size(); i++) {
            if (appointments.get(i).getId() == id) {
                appointments.set(i, new Appointment(id, patientId, doctorId, dateTime, priority));
                break;
            }
        }
        emergencyQueue.clear();
        emergencyQueue.addAll(appointments);
        writeAppointments(appointments);
    }

    public void cancelAppointment(int id) throws IOException {
        List<Appointment> appointments = readAppointments();
        appointments.removeIf(appt -> appt.getId() == id);
        emergencyQueue.clear();
        emergencyQueue.addAll(appointments);
        writeAppointments(appointments);
    }

    private void writeAppointments(List<Appointment> appointments) throws IOException {
        List<String> lines = new ArrayList<>();
        for (Appointment appt : appointments) {
            lines.add(String.format("%d,%s,%s,%s,%d", appt.getId(), appt.getPatientId(), appt.getDoctorId(), appt.getDateTime(), appt.getPriority()));
        }
        fileHandler.writeLines(lines);
    }
}