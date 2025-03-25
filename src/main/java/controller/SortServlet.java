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
        String startTime;
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
        String time = request.getParameter("time");

        LOGGER.info("Request params - specialty: " + specialty + ", doctor: " + doctorName + ", date: " + date + ", time: " + time);

        Map<String, Map<String, String>> doctorDetails = loadDoctorDetails(request);
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(doctorDetails);
        List<Doctor> allDoctors = loadDoctors(request, doctorDetails);

        Map<String, Object> responseData = new HashMap<>();
        List<String> specialties = new ArrayList<>(specialtyDoctors.keySet());
        Collections.sort(specialties, String.CASE_INSENSITIVE_ORDER);
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
            Collections.sort(doctorsForSpecialty, String.CASE_INSENSITIVE_ORDER);
            responseData.put("doctors", doctorsForSpecialty);

            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialtyLower, doctorName, date, time);
            Collections.sort(filteredDoctors);
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
}