package model;

public class Patient {
    private String name;
    private int age;
    private String contact;
    private String username;
    private String password;

    public Patient(String name, int age, String contact, String username, String password) {
        this.name = name;
        this.age = age;
        this.contact = contact;
        this.username = username;
        this.password = password;
    }

    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getContact() { return contact; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }

    // For file storage: Format as a single line
    @Override
    public String toString() {
        return name + "," + age + "," + contact + "," + username + "," + password;
    }
}