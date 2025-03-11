package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DoctorScheduleServlet extends HttpServlet {
    private FileHandler availabilityFileHandler;
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        availabilityFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors_availability.txt"));
        doctorFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> availability = availabilityFileHandler.readLines();
        List<String> doctors = doctorFileHandler.readLines();
        request.setAttribute("availability", availability);
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/pages/doctorSchedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<String> availability = availabilityFileHandler.readLines();
        if (availability == null) availability = new ArrayList<>();

        System.out.println("Action: " + action); // Debug

        if ("add".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String slot = String.join(",", doctorId, date, startTime, endTime);
            boolean exists = availability.contains(slot);
            if (!exists) {
                availability.add(slot);
                System.out.println("Added: " + slot);
            }
        } else if ("remove".equals(action)) {
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String slot = String.join(",", doctorId, date, startTime, endTime);
            availability.remove(slot);
            System.out.println("Removed: " + slot);
        } else if ("edit".equals(action)) {
            String originalDoctorId = request.getParameter("originalDoctorId");
            String originalDate = request.getParameter("originalDate");
            String originalStartTime = request.getParameter("originalStartTime");
            String originalEndTime = request.getParameter("originalEndTime");
            String doctorId = request.getParameter("doctorId");
            String date = request.getParameter("date");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String originalSlot = String.join(",", originalDoctorId, originalDate, originalStartTime, originalEndTime);
            String newSlot = String.join(",", doctorId, date, startTime, endTime);
            for (int i = 0; i < availability.size(); i++) {
                if (availability.get(i).equals(originalSlot)) {
                    availability.set(i, newSlot);
                    System.out.println("Edited: " + originalSlot + " to " + newSlot);
                    break;
                }
            }
        }

        availabilityFileHandler.writeLines(availability);
        System.out.println("Availability after update: " + availability);
        response.sendRedirect(request.getContextPath() + "/DoctorScheduleServlet");
    }
}