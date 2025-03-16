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
    private static final String NAME = "name";
    private static final String SPECIALTY = "specialty";
    private static final String DATE_FORMAT = "yyyy-MM-dd";

    static class Doctor implements Comparable<Doctor> {
        String username;
        String name;
        String specialty;
        String date;
        String startTime; // Keep as String to avoid parsing issues in constructor
        String endTime;

        Doctor(String username, String name, String specialty, String date, String startTime, String endTime) {
            this.username = username;
            this.name = name;
            this.specialty = specialty;
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
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

        LOGGER.info("Request params - specialty: " + specialty + ", doctor: " + doctorName + ", date: " + date);

        Map<String, Map<String, String>> doctorDetails = loadDoctorDetails(request);
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(doctorDetails);
        List<Doctor> allDoctors = loadDoctors(request, doctorDetails);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("specialties", new ArrayList<>(specialtyDoctors.keySet()));

        if (specialty == null || specialty.trim().isEmpty()) {
            responseData.put("doctors", new ArrayList<>());
            responseData.put("availability", new ArrayList<>());
        } else {
            List<String> doctorsForSpecialty = specialtyDoctors.getOrDefault(specialty, new ArrayList<>());
            Collections.sort(doctorsForSpecialty, String.CASE_INSENSITIVE_ORDER);
            responseData.put("doctors", doctorsForSpecialty);

            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialty, doctorName, date);
            Collections.sort(filteredDoctors);
            responseData.put("availability", filteredDoctors);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        LOGGER.info("Response JSON: " + jsonResponse);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private Map<String, Map<String, String>> loadDoctorDetails(HttpServletRequest request) throws ServletException {
        Map<String, Map<String, String>> doctorDetails = new HashMap<>();
        String doctorsPath = request.getServletContext().getRealPath(DOCTORS_FILE);

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
        return doctorDetails;
    }

    private Map<String, List<String>> loadSpecialtiesAndDoctors(Map<String, Map<String, String>> doctorDetails) {
        Map<String, List<String>> specialtyDoctors = new HashMap<>();
        for (Map.Entry<String, Map<String, String>> entry : doctorDetails.entrySet()) {
            String specialty = entry.getValue().get(SPECIALTY);
            String doctorName = entry.getValue().get(NAME);
            specialtyDoctors.computeIfAbsent(specialty, k -> new ArrayList<>()).add(doctorName);
        }
        return specialtyDoctors;
    }

    private List<Doctor> loadDoctors(HttpServletRequest request, Map<String, Map<String, String>> doctorDetails) throws ServletException {
        List<Doctor> doctors = new ArrayList<>();
        String availabilityPath = request.getServletContext().getRealPath(AVAILABILITY_FILE);

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
                                parts[2].trim(),         // startTime (as String)
                                parts[3].trim()          // endTime (as String)
                        ));
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading doctor availability", e);
            throw new ServletException("Error loading doctor availability", e);
        }
        return doctors;
    }

    private List<Doctor> filterDoctors(List<Doctor> doctors, String specialty, String doctorName, String date) {
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
            if (date != null && date.equals(today) && doc.getStartTimeAsLocalTime().isBefore(now)) {
                matches = false; // Exclude past slots for today
            }

            if (matches) {
                filtered.add(doc);
            }
        }
        return filtered;
    }
}