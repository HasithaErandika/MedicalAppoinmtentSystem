package service;

import model.Appointment;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {
    private final String filePath;

    public FileHandler(String filePath) {
        this.filePath = filePath;
    }

    // Read all appointments from the appointments.txt file
    public List<Appointment> readAppointments() throws IOException {
        List<Appointment> appointments = new ArrayList<>();
        if (!Files.exists(Paths.get(filePath))) {
            return appointments; // Return empty list if file doesn't exist yet
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    Appointment appt = new Appointment(
                            Integer.parseInt(parts[0]), // id
                            parts[1],                   // patientId
                            parts[2],                   // doctorId
                            parts[3],                   // dateTime
                            Integer.parseInt(parts[4])  // priority
                    );
                    appointments.add(appt);
                }
            }
        }
        return appointments;
    }

    // Write appointments to the appointments.txt file
    public void writeAppointments(List<Appointment> appointments) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Appointment appt : appointments) {
                writer.write(appt.toString());
                writer.newLine();
            }
        }
    }

    // Generic method to read all lines from any file (e.g., doctors.txt, patients.txt)
    public List<String> readLines() throws IOException {
        if (!Files.exists(Paths.get(filePath))) {
            return new ArrayList<>(); // Return empty list if file doesn't exist
        }
        return Files.readAllLines(Paths.get(filePath));
    }

    // Generic method to write lines to any file
    public void writeLines(List<String> lines) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        }
    }
}