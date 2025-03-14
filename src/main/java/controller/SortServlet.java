package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.ParseException;
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
    private static final String MORNING = "morning";
    private static final String AFTERNOON = "afternoon";
    private static final String EVENING = "evening";
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

        @Override
        public int compareTo(Doctor other) {
            int nameComparison = this.name.compareToIgnoreCase(other.name);
            if (nameComparison != 0) return nameComparison;
            int specialtyComparison = this.specialty.compareToIgnoreCase(other.specialty);
            if (specialtyComparison != 0) return specialtyComparison;
            return this.date.compareTo(other.date);
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

        // Load doctor data
        Map<String, Map<String, String>> doctorDetails = loadDoctorDetails(request);
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(doctorDetails);
        List<Doctor> allDoctors = loadDoctors(request, doctorDetails);

        // Prepare response
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("specialties", new ArrayList<>(specialtyDoctors.keySet()));

        if (specialty == null || specialty.isEmpty()) {
            responseData.put("doctors", new ArrayList<>());
            responseData.put("availability", new ArrayList<>());
        } else {
            // Get and sort doctor names for the selected specialty
            List<String> doctorsForSpecialty = specialtyDoctors.getOrDefault(specialty, new ArrayList<>());
            Collections.sort(doctorsForSpecialty, String.CASE_INSENSITIVE_ORDER);
            responseData.put("doctors", doctorsForSpecialty);

            // Filter and sort availability
            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialty, doctorName, date, time);
            Collections.sort(filteredDoctors); // Sort by doctor name (case-insensitive)
            responseData.put("availability", filteredDoctors);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
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
            LOGGER.log(Level.SEVERE, "Error loading doctor details from " + DOCTORS_FILE, e);
            throw new ServletException("Error loading doctor details", e); //Propagate error to container
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
                                details.get(NAME),     // name
                                details.get(SPECIALTY), // specialty
                                parts[1].trim(),         // date
                                parts[2].trim(),         // startTime
                                parts[3].trim()          // endTime
                        ));
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading doctors from " + AVAILABILITY_FILE, e);
            throw new ServletException("Error loading doctor availability", e); //Propagate error to container
        }
        return doctors;
    }

    private List<Doctor> filterDoctors(List<Doctor> doctors, String specialty, String doctorName,
                                       String date, String time) {
        List<Doctor> filtered = new ArrayList<>();

        for (Doctor doc : doctors) {
            boolean matches = true;

            if (specialty != null && !specialty.isEmpty() && !doc.specialty.equalsIgnoreCase(specialty)) {
                matches = false;
            }
            if (doctorName != null && !doctorName.isEmpty() && !doc.name.equalsIgnoreCase(doctorName)) {
                matches = false;
            }
            if (date != null && !date.isEmpty() && !doc.date.equals(date)) {
                matches = false;
            }
            if (time != null && !time.isEmpty()) {
                int startHour = Integer.parseInt(doc.startTime.split(":")[0]);
                if (time.equalsIgnoreCase("morning") && (startHour < 8 || startHour >= 12)) {
                    matches = false;
                } else if (time.equalsIgnoreCase("afternoon") && (startHour < 12 || startHour >= 17)) {
                    matches = false;
                } else if (time.equalsIgnoreCase("evening") && (startHour < 17)) {
                    matches = false;
                }
            }

            if (matches) {
                filtered.add(doc);
            }
        }
        return filtered;
    }

    private boolean isValidDate(String date) {
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        sdf.setLenient(false);  // Strict date checking
        try {
            sdf.parse(date);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }
}