<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="dashboard-card user-details" id="userDetailsSection" aria-labelledby="user-details-title">
    <header class="section-header">
        <h2 id="user-details-title">
            <i class="fas fa-user-md" aria-hidden="true"></i> Your Profile Details
        </h2>
    </header>

    <div class="profile-container">
        <!-- Profile Picture Centered -->
        <div class="profile-picture-wrapper">
            <div class="profile-picture">
                <img src="https://img.freepik.com/premium-vector/doctor-profile-with-medical-service-icon_617655-48.jpg" alt="Doctor Profile Picture" class="profile-img">
                <div class="upload-overlay" aria-hidden="true">
                    <i class="fas fa-camera"></i>
                </div>
            </div>
        </div>

        <!-- Details and Edit Popup -->
        <div class="details-container">
            <!-- Read-only View -->
            <div class="details-view" id="detailsView">
                <dl class="details-list">
                    <div class="detail-item">
                        <dt>ID</dt>
                        <dd><c:out value="${doctor.id != null ? doctor.id : 'N/A'}" /></dd>
                    </div>
                    <div class="detail-item">
                        <dt>Full Name</dt>
                        <dd><c:out value="${doctor.name != null ? doctor.name : 'N/A'}" /></dd>
                    </div>
                    <div class="detail-item">
                        <dt>Specialization</dt>
                        <dd><c:out value="${doctor.specialization != null ? doctor.specialization : 'N/A'}" /></dd>
                    </div>
                    <div class="detail-item">
                        <dt>Contact</dt>
                        <dd><c:out value="${doctor.contact != null ? doctor.contact : 'N/A'}" /></dd>
                    </div>
                    <div class="detail-item">
                        <dt>Password</dt>
                        <dd>••••••••</dd>
                    </div>
                </dl>
                <div class="action-buttons">
                    <button type="button" id="editDetailsBtn" class="btn btn-primary" aria-label="Edit Profile Details">
                        <i class="fas fa-edit" aria-hidden="true"></i> Edit Profile
                    </button>
                </div>
            </div>

            <!-- Editable Popup Form -->
            <div class="edit-popup" id="editPopup" style="display: none;">
                <div class="popup-content">
                    <form action="<%= request.getContextPath() %>/DoctorServlet" method="post" id="detailsForm" class="edit-form" novalidate>
                        <input type="hidden" name="action" value="updateDetails">
                        <input type="hidden" name="id" value="${doctor.id}">

                        <div class="form-grid">
                            <div class="form-field">
                                <label for="id">ID</label>
                                <input type="text" id="id" name="id" value="${doctor.id}" class="form-input" disabled aria-describedby="id-info">
                                <span class="info-text" id="id-info">ID cannot be changed</span>
                            </div>
                            <div class="form-field">
                                <label for="name">Full Name</label>
                                <input type="text" id="name" name="name" value="${doctor.name}" class="form-input" required aria-required="true" aria-describedby="name-error">
                                <span class="error-text" id="name-error" aria-live="polite"></span>
                            </div>
                            <div class="form-field">
                                <label for="specialization">Specialization</label>
                                <select id="specialization" name="specialization" class="form-input" required aria-required="true" aria-describedby="specialization-error">
                                    <option value="${doctor.specialization}" selected><c:out value="${doctor.specialization != null ? doctor.specialization : 'Select Specialization'}" /></option>
                                    <option value="General Surgery">General Surgery</option>
                                    <option value="Obstetrics and Gynecology">Obstetrics and Gynecology</option>
                                    <option value="Gynecology">Gynecology</option>
                                    <option value="Ayurvedic Medicine">Ayurvedic Medicine</option>
                                    <option value="Pediatrics">Pediatrics</option>
                                    <option value="Other">Other</option>
                                </select>
                                <span class="error-text" id="specialization-error" aria-live="polite"></span>
                            </div>
                            <div class="form-field">
                                <label for="contact">Contact</label>
                                <input type="tel" id="contact" name="contact" value="${doctor.contact}" class="form-input" pattern="[0-9]{10}" required aria-required="true" aria-describedby="contact-error">
                                <span class="error-text" id="contact-error" aria-live="polite">Format: 0778896501 (10 digits)</span>
                            </div>
                            <div class="form-field">
                                <label for="password">New Password</label>
                                <input type="password" id="password" name="password" class="form-input" aria-describedby="password-error">
                                <span class="error-text" id="password-error" aria-live="polite">Leave blank to keep current password</span>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <button type="button" id="cancelEditBtn" class="btn btn-secondary" aria-label="Cancel Editing">Cancel</button>
                            <button type="submit" class="btn btn-primary" aria-label="Save Profile Changes">
                                <i class="fas fa-save" aria-hidden="true"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/doctorDashboard.css">

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const editBtn = document.getElementById('editDetailsBtn');
        const cancelBtn = document.getElementById('cancelEditBtn');
        const editPopup = document.getElementById('editPopup');
        const detailsView = document.getElementById('detailsView');

        editBtn.addEventListener('click', () => {
            detailsView.style.opacity = '0';
            setTimeout(() => {
                detailsView.style.display = 'none';
                editPopup.style.display = 'flex';
            }, 300);
        });

        cancelBtn.addEventListener('click', () => {
            editPopup.style.display = 'none';
            detailsView.style.opacity = '0';
            setTimeout(() => {
                detailsView.style.display = 'block';
                detailsView.style.opacity = '1';
            }, 50);
        });
    });
</script>