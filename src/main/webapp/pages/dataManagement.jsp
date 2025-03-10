<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediSchedule - Data Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #ed8936; --secondary: #2c5282; --accent: #48bb78;
            --bg-light: #f4f7fa; --text-light: #2d3748; --text-dark: #ffffff;
            --card-bg: #ffffff; --shadow: 0 4px 15px rgba(0,0,0,0.1);
            --hover: #f1f5f9;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: var(--bg-light); padding: 2rem; }
        .container { max-width: 1000px; margin: 0 auto; background: var(--card-bg); padding: 2rem; border-radius: 12px; box-shadow: var(--shadow); }
        h1 { color: var(--primary); font-size: 1.8rem; margin-bottom: 1.5rem; }
        .actions { margin-bottom: 2rem; display: flex; gap: 1rem; }
        button { padding: 0.75rem 1.5rem; background: var(--primary); color: var(--text-dark); border: none; border-radius: 8px; cursor: pointer; transition: all 0.3s ease; }
        button:hover { background: #dd6b20; transform: scale(1.05); }
        .clear-btn { background: #e53e3e; }
        .clear-btn:hover { background: #c53030; }
        .table-section { background: var(--card-bg); padding: 1.5rem; border-radius: 12px; box-shadow: var(--shadow); }
        h2 { color: var(--text-light); font-size: 1.4rem; margin-bottom: 1rem; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e5e7eb; }
        th { background: var(--primary); color: var(--text-dark); font-weight: 600; }
        tr:hover { background: var(--hover); }
        .back-btn { display: inline-block; margin-top: 1rem; color: var(--primary); text-decoration: none; }
        .back-btn:hover { text-decoration: underline; }
        @media (max-width: 768px) { .container { padding: 1rem; } .actions { flex-direction: column; } }
    </style>
</head>
<body>
<div class="container">
    <h1>Data Management</h1>

    <div class="actions">
        <form action="<%=request.getContextPath()%>/DataManagementServlet" method="post">
            <input type="hidden" name="action" value="backup">
            <button type="submit">Create Backup</button>
        </form>
        <form action="<%=request.getContextPath()%>/DataManagementServlet" method="post">
            <input type="hidden" name="action" value="clearLogs">
            <button type="submit" class="clear-btn">Clear Audit Logs</button>
        </form>
    </div>

    <div class="table-section">
        <h2>Audit Logs</h2>
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
    <a href="<%=request.getContextPath()%>/AdminServlet" class="back-btn">Back to Dashboard</a>
</div>
</body>
</html>