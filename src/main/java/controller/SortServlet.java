import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import com.google.gson.Gson;

@WebServlet("/SortServlet")
public class SortServlet extends HttpServlet {

    // Doctor class to hold doctor information
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

        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Get search parameters
        String specialty = request.getParameter("specialty");
        String doctorName = request.getParameter("doctor");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        // Load and filter doctors
        List<Doctor> doctors = loadDoctors();
        List<Doctor> filteredDoctors = filterDoctors(doctors, specialty, doctorName, date, time);

        // Sort using bubble sort
        bubbleSort(filteredDoctors);

        // Convert to JSON and send response
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(filteredDoctors);
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }

    private List<Doctor> loadDoctors() {
        List<Doctor> doctors = new ArrayList<>();

        // Load doctor details
        Map<String, String[]> doctorDetails = new HashMap<>();
        try (BufferedReader br = new BufferedReader(new FileReader(getServletContext().getRealPath("/WEB-INF/doctors.txt")))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                doctorDetails.put(parts[0], new String[]{parts[2], parts[3]}); // username -> [name, specialty]
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Load availability and combine with doctor details
        try (BufferedReader br = new BufferedReader(new FileReader(getServletContext().getRealPath("/WEB-INF/doctors_availability.txt")))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                String[] details = doctorDetails.get(parts[0]);
                if (details != null) {
                    doctors.add(new Doctor(parts[0], details[0], details[1], parts[1], parts[2], parts[3]));
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
            if (doctorName != null && !doctorName.isEmpty() &&
                    !doc.name.toLowerCase().contains(doctorName.toLowerCase())) {
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
                    // Swap doctors
                    Doctor temp = doctors.get(j);
                    doctors.set(j, doctors.get(j + 1));
                    doctors.set(j + 1, temp);
                }
            }
        }
    }
}