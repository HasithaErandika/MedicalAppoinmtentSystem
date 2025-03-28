
<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>MediSchedule - Error</title>--%>
<%--    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">--%>
<%--    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">--%>
<%--    <style>--%>
<%--        :root {--%>
<%--            --primary-patient: #34C759;--%>
<%--            --primary-doctor: #2C6EBF;--%>
<%--            --primary-admin: #F59E0B;--%>
<%--            --bg-light: #F0F4F8;--%>
<%--            --text-primary: #1F2A44;--%>
<%--            --text-secondary: #64748B;--%>
<%--            --card-bg: #FFFFFF;--%>
<%--            --shadow: 0 8px 24px rgba(0, 0, 0, 0.1);--%>
<%--            --error: #EF4444;--%>
<%--            --border-radius: 12px;--%>
<%--            --accent: #D1D5DB;--%>
<%--        }--%>

<%--        * {--%>
<%--            margin: 0;--%>
<%--            padding: 0;--%>
<%--            box-sizing: border-box;--%>
<%--        }--%>

<%--        body {--%>
<%--            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;--%>
<%--            background: linear-gradient(135deg, var(--bg-light) 0%, rgba(44, 110, 191, 0.1) 100%);--%>
<%--            color: var(--text-primary);--%>
<%--            min-height: 100vh;--%>
<%--            display: flex;--%>
<%--            justify-content: center;--%>
<%--            align-items: center;--%>
<%--            padding: 1.5rem;--%>
<%--            overflow: hidden;--%>
<%--        }--%>

<%--        .error-container {--%>
<%--            background: var(--card-bg);--%>
<%--            padding: 3rem;--%>
<%--            border-radius: var(--border-radius);--%>
<%--            box-shadow: var(--shadow);--%>
<%--            width: 100%;--%>
<%--            max-width: 520px;--%>
<%--            text-align: center;--%>
<%--            position: relative;--%>
<%--            animation: slideIn 0.6s ease-out;--%>
<%--        }--%>

<%--        .error-header {--%>
<%--            margin-bottom: 2.5rem;--%>
<%--        }--%>

<%--        .error-header .logo {--%>
<%--            font-size: 2.25rem;--%>
<%--            font-weight: 700;--%>
<%--            display: flex;--%>
<%--            justify-content: center;--%>
<%--            align-items: center;--%>
<%--            gap: 0.75rem;--%>
<%--            color: var(--error);--%>
<%--            transition: transform 0.3s ease;--%>
<%--        }--%>

<%--        .error-header .logo:hover {--%>
<%--            transform: scale(1.05);--%>
<%--        }--%>

<%--        .error-header h1 {--%>
<%--            font-size: 1.875rem;--%>
<%--            font-weight: 600;--%>
<%--            margin-top: 0.5rem;--%>
<%--        }--%>

<%--        .error-icon {--%>
<%--            position: relative;--%>
<%--            display: inline-block;--%>
<%--            margin-bottom: 1rem;--%>
<%--        }--%>

<%--        .error-icon .circle {--%>
<%--            width: 60px;--%>
<%--            height: 60px;--%>
<%--            stroke: var(--error);--%>
<%--            stroke-width: 4;--%>
<%--            fill: none;--%>
<%--            stroke-linecap: round;--%>
<%--            animation: progress 2s ease-out infinite;--%>
<%--        }--%>

<%--        .error-message {--%>
<%--            color: var(--error);--%>
<%--            font-size: 1.125rem;--%>
<%--            background: rgba(239, 68, 68, 0.1);--%>
<%--            padding: 1.25rem;--%>
<%--            border-radius: 8px;--%>
<%--            margin-bottom: 2rem;--%>
<%--            line-height: 1.5;--%>
<%--            word-wrap: break-word;--%>
<%--        }--%>

<%--        .error-details {--%>
<%--            font-size: 0.875rem;--%>
<%--            color: var(--text-secondary);--%>
<%--            margin-top: 1rem;--%>
<%--            display: none; /* Hidden by default, toggle with JS if needed */--%>
<%--        }--%>

