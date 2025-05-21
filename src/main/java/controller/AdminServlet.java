package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import service.AppointmentService;
import service.DoctorAvailabilityService;
import service.FileHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminServlet.class.getName());
    private static final String ADMIN_ROLE = "admin";
    private static final String APPOINTMENTS_FILE = "/data/appointments.txt";
    private static final String DOCTORS_FILE = "/data/doctors.txt";
    private static final String PATIENTS_FILE = "/data/patients.txt";
    private static final String AVAILABILITY_FILE = "/data/doctors_availability.txt";
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private FileHandler doctorFileHandler;
    private FileHandler patientFileHandler;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("");
        LOGGER.info("Initializing AdminServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + APPOINTMENTS_FILE);
            availabilityService = new DoctorAvailabilityService(basePath + AVAILABILITY_FILE, appointmentService);
            doctorFileHandler = new FileHandler(basePath + DOCTORS_FILE);

        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize AdminServlet services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !ADMIN_ROLE.equals(role)) {
            LOGGER.info("Unauthorized access attempt by user: " + (username != null ? username : "anonymous"));
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
            return;
        }

        try {
            // Fetch data
            List<Appointment> appointments = appointmentService.getAllAppointments();
            List<Appointment> sortedAppointments = appointmentService.getSortedAppointments();
            List<String> doctorLines = doctorFileHandler.readLines();
            List<String> patientLines = patientFileHandler.readLines();

            // Debug raw data
            LOGGER.info("Appointments loaded: " + (appointments != null ? appointments.size() : "null") + " - " + appointments);
            LOGGER.info("Sorted appointments: " + (sortedAppointments != null ? sortedAppointments.size() : "null"));

            // Calculate stats
            LocalDateTime now = LocalDateTime.now();
            int totalAppointments = appointments != null ? appointments.size() : 0;
            int previousAppointments = appointments != null ?
                    (int) appointments.stream()
                            .filter(appt -> LocalDateTime.parse(appt.getDateTime(), DATE_TIME_FORMATTER).isBefore(now))
                            .count() : 0;
            int futureAppointments = appointments != null ?
                    (int) appointments.stream()
                            .filter(appt -> !LocalDateTime.parse(appt.getDateTime(), DATE_TIME_FORMATTER).isBefore(now))
                            .count() : 0;
            int emergencyQueueSize = appointments != null ?
                    (int) appointments.stream()
                            .filter(appt -> appt.getPriority() == 1 && !LocalDateTime.parse(appt.getDateTime(), DATE_TIME_FORMATTER).isBefore(now))
                            .count() : 0;
            int totalDoctors = doctorLines != null ? doctorLines.size() : 0;
            int totalPatients = patientLines != null ? patientLines.size() : 0;

            // Log stats
            LOGGER.info("Dashboard data for admin " + username + ": " +
                    "Total=" + totalAppointments + ", Previous=" + previousAppointments +
                    ", Future=" + futureAppointments + ", Emergency=" + emergencyQueueSize +
                    ", Doctors=" + totalDoctors + ", Patients=" + totalPatients);

            // Set attributes
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("previousAppointments", previousAppointments);
            request.setAttribute("futureAppointments", futureAppointments);
            request.setAttribute("emergencyQueueSize", emergencyQueueSize);
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("sortedAppointments", sortedAppointments);

        } catch (Exception e) { // Broaden to catch parsing errors
            LOGGER.log(Level.SEVERE, "Error processing dashboard data for admin " + username, e);
            request.setAttribute("error", "Error fetching dashboard data: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = (String) request.getSession().getAttribute("username");
        if (username == null || !ADMIN_ROLE.equals(request.getSession().getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
            return;
        }

        try {
            if ("cancelAppointment".equals(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                appointmentService.cancelAppointment(appointmentId);
                LOGGER.info("Admin " + username + " canceled appointment ID: " + appointmentId);
                request.setAttribute("message", "Appointment canceled successfully");
            } else if ("updateAppointment".equals(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                String patientId = request.getParameter("patientId");
                String doctorId = request.getParameter("doctorId");
                String tokenID = request.getParameter("tokenID");
                String dateTime = request.getParameter("dateTime");
                int priority = Integer.parseInt(request.getParameter("priority"));

                if (priority != 0 && priority != 1) {
                    throw new IllegalArgumentException("Priority must be 0 (non-emergency) or 1 (emergency)");
                }

                appointmentService.updateAppointment(appointmentId, patientId, doctorId, tokenID, dateTime, priority);
                LOGGER.info("Admin " + username + " updated appointment ID: " + appointmentId);
                request.setAttribute("message", "Appointment updated successfully");
            }
        } catch (IllegalArgumentException | IOException e) {
            LOGGER.log(Level.WARNING, "Error processing action '" + action + "' for admin " + username, e);
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        doGet(request, response);
    }
}