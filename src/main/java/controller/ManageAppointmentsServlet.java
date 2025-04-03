package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import service.AppointmentService;
import service.DoctorAvailabilityService;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class ManageAppointmentsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManageAppointmentsServlet.class.getName());
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private String doctorsFilePath;
    private String patientsFilePath;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        LOGGER.info("Initializing AppointmentServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + "appointments.txt");
            availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
            doctorsFilePath = basePath + "doctors.txt";
            patientsFilePath = basePath + "patients.txt";
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize AppointmentServlet services", e);
        }
    }

    // Simple class to hold doctor/patient data
    static class User {
        String id;
        String name;

        User(String id, String name) {
            this.id = id;
            this.name = name;
        }

        public String getId() { return id; }
        public String getName() { return name; }
    }

    private List<User> readUsers(String filePath, boolean isDoctor) throws IOException {
        List<User> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (isDoctor && parts.length >= 3) { // Doctor: id,password,name,specialty
                    users.add(new User(parts[0].trim(), parts[2].trim())); // id, name
                } else if (!isDoctor && parts.length >= 3) { // Patient: id,password,name
                    users.add(new User(parts[0].trim(), parts[2].trim())); // id, name
                } else {
                    LOGGER.warning("Skipping malformed line in " + filePath + ": " + line);
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading file: " + filePath, e);
            throw e;
        }
        return users;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        List<Appointment> appointments;
        if ("admin".equals(role)) {
            appointments = appointmentService.getSortedAppointments();
        } else {
            appointments = appointmentService.getAllAppointments().stream()
                    .filter(appt -> appt.getPatientId().equals(username))
                    .collect(Collectors.toList());
        }

        // Fetch doctors and patients
        List<User> doctors = readUsers(doctorsFilePath, true);
        List<User> patients = readUsers(patientsFilePath, false);

        // Enhance appointments with patient and doctor names
        for (Appointment appt : appointments) {
            patients.stream()
                    .filter(p -> p.getId().equals(appt.getPatientId()))
                    .findFirst()
                    .ifPresent(p -> appt.setPatientName(p.getName()));
            doctors.stream()
                    .filter(d -> d.getId().equals(appt.getDoctorId()))
                    .findFirst()
                    .ifPresent(d -> appt.setDoctorName(d.getName()));
        }

        LOGGER.info("Fetched " + appointments.size() + " appointments for " + username + " (" + role + ")");
        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.setAttribute("doctors", doctors);

        request.getRequestDispatcher("/pages/manageAppointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> responseData = new HashMap<>();
        Gson gson = new Gson();

        try {
            String doctorUsername = request.getParameter("doctorUsername");
            String date = request.getParameter("date");
            String time = request.getParameter("time");
            String tokenID = request.getParameter("tokenID"); // Added tokenID parameter
            String dateTime = date + " " + time;

            if (tokenID == null || tokenID.trim().isEmpty()) {
                tokenID = generateTokenID(); // Generate a token if not provided
            }

            if (!availabilityService.isTimeSlotAvailable(doctorUsername, dateTime)) {
                responseData.put("success", false);
                responseData.put("message", "Time slot not available");
            } else {
                appointmentService.bookAppointment(username, doctorUsername, tokenID, dateTime, false); // Added tokenID
                responseData.put("success", true);
                responseData.put("tokenID", tokenID); // Return the tokenID in response
            }
        } catch (IllegalArgumentException | IOException e) {
            LOGGER.log(Level.WARNING, "Booking error for " + username + ": " + e.getMessage());
            responseData.put("success", false);
            responseData.put("message", "Error: " + e.getMessage());
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
            out.flush();
        }
    }

    // Simple method to generate a unique tokenID
    private String generateTokenID() {
        return "TOK" + System.currentTimeMillis(); // Basic implementation, could be improved
    }
}