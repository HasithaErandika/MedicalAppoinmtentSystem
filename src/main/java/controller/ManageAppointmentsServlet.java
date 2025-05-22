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
        LOGGER.info("Initializing ManageAppointmentsServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + "appointments.txt");
            availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
            doctorsFilePath = basePath + "doctors.txt";
            patientsFilePath = basePath + "patients.txt";
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize ManageAppointmentsServlet services", e);
        }
    }

    // class to hold doctor/patient data
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
        LOGGER.info("Accessing ManageAppointmentsServlet - Username: " + username + ", Role: " + role);
        if (username == null) {
            LOGGER.info("Redirecting to login.jsp due to null username");
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

        LOGGER.info("Fetched " + appointments.size() + " appointments for " + username + " (" + role + "): " + appointments);
        List<User> doctors = readUsers(doctorsFilePath, true);
        List<User> patients = readUsers(patientsFilePath, false);
        LOGGER.info("Doctors: " + doctors.size() + ", Patients: " + patients.size());

        for (Appointment appt : appointments) {
            patients.stream().filter(p -> p.getId().equals(appt.getPatientId())).findFirst()
                    .ifPresent(p -> appt.setPatientName(p.getName()));
            doctors.stream().filter(d -> d.getId().equals(appt.getDoctorId())).findFirst()
                    .ifPresent(d -> appt.setDoctorName(d.getName()));
        }

        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.setAttribute("doctors", doctors);
        LOGGER.info("Forwarding to /pages/manageAppointments.jsp");
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
            String tokenID = request.getParameter("tokenID");
            boolean isEmergency = Boolean.parseBoolean(request.getParameter("isEmergency")); // Allow emergency booking
            String dateTime = date + " " + time;

            if (doctorUsername == null || date == null || time == null || doctorUsername.trim().isEmpty() || date.trim().isEmpty() || time.trim().isEmpty()) {
                throw new IllegalArgumentException("Doctor username, date, and time are required");
            }

            if (tokenID == null || tokenID.trim().isEmpty()) {
                tokenID = generateTokenID();
            }

            if (!availabilityService.isTimeSlotAvailable(doctorUsername, dateTime)) {
                responseData.put("success", false);
                responseData.put("message", "Time slot not available for doctor " + doctorUsername);
            } else {
                // Use 0 for non-emergency, 1 for emergency to match appointments.txt
                appointmentService.bookAppointment(username, doctorUsername, tokenID, dateTime, isEmergency);
                responseData.put("success", true);
                responseData.put("tokenID", tokenID);
                responseData.put("message", "Appointment booked successfully");
                LOGGER.info("Appointment booked by " + username + " with doctor " + doctorUsername + " at " + dateTime);
            }
        } catch (IllegalArgumentException | IOException e) {
            LOGGER.log(Level.WARNING, "Booking error for " + username + ": " + e.getMessage(), e);
            responseData.put("success", false);
            responseData.put("message", "Error: " + e.getMessage());
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
            out.flush();
        }
    }

    // Generate a unique tokenID matching the TOKXXX format
    private String generateTokenID() {
        List<Appointment> appointments = appointmentService.getAllAppointments();
        int maxTokenNum = appointments.stream()
                .map(appt -> appt.getTokenID())
                .filter(token -> token.startsWith("TOK"))
                .map(token -> token.substring(3))
                .mapToInt(Integer::parseInt)
                .max()
                .orElse(0);
        return String.format("TOK%03d", maxTokenNum + 1); // TOK001, TOK002
    }
}