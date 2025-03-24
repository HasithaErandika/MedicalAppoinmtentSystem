package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import service.AppointmentService;
import service.DoctorAvailabilityService;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class AppointmentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AppointmentServlet.class.getName());
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        LOGGER.info("Initializing AppointmentServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + "appointments.txt");
            availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize AppointmentServlet services", e);
        }
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
            appointments = appointmentService.getSortedAppointments(); // Admin sees all sorted
        } else {
            appointments = appointmentService.getAllAppointments().stream()
                    .filter(appt -> appt.getPatientId().equals(username))
                    .collect(Collectors.toList());
        }
        LOGGER.info("Fetched " + appointments.size() + " appointments for " + username + " (" + role + ")");
        request.setAttribute("appointments", appointments);

        request.getRequestDispatcher("/pages/appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        LOGGER.info("User " + username + " (" + role + ") posted action: " + action);

        try {
            if ("book".equals(action) && !"admin".equals(role)) {
                String doctorId = request.getParameter("doctorId");
                String dateTime = request.getParameter("dateTime");
                boolean isEmergency = "on".equals(request.getParameter("isEmergency"));
                if (!availabilityService.isTimeSlotAvailable(doctorId, dateTime)) {
                    throw new IllegalStateException("Time slot not available");
                }
                appointmentService.bookAppointment(username, doctorId, dateTime, isEmergency);
                request.setAttribute("message", "Appointment booked successfully!");
            } else if ("cancel".equals(action)) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                appointmentService.cancelAppointment(appointmentId);
                request.setAttribute("message", "Appointment canceled successfully!");
            }
        } catch (IllegalStateException e) {
            LOGGER.log(Level.WARNING, "Booking error for " + username + ": " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "IO error during " + action + " for " + username, e);
            request.setAttribute("error", "Server error: " + e.getMessage());
        }

        doGet(request, response); // Refresh page
    }
}