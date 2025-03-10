package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DoctorScheduleServlet extends HttpServlet {
    private FileHandler availabilityFileHandler;
    private static final List<String> DAYS = Arrays.asList("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday");

    @Override
    public void init() throws ServletException {
        availabilityFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors_availability.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> availability = availabilityFileHandler.readLines();
        request.setAttribute("availability", availability);
        request.setAttribute("days", DAYS);
        request.getRequestDispatcher("/pages/doctorSchedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<String> availability = availabilityFileHandler.readLines();
        if (availability == null) availability = new ArrayList<>();

        if ("add".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String day = request.getParameter("day");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String slot = String.format("%s,%s,%s,%s", doctorId, day, startTime, endTime);
            availability.add(slot);
        } else if ("remove".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String day = request.getParameter("day");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String slot = String.format("%s,%s,%s,%s", doctorId, day, startTime, endTime);
            availability.remove(slot);
        }

        availabilityFileHandler.writeLines(availability);
        response.sendRedirect(request.getContextPath() + "/DoctorScheduleServlet");
    }
}