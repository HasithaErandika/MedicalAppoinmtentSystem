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
import com.google.gson.Gson;

public class AppointmentServlet extends HttpServlet {
    private AppointmentService appointmentService;
    private DoctorAvailabilityService availabilityService;
    private FileHandler doctorFileHandler;
    private FileHandler patientFileHandler;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        appointmentService = new AppointmentService(basePath + "appointments.txt");
        availabilityService = new DoctorAvailabilityService(basePath + "doctors_availability.txt", appointmentService);
        doctorFileHandler = new FileHandler(basePath + "doctors.txt");
        patientFileHandler = new FileHandler(basePath + "patients.txt");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("getTimeSlots".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            List<String> slots = availabilityService.getAvailableTimeSlots(doctorId, date);
            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(slots));
            return;
        }

        List<String> doctors = doctorFileHandler.readLines();
        List<String> patients = patientFileHandler.readLines();
        List<Appointment> appointments = appointmentService.readAppointments();

        request.setAttribute("doctors", doctors);
        request.setAttribute("patients", patients);
        request.setAttribute("appointments", appointments);

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("appointmentId"));
            Appointment editAppointment = appointments.stream()
                    .filter(appt -> appt.getId() == id)
                    .findFirst()
                    .orElse(null);
            request.setAttribute("editAppointment", editAppointment);
        }

        request.getRequestDispatcher("/pages/appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("add".equals(action) || "update".equals(action)) {
                int id = "update".equals(action) ? Integer.parseInt(request.getParameter("appointmentId")) : -1;
                String patientId = request.getParameter("patientId");
                String doctorId = request.getParameter("doctorId");
                String date = request.getParameter("date");
                String timeSlot = request.getParameter("timeSlot");
                String dateTime = date + " " + timeSlot;
                boolean isEmergency = "on".equals(request.getParameter("isEmergency"));
                int priority = isEmergency ? 1 : 2;

                if (!availabilityService.isTimeSlotAvailable(doctorId, dateTime)) {
                    throw new Exception("Selected time slot is not available.");
                }

                if ("add".equals(action)) {
                    appointmentService.bookAppointment(patientId, doctorId, dateTime, isEmergency);
                    request.setAttribute("message", "Appointment booked successfully!");
                } else {
                    appointmentService.updateAppointment(id, patientId, doctorId, dateTime, priority);
                    request.setAttribute("message", "Appointment updated successfully!");
                }
                request.setAttribute("messageType", "success");
            } else if ("cancel".equals(action)) {
                int id = Integer.parseInt(request.getParameter("appointmentId"));
                appointmentService.cancelAppointment(id);
                request.setAttribute("message", "Appointment canceled successfully!");
                request.setAttribute("messageType", "success");
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }

        doGet(request, response);
    }
}