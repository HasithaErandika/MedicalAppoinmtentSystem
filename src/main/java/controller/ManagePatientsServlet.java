package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ManagePatientsServlet extends HttpServlet {
    private FileHandler patientFileHandler;

    @Override
    public void init() throws ServletException {
        patientFileHandler = new FileHandler(getServletContext().getRealPath("/data/patients.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> patients = patientFileHandler.readLines();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/pages/managePatients.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<String> patients = patientFileHandler.readLines();
        if (patients == null) patients = new ArrayList<>();

        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String age = request.getParameter("age");
            String phone = request.getParameter("phone");
            patients.add(username + "," + password + "," + name + "," + age + "," + phone);
        } else if ("remove".equals(action)) {
            String username = request.getParameter("username");
            patients.removeIf(line -> line.startsWith(username + ","));
        }

        patientFileHandler.writeLines(patients);
        response.sendRedirect(request.getContextPath() + "/ManagePatientsServlet");
    }
}