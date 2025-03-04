<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login - Medical Appointment System</title>
    <link rel="stylesheet" href="../assets/styles.css">
</head>
<body>
<h2>Login</h2>
<form action="../LoginServlet" method="post">
    <label for="username">Username:</label>
    <input type="text" name="username" required><br>

    <label for="password">Password:</label>
    <input type="password" name="password" required><br>

    <label for="role">Login As:</label>
    <select name="role">
        <option value="patient">Patient</option>
        <option value="admin">Admin</option>
    </select><br>

    <input type="submit" value="Login">
</form>
</body>
</html>
