package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ManageDoctorsServlet extends HttpServlet {
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        doctorFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> doctors = doctorFileHandler.readLines();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/pages/manageDoctors.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<String> doctors = doctorFileHandler.readLines();
        if (doctors == null) doctors = new ArrayList<>();

        System.out.println("Action: " + action); // Debug: Check which action is triggered

        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            boolean exists = doctors.stream().anyMatch(line -> line.split(",")[0].equals(username));
            if (!exists) {
                String newDoctor = String.join(",", username, password, name, specialization, email, phone);
                doctors.add(newDoctor);
                System.out.println("Added: " + newDoctor); // Debug: Confirm addition
            }
        } else if ("remove".equals(action)) {
            String username = request.getParameter("username");
            if (username != null && !username.isEmpty()) {
                doctors.removeIf(line -> line.split(",")[0].equals(username));
                System.out.println("Removed: " + username); // Debug: Confirm removal
            }
        } else if ("edit".equals(action)) {
            String originalUsername = request.getParameter("originalUsername");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            System.out.println("Editing - Original Username: " + originalUsername); // Debug
            System.out.println("New Data: " + username + "," + password + "," + name + "," + specialization + "," + email + "," + phone);

            if (originalUsername != null && !originalUsername.isEmpty()) {
                for (int i = 0; i < doctors.size(); i++) {
                    String[] parts = doctors.get(i).split(",");
                    if (parts[0].equals(originalUsername)) {
                        String updatedDoctor = String.join(",", username, password, name, specialization, email, phone);
                        doctors.set(i, updatedDoctor);
                        System.out.println("Updated: " + updatedDoctor); // Debug: Confirm update
                        break;
                    }
                }
            }
        }

        doctorFileHandler.writeLines(doctors);
        System.out.println("Doctors after update: " + doctors); // Debug: Check final list
        response.sendRedirect(request.getContextPath() + "/ManageDoctorsServlet");
    }
}