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
            return this.name.compareToIgnoreCase(other.name); // Case-insensitive sorting by name
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

        // Load doctor data
        Map<String, Map<String, String>> doctorDetails = loadDoctorDetails(request);
        Map<String, List<String>> specialtyDoctors = loadSpecialtiesAndDoctors(doctorDetails);
        List<Doctor> allDoctors = loadDoctors(request, doctorDetails);

        // Prepare response
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("specialties", new ArrayList<>(specialtyDoctors.keySet()));

        if (specialty == null || specialty.isEmpty()) {
            responseData.put("doctors", new ArrayList<>());
            responseData.put("availability", new ArrayList<>());
        } else {
            // Get and sort doctor names for the selected specialty
            List<String> doctorsForSpecialty = specialtyDoctors.getOrDefault(specialty, new ArrayList<>());
            Collections.sort(doctorsForSpecialty, String.CASE_INSENSITIVE_ORDER);
            responseData.put("doctors", doctorsForSpecialty);

            // Filter and sort availability
            List<Doctor> filteredDoctors = filterDoctors(allDoctors, specialty, doctorName, date, time);
            Collections.sort(filteredDoctors); // Sort by doctor name (case-insensitive)
            responseData.put("availability", filteredDoctors);
        }

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    // Load doctor details: username -> {name, specialty}
    private Map<String, Map<String, String>> loadDoctorDetails(HttpServletRequest request) {
        Map<String, Map<String, String>> doctorDetails = new HashMap<>();
        String doctorsPath = request.getServletContext().getRealPath("/data/doctors.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(doctorsPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    Map<String, String> details = new HashMap<>();
                    details.put("name", parts[2].trim());
                    details.put("specialty", parts[3].trim());
                    doctorDetails.put(parts[0].trim(), details);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return doctorDetails;
    }

    // Map specialties to doctor names
    private Map<String, List<String>> loadSpecialtiesAndDoctors(Map<String, Map<String, String>> doctorDetails) {
        Map<String, List<String>> specialtyDoctors = new HashMap<>();
        for (Map.Entry<String, Map<String, String>> entry : doctorDetails.entrySet()) {
            String specialty = entry.getValue().get("specialty");
            String doctorName = entry.getValue().get("name");
            specialtyDoctors.computeIfAbsent(specialty, k -> new ArrayList<>()).add(doctorName);
        }
        return specialtyDoctors;
    }

    // Load full doctor availability
    private List<Doctor> loadDoctors(HttpServletRequest request, Map<String, Map<String, String>> doctorDetails) {
        List<Doctor> doctors = new ArrayList<>();
        String availabilityPath = request.getServletContext().getRealPath("/data/doctors_availability.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(availabilityPath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 4) {
                    Map<String, String> details = doctorDetails.get(parts[0].trim());
                    if (details != null) {
                        doctors.add(new Doctor(
                                parts[0].trim(),         // username
                                details.get("name"),     // name
                                details.get("specialty"), // specialty
                                parts[1].trim(),         // date
                                parts[2].trim(),         // startTime
                                parts[3].trim()          // endTime
                        ));
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
}