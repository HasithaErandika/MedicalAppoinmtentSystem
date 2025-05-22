package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import service.AuditService;
import service.BackupService;
import service.FileHandler;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DataManagementServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(DataManagementServlet.class.getName());

    private AuditService auditService;
    private BackupService backupService;

    @Override
    public void init() throws ServletException {
        String dataDirectory = getServletContext().getRealPath("/data/");
        FileHandler auditFileHandler = new FileHandler(dataDirectory + "audit.txt");

        auditService = new AuditService(auditFileHandler);
        backupService = new BackupService(dataDirectory, auditService);

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadAuditLogs(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "backup":
                    createBackup(request);
                    break;
                case "clearLogs":
                    clearAuditLogs();
                    break;
                default:
                    logger.warning("Invalid action: " + action);
                    break;
            }

            response.sendRedirect(request.getContextPath() + "/DataManagementServlet");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error handling action: " + action, e);
            forwardToErrorPage(request, response, e.getMessage());
        }
    }

    // --- Helper Methods ---

    private void loadAuditLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<String> auditLogs = auditService.readAuditLogs();
            request.setAttribute("auditLogs", auditLogs);
            request.getRequestDispatcher("/pages/dataManagement.jsp").forward(request, response);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error reading audit logs", e);
            forwardToErrorPage(request, response, e.getMessage());
        }
    }

    private void createBackup(HttpServletRequest request) throws IOException {
        String username = (String) request.getSession().getAttribute("username");
        backupService.createBackup(username);
    }

    private void clearAuditLogs() throws IOException {
        auditService.clearAuditLogs();
    }

    private void forwardToErrorPage(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("message", "Error: " + errorMessage);
        request.setAttribute("messageType", "error");
        request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
    }
}
