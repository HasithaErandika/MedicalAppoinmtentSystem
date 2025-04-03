package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import model.Doctor;
import service.AppointmentService;
import service.DoctorAvailabilityService;
import service.FileHandler;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class DoctorServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DoctorServlet.class.getName());
    private static final String DOCTOR_ROLE = "doctor";
    private static final String APPOINTMENTS_FILE = "/data/appointments.txt";
    private static final String DOCTORS_FILE = "/data/doctors.txt";
    private static final String AVAILABILITY_FILE = "/data/doctors_availability.txt";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("");
        LOGGER.info("Initializing DoctorServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + APPOINTMENTS_FILE);
            availabilityService = new DoctorAvailabilityService(basePath + AVAILABILITY_FILE, appointmentService);
            doctorFileHandler = new FileHandler(basePath + DOCTORS_FILE);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize DoctorServlet services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !DOCTOR_ROLE.equals(role)) {
            LOGGER.info("Unauthorized access attempt by user: " + (username != null ? username : "anonymous"));
            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
            return;
        }

        try {
            // Fetch doctor details
            Doctor doctor = getDoctorByUsername(username);
            if (doctor == null) {
                throw new IOException("Doctor not found for username: " + username);
            }

            // Fetch all appointments for this doctor
            List<Appointment> appointments = appointmentService.getAppointmentsByDoctorId(doctor.getId());
            LocalDateTime now = LocalDateTime.now();
            LocalDate today = LocalDate.now();

            // Categorize appointments
            int totalAppointments = appointments.size();
            int upcomingAppointments = (int) appointments.stream()
                    .filter(appt -> LocalDateTime.parse(appt.getDateTime()).isAfter(now))
                    .count();
            int emergencyAppointments = (int) appointments.stream()
                    .filter(appt -> appt.getPriority() == 1)
                    .count();
            int todayAppointments = (int) appointments.stream()
                    .filter(appt -> LocalDate.parse(appt.getDateTime().split(" ")[0], DATE_FORMATTER).equals(today))
                    .count();
            List<Appointment> emergencyAppointmentsList = appointments.stream()
                    .filter(appt -> appt.getPriority() == 1)
                    .collect(Collectors.toList());

            // Set patient names (fallback if not populated)
            for (Appointment appt : appointments) {
                if (appt.getPatientName() == null) {
                    appt.setPatientName("Patient " + appt.getPatientId());
                }
            }

            // Set request attributes
            request.setAttribute("doctor", doctor);
            request.setAttribute("appointments", appointments);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("upcomingAppointments", upcomingAppointments);
            request.setAttribute("emergencyAppointments", emergencyAppointments);
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("emergencyAppointmentsList", emergencyAppointmentsList);

            LOGGER.info("Doctor dashboard data for " + username + ": Total=" + totalAppointments +
                    ", Upcoming=" + upcomingAppointments + ", Emergency=" + emergencyAppointments +
                    ", Today=" + todayAppointments);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error fetching doctor dashboard data for " + username, e);
            request.setAttribute("error", "Error fetching dashboard data: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/doctorDashboard.jsp").forward(request, response);
    }

    private Doctor getDoctorByUsername(String username) throws IOException {
        List<String> lines = doctorFileHandler.readLines();
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length >= 4 && parts[0].equals(username)) { // Assuming username = doctorId
                return new Doctor(parts[0], parts[1], parts[2], parts[3]);
            }
        }
        LOGGER.warning("No doctor found for username: " + username);
        return null;
    }


}