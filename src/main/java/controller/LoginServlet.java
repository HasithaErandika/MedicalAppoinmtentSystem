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

    private String getBasePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/data/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try {
            if (validateCredentials(username, password, role, request)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                switch (role) {
                    case "patient":
                        response.sendRedirect(request.getContextPath() + "/pages/userProfile.jsp");
                        break;
                    case "doctor":
                        response.sendRedirect(request.getContextPath() + "/pages/doctorDashboard.jsp");
                        break;
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/pages/adminDashboard.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid username, password, or role.");
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error accessing user data", e);
            request.setAttribute("error", "Error accessing user data: " + e.getMessage());
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }

    private boolean validateCredentials(String username, String password, String role, HttpServletRequest request) throws IOException {
        String filePath = getFilePath(role, request);
        if (filePath == null) return false;

        if (!Files.exists(Paths.get(filePath))) {
            throw new IOException("File not found: " + filePath);
        }

        List<String> lines = Files.readAllLines(Paths.get(filePath));
        for (String line : lines) {
            String[] parts = line.split(",");
            if (parts.length >= 2 && parts[0].equals(username) && parts[1].equals(password)) {
                return true;
            }
        }
        return false;
    }

    private String getFilePath(String role, HttpServletRequest request) {
        String basePath = getBasePath(request);
        switch (role) {
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
}