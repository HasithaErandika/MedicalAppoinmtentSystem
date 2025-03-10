package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.FileHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ManageDoctorsServlet extends HttpServlet {
    private FileHandler doctorFileHandler;

    @Override
    public void init() throws ServletException {
        doctorFileHandler = new FileHandler(getServletContext().getRealPath("/data/doctors.txt"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> doctors = doctorFileHandler.readLines();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/pages/manageDoctors.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<String> doctors = doctorFileHandler.readLines();
        if (doctors == null) doctors = new ArrayList<>();

        if ("add".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String specialization = request.getParameter("specialization");
            doctors.add(username + "," + password + "," + name + "," + specialization);
        } else if ("remove".equals(action)) {
            String username = request.getParameter("username");
            doctors.removeIf(line -> line.startsWith(username + ","));
        }

        doctorFileHandler.writeLines(doctors);
        response.sendRedirect(request.getContextPath() + "/ManageDoctorsServlet");
    }
}