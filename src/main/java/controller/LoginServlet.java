package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private String getBasePath(HttpServletRequest request) {
        return request.getServletContext().getRealPath("/data/");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        boolean isValid = validateCredentials(username, password, role, request);

        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            switch (role) {
                case "patient":
                    response.sendRedirect(request.getContextPath() + "/pages/userPuserProfile.jsp");
                    break;
                case "doctor":
                    response.sendRedirect(request.getContextPath() + "/pages/doctorDashboard.jsp");
                    break;
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/pages/adminDadminDashboard.jsp");
                    break;
            }
        } else {
            request.setAttribute("error", "Invalid username, password, or role.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }

    private boolean validateCredentials(String username, String password, String role, HttpServletRequest request) throws IOException {
        String filePath;
        String basePath = getBasePath(request);
        switch (role) {
            case "patient": filePath = basePath + "patients.txt"; break;
            case "doctor": filePath = basePath + "doctors.txt"; break;
            case "admin": filePath = basePath + "admins.txt"; break;
            default: return false;
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