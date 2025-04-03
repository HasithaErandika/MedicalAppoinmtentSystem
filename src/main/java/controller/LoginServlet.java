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
    private static final String DATA_DIR = "/data/";

    private String getBasePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath(DATA_DIR);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || password == null || role == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || role.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        try {
            if (validateCredentials(username.trim(), password.trim(), role.trim(), request)) {
                HttpSession session = request.getSession(true); // Create new session
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout

                // Redirect based on role
                String redirectUrl = getRedirectUrl(role);
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                request.setAttribute("error", "Invalid username or password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error accessing user data file", e);
            request.setAttribute("error", "Unable to process login. Please try again later.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private boolean validateCredentials(String username, String password, String role, HttpServletRequest request) throws IOException {
        String filePath = getFilePath(role, request);
        if (filePath == null) {
            logger.log(Level.WARNING, "Invalid role provided: {0}", role);
            return false;
        }

        if (!Files.exists(Paths.get(filePath))) {
            logger.log(Level.SEVERE, "User data file not found: {0}", filePath);
            throw new IOException("User data file is missing.");
        }

        List<String> lines = Files.readAllLines(Paths.get(filePath));
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length >= 2 && parts[0].trim().equals(username) && parts[1].trim().equals(password)) {
                logger.log(Level.INFO, "Successful login for user: {0}, role: {1}", new Object[]{username, role});
                return true;
            }
        }
        logger.log(Level.INFO, "Failed login attempt for user: {0}, role: {1}", new Object[]{username, role});
        return false;
    }

    private String getFilePath(String role, HttpServletRequest request) {
        String basePath = getBasePath(request);
        switch (role.toLowerCase()) {
            case "patient":
                return basePath + "patients.txt";
            case "doctor":
                return basePath + "doctors.txt";
            case "admin":
                return basePath + "admins.txt";
            default:
                return null;
        }
    }

    private String getRedirectUrl(String role) {
        switch (role.toLowerCase()) {
            case "patient":
                return "/pages/userProfile/userProfile.jsp";
            case "doctor":
                return "/pages/doctorProfile/doctorDashboard.jsp";
            case "admin":
                return "/pages/adminDashboard.jsp";
            default:
                return "/index.jsp"; // Fallback
        }
    }
}