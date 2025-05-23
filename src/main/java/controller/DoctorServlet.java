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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DoctorServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DoctorServlet.class.getName());
    private static final String DOCTOR_ROLE = "doctor";
    private static final String APPOINTMENTS_FILE = "/data/appointments.txt";
    private static final String DOCTORS_FILE = "/data/doctors.txt";
    private static final String AVAILABILITY_FILE = "/data/doctors_availability.txt";
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

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

        String section = request.getParameter("section") != null ? request.getParameter("section") : "dashboard";
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            Doctor doctor = getDoctorByUsername(username);
            if (doctor == null) {
                throw new IOException("Doctor not found for username: " + username);
            }

            // Get sorted appointments and filter by doctorId
            List<Appointment> allAppointments = appointmentService.getSortedAppointments();
            List<Appointment> appointments = new ArrayList<>();
            for (Appointment appt : allAppointments) {
                if (appt.getDoctorId().equals(doctor.getId())) {
                    appointments.add(appt);
                }
            }

            LocalDateTime now = LocalDateTime.now();
            LocalDate today = LocalDate.now();

            // Create a map to store patientId -> patientName
            FileHandler patientFileHandler = new FileHandler(getServletContext().getRealPath("") + "/data/patients.txt");
            Map<String, String> patientNames = new HashMap<>();
            for (Appointment appt : appointments) {
                String patientName = patientFileHandler.getPatientNameByUsername(appt.getPatientId(), getServletContext().getRealPath("") + "/data/patients.txt");
                patientNames.put(appt.getPatientId(), patientName);
            }

            int totalAppointments = appointments.size();
            int upcomingAppointments = 0;
            int emergencyAppointments = 0;
            int todayAppointments = 0;
            int completedAppointments = 0;

            for (Appointment appt : appointments) {
                LocalDateTime apptTime = LocalDateTime.parse(appt.getDateTime(), DATE_TIME_FORMATTER);
                if (apptTime.isAfter(now)) {
                    upcomingAppointments++;
                }
                if (appt.getPriority() == 1) {
                    emergencyAppointments++;
                }
                if (apptTime.toLocalDate().equals(today)) {
                    todayAppointments++;
                }
                if (apptTime.isBefore(now)) {
                    completedAppointments++;
                }
            }

            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("upcomingAppointments", upcomingAppointments);
            request.setAttribute("emergencyAppointments", emergencyAppointments);
            request.setAttribute("todayAppointments", todayAppointments);
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("appointments", appointments);
            request.setAttribute("patientNames", patientNames);
            request.setAttribute("doctor", doctor);
            request.setAttribute("section", section);

            LOGGER.info("Serving " + section + " section for " + username + " (AJAX: " + isAjax + ")");
            LOGGER.info("Appointments: " + appointments.size() + ", Doctor: " + doctor.getId());
            String jspPath = "/pages/doctorProfile/" + section + ".jsp";
            if (isAjax) {
                LOGGER.info("Forwarding AJAX request to: " + jspPath);
                response.setContentType("text/html;charset=UTF-8");
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else {
                request.getRequestDispatcher("/pages/doctorProfile/doctorDashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching data for " + section + " section, user: " + username, e);
            request.setAttribute("error", "Error fetching data: " + e.getMessage());
            if (isAjax) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<p>Error loading " + section + ": " + e.getMessage() + "</p>");
            } else {
                request.getRequestDispatcher("/pages/doctorProfile/doctorDashboard.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !DOCTOR_ROLE.equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            if ("updateDetails".equals(action)) {
                Doctor doctor = new Doctor(
                        request.getParameter("id"),
                        request.getParameter("name"),
                        request.getParameter("specialization"),
                        request.getParameter("contact")
                );
                String password = request.getParameter("password");
                updateDoctorDetails(doctor, password);
                request.setAttribute("message", "Details updated successfully");
            } else if ("cancelAppointment".equals(action)) {
                String appointmentIdStr = request.getParameter("appointmentId");
                int appointmentId = Integer.parseInt(appointmentIdStr);
                appointmentService.cancelAppointment(appointmentId);
                request.setAttribute("message", "Appointment canceled successfully");
            }
            doGet(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing action " + action + " for " + username, e);
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            doGet(request, response);
        }
    }

    private Doctor getDoctorByUsername(String username) throws IOException {
        List<String> lines = doctorFileHandler.readLines();
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length >= 6 && parts[0].equals(username)) {
                return new Doctor(parts[0], parts[2], parts[3], parts[5]);
            }
        }
        LOGGER.warning("No doctor found for username: " + username);
        return null;
    }

    private void updateDoctorDetails(Doctor doctor, String password) throws IOException {
        List<String> lines = doctorFileHandler.readLines();
        for (int i = 0; i < lines.size(); i++) {
            String[] parts = lines.get(i).split(",");
            if (parts[0].equals(doctor.getId())) {
                lines.set(i, String.format("%s,%s,%s,%s,%s,%s",
                        parts[0], password != null && !password.isEmpty() ? password : parts[1],
                        doctor.getName(), doctor.getSpecialization(), parts[4], doctor.getContact()));
                break;
            }
        }
        doctorFileHandler.writeLines(lines);
    }
}