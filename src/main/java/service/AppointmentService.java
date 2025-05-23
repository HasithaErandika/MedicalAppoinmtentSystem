package service;

import model.Appointment;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class AppointmentService {
    private static final Logger LOGGER = Logger.getLogger(AppointmentService.class.getName());
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private final String filePath;
    private final FileHandler fileHandler;
    private List<Appointment> cachedAppointments;
    private final String patientFilePath = "/data/patients.txt";

    public AppointmentService(String filePath) throws IOException {
        this.filePath = filePath;
        this.fileHandler = new FileHandler(filePath);
        this.cachedAppointments = readAppointments();
        if (cachedAppointments == null) {
            cachedAppointments = new ArrayList<>();
        }
        enrichAppointmentsWithPatientNames();
    }

    public List<Appointment> readAppointments() throws IOException {
        return fileHandler.readAppointments();
    }

    public synchronized void bookAppointment(String patientId, String doctorId, String tokenID, String dateTime, boolean isEmergency) throws IOException {
        if (patientId == null || doctorId == null || tokenID == null || dateTime == null) {
            throw new IllegalArgumentException("Invalid appointment details");
        }

        int newId = 0;
        for (Appointment appt : cachedAppointments) {
            if (appt.getId() > newId) {
                newId = appt.getId();
            }
        }
        newId++;
        int priority = isEmergency ? 1 : 2;
        Appointment newAppointment = new Appointment(newId, patientId, doctorId, tokenID, dateTime, priority);
        String patientName = fileHandler.getPatientNameByUsername(patientId, patientFilePath);
        newAppointment.setPatientName(patientName);

        cachedAppointments.add(newAppointment);
        writeAppointments(cachedAppointments);
        LOGGER.info("Booked appointment: " + newAppointment);
    }

    public synchronized void updateAppointment(int id, String patientId, String doctorId, String tokenID, String dateTime, int priority) throws IOException {
        boolean found = false;
        for (int i = 0; i < cachedAppointments.size(); i++) {
            if (cachedAppointments.get(i).getId() == id) {
                Appointment updated = new Appointment(id, patientId, doctorId, tokenID, dateTime, priority);
                String patientName = fileHandler.getPatientNameByUsername(patientId, patientFilePath);
                updated.setPatientName(patientName);
                cachedAppointments.set(i, updated);
                found = true;
                break;
            }
        }
        if (!found) throw new IllegalArgumentException("Appointment with ID " + id + " not found");
        writeAppointments(cachedAppointments);
        LOGGER.info("Updated appointment ID: " + id);
    }

    public synchronized void cancelAppointment(int id) throws IOException {
        boolean removed = false;
        for (int i = 0; i < cachedAppointments.size(); i++) {
            if (cachedAppointments.get(i).getId() == id) {
                cachedAppointments.remove(i);
                removed = true;
                break;
            }
        }
        if (!removed) throw new IllegalArgumentException("Appointment with ID " + id + " not found");
        writeAppointments(cachedAppointments);
        LOGGER.info("Cancelled appointment ID: " + id);
    }

    private void writeAppointments(List<Appointment> appointments) throws IOException {
        fileHandler.writeAppointments(appointments);
    }

    private void enrichAppointmentsWithPatientNames() throws IOException {
        for (Appointment appt : cachedAppointments) {
            String patientName = fileHandler.getPatientNameByUsername(appt.getPatientId(), patientFilePath);
            appt.setPatientName(patientName);
        }
    }

    public Appointment getNextEmergency() {
        Appointment earliest = null;
        for (Appointment appt : cachedAppointments) {
            if (appt.getPriority() == 1) {
                if (earliest == null || compareDateTimes(appt.getDateTime(), earliest.getDateTime()) < 0) {
                    earliest = appt;
                }
            }
        }
        return earliest;
    }

    public List<Appointment> getAllAppointments() {
        return new ArrayList<>(cachedAppointments);
    }

    public List<Appointment> getAppointmentsByPatientId(String patientId) {
        List<Appointment> result = new ArrayList<>();
        for (Appointment appt : cachedAppointments) {
            if (appt.getPatientId().equals(patientId)) {
                result.add(appt);
            }
        }
        return result;
    }

    public List<Appointment> getAppointmentsByDoctorId(String doctorId) {
        List<Appointment> result = new ArrayList<>();
        for (Appointment appt : cachedAppointments) {
            if (appt.getDoctorId().equals(doctorId)) {
                result.add(appt);
            }
        }
        return result;
    }

    public List<Appointment> getSortedAppointments() {
        List<Appointment> appointments = new ArrayList<>(cachedAppointments);
        mergeSortAppointments(appointments, 0, appointments.size() - 1);
        return appointments;
    }

    private void mergeSortAppointments(List<Appointment> appointments, int left, int right) {
        if (left < right) {
            int mid = (left + right) / 2;
            mergeSortAppointments(appointments, left, mid);
            mergeSortAppointments(appointments, mid + 1, right);
            mergeAppointments(appointments, left, mid, right);
        }
    }

    private void mergeAppointments(List<Appointment> appointments, int left, int mid, int right) {
        List<Appointment> leftList = new ArrayList<>();
        List<Appointment> rightList = new ArrayList<>();

        for (int i = left; i <= mid; i++) {
            leftList.add(appointments.get(i));
        }
        for (int i = mid + 1; i <= right; i++) {
            rightList.add(appointments.get(i));
        }

        int i = 0, j = 0, k = left;
        while (i < leftList.size() && j < rightList.size()) {
            Appointment leftAppt = leftList.get(i);
            Appointment rightAppt = rightList.get(j);

            if (compareAppointments(leftAppt, rightAppt) <= 0) {
                appointments.set(k, leftAppt);
                i++;
            } else {
                appointments.set(k, rightAppt);
                j++;
            }
            k++;
        }

        while (i < leftList.size()) {
            appointments.set(k, leftList.get(i));
            i++;
            k++;
        }

        while (j < rightList.size()) {
            appointments.set(k, rightList.get(j));
            j++;
            k++;
        }
    }

    private int compareAppointments(Appointment a1, Appointment a2) {
        // Compare by priority first (1 = emergency, 2 = non-emergency)
        if (a1.getPriority() != a2.getPriority()) {
            return a1.getPriority() - a2.getPriority(); // Lower priority number comes first
        }
        // If priorities are equal, compare by date-time
        return compareDateTimes(a1.getDateTime(), a2.getDateTime());
    }

    private int compareDateTimes(String dateTime1, String dateTime2) {
        LocalDateTime dt1 = LocalDateTime.parse(dateTime1, DATE_TIME_FORMATTER);
        LocalDateTime dt2 = LocalDateTime.parse(dateTime2, DATE_TIME_FORMATTER);

        // Manual comparison of LocalDateTime components
        if (dt1.getYear() != dt2.getYear()) {
            return dt1.getYear() - dt2.getYear();
        }
        if (dt1.getMonthValue() != dt2.getMonthValue()) {
            return dt1.getMonthValue() - dt2.getMonthValue();
        }
        if (dt1.getDayOfMonth() != dt2.getDayOfMonth()) {
            return dt1.getDayOfMonth() - dt2.getDayOfMonth();
        }
        if (dt1.getHour() != dt2.getHour()) {
            return dt1.getHour() - dt2.getHour();
        }
        if (dt1.getMinute() != dt2.getMinute()) {
            return dt1.getMinute() - dt2.getMinute();
        }
        return 0;
    }
}