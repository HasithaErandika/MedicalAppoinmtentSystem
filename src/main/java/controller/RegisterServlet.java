package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class RegisterServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private FileHandler patientFileHandler;


    @Override
    public void init() throws ServletException {
        patientFileHandler = new FileHandler(getServletContext().getRealPath("/data/patients.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = sanitizeInput(request.getParameter("username"));
            String password = sanitizeInput(request.getParameter("password"));
            String name = sanitizeInput(request.getParameter("name"));
            String email = sanitizeInput(request.getParameter("email"));
            String phone = sanitizeInput(request.getParameter("phone"));
            String dob = sanitizeInput(request.getParameter("dob"));

            // Check for empty fields
            if (isAnyFieldEmpty(username, password, name, email, phone, dob)) {
                setErrorMessage(request, response, "All fields are required.");
                return;
            }

            // Server-side validation
            if (!isValidUsername(username)) {
                setErrorMessage(request, response, "Username must be 3-20 characters (letters, numbers, underscores).");
                return;
            }
            if (password.length() < 6) {
                setErrorMessage(request, response, "Password must be at least 6 characters.");
                return;
            }
            if (!isValidEmail(email)) {
                setErrorMessage(request, response, "Invalid email format.");
                return;
            }
            if (!isValidPhone(phone)) {
                setErrorMessage(request, response, "Phone number must be exactly 10 digits.");
                return;
            }
            if (!isValidDate(dob)) {
                setErrorMessage(request, response, "Invalid date of birth.");
                return;
            }

            List<String> patients = patientFileHandler.readLines();
            if (patients == null) patients = new ArrayList<>();

            // Check for duplicate username
            if (patients.stream().anyMatch(line -> line.split(",")[0].equals(username))) {
                setErrorMessage(request, response, "Username already exists.");
                return;
            }

            // Save new patient
            String newPatient = String.join(",", username, password, name, email, phone, dob);
            patients.add(newPatient);
            patientFileHandler.writeLines(patients);

            // Success
            request.getSession().setAttribute("message", "Registration successful! Please log in.");
            request.getSession().setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        } catch (Exception e) {
            LOGGER.severe("Registration error: " + e.getMessage());
            setErrorMessage(request, response, "An error occurred during registration. Please try again.");
        }
    }

    private String sanitizeInput(String input) {
        return input == null ? "" : input.trim().replaceAll("[<>\"']", "");
    }

    private boolean isAnyFieldEmpty(String... fields) {
        for (String field : fields) {
            if (field.isEmpty()) return true;
        }
        return false;
    }

    private boolean isValidUsername(String username) {
        return username.matches("^[a-zA-Z0-9_]{3,20}$");
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    private boolean isValidPhone(String phone) {
        return phone.matches("^\\d{10}$");
    }

    private boolean isValidDate(String dob) {
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            java.util.Date date = sdf.parse(dob);
            return date.before(new java.util.Date());
        } catch (java.text.ParseException e) {
            return false;
        }
    }

    private void setErrorMessage(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("message", message);
        request.setAttribute("messageType", "error");
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }
}