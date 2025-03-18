<%--&lt;%&ndash;--%>
<%--  Created by IntelliJ IDEA.--%>
<%--  User: hasit--%>
<%--  Date: 3/18/2025--%>
<%--  Time: 2:35 PM--%>
<%--  To change this template use File | Settings | File Templates.--%>
<%--&ndash;%&gt;--%>
<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--  <meta charset="UTF-8">--%>
<%--  <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--  <title>MediSchedule - Error</title>--%>
<%--  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">--%>
<%--  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">--%>
<%--  <style>--%>
<%--    :root {--%>
<%--      --primary-patient: #34C759;--%>
<%--      --primary-doctor: #2C6EBF;--%>
<%--      --primary-admin: #F59E0B;--%>
<%--      --bg-light: #F0F4F8;--%>
<%--      --text-primary: #1F2A44;--%>
<%--      --text-secondary: #64748B;--%>
<%--      --card-bg: #FFFFFF;--%>
<%--      --shadow: 0 8px 24px rgba(0, 0, 0, 0.1);--%>
<%--      --error: #EF4444;--%>
<%--      --border-radius: 12px;--%>
<%--    }--%>

<%--    * {--%>
<%--      margin: 0;--%>
<%--      padding: 0;--%>
<%--      box-sizing: border-box;--%>
<%--    }--%>

<%--    body {--%>
<%--      font-family: 'Inter', 'Segoe UI', Arial, sans-serif;--%>
<%--      background: linear-gradient(135deg, var(--bg-light) 0%, rgba(44, 110, 191, 0.05) 100%);--%>
<%--      color: var(--text-primary);--%>
<%--      min-height: 100vh;--%>
<%--      display: flex;--%>
<%--      justify-content: center;--%>
<%--      align-items: center;--%>
<%--      padding: 1.5rem;--%>
<%--    }--%>

<%--    .error-container {--%>
<%--      background: var(--card-bg);--%>
<%--      padding: 3rem 2.5rem;--%>
<%--      border-radius: var(--border-radius);--%>
<%--      box-shadow: var(--shadow);--%>
<%--      width: 100%;--%>
<%--      max-width: 480px;--%>
<%--      text-align: center;--%>
<%--      animation: fadeIn 0.5s ease;--%>
<%--    }--%>

<%--    .error-header {--%>
<%--      margin-bottom: 2rem;--%>
<%--    }--%>

<%--    .error-header .logo {--%>
<%--      font-size: 2rem;--%>
<%--      font-weight: 700;--%>
<%--      display: flex;--%>
<%--      justify-content: center;--%>
<%--      align-items: center;--%>
<%--      gap: 0.75rem;--%>
<%--      margin-bottom: 0.75rem;--%>
<%--      color: var(--error);--%>
<%--    }--%>

<%--    .error-header h1 {--%>
<%--      font-size: 1.75rem;--%>
<%--      font-weight: 600;--%>
<%--      color: var(--text-primary);--%>
<%--    }--%>

<%--    .error-message {--%>
<%--      color: var(--error);--%>
<%--      font-size: 1.1rem;--%>
<%--      background: rgba(239, 68, 68, 0.1);--%>
<%--      padding: 1rem;--%>
<%--      border-radius: 8px;--%>
<%--      margin-bottom: 2rem;--%>
<%--    }--%>

<%--    .back-btn {--%>
<%--      display: inline-flex;--%>
<%--      align-items: center;--%>
<%--      justify-content: center;--%>
<%--      padding: 1rem 2rem;--%>
<%--      border: none;--%>
<%--      border-radius: var(--border-radius);--%>
<%--      background: var(--text-secondary);--%>
<%--      color: #FFFFFF;--%>
<%--      font-size: 1rem;--%>
<%--      font-weight: 600;--%>
<%--      text-decoration: none;--%>
<%--      transition: all 0.3s ease;--%>
<%--    }--%>

<%--    .back-btn:hover {--%>
<%--      background: #475569;--%>
<%--      transform: translateY(-3px);--%>
<%--      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);--%>
<%--    }--%>

<%--    .back-btn i {--%>
<%--      margin-right: 0.5rem;--%>
<%--    }--%>

<%--    @keyframes fadeIn {--%>
<%--      from { opacity: 0; transform: translateY(20px); }--%>
<%--      to { opacity: 1; transform: translateY(0); }--%>
<%--    }--%>

<%--    @media (max-width: 480px) {--%>
<%--      .error-container {--%>
<%--        padding: 2rem;--%>
<%--        max-width: 100%;--%>
<%--      }--%>
<%--      .error-header .logo { font-size: 1.75rem; }--%>
<%--      .error-header h1 { font-size: 1.5rem; }--%>
<%--    }--%>
<%--  </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="error-container">--%>
<%--  <div class="error-header">--%>
<%--    <div class="logo">--%>
<%--      <i class="fas fa-exclamation-triangle"></i> MediSchedule--%>
<%--    </div>--%>
<%--    <h1>Error</h1>--%>
<%--  </div>--%>
<%--  <div class="error-message">--%>
<%--    <%--%>
<%--      String error = (String) request.getAttribute("error");--%>
<%--      if (error != null && !error.trim().isEmpty()) {--%>
<%--        Systeout.print(error);--%>
<%--      } else {--%>
<%--        out.print("An unexpected error occurred. Please try again.");--%>
<%--      }--%>
<%--    %>--%>
<%--  </div>--%>
<%--  <a href="<%=request.getContextPath()%>/pages/index.jsp" class="back-btn">--%>
<%--    <i class="fas fa-arrow-left"></i> Back to Home--%>
<%--  </a>--%>
<%--</div>--%>
<%--</body>--%>
<%--</html>--%>
