<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Data Management</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/manageOperations.css">
</head>
<body>
<div class="container">
    <div class="header">
        <h1><i class="ri-database-2-line"></i> Data Management</h1>
        <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">
            <i class="ri-arrow-left-line"></i> Back to Dashboard
        </a>
    </div>

    <div class="card">
        <div class="action-buttons">
            <!-- Backup Button -->
            <form action="<%=request.getContextPath()%>/DataManagementServlet" method="post">
                <input type="hidden" name="action" value="backup">
                <button type="submit" class="btn btn-primary">
                    <i class="ri-download-cloud-2-line"></i> Create Backup
                </button>
            </form>

            <!-- Clear Logs Button -->
            <form action="<%=request.getContextPath()%>/DataManagementServlet" method="post">
                <input type="hidden" name="action" value="clearLogs">
                <button type="submit" class="btn btn-danger">
                    <i class="ri-delete-bin-line"></i> Clear Audit Logs
                </button>
            </form>
        </div>

        <!-- Audit Logs Table -->
        <div class="table-container">
            <h2><i class="ri-file-list-3-line"></i> Audit Logs</h2>
            <table>
                <thead>
                <tr>
                    <th>Log Entry</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="log" items="${auditLogs}">
                    <tr><td>${log}</td></tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Optional JavaScript Analysis (Currently not displayed visually) -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const logs = [
            <c:forEach var="log" items="${auditLogs}">
            "${log}",
            </c:forEach>
        ];

        const allowedUsers = ['admin', 'admin1', 'admin2', 'admin3'];

        // Count backups by user
        const backupSummary = logs.reduce((acc, log) => {
            if (log.toLowerCase().includes('backup')) {
                const match = log.match(/User (\w+)/);
                const user = match ? match[1] : 'Unknown';
                if (allowedUsers.includes(user)) {
                    acc[user] = (acc[user] || 0) + 1;
                }
            }
            return acc;
        }, {});

        // Ensure all allowed users are included
        allowedUsers.forEach(user => {
            if (!backupSummary[user]) {
                backupSummary[user] = 0;
            }
        });

        // Optional: use backupSummary to render charts or stats
    });
</script>
</body>
</html>
