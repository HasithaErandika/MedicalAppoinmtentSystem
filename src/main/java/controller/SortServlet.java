package controller;

import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.google.gson.Gson;

public class SortServlet extends HttpServlet {

    static class Doctor implements Comparable<Doctor> {
        String username;
        String name;
        String specialty;
        String date;
        String startTime;
        String endTime;

        Doctor(String username, String name, String specialty, String date, String startTime, String endTime) {
            this.username = username;
            this.name = name;
            this.specialty = specialty;
            this.date = date;
            this.startTime = startTime;
            this.endTime = endTime;
        }

        @Override
        public int compareTo(Doctor other) {
            return this.name.compareTo(other.name);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String specialty = request.getParameter("specialty");
        String doctorName = request.getParameter("doctor");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        // Load data
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(request);
        List<Doctor> allDoctors = loadDoctors(request);

        // Prepare response
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("specialties", new ArrayList<>(specialtyDoctors.keySet()));

        if (specialty == null || specialty.isEmpty()) {
            responseData.put("doctors", new ArrayList<>());
            responseData.put("availability", new ArrayList<>());
        } else {
            List<String> doctorsForSpecialty = specialtyDoctors.getOrDefault(specialty, new ArrayList<>());
            responseData.put("doctors", doctorsForSpecialty);

            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialty, doctorName, date, time);
            bubbleSort(filteredDoctors);
            responseData.put("availability", filteredDoctors);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private Map<String, List<String>> loadSpecialtiesAndDoctors(HttpServletRequest request) {
        Map<String, List<String>> specialtyDoctors = new HashMap<>();
        String doctorsPath = request.getServletContext().getRealPath("/data/doctors.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(doctorsPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    String specialty = parts[3].trim();
                    String doctorName = parts[2].trim();
                    specialtyDoctors.computeIfAbsent(specialty, k -> new ArrayList<>()).add(doctorName);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return specialtyDoctors;
    }

    private List<Doctor> loadDoctors(HttpServletRequest request) {
        List<Doctor> doctors = new ArrayList<>();
        Map<String, String[]> doctorDetails = new HashMap<>();
        String doctorsPath = request.getServletContext().getRealPath("/data/doctors.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(doctorsPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    doctorDetails.put(parts[0], new String[]{parts[2], parts[3]});
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        String availabilityPath = request.getServletContext().getRealPath("/data/doctors_availability.txt");
        try (BufferedReader br = new BufferedReader(new FileReader(availabilityPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    String[] details = doctorDetails.get(parts[0]);
                    if (details != null) {
                        doctors.add(new Doctor(parts[0], details[0], details[1], parts[1], parts[2], parts[3]));
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return doctors;
    }

    private List<Doctor> filterDoctors(List<Doctor> doctors, String specialty, String doctorName,
                                       String date, String time) {
        List<Doctor> filtered = new ArrayList<>();

        for (Doctor doc : doctors) {
            boolean matches = true;

            if (specialty != null && !specialty.isEmpty() && !doc.specialty.equalsIgnoreCase(specialty)) {
                matches = false;
            }
            if (doctorName != null && !doctorName.isEmpty() && !doc.name.equalsIgnoreCase(doctorName)) {
                matches = false;
            }
            if (date != null && !date.isEmpty() && !doc.date.equals(date)) {
                matches = false;
            }
            if (time != null && !time.isEmpty()) {
                int startHour = Integer.parseInt(doc.startTime.split(":")[0]);
                if (time.equals("morning") && (startHour < 8 || startHour >= 12)) {
                    matches = false;
                } else if (time.equals("afternoon") && (startHour < 12 || startHour >= 17)) {
                    matches = false;
                }
            }

            if (matches) {
                filtered.add(doc);
            }
        }
        return filtered;
    }

    private void bubbleSort(List<Doctor> doctors) {
        int n = doctors.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (doctors.get(j).compareTo(doctors.get(j + 1)) > 0) {
                    Doctor temp = doctors.get(j);
                    doctors.set(j, doctors.get(j + 1));
                    doctors.set(j + 1, temp);
                }
            }
        }
    }
}