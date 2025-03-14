package model;

public class Doctor {
    private String id;
    private String name;
    private String specialization;
    private String contact;

    public Doctor(String id, String name, String specialization, String contact) {
        this.id = id;
        this.name = name;
        this.specialization = specialization;
        this.contact = contact;
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public String getSpecialization() { return specialization; }
    public String getContact() { return contact; }

    // For file storage: Format as a single line
    @Override
    public String toString() {
        return id + "," + name + "," + specialization + "," + contact;
    }
}