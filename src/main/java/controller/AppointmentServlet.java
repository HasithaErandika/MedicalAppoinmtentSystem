package controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import service.AppointmentService;
import service.DoctorAvailabilityService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
            appointments = appointmentService.getSortedAppointments();
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> responseData = new HashMap<>();
        Gson gson = new Gson();

        try {
            String doctorUsername = request.getParameter("doctorUsername");
            String date = request.getParameter("date");
            String time = request.getParameter("time");
            String dateTime = date + " " + time;

            if (!availabilityService.isTimeSlotAvailable(doctorUsername, dateTime)) {
                responseData.put("success", false);
                responseData.put("message", "Time slot not available");
            } else {
                appointmentService.bookAppointment(username, doctorUsername, dateTime, false); // Assuming non-emergency from index.js
                responseData.put("success", true);
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
}