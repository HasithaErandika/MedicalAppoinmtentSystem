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
import java.util.stream.Collectors;
import com.google.gson.Gson;

public class UserServlet extends HttpServlet {
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        appointmentService = new AppointmentService(basePath + "appointments.txt");
        availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
        doctorFileHandler = new FileHandler(basePath + "doctors.txt");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = (String) request.getSession().getAttribute("username");

        if ("getTimeSlots".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            List<String> slots = availabilityService.getAvailableTimeSlots(doctorId, date);
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(slots));
            return;
        }

        String specialty = request.getParameter("specialty");
        String doctorName = request.getParameter("doctor");
        String date = request.getParameter("date");

        List<String> allDoctors = doctorFileHandler.readLines();
        List<String> filteredDoctors = allDoctors.stream()
                .filter(doctor -> {
                    String[] parts = doctor.split(",");
                    boolean specialtyMatch = specialty == null || specialty.isEmpty() || parts[4].equalsIgnoreCase(specialty);
                    boolean nameMatch = doctorName == null || doctorName.isEmpty() || parts[2].toLowerCase().contains(doctorName.toLowerCase());
                    boolean availabilityMatch = date == null || !date.isEmpty() && availabilityService.hasAvailability(parts[0], date);
                    return specialtyMatch && nameMatch && availabilityMatch;
                })
                .collect(Collectors.toList());

        List<Appointment> allAppointments = appointmentService.readAppointments();
        List<Appointment> userAppointments = allAppointments.stream()
                .filter(appt -> appt.getPatientId().equals(username))
                .collect(Collectors.toList());

        request.setAttribute("filteredDoctors", filteredDoctors);
        request.setAttribute("appointments", userAppointments);
        request.setAttribute("param.date", date);
        request.getRequestDispatcher("/pages/userProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = (String) request.getSession().getAttribute("username");

        if ("book".equals(action)) {
            try {
                String doctorId = request.getParameter("doctorId");
                String date = request.getParameter("date");
                String timeSlot = request.getParameter("timeSlot");
                String dateTime = date + " " + timeSlot;
                boolean isEmergency = "on".equals(request.getParameter("isEmergency"));

                if (!availabilityService.isTimeSlotAvailable(doctorId, dateTime)) {
                    throw new Exception("Selected time slot is not available.");
                }

                appointmentService.bookAppointment(username, doctorId, dateTime, isEmergency);
                request.setAttribute("message", "Appointment booked successfully!");
                request.setAttribute("messageType", "success");
            } catch (Exception e) {
                request.setAttribute("message", "Error booking appointment: " + e.getMessage());
                request.setAttribute("messageType", "error");
            }
        }

        doGet(request, response);
    }
}