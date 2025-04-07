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

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserServlet.class.getName());
    private static final String USER_ROLE = "patient";
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private FileHandler doctorFileHandler;
    private FileHandler userFileHandler;
    private static final Gson GSON = new Gson();

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        LOGGER.info("Initializing UserServlet with base path: " + basePath);
        try {
            appointmentService = new AppointmentService(basePath + "appointments.txt");
            availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
            doctorFileHandler = new FileHandler(basePath + "doctors.txt");
            userFileHandler = new FileHandler(basePath + "patients.txt");
            LOGGER.info("Successfully initialized file handlers. Patients file: " + (basePath + "patients.txt"));
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize services", e);
            throw new ServletException("Failed to initialize UserServlet services", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");

        LOGGER.info("Session - username: " + username + ", role: " + role);

        if (username == null || !USER_ROLE.equals(role)) {
            LOGGER.info("Unauthorized access attempt by: " + (username != null ? username : "anonymous") + " with role: " + role);
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=patient");
            return;
        }

        String action = request.getParameter("action");
        LOGGER.info("User " + username + " requested action: " + action);

        if ("getAppointments".equals(action)) {
            try {
                List<Appointment> allAppointments = appointmentService.getAllAppointments();
                List<Appointment> userAppointments = allAppointments.stream()
                        .filter(appt -> appt.getPatientId().equals(username))
                        .collect(Collectors.toList());

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String json = GSON.toJson(userAppointments);
                response.getWriter().write(json);
                LOGGER.info("Sent appointments for user " + username + ": " + json);
                return; // Exit after sending JSON
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error fetching appointments for " + username, e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.getWriter().write(GSON.toJson(new ErrorResponse("Error fetching appointments: " + e.getMessage())));
                return;
            }
        }

        // Load user details for page rendering
        try {
            List<String> userLines = userFileHandler.readLines();
            LOGGER.info("Read " + userLines.size() + " lines from patients.txt: " + userLines);
            String userLine = userLines.stream()
                    .filter(line -> line.startsWith(username + ","))
                    .findFirst()
                    .orElse(username + ",pass123,John Doe,john.doe@example.com,123-456-7890,2000-01-01");
            LOGGER.info("Selected user line for " + username + ": " + userLine);
            String[] userParts = userLine.split(",");
            LOGGER.info("Parsed user parts: " + String.join(" | ", userParts));
            if (userParts.length >= 6) {
                request.getSession().setAttribute("password", userParts[1]);
                request.getSession().setAttribute("fullname", userParts[2]);
                request.getSession().setAttribute("email", userParts[3]);
                request.getSession().setAttribute("phone", userParts[4]);
                request.getSession().setAttribute("birthday", userParts[5]);
                LOGGER.info("Set session attributes - password: " + userParts[1] + ", fullname: " + userParts[2] +
                        ", email: " + userParts[3] + ", phone: " + userParts[4] + ", birthday: " + userParts[5]);
            } else {
                LOGGER.warning("User line has insufficient parts: " + userLine);
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user details for " + username, e);
            request.setAttribute("message", "Error loading user details: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        request.getRequestDispatcher("/pages/userProfile/userProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");

        if (username == null || !USER_ROLE.equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=patient");
            return;
        }

        String action = request.getParameter("action");
        LOGGER.info("User " + username + " posted action: " + action);

        if ("book".equals(action)) {
            try {
                String doctorId = request.getParameter("doctorId");
                String date = request.getParameter("date");
                String timeSlot = request.getParameter("timeSlot");
                String token = request.getParameter("token"); // Changed from tokenID to token
                boolean isEmergency = "on".equals(request.getParameter("isEmergency"));

                if (doctorId == null || date == null || timeSlot == null || token == null ||
                        doctorId.trim().isEmpty() || date.trim().isEmpty() || timeSlot.trim().isEmpty() || token.trim().isEmpty()) {
                    throw new IllegalArgumentException("Missing booking parameters");
                }

                String dateTime = date + " " + timeSlot;
                if (!availabilityService.isTimeSlotAvailable(doctorId, dateTime)) {
                    throw new IllegalStateException("Time slot unavailable");
                }

                appointmentService.bookAppointment(username, doctorId, token, dateTime, isEmergency);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(GSON.toJson(new SuccessResponse(true, "Appointment booked successfully! Token: " + token)));
                LOGGER.info("Booked appointment for " + username + " with token: " + token);
                return; // Exit after sending JSON
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Booking error: " + e.getMessage());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.setContentType("application/json");
                response.getWriter().write(GSON.toJson(new ErrorResponse("Error booking appointment: " + e.getMessage())));
                return;
            }
        } else if ("updateDetails".equals(action)) {
            try {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password");
                String birthday = request.getParameter("birthday");

                if (fullName == null || email == null || phone == null || password == null || birthday == null ||
                        fullName.trim().isEmpty() || email.trim().isEmpty() || phone.trim().isEmpty() ||
                        password.trim().isEmpty() || birthday.trim().isEmpty()) {
                    throw new IllegalArgumentException("Missing user details");
                }

                List<String> userLines = userFileHandler.readLines();
                List<String> updatedLines = new ArrayList<>();
                boolean updated = false;
                for (String line : userLines) {
                    if (line.startsWith(username + ",")) {
                        updatedLines.add(username + "," + password + "," + fullName + "," + email + "," + phone + "," + birthday);
                        updated = true;
                    } else {
                        updatedLines.add(line);
                    }
                }
                if (!updated) {
                    updatedLines.add(username + "," + password + "," + fullName + "," + email + "," + phone + "," + birthday);
                }
                userFileHandler.writeLines(updatedLines);

                request.getSession().setAttribute("password", password);
                request.getSession().setAttribute("fullname", fullName);
                request.getSession().setAttribute("email", email);
                request.getSession().setAttribute("phone", phone);
                request.getSession().setAttribute("birthday", birthday);
                request.setAttribute("message", "Details updated successfully!");
                request.setAttribute("messageType", "success");
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error updating user details: " + e.getMessage());
                request.setAttribute("message", "Error updating details: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
            doGet(request, response); // Refresh page for UI updates
        }
    }

    // Helper classes for JSON responses
    private static class SuccessResponse {
        boolean success;
        String message;

        SuccessResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    private static class ErrorResponse {
        String error;

        ErrorResponse(String error) {
            this.error = error;
        }
    }
}