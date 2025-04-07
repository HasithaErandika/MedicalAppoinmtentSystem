package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SortServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SortServlet.class.getName());
    private static final String DOCTORS_FILE = "/data/doctors.txt";
    private static final String AVAILABILITY_FILE = "/data/doctors_availability.txt";
    private static final String APPOINTMENTS_FILE = "/data/appointments.txt";
    private static final String NAME = "name";
    private static final String SPECIALTY = "specialty";
    private static final String DATE_FORMAT = "yyyy-MM-dd";

    static class Doctor implements Comparable<Doctor> {
        String username;
        String name;
        String specialty;
        String date;
        String startTime;
        String endTime;
        int appointmentCount;
        String nextToken; // Added to store the next available token

        Doctor(String username, String name, String specialty, String date, String startTime, String endTime) {
            this.username = username;
            this.name = name;
            this.specialty = specialty;
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
            this.appointmentCount = 0;
            this.nextToken = "TOK001"; // Default, updated later
        }

        public LocalTime getStartTimeAsLocalTime() {
            try {
                return LocalTime.parse(startTime);
            } catch (DateTimeParseException e) {
                LOGGER.warning("Invalid start time format: " + startTime + ", defaulting to 00:00");
                return LocalTime.of(0, 0);
            }
        }

        public LocalTime getEndTimeAsLocalTime() {
            try {
                return LocalTime.parse(endTime);
            } catch (DateTimeParseException e) {
                LOGGER.warning("Invalid end time format: " + endTime + ", defaulting to 00:00");
                return LocalTime.of(0, 0);
            }
        }

        @Override
        public int compareTo(Doctor other) {
            int dateComparison = this.date.compareTo(other.date);
            if (dateComparison != 0) return dateComparison;
            return this.getStartTimeAsLocalTime().compareTo(other.getStartTimeAsLocalTime());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String specialty = request.getParameter("specialty");
        String doctorName = request.getParameter("doctor");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        LOGGER.info("Request params - specialty: " + specialty + ", doctor: " + doctorName + ", date: " + date + ", time: " + time);

        Map<String, Map<String, String>> doctorDetails = loadDoctorDetails(request);
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(doctorDetails);
        List<Doctor> allDoctors = loadDoctors(request, doctorDetails);

        calculateAppointmentCounts(request, allDoctors);

        Map<String, Object> responseData = new HashMap<>();
        List<String> specialties = new ArrayList<>(specialtyDoctors.keySet());
        bubbleSortStrings(specialties, true);
        responseData.put("specialties", specialties);

        if (specialty == null || specialty.trim().isEmpty()) {
            responseData.put("doctors", new ArrayList<>());
            responseData.put("availability", new ArrayList<>());
        } else {
            String specialtyLower = specialty.toLowerCase();
            List<String> doctorsForSpecialty = null;
            for (String key : specialtyDoctors.keySet()) {
                if (key.equalsIgnoreCase(specialtyLower)) {
                    doctorsForSpecialty = specialtyDoctors.get(key);
                    break;
                }
            }
            if (doctorsForSpecialty == null) {
                doctorsForSpecialty = new ArrayList<>();
            }
            LOGGER.info("Doctors for specialty '" + specialtyLower + "': " + doctorsForSpecialty);
            bubbleSortStrings(doctorsForSpecialty, true);
            responseData.put("doctors", doctorsForSpecialty);

            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialtyLower, doctorName, date, time);
            bubbleSortDoctors(filteredDoctors);
            responseData.put("availability", filteredDoctors);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        LOGGER.info("Response JSON: " + jsonResponse);
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        }
    }

    private void bubbleSortStrings(List<String> list, boolean caseInsensitive) {
        int n = list.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                String a = list.get(j);
                String b = list.get(j + 1);
                int comparison = caseInsensitive ?
                        a.compareToIgnoreCase(b) :
                        a.compareTo(b);
                if (comparison > 0) {
                    list.set(j, b);
                    list.set(j + 1, a);
                }
            }
        }
    }

    private void bubbleSortDoctors(List<Doctor> doctors) {
        int n = doctors.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                Doctor a = doctors.get(j);
                Doctor b = doctors.get(j + 1);
                if (a.compareTo(b) > 0) {
                    doctors.set(j, b);
                    doctors.set(j + 1, a);
                }
            }
        }
    }

    private Map<String, Map<String, String>> loadDoctorDetails(HttpServletRequest request) throws ServletException {
        Map<String, Map<String, String>> doctorDetails = new HashMap<>();
        String doctorsPath = request.getServletContext().getRealPath(DOCTORS_FILE);

        File file = new File(doctorsPath);
        if (!file.exists()) {
            LOGGER.severe("Doctors file not found at: " + doctorsPath);
            throw new ServletException("Doctors file not found");
        }

        try (BufferedReader br = new BufferedReader(new FileReader(doctorsPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    Map<String, String> details = new HashMap<>();
                    details.put(NAME, parts[2].trim());
                    details.put(SPECIALTY, parts[3].trim());
                    doctorDetails.put(parts[0].trim(), details);
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading doctor details", e);
            throw new ServletException("Error loading doctor details", e);
        }
        LOGGER.info("Loaded doctor details: " + doctorDetails);
        return doctorDetails;
    }

    private Map<String, List<String>> loadSpecialtiesAndDoctors(Map<String, Map<String, String>> doctorDetails) {
        Map<String, List<String>> specialtyDoctors = new HashMap<>();
        for (Map.Entry<String, Map<String, String>> entry : doctorDetails.entrySet()) {
            String specialty = entry.getValue().get(SPECIALTY);
            String doctorName = entry.getValue().get(NAME);
            specialtyDoctors.computeIfAbsent(specialty, k -> new ArrayList<>()).add(doctorName);
        }
        LOGGER.info("Specialty to doctors mapping: " + specialtyDoctors);
        return specialtyDoctors;
    }

    private List<Doctor> loadDoctors(HttpServletRequest request, Map<String, Map<String, String>> doctorDetails) throws ServletException {
        List<Doctor> doctors = new ArrayList<>();
        String availabilityPath = request.getServletContext().getRealPath(AVAILABILITY_FILE);

        File file = new File(availabilityPath);
        if (!file.exists()) {
            LOGGER.severe("Availability file not found at: " + availabilityPath);
            throw new ServletException("Availability file not found");
        }

        try (BufferedReader br = new BufferedReader(new FileReader(availabilityPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    Map<String, String> details = doctorDetails.get(parts[0].trim());
                    if (details != null) {
                        doctors.add(new Doctor(
                                parts[0].trim(),         // username
                                details.get(NAME),       // name
                                details.get(SPECIALTY),  // specialty
                                parts[1].trim(),         // date
                                parts[2].trim(),         // startTime
                                parts[3].trim()          // endTime
                        ));
                    } else {
                        LOGGER.warning("No doctor details found for username: " + parts[0].trim());
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading doctor availability", e);
            throw new ServletException("Error loading doctor availability", e);
        }
        LOGGER.info("Loaded doctors availability: " + doctors.size() + " entries");
        return doctors;
    }

    private List<Doctor> filterDoctors(List<Doctor> doctors, String specialty, String doctorName, String date, String time) {
        List<Doctor> filtered = new ArrayList<>();
        LocalTime now = LocalTime.now();
        String today = new SimpleDateFormat(DATE_FORMAT).format(new Date());

        for (Doctor doc : doctors) {
            boolean matches = true;

            if (specialty != null && !specialty.trim().isEmpty() && !doc.specialty.equalsIgnoreCase(specialty)) {
                matches = false;
            }
            if (doctorName != null && !doctorName.trim().isEmpty() && !doc.name.equalsIgnoreCase(doctorName)) {
                matches = false;
            }
            if (date != null && !date.trim().isEmpty() && !doc.date.equals(date)) {
                matches = false;
            }
            if (time != null && !time.trim().isEmpty() && doc.getStartTimeAsLocalTime() != null) {
                LocalTime start = doc.getStartTimeAsLocalTime();
                switch (time) {
                    case "morning": if (start.isBefore(LocalTime.of(8, 0)) || start.isAfter(LocalTime.of(12, 0))) matches = false; break;
                    case "afternoon": if (start.isBefore(LocalTime.of(12, 0)) || start.isAfter(LocalTime.of(17, 0))) matches = false; break;
                    default: LOGGER.warning("Unknown time filter: " + time);
                }
            }
            if (date != null && date.equals(today) && doc.getStartTimeAsLocalTime().isBefore(now)) {
                matches = false;
            }

            if (matches) {
                filtered.add(doc);
            }
        }
        LOGGER.info("Filtered doctors for specialty '" + specialty + "' and doctor '" + doctorName + "': " + filtered.size() + " entries");
        return filtered;
    }

    private void calculateAppointmentCounts(HttpServletRequest request, List<Doctor> doctors) throws ServletException {
        String appointmentsPath = request.getServletContext().getRealPath(APPOINTMENTS_FILE);
        File file = new File(appointmentsPath);

        if (!file.exists()) {
            LOGGER.severe("Appointments file not found at: " + appointmentsPath);
            throw new ServletException("Appointments file not found");
        }

        try (BufferedReader br = new BufferedReader(new FileReader(appointmentsPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7) { // Ensure enough fields (appointmentID, patient, doctor, token, date, time, priority)
                    String doctorUsername = parts[2].trim(); // Doctor ID (e.g., doctor5)
                    String appointmentDate = parts[4].trim(); // Date (e.g., 2025-03-09)
                    String appointmentTime = parts[5].trim(); // Time (e.g., 09:30)

                    for (Doctor doc : doctors) {
                        if (doc.username.equals(doctorUsername) &&
                                doc.date.equals(appointmentDate) &&
                                doc.startTime.equals(appointmentTime)) {
                            doc.appointmentCount++;
                        }
                    }
                } else {
                    LOGGER.warning("Invalid appointment entry: " + line);
                }
            }

            // After counting appointments, generate next available token for each slot
            for (Doctor doc : doctors) {
                int nextTokenNumber = doc.appointmentCount + 1;
                doc.nextToken = String.format("TOK%03d", nextTokenNumber); // e.g., TOK001, TOK002
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading appointments", e);
            throw new ServletException("Error loading appointments", e);
        }
        LOGGER.info("Calculated appointment counts and tokens for doctors: " + doctors.size() + " entries updated");
    }
}