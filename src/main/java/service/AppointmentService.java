package service;

import model.Appointment;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;

public class AppointmentService {
    private final FileHandler fileHandler;
    private PriorityQueue<Appointment> priorityQueue;

    public AppointmentService(String filePath) {
        this.fileHandler = new FileHandler(filePath);
        this.priorityQueue = new PriorityQueue<>();
        loadAppointments();
    }

    // Load existing appointments into the priority queue
    private void loadAppointments() {
        try {
            List<Appointment> appointments = fileHandler.readAppointments();
            priorityQueue.addAll(appointments);
        } catch (IOException e) {
            e.printStackTrace(); // Log error; could be enhanced with proper logging
        }
    }

    // Book a new appointment
    public void bookAppointment(String patientId, String doctorId, String dateTime, boolean isEmergency) throws IOException {
        int id = getNextId(); // Generate a unique ID
        int priority = isEmergency ? 1 : 2; // 1 = Emergency, 2 = Normal
        Appointment appt = new Appointment(id, patientId, doctorId, dateTime, priority);
        priorityQueue.add(appt);

        // Update file
        List<Appointment> allAppointments = new ArrayList<>(priorityQueue);
        fileHandler.writeAppointments(allAppointments);
    }

    // Cancel an appointment by ID
    public void cancelAppointment(int id) throws IOException {
        PriorityQueue<Appointment> tempQueue = new PriorityQueue<>();
        while (!priorityQueue.isEmpty()) {
            Appointment appt = priorityQueue.poll();
            if (appt.getId() != id) {
                tempQueue.add(appt);
            }
        }
        priorityQueue = tempQueue;
        fileHandler.writeAppointments(new ArrayList<>(priorityQueue));
    }

    // Get all appointments (for admin display or other purposes)
    public List<Appointment> readAppointments() throws IOException {
        return fileHandler.readAppointments();
    }

    // Get the next appointment in the priority queue (highest priority)
    public Appointment getNextAppointment() {
        return priorityQueue.peek(); // Peek to preview without removing
    }

    // Generate a unique ID for new appointments
    private int getNextId() throws IOException {
        List<Appointment> appointments = readAppointments();
        if (appointments.isEmpty()) {
            return 1;
        }
        int maxId = 0;
        for (Appointment appt : appointments) {
            if (appt.getId() > maxId) {
                maxId = appt.getId();
            }
        }
        return maxId + 1;
    }
}