<%--        .back-btn {--%>
<%--            display: inline-flex;--%>
<%--            align-items: center;--%>
<%--            justify-content: center;--%>
<%--            padding: 1rem 2.5rem;--%>
<%--            border: none;--%>
<%--            border-radius: var(--border-radius);--%>
<%--            background: var(--primary-doctor);--%>
<%--            color: #FFFFFF;--%>
<%--            font-size: 1rem;--%>
<%--            font-weight: 600;--%>
<%--            text-decoration: none;--%>
<%--            transition: all 0.3s ease;--%>
<%--            position: relative;--%>
<%--            overflow: hidden;--%>
<%--        }--%>

<%--        .back-btn::before {--%>
<%--            content: '';--%>
<%--            position: absolute;--%>
<%--            top: 50%;--%>
<%--            left: 50%;--%>
<%--            width: 0;--%>
<%--            height: 0;--%>
<%--            background: rgba(255, 255, 255, 0.2);--%>
<%--            border-radius: 50%;--%>
<%--            transform: translate(-50%, -50%);--%>
<%--            transition: width 0.6s ease, height 0.6s ease;--%>
<%--        }--%>

<%--        .back-btn:hover::before {--%>
<%--            width: 300px;--%>
<%--            height: 300px;--%>
<%--        }--%>

<%--        .back-btn:hover {--%>
<%--            transform: translateY(-3px);--%>
<%--            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);--%>
<%--        }--%>

<%--        .back-btn i {--%>
<%--            margin-right: 0.5rem;--%>
<%--        }--%>

<%--        .footer-note {--%>
<%--            font-size: 0.875rem;--%>
<%--            color: var(--text-secondary);--%>
<%--            margin-top: 2rem;--%>
<%--        }--%>

<%--        @keyframes slideIn {--%>
<%--            from { opacity: 0; transform: translateY(30px); }--%>
<%--            to { opacity: 1; transform: translateY(0); }--%>
<%--        }--%>

<%--        @keyframes progress {--%>
<%--            0% { stroke-dasharray: 0 100; }--%>
<%--            50% { stroke-dasharray: 50 100; }--%>
<%--            100% { stroke-dasharray: 0 100; }--%>
<%--        }--%>

<%--        @media (max-width: 480px) {--%>
<%--            .error-container {--%>
<%--                padding: 2rem;--%>
<%--                max-width: 100%;--%>
<%--            }--%>
<%--            .error-header .logo { font-size: 1.875rem; }--%>
<%--            .error-header h1 { font-size: 1.5rem; }--%>
<%--            .error-icon .circle { width: 50px; height: 50px; }--%>
<%--            .back-btn { padding: 0.875rem 2rem; }--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="error-container">--%>
<%--    <div class="error-header">--%>
<%--        <div class="error-icon">--%>
<%--            <svg class="circle" viewBox="0 0 36 36">--%>
<%--                <path d="M18 2 a 16 16 0 0 1 0 32 a 16 16 0 0 1 0 -32"></path>--%>
<%--            </svg>--%>
<%--        </div>--%>
<%--        <div class="logo">--%>
<%--            <i class="fas fa-exclamation-triangle"></i> MediSchedule--%>
<%--        </div>--%>
<%--        <h1>Oops! Something Went Wrong</h1>--%>
<%--    </div>--%>
<%--    <div class="error-message">--%>
<%--        <%--%>
<%--            String error = (String) request.getAttribute("error");--%>
<%--            if (error != null && !error.trim().isEmpty()) {--%>
<%--                System.out.print(error); // Display to user--%>
<%--                System.out.println("Error logged: " + error); // Log to server console--%>
<%--            } else {--%>
<%--                System.out.print("An unexpected error occurred. Please try again.");--%>
<%--            }--%>
<%--        %>--%>
<%--        <div class="error-details">--%>
<%--            <!-- Additional details could be injected here via JavaScript or server-side logic -->--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <a href="<%=request.getContextPath()%>/pages/index.jsp" class="back-btn">--%>
<%--        <i class="fas fa-arrow-left"></i> Return to Home--%>
<%--    </a>--%>
<%--    <div class="footer-note">--%>
<%--        Need help? Contact support at <a href="mailto:support@medischedule.com">support@medischedule.com</a>--%>
<%--    </div>--%>
<%--</div>--%>
<%--</body>--%>
<%--</html>--%>