<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register - Medical Appointment System</title>
    <link rel="stylesheet" href="../assets/styles.css">
</head>
<body>
<h2>Register as Patient</h2>
<form action="../RegisterServlet" method="post">
    <label>Name:</label>
    <input type="text" name="name" required><br>

    <label>Age:</label>
    <input type="number" name="age" required><br>

    <label>Contact:</label>
    <input type="text" name="contact" required><br>

    <label>Username:</label>
    <input type="text" name="username" required><br>

    <label>Password:</label>
    <input type="password" name="password" required><br>

    <input type="submit" value="Register">
</form>
</body>
</html>
