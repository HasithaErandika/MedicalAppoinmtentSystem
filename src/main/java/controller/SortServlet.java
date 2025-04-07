package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Doctor;
import service.AppointmentService;
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
    private static final String DATE_FORMAT = "yyyy-MM-dd";
    private AppointmentService appointmentService;

    static class Availability implements Comparable<Availability> {
        String doctorId;
        String date;
        String startTime;
        String endTime;
        int appointmentCount;
        String nextToken;

        Availability(String doctorId, String date, String startTime, String endTime) {
            this.doctorId = doctorId;
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
            this.appointmentCount = 0;
            this.nextToken = "TOK001";
        }

        public LocalTime getStartTimeAsLocalTime() {
            try {
                return LocalTime.parse(startTime);
            } catch (DateTimeParseException e) {
                LOGGER.warning("Invalid start time format: " + startTime + ", defaulting to 00:00");
                return LocalTime.of(0, 0);
            }
        }

        @Override
        public int compareTo(Availability other) {
            int dateComparison = this.date.compareTo(other.date);
            if (dateComparison != 0) return dateComparison;
            return this.getStartTimeAsLocalTime().compareTo(other.getStartTimeAsLocalTime());
        }
    }

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        try {
            appointmentService = new AppointmentService(basePath + "appointments.txt");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AppointmentService", e);
            throw new ServletException("Failed to initialize SortServlet", e);
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

        Map<String, Doctor> doctorDetails = loadDoctorDetails(request);
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(doctorDetails);
        List<Availability> allAvailabilities = loadAvailabilities(request, doctorDetails);

        calculateAppointmentCounts(allAvailabilities);

        Map<String, Object> responseData = new HashMap<>();
        List<String> specialties = new ArrayList<>(specialtyDoctors.keySet());
        Collections.sort(specialties, String.CASE_INSENSITIVE_ORDER);
        responseData.put("specialties", specialties);

        if (specialty == null || specialty.trim().isEmpty()) {
            responseData.put("doctors", new ArrayList<>());
            responseData.put("availability", new ArrayList<>());
        } else {
            String specialtyLower = specialty.toLowerCase();
            List<String> doctorsForSpecialty = specialtyDoctors.getOrDefault(specialtyLower, new ArrayList<>());
            Collections.sort(doctorsForSpecialty, String.CASE_INSENSITIVE_ORDER);
            responseData.put("doctors", doctorsForSpecialty);

            List<Availability> filteredAvailabilities = filterAvailabilities(allAvailabilities, doctorDetails, specialtyLower, doctorName, date, time);
            Collections.sort(filteredAvailabilities);
            responseData.put("availability", filteredAvailabilities);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        LOGGER.info("Response JSON: " + jsonResponse);
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        }
    }

    private Map<String, Doctor> loadDoctorDetails(HttpServletRequest request) throws ServletException {
        Map<String, Doctor> doctorDetails = new HashMap<>();
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
                if (parts.length >= 6) { // username,password,name,specialty,email,phone
                    String username = parts[0].trim();
                    String name = parts[2].trim();      // e.g., "Dr. Gamini Goonetilleke"
                    String specialty = parts[3].trim(); // e.g., "General Surgery"
                    String contact = parts[5].trim();   // e.g., "0778896501" (using phone as contact)
                    doctorDetails.put(username, new Doctor(username, name, specialty, contact));
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading doctor details", e);
            throw new ServletException("Error loading doctor details", e);
        }
        LOGGER.info("Loaded doctor details: " + doctorDetails.size() + " entries");
        return doctorDetails;
    }

    private Map<String, List<String>> loadSpecialtiesAndDoctors(Map<String, Doctor> doctorDetails) {
        Map<String, List<String>> specialtyDoctors = new HashMap<>();
        for (Doctor doctor : doctorDetails.values()) {
            String specialty = doctor.getSpecialization().toLowerCase();
            specialtyDoctors.computeIfAbsent(specialty, k -> new ArrayList<>()).add(doctor.getName());
        }
        LOGGER.info("Specialty to doctors mapping: " + specialtyDoctors);
        return specialtyDoctors;
    }

    private List<Availability> loadAvailabilities(HttpServletRequest request, Map<String, Doctor> doctorDetails) throws ServletException {
        List<Availability> availabilities = new ArrayList<>();
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
                if (parts.length >= 4 && doctorDetails.containsKey(parts[0].trim())) {
                    availabilities.add(new Availability(
                            parts[0].trim(), // doctorId (username)
                            parts[1].trim(), // date
                            parts[2].trim(), // startTime
                            parts[3].trim()  // endTime
                    ));
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading doctor availability", e);
            throw new ServletException("Error loading doctor availability", e);
        }
        LOGGER.info("Loaded availabilities: " + availabilities.size() + " entries");
        return availabilities;
    }

    private List<Availability> filterAvailabilities(List<Availability> availabilities, Map<String, Doctor> doctorDetails,
                                                    String specialty, String doctorName, String date, String time) {
        List<Availability> filtered = new ArrayList<>();
        LocalTime now = LocalTime.now();
        String today = new SimpleDateFormat(DATE_FORMAT).format(new Date());

        for (Availability avail : availabilities) {
            Doctor doc = doctorDetails.get(avail.doctorId);
            if (doc == null) continue;
            boolean matches = true;
            if (specialty != null && !doc.getSpecialization().equalsIgnoreCase(specialty)) matches = false;
            if (doctorName != null && !doctorName.trim().isEmpty() && !doc.getName().equalsIgnoreCase(doctorName)) matches = false;
            if (date != null && !date.trim().isEmpty() && !avail.date.equals(date)) matches = false;
            if (time != null && !time.trim().isEmpty() && avail.getStartTimeAsLocalTime() != null) {
                LocalTime start = avail.getStartTimeAsLocalTime();
                switch (time.toLowerCase()) {
                    case "morning": if (start.isBefore(LocalTime.of(8, 0)) || start.isAfter(LocalTime.of(12, 0))) matches = false; break;
                    case "afternoon": if (start.isBefore(LocalTime.of(12, 0)) || start.isAfter(LocalTime.of(17, 0))) matches = false; break;
                    default: LOGGER.warning("Unknown time filter: " + time);
                }
            }
            if (date != null && date.equals(today) && avail.getStartTimeAsLocalTime().isBefore(now)) matches = false;
            if (matches) filtered.add(avail);
        }
        LOGGER.info("Filtered availabilities: " + filtered.size() + " entries");
        return filtered;
    }

    private void calculateAppointmentCounts(List<Availability> availabilities) throws ServletException {
        List<model.Appointment> appointments = appointmentService.getAllAppointments();
        for (model.Appointment appt : appointments) {
            String[] dateTime = appt.getDateTime().split(" ");
            if (dateTime.length != 2) continue;
            String appointmentDate = dateTime[0];
            String appointmentTime = dateTime[1];
            for (Availability avail : availabilities) {
                if (avail.doctorId.equals(appt.getDoctorId()) &&
                        avail.date.equals(appointmentDate) &&
                        avail.startTime.equals(appointmentTime)) {
                    avail.appointmentCount++;
                }
            }
        }
        for (Availability avail : availabilities) {
            avail.nextToken = String.format("TOK%03d", avail.appointmentCount + 1);
        }
    }
}