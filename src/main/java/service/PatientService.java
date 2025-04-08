package service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class PatientService {
    private static final Logger LOGGER = Logger.getLogger(PatientService.class.getName());
    private final FileHandler fileHandler;

    public PatientService(String filePath) {
        this.fileHandler = new FileHandler(filePath);
    }

    public Map<String, String> getPatientNames() throws IOException {
        Map<String, String> patientNames = new HashMap<>();
        List<String> lines = fileHandler.readLines();
        if (lines != null) {
            for (String line : lines) {
                String[] parts = line.split(",");
                if (parts.length >= 3) {
                    patientNames.put(parts[0], parts[2]); // patientId -> fullName
                }
            }
        }
        return patientNames;
    }
}