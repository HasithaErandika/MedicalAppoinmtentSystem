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

        if (session != null) {
            // Capture username and role before invalidation
            String username = (String) session.getAttribute("username");
            String role = (String) session.getAttribute("role");
            String safeUsername = (username != null) ? username : "unknown";
            String safeRole = (role != null) ? role : "unknown";

            logger.log(Level.INFO, "Logout initiated for user: {0}, role: {1}",
                    new Object[]{safeUsername, safeRole});

            try {
                // Invalidate the session
                session.invalidate();
                logger.log(Level.INFO, "Session successfully invalidated for user: {0}, role: {1}",
                        new Object[]{safeUsername, safeRole});
            } catch (IllegalStateException e) {
                logger.log(Level.WARNING, "Session already invalidated for user: {0}, role: {1}",
                        new Object[]{safeUsername, safeRole});
                // No need to rethrow; proceed to redirect
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Unexpected error during logout for user: {0}, role: {1}",
                        new Object[]{safeUsername, safeRole});
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Logout failed due to a server error.");
                return;
            }
        } else {
            logger.log(Level.INFO, "No active session found for logout request.");
        }

        // Always redirect to index.jsp after logout attempt
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle GET requests by delegating to doPost for consistency
        logger.log(Level.INFO, "GET request received for logout; delegating to POST handling.");
        doPost(request, response);
    }
}