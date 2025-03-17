package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LoginServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());

    // Get the base path for data files
    private String getBasePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/WEB-INF/data/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Basic input validation
        if (username == null || password == null || role == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || role.trim().isEmpty()) {
            request.setAttribute("error", "All fields (username, password, role) are required.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        try {
            // Validate credentials based on role
            if (validateCredentials(username, password, role, request)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username.trim());
                session.setAttribute("role", role.trim());

                // Redirect based on role
                switch (role.trim().toLowerCase()) {
                    case "patient":
                        response.sendRedirect(request.getContextPath() + "/UserServlet"); // Assuming UserServlet serves userProfile.jsp
                        break;
                    case "doctor":
                        response.sendRedirect(request.getContextPath() + "/pages/doctorDashboard.jsp");
                        break;
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/AdminServlet"); // Assuming AdminServlet serves adminDashboard.jsp
                        break;
                    default:
                        request.setAttribute("error", "Invalid role specified.");
                        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid username or password for the selected role.");
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error accessing user data file", e);
            request.setAttribute("error", "System error: Unable to access user data. Please try again later.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }

    // Validate credentials by checking the appropriate file
    private boolean validateCredentials(String username, String password, String role, HttpServletRequest request) throws IOException {
        String filePath = getFilePath(role, request);
        if (filePath == null) {
            logger.log(Level.WARNING, "Invalid role provided: " + role);
            return false;
        }

        // Check if file exists
        if (!Files.exists(Paths.get(filePath))) {
            logger.log(Level.WARNING, "User data file not found: " + filePath);
            return false; // Return false instead of throwing exception to allow graceful failure
        }

        // Read file lines and validate credentials
        List<String> lines = Files.readAllLines(Paths.get(filePath));
        for (String line : lines) {
            if (line.trim().isEmpty()) continue; // Skip empty lines
            String[] parts = line.split(",", -1); // -1 to include trailing empty fields
            if (parts.length < 2) {
                logger.log(Level.WARNING, "Malformed line in file " + filePath + ": " + line);
                continue;
            }

            // For patients.txt: id,name,age,contact,password,dob
            // For doctors.txt: id,name,specialization,contact,password
            // For audit.txt (admins): admin,admin123 (assuming username,password format)
            int usernameIndex = 0;
            int passwordIndex = (role.equals("admin")) ? 1 : 4; // Adjust based on file format

            if (parts.length > passwordIndex &&
                    parts[usernameIndex].trim().equals(username.trim()) &&
                    parts[passwordIndex].trim().equals(password.trim())) {
                logger.log(Level.INFO, "Successful login for user: " + username + ", role: " + role);
                return true;
            }
        }
        logger.log(Level.INFO, "Failed login attempt for user: " + username + ", role: " + role);
        return false;
    }

    // Determine file path based on role
    private String getFilePath(String role, HttpServletRequest request) {
        String basePath = getBasePath(request);
        switch (role.trim().toLowerCase()) {
            case "patient":
                return basePath + "patients.txt";
            case "doctor":
                return basePath + "doctors.txt";
            case "admin":
                return basePath + "audit.txt"; // Assuming admin credentials are in audit.txt as per project structure
            default:
                return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to login.jsp to prevent direct access
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
}