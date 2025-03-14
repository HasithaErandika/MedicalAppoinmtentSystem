package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

public class RegisterServlet extends HttpServlet {
    private FileHandler patientFileHandler;

    @Override
    public void init() throws ServletException {
        patientFileHandler = new FileHandler(getServletContext().getRealPath("/data/patients.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");

        List<String> patients = patientFileHandler.readLines();
        if (patients == null) patients = new ArrayList<>();

        // Check for duplicate username
        boolean usernameExists = patients.stream().anyMatch(line -> line.split(",")[0].equals(username));
        if (usernameExists) {
            setErrorMessage(request, response, "Username already exists. Please choose a different one.");
            return;
        }

        // Basic validation (could be expanded)
        if (isAnyFieldEmpty(username, password, name, email, phone, dob)) {
            setErrorMessage(request, response, "All fields are required.");
            return;
        }

        // Save new patient
        String newPatient = String.join(",", username, password, name, email, phone, dob);
        patients.add(newPatient);
        patientFileHandler.writeLines(patients);

        // Redirect to login page with success message
        request.getSession().setAttribute("message", "Registration successful! Please log in.");
        request.getSession().setAttribute("messageType", "success");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    private boolean isAnyFieldEmpty(String... fields) {
        for (String field : fields) {
            if (field.isEmpty()) {
                return true;
            }
        }
        return false;
    }

    private void setErrorMessage(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("message", message);
        request.setAttribute("messageType", "error");
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }
}