package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.AppointmentService;
import service.DoctorAvailabilityService;
import java.io.*;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.logging.Logger;

public class SortServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SortServlet.class.getName());
    private static final String DOCTORS_FILE = "/data/doctors.txt";
    private static final String AVAILABILITY_FILE = "/data/doctors_availability.txt";
    private static final String NAME = "name";
    private static final String SPECIALTY = "specialty";
    private Map<String, Map<String, String>> cachedDoctorDetails;
    private Map<String, List<String>> cachedSpecialtyDoctors;
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;

    static class Doctor {
        String username;
        String name;
        String specialty;
        String date;
        String startTime;
        String endTime;

        Doctor(String username, String name, String specialty, String date, String startTime, String endTime) {
            this.username = username;
            this.name = name;
            this.specialty = specialty.toLowerCase();
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
        }

        public LocalTime getStartTimeAsLocalTime() {
            try {
                return LocalTime.parse(startTime);
            } catch (DateTimeParseException e) {
                LOGGER.warning("Invalid start time: " + startTime + " for doctor " + name);
                return null;
            }
        }
    }

    @Override
    public void init() throws ServletException {
        String doctorsPath = getServletContext().getRealPath(DOCTORS_FILE);
        String appointmentsPath = getServletContext().getRealPath("/data/appointments.txt");
        String availabilityPath = getServletContext().getRealPath(AVAILABILITY_FILE);
        cachedDoctorDetails = loadDoctorDetails(doctorsPath);
        cachedSpecialtyDoctors = loadSpecialtiesAndDoctors(cachedDoctorDetails);
        try {
            appointmentService = new AppointmentService(appointmentsPath);
            availabilityService = new DoctorAvailabilityService(availabilityPath, appointmentService);
        } catch (IOException e) {
            throw new ServletException("Failed to initialize services", e);
        }
        LOGGER.info("Servlet initialized with " + cachedDoctorDetails.size() + " doctors.");
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

        LOGGER.info("Request received: specialty=" + specialty + ", doctor=" + doctorName + ", date=" + date + ", time=" + time);

        List<Doctor> allDoctors = loadDoctors(request.getServletContext().getRealPath(AVAILABILITY_FILE), cachedDoctorDetails);

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("specialties", new ArrayList<>(cachedSpecialtyDoctors.keySet()));
        responseData.put("doctors", new ArrayList<>());
        responseData.put("availability", new ArrayList<>());

        if (specialty != null && !specialty.trim().isEmpty()) {
            List<String> doctorsForSpecialty = cachedSpecialtyDoctors.getOrDefault(specialty.toLowerCase(), new ArrayList<>());
            Collections.sort(doctorsForSpecialty);
            responseData.put("doctors", doctorsForSpecialty);

            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialty, doctorName, date, time);
            bubbleSortDoctors(filteredDoctors);
            List<Doctor> availableDoctors = new ArrayList<>();
            for (Doctor doc : filteredDoctors) {
                String dateTime = doc.date + " " + doc.startTime;
                if (availabilityService.isTimeSlotAvailable(doc.username, dateTime)) {
                    availableDoctors.add(doc);
                }
            }
            responseData.put("availability", availableDoctors);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        }
    }

    private void bubbleSortDoctors(List<Doctor> doctors) {
        int n = doctors.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                Doctor current = doctors.get(j);
                Doctor next = doctors.get(j + 1);
                int dateCompare = current.date.compareTo(next.date);
                if (dateCompare > 0) {
                    swap(doctors, j, j + 1);
                } else if (dateCompare == 0) {
                    LocalTime t1 = current.getStartTimeAsLocalTime();
                    LocalTime t2 = next.getStartTimeAsLocalTime();
                    if (t1 != null && t2 != null && t1.isAfter(t2)) {
                        swap(doctors, j, j + 1);
                    }
                }
            }
        }
    }

    private void swap(List<Doctor> doctors, int i, int j) {
        Doctor temp = doctors.get(i);
        doctors.set(i, doctors.get(j));
        doctors.set(j, temp);
    }

    private Map<String, Map<String, String>> loadDoctorDetails(String doctorsPath) throws ServletException {
        Map<String, Map<String, String>> doctorDetails = new HashMap<>();
        File file = new File(doctorsPath);
        if (!file.exists()) {
            LOGGER.severe("doctors.txt file not found at: " + doctorsPath);
            throw new ServletException("doctors.txt file not found");
        }
        try (BufferedReader br = new BufferedReader(new FileReader(doctorsPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    Map<String, String> details = new HashMap<>();
                    details.put(NAME, parts[1].trim()); // Assuming format: id,name,specialization,contact
                    details.put(SPECIALTY, parts[2].trim().toLowerCase());
                    doctorDetails.put(parts[0].trim(), details);
                }
            }
        } catch (IOException e) {
            throw new ServletException("Error loading doctors.txt", e);
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

    private List<Doctor> loadDoctors(String availabilityPath, Map<String, Map<String, String>> doctorDetails) throws ServletException {
        List<Doctor> doctors = new ArrayList<>();
        File file = new File(availabilityPath);
        if (!file.exists()) {
            LOGGER.severe("doctors_availability.txt file not found at: " + availabilityPath);
            throw new ServletException("doctors_availability.txt file not found");
        }
        try (BufferedReader br = new BufferedReader(new FileReader(availabilityPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    Map<String, String> details = doctorDetails.get(parts[0].trim());
                    if (details != null) {
                        doctors.add(new Doctor(parts[0].trim(), details.get(NAME), details.get(SPECIALTY), parts[1].trim(), parts[2].trim(), parts[3].trim()));
                    }
                }
            }
        } catch (IOException e) {
            throw new ServletException("Error loading doctors_availability.txt", e);
        }
        return doctors;
    }

    private List<Doctor> filterDoctors(List<Doctor> doctors, String specialty, String doctorName, String date, String time) {
        // ... existing filter logic from your original code ...
        List<Doctor> filtered = new ArrayList<>();
        LocalTime now = LocalTime.now();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String today = sdf.format(new Date());

        for (Doctor doc : doctors) {
            boolean matches = true;

            if (specialty != null && !specialty.isEmpty() && !doc.specialty.equals(specialty)) {
                matches = false;
            }
            if (doctorName != null && !doctorName.isEmpty() && !doc.name.equalsIgnoreCase(doctorName)) {
                matches = false;
            }
            if (date != null && !date.isEmpty() && !doc.date.equals(date)) {
                matches = false;
            }
            if (date != null && date.equals(today) && doc.getStartTimeAsLocalTime() != null && doc.getStartTimeAsLocalTime().isBefore(now)) {
                matches = false;
            }
            if (time != null && !time.isEmpty() && doc.getStartTimeAsLocalTime() != null) {
                LocalTime start = doc.getStartTimeAsLocalTime();
                switch (time) {
                    case "morning":
                        if (start.isBefore(LocalTime.of(8, 0)) || start.isAfter(LocalTime.of(12, 0))) matches = false;
                        break;
                    case "afternoon":
                        if (start.isBefore(LocalTime.of(12, 0)) || start.isAfter(LocalTime.of(17, 0))) matches = false;
                        break;
                    default:
                        LOGGER.warning("Unknown time filter: " + time);
                }
            }

            if (matches) {
                filtered.add(doc);
            }
        }
        return filtered;
    }
}