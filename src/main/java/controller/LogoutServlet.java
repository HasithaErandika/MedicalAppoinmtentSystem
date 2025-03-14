package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LogoutServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Get existing session, don't create new
        String username = "unknown";
        String role = "unknown";

        if (session != null) {
            try {
                // Retrieve attributes immediately and store them
                username = (String) session.getAttribute("username");
                role = (String) session.getAttribute("role");

                // Log the logout attempt with retrieved values
                logger.log(Level.INFO, "Logout attempt for user: {0}, role: {1}",
                        new Object[]{username != null ? username : "unknown", role != null ? role : "unknown"});

                // Invalidate the session
                session.invalidate();
                logger.log(Level.INFO, "Session successfully invalidated for user: {0}, role: {1}",
                        new Object[]{username != null ? username : "unknown", role != null ? role : "unknown"});
            } catch (IllegalStateException e) {
                // Handle case where session was already invalidated
                logger.log(Level.WARNING, "Session was already invalidated for user: {0}, role: {1}. Error: {2}",
                        new Object[]{username, role, e.getMessage()});
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Unexpected error during logout: {0}", e.getMessage());
                throw new ServletException("Logout failed due to an unexpected error.", e);
            }
        } else {
            logger.log(Level.INFO, "No active session found for logout.");
        }

        // Redirect to index.jsp regardless of session state
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response); // Delegate GET to POST for consistency
    }
}