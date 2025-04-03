package service;

import model.Appointment;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FileHandler {
    private static final Logger LOGGER = Logger.getLogger(FileHandler.class.getName());
    private final String filePath;

    public FileHandler(String filePath) {
        this.filePath = filePath;
    }

    // Read all appointments from the appointments.txt file
    public List<Appointment> readAppointments() throws IOException {
        List<Appointment> appointments = new ArrayList<>();
        if (!Files.exists(Paths.get(filePath))) {
            LOGGER.info("File does not exist yet: " + filePath + ". Returning empty list.");
            return appointments;
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    try {
                        Appointment appt = new Appointment(
                                Integer.parseInt(parts[0].trim()), // id
                                parts[1].trim(),                   // patientId
                                parts[2].trim(),                   // doctorId
                                parts[3].trim(),                   // dateTime
                                Integer.parseInt(parts[4].trim())  // priority
                        );
                        appointments.add(appt);
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid number format in line: " + line, e);
                    }
                } else {
                    LOGGER.warning("Skipping malformed line: " + line + " (Expected 5 parts, got " + parts.length + ")");
                }
            }
        }
        return appointments;
    }

    // Write appointments to the appointments.txt file in CSV format
    public void writeAppointments(List<Appointment> appointments) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Appointment appt : appointments) {
                String line = String.format("%d,%s,%s,%s,%d",
                        appt.getId(),
                        appt.getPatientId(),
                        appt.getDoctorId(),
                        appt.getDateTime(),
                        appt.getPriority());
                writer.write(line);
                writer.newLine();
            }
        }
    }

    // Generic method to read all lines from any file (e.g., doctors.txt, patients.txt)
    public List<String> readLines() throws IOException {
        if (!Files.exists(Paths.get(filePath))) {
            LOGGER.info("File does not exist yet: " + filePath + ". Returning empty list.");
            return new ArrayList<>();
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