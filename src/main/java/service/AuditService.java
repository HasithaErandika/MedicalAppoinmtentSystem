package service;

import java.io.IOException;
import java.util.List;

public class AuditService {
    private final FileHandler fileHandler;

    public AuditService(FileHandler fileHandler) {
        this.fileHandler = fileHandler;
    }

    public List<String> readAuditLogs() throws IOException {
        return fileHandler.readLines();
    }

    public void clearAuditLogs() throws IOException {
        fileHandler.writeLines(List.of());
    }

    public void addAuditLog(String log) throws IOException {
        List<String> logs = fileHandler.readLines();
        logs.add(log);
        fileHandler.writeLines(logs);
    }
}