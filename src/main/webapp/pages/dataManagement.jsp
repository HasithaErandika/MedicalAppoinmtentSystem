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
        <div style="display: flex; gap: 1rem; margin-bottom: 2rem;">
            <form action="<%=request.getContextPath()%>/DataManagementServlet" method="post">
                <input type="hidden" name="action" value="backup">
                <button type="submit" class="btn btn-primary">
                    <i class="ri-download-cloud-2-line"></i> Create Backup
                </button>
            </form>
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
                    <tr>
                        <td>${log}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function() {
        const logs = [
            <c:forEach var="log" items="${auditLogs}">
            "${log}",
            </c:forEach>
        ];

        // Define the users to filter by
        const allowedUsers = ['admin', 'admin1', 'admin2', 'admin3']; // Add more usernames as needed

        // Count backups by user, filtered by allowedUsers
        const backupSummary = logs.reduce((acc, log) => {
            if (log.toLowerCase().includes('backup')) {
                const userMatch = log.match(/User (\w+)/);
                const username = userMatch ? userMatch[1] : 'Unknown';
                if (allowedUsers.includes(username)) {
                    acc[username] = (acc[username] || 0) + 1;
                }
            }
            return acc;
        }, {});

        // Ensure all allowed users are in the summary, even with 0 backups
        allowedUsers.forEach(user => {
            if (!backupSummary[user]) {
                backupSummary[user] = 0;
            }
        });

    });
</script>
</body>
</html>