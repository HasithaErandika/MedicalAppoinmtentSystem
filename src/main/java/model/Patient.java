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

    public String toFileFormat() {
        return name + "," + age + "," + contact + "," + username + "," + password;
    }
}
