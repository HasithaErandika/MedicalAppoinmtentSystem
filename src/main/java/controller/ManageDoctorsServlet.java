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
        if (doctors == null) doctors = new ArrayList<>();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/pages/manageDoctors.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            List<String> doctors = doctorFileHandler.readLines();
            if (doctors == null) doctors = new ArrayList<>();

            switch (action) {
                case "add":
                    handleAdd(request, doctors);
                    break;
                case "remove":
                    handleRemove(request, doctors);
                    break;
                case "edit":
                    handleEdit(request, doctors);
                    break;
                default:
                    throw new IllegalArgumentException("Invalid action: " + action);
            }


            doctorFileHandler.writeLines(doctors);
            response.sendRedirect(request.getContextPath() + "/ManageDoctorsServlet");
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    private void handleAdd(HttpServletRequest request, List<String> doctors) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (username == null || username.trim().isEmpty() || password == null || name == null ||
                specialization == null || email == null || phone == null) {
            throw new IllegalArgumentException("All fields are required for adding a doctor.");
        }

        boolean exists = doctors.stream().anyMatch(line -> line.split(",")[0].equals(username));
        if (!exists) {
            String newDoctor = String.join(",", username.trim(), password.trim(), name.trim(),
                    specialization.trim(), email.trim(), phone.trim());
            doctors.add(newDoctor);
        } else {
            throw new IllegalArgumentException("Username '" + username + "' already exists.");
        }
    }

    private void handleRemove(HttpServletRequest request, List<String> doctors) {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required for removal.");
        }
        boolean removed = doctors.removeIf(line -> line.split(",")[0].equals(username.trim()));
        if (!removed) {
            throw new IllegalArgumentException("Doctor with username '" + username + "' not found.");
        }
    }

    private void handleEdit(HttpServletRequest request, List<String> doctors) {
        String originalUsername = request.getParameter("originalUsername");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String specialization = request.getParameter("specialization");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (originalUsername == null || originalUsername.trim().isEmpty() || username == null ||
                password == null || name == null || specialization == null || email == null || phone == null) {
            throw new IllegalArgumentException("All fields are required for editing a doctor.");
        }

        boolean found = false;
        for (int i = 0; i < doctors.size(); i++) {
            String[] parts = doctors.get(i).split(",");
            if (parts[0].equals(originalUsername.trim())) {
                String updatedDoctor = String.join(",", username.trim(), password.trim(), name.trim(),
                        specialization.trim(), email.trim(), phone.trim());
                doctors.set(i, updatedDoctor);
                found = true;
                break;
            }
        }
        if (!found) {
            throw new IllegalArgumentException("Doctor with username '" + originalUsername + "' not found.");
        }
    }
}