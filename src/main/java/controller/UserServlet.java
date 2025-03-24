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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import com.google.gson.Gson;

public class UserServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserServlet.class.getName());
    private static final String USER_ROLE = "user"; // Assuming 'user' role for patients
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        LOGGER.info("Initializing UserServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + "appointments.txt");
            availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
            doctorFileHandler = new FileHandler(basePath + "doctors.txt");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize UserServlet services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check user authentication
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !USER_ROLE.equals(role)) {
            LOGGER.info("Unauthorized access attempt by: " + (username != null ? username : "anonymous"));
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=user");
            return;
        }

        String action = request.getParameter("action");
        LOGGER.info("User " + username + " requested action: " + action);

        // Handle AJAX request for time slots
        if ("getTimeSlots".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            if (doctorId == null || date == null || doctorId.trim().isEmpty() || date.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing doctorId or date");
                return;
            }
            try {
                List<String> slots = availabilityService.getAvailableTimeSlots(doctorId, date);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String jsonResponse = new Gson().toJson(slots);
                response.getWriter().write(jsonResponse);
                LOGGER.info("Returned " + slots.size() + " available slots for doctor " + doctorId + " on " + date);
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error fetching time slots for doctor " + doctorId + " on " + date, e);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching time slots");
            }
            return;
        }

        // Fetch user appointments and doctor filtering
        try {
            List<Appointment> allAppointments = appointmentService.getAllAppointments();
            List<Appointment> userAppointments = allAppointments != null ?
                    allAppointments.stream()
                            .filter(appt -> appt.getPatientId().equals(username))
                            .collect(Collectors.toList()) : new ArrayList<>();

            String specialty = request.getParameter("specialty");
            String doctorName = request.getParameter("doctor");
            String date = request.getParameter("date");

            List<String> allDoctors = doctorFileHandler.readLines();
            List<String> filteredDoctors = allDoctors != null ?
                    allDoctors.stream()
                            .filter(doctor -> {
                                String[] parts = doctor.split(",");
                                if (parts.length < 4) return false; // id,name,specialization,contact
                                boolean specialtyMatch = specialty == null || specialty.isEmpty() || parts[2].equalsIgnoreCase(specialty);
                                boolean nameMatch = doctorName == null || doctorName.isEmpty() || parts[1].toLowerCase().contains(doctorName.toLowerCase());
                                boolean availabilityMatch = date == null || date.isEmpty();
                                if (!availabilityMatch) {
                                    try {
                                        availabilityMatch = availabilityService.hasAvailability(parts[0], date);
                                    } catch (IOException e) {
                                        LOGGER.log(Level.WARNING, "Error checking availability for doctor " + parts[0] + " on " + date, e);
                                        return false; // Skip this doctor if availability check fails
                                    }
                                }
                                return specialtyMatch && nameMatch && availabilityMatch;
                            })
                            .collect(Collectors.toList()) : new ArrayList<>();

            request.setAttribute("filteredDoctors", filteredDoctors);
            request.setAttribute("appointments", userAppointments);
            request.setAttribute("param.date", date);
            LOGGER.info("User " + username + " - Appointments: " + userAppointments.size() + ", Filtered Doctors: " + filteredDoctors.size());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error fetching data for user " + username, e);
            request.setAttribute("message", "Error loading profile: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        request.getRequestDispatcher("/pages/userProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check user authentication
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !USER_ROLE.equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=user");
            return;
        }

        String action = request.getParameter("action");
        LOGGER.info("User " + username + " posted action: " + action);

        if ("book".equals(action)) {
            try {
                String doctorId = request.getParameter("doctorId");
                String date = request.getParameter("date");
                String timeSlot = request.getParameter("timeSlot");
                boolean isEmergency = "on".equals(request.getParameter("isEmergency"));

                if (doctorId == null || date == null || timeSlot == null ||
                        doctorId.trim().isEmpty() || date.trim().isEmpty() || timeSlot.trim().isEmpty()) {
                    throw new IllegalArgumentException("Missing required booking parameters");
                }

                String dateTime = date + " " + timeSlot;
                if (!availabilityService.isTimeSlotAvailable(doctorId, dateTime)) {
                    throw new IllegalStateException("Selected time slot is not available");
                }

                appointmentService.bookAppointment(username, doctorId, dateTime, isEmergency);
                LOGGER.info("User " + username + " booked appointment with doctor " + doctorId + " at " + dateTime +
                        " (Emergency: " + isEmergency + ")");
                request.setAttribute("message", "Appointment booked successfully!");
                request.setAttribute("messageType", "success");
            } catch (IllegalArgumentException | IllegalStateException e) {
                LOGGER.log(Level.WARNING, "Booking error for user " + username + ": " + e.getMessage());
                request.setAttribute("message", "Error booking appointment: " + e.getMessage());
                request.setAttribute("messageType", "error");
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "IO error during booking for user " + username, e);
                request.setAttribute("message", "Server error booking appointment: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
        }

        doGet(request, response); // Refresh profile page
    }
}