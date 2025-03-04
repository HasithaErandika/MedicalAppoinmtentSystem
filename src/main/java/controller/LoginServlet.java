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

public class LoginServlet extends HttpServlet {
    private String getBasePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/data/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        boolean isValid;
        try {
            isValid = validateCredentials(username, password, role, request);
        } catch (IOException e) {
            request.setAttribute("error", "Error accessing user data: " + e.getMessage());
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            switch (role) {
                case "patient":
                    response.sendRedirect(request.getContextPath() + "/pages/profile.jsp");
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
    }

    private boolean validateCredentials(String username, String password, String role, HttpServletRequest request) throws ServletException, IOException {
        String filePath;
        String basePath = getBasePath(request);
        switch (role) {
            case "patient": filePath = basePath + "patients.txt"; break;
            case "doctor": filePath = basePath + "doctors.txt"; break;
            case "admin": filePath = basePath + "admins.txt"; break;
            default: return false;
        }

        // Check if file exists before reading
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
}
