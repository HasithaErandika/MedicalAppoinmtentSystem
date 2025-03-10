package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class DataManagementServlet extends HttpServlet {
    private FileHandler auditFileHandler;

    @Override
    public void init() throws ServletException {
        auditFileHandler = new FileHandler(getServletContext().getRealPath("/data/audit.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> auditLogs = auditFileHandler.readLines();
        request.setAttribute("auditLogs", auditLogs);
        request.getRequestDispatcher("/pages/dataManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String basePath = getServletContext().getRealPath("/data/");
        List<String> auditLogs = auditFileHandler.readLines();
        if (auditLogs == null) auditLogs = new ArrayList<>();

        if ("backup".equals(action)) {
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
            File backupDir = new File(basePath + "backup_" + timestamp);
            backupDir.mkdir();
            Files.copy(new File(basePath + "appointments.txt").toPath(), new File(backupDir, "appointments.txt").toPath());
            Files.copy(new File(basePath + "doctors.txt").toPath(), new File(backupDir, "doctors.txt").toPath());
            Files.copy(new File(basePath + "patients.txt").toPath(), new File(backupDir, "patients.txt").toPath());
            auditLogs.add("Backup created at " + timestamp + " by " + request.getSession().getAttribute("username"));
            auditFileHandler.writeLines(auditLogs);
        } else if ("clearLogs".equals(action)) {
            auditLogs.clear();
            auditFileHandler.writeLines(auditLogs);
        }

        response.sendRedirect(request.getContextPath() + "/DataManagementServlet");
    }
}