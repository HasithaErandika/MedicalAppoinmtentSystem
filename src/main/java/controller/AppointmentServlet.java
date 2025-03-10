package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.AppointmentService;

import java.io.IOException;

public class AppointmentServlet extends HttpServlet {
    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService(getServletContext().getRealPath("/data/appointments.txt"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("cancel".equals(action)) {
            int id = Integer.parseInt(request.getParameter("appointmentId"));
            appointmentService.cancelAppointment(id);
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
        } else if ("book".equals(action)) {
            String patientId = request.getParameter("patientId");
            String doctorId = request.getParameter("doctorId");
            String dateTime = request.getParameter("dateTime");
            boolean isEmergency = "on".equals(request.getParameter("isEmergency"));
            appointmentService.bookAppointment(patientId, doctorId, dateTime, isEmergency);
            response.sendRedirect(request.getContextPath() + "/AdminServlet");
        }
    }
}