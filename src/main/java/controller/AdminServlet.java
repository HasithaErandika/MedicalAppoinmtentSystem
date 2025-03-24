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
            patientFileHandler = new FileHandler(basePath + PATIENTS_FILE);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize AdminServlet services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check admin authentication
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !ADMIN_ROLE.equals(role)) {
            LOGGER.info("Unauthorized access attempt by user: " + (username != null ? username : "anonymous"));
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
            return;
        }

        try {
            // Fetch data for dashboard
            List<Appointment> appointments = appointmentService.getAllAppointments();
            List<Appointment> sortedAppointments = appointmentService.getSortedAppointments(); // Uses bubble sort
            List<String> doctorLines = doctorFileHandler.readLines();
            List<String> patientLines = patientFileHandler.readLines();

            // Calculate dashboard stats
            int totalAppointments = appointments != null ? appointments.size() : 0;
            int totalDoctors = doctorLines != null ? doctorLines.size() : 0;
            int totalPatients = patientLines != null ? patientLines.size() : 0;
            int emergencyQueueSize = appointments != null ?
                    (int) appointments.stream().filter(appt -> appt.getPriority() == 1).count() : 0;

            // Log dashboard data
            LOGGER.info("Dashboard data for admin " + username + ": " +
                    "Total Appointments=" + totalAppointments + ", " +
                    "Total Doctors=" + totalDoctors + ", " +
                    "Total Patients=" + totalPatients + ", " +
                    "Emergency Queue Size=" + emergencyQueueSize);
            LOGGER.info("Sorted Appointments: " + (sortedAppointments != null ? sortedAppointments : "none"));

            // Set request attributes for JSP
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("emergencyQueueSize", emergencyQueueSize);
            request.setAttribute("sortedAppointments", sortedAppointments);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error fetching dashboard data for admin " + username, e);
            request.setAttribute("error", "Error fetching dashboard data: " + e.getMessage());
        }

        // Forward to admin dashboard JSP
        request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle potential POST requests (e.g., admin actions like canceling appointments)
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
            }
        } catch (IllegalArgumentException | IOException e) {
            LOGGER.log(Level.WARNING, "Error processing action '" + action + "' for admin " + username, e);
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        // Refresh dashboard after POST action
        doGet(request, response);
    }
}