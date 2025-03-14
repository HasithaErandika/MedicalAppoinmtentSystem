package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DoctorScheduleServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(DoctorScheduleServlet.class.getName());

    private FileHandler availabilityFileHandler;
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        availabilityFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors_availability.txt"));
        doctorFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<String> availability = availabilityFileHandler.readLines();
            List<String> doctors = doctorFileHandler.readLines();
            request.setAttribute("availability", availability);
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("/pages/doctorSchedule.jsp").forward(request, response);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error reading files", e);
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            List<String> availability = availabilityFileHandler.readLines();
            if (availability == null) availability = new ArrayList<>();

            if ("add".equals(action)) {
                handleAdd(request, availability);
            } else if ("remove".equals(action)) {
                handleRemove(request, availability);
            } else if ("edit".equals(action)) {
                handleEdit(request, availability);
            }

            availabilityFileHandler.writeLines(availability);
            response.sendRedirect(request.getContextPath() + "/DoctorScheduleServlet");
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error updating availability", e);
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    private void handleAdd(HttpServletRequest request, List<String> availability) {
        String slot = getSlot(request);
        if (!availability.contains(slot)) {
            availability.add(slot);
            logger.info("Added: " + slot);
        }
    }

    private void handleRemove(HttpServletRequest request, List<String> availability) {
        String slot = getSlot(request);
        availability.remove(slot);
        logger.info("Removed: " + slot);
    }

    private void handleEdit(HttpServletRequest request, List<String> availability) {
        String originalSlot = getOriginalSlot(request);
        String newSlot = getSlot(request);
        for (int i = 0; i < availability.size(); i++) {
            if (availability.get(i).equals(originalSlot)) {
                availability.set(i, newSlot);
                logger.info("Edited: " + originalSlot + " to " + newSlot);
                break;
            }
        }
    }

    private String getSlot(HttpServletRequest request) {
        String doctorId = request.getParameter("doctorId");
        String date = request.getParameter("date");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        return String.join(",", doctorId, date, startTime, endTime);
    }

    private String getOriginalSlot(HttpServletRequest request) {
        String originalDoctorId = request.getParameter("originalDoctorId");
        String originalDate = request.getParameter("originalDate");
        String originalStartTime = request.getParameter("originalStartTime");
        String originalEndTime = request.getParameter("originalEndTime");
        return String.join(",", originalDoctorId, originalDate, originalStartTime, originalEndTime);
    }
}