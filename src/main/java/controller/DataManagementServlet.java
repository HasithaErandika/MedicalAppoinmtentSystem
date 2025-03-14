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
        String basePath = getServletContext().getRealPath("/data/");
        FileHandler auditFileHandler = new FileHandler(basePath + "audit.txt");
        auditService = new AuditService(auditFileHandler);
        backupService = new BackupService(basePath, auditService);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<String> auditLogs = auditService.readAuditLogs();
            request.setAttribute("auditLogs", auditLogs);
            request.getRequestDispatcher("/pages/dataManagement.jsp").forward(request, response);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Error reading audit logs", e);
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("backup".equals(action)) {
                handleBackup(request);
            } else if ("clearLogs".equals(action)) {
                handleClearLogs();
            }
            response.sendRedirect(request.getContextPath() + "/DataManagementServlet");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing action", e);
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    private void handleBackup(HttpServletRequest request) throws IOException {
        String username = (String) request.getSession().getAttribute("username");
        backupService.createBackup(username);
    }

    private void handleClearLogs() throws IOException {
        auditService.clearAuditLogs();
    }
}