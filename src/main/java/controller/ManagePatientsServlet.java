package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ManagePatientsServlet extends HttpServlet {
    private FileHandler patientFileHandler;

    @Override
    public void init() throws ServletException {
        patientFileHandler = new FileHandler(getServletContext().getRealPath("/data/patients.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> patients = patientFileHandler.readLines();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/pages/managePatients.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<String> patients = patientFileHandler.readLines();
        if (patients == null) patients = new ArrayList<>();

        System.out.println("Action: " + action); // Debug

        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dob = request.getParameter("dob");
            boolean exists = patients.stream().anyMatch(line -> line.split(",")[0].equals(username));
            if (!exists) {
                String newPatient = String.join(",", username, password, name, email, phone, dob);
                patients.add(newPatient);
                System.out.println("Added: " + newPatient);
            }
        } else if ("remove".equals(action)) {
            String username = request.getParameter("username");
            if (username != null && !username.isEmpty()) {
                patients.removeIf(line -> line.split(",")[0].equals(username));
                System.out.println("Removed: " + username);
            }
        } else if ("edit".equals(action)) {
            String originalUsername = request.getParameter("originalUsername");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dob = request.getParameter("dob");
            if (originalUsername != null && !originalUsername.isEmpty()) {
                for (int i = 0; i < patients.size(); i++) {
                    String[] parts = patients.get(i).split(",");
                    if (parts[0].equals(originalUsername)) {
                        String updatedPatient = String.join(",", username, password, name, email, phone, dob);
                        patients.set(i, updatedPatient);
                        System.out.println("Updated: " + updatedPatient);
                        break;
                    }
                }
            }
        }

        patientFileHandler.writeLines(patients);
        System.out.println("Patients after update: " + patients);
        response.sendRedirect(request.getContextPath() + "/ManagePatientsServlet");
    }
}