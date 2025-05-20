// test branch
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import service.AppointmentService;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


public class AdminServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());
    private static final String ADMIN_ROLE = "admin";
    private static final String APPOINTMENTS_FILE = "appointments.txt";
    private static final String DOCTORS_FILE = "doctors.txt";
    private static final String PATIENTS_FILE = "patients.txt";

    private AppointmentService appointmentService;
    private FileHandler doctorFileHandler;
    private FileHandler patientFileHandler;

    @Override
    public void init() throws ServletException {
        String basePath = getServletContext().getRealPath("/data/");
        logger.info("Base Path: " + basePath);
        appointmentService = new AppointmentService(basePath + APPOINTMENTS_FILE);
        doctorFileHandler = new FileHandler(basePath + DOCTORS_FILE);
        patientFileHandler = new FileHandler(basePath + PATIENTS_FILE);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String role = (String) request.getSession().getAttribute("role");
        if (username == null || !ADMIN_ROLE.equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?role=admin");
            return;
        }

        try {
            List<Appointment> appointments = appointmentService.readAppointments();
            logger.info("Raw Appointments: " + (appointments != null ? appointments : "null"));

            int totalAppointments = appointments != null ? appointments.size() : 0;
            int totalDoctors = doctorFileHandler.readLines().size();
            int totalPatients = patientFileHandler.readLines().size();
            int emergencyQueueSize = (int) appointments.stream().filter(appt -> appt.getPriority() == 1).count();
            List<Appointment> sortedAppointments = new ArrayList<>(appointments);
            Collections.sort(sortedAppointments, (a, b) -> a.getDateTime().compareTo(b.getDateTime()));

            logger.info("Total Appointments: " + totalAppointments);
            logger.info("Total Doctors: " + totalDoctors);
            logger.info("Total Patients: " + totalPatients);
            logger.info("Emergency Queue Size: " + emergencyQueueSize);
            logger.info("Sorted Appointments: " + (sortedAppointments != null ? sortedAppointments : "null"));

            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalDoctors", totalDoctors);
            request.setAttribute("totalPatients", totalPatients);
            request.setAttribute("emergencyQueueSize", emergencyQueueSize);
            request.setAttribute("sortedAppointments", sortedAppointments);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error fetching dashboard data", e);
            request.setAttribute("error", "Error fetching dashboard data: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/adminDashboard.jsp").forward(request, response);
    }
}