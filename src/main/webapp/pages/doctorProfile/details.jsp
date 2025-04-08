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

<style>
    .user-details {
        max-width: 800px;
        margin: 0 auto;
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        padding: 2rem;
        animation: fadeIn 0.5s ease-in;
    }

    .section-header {
        margin-bottom: 1.5rem;
        border-bottom: 2px solid var(--secondary);
        padding-bottom: 0.5rem;
    }

    .section-header h2 {
        font-size: 1.5rem;
        color: var(--text);
        display: flex;
        align-items: center;
    }

    .section-header i {
        margin-right: 0.5rem;
        color: var(--secondary);
    }

    .profile-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 2rem;
    }

    .profile-picture-wrapper {
        text-align: center;
    }

    .profile-picture {
        position: relative;
        width: 150px;
        height: 150px;
    }

    .profile-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        border: 3px solid var(--secondary);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .upload-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.4);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .profile-picture:hover .upload-overlay {
        opacity: 1;
        cursor: pointer;
    }

    .upload-overlay i {
        color: white;
        font-size: 1.5rem;
    }

    .details-container {
        width: 100%;
        max-width: 600px;
    }

    .details-view {
        transition: opacity 0.3s ease;
    }

    .details-list {
        display: grid;
        gap: 1rem;
    }

    .detail-item {
        display: flex;
        align-items: center;
        padding: 0.5rem 0;
        border-bottom: 1px solid #eee;
    }

    .detail-item dt {
        font-weight: 600;
        color: var(--text);
        width: 120px;
        flex-shrink: 0;
    }

    .detail-item dd {
        margin: 0;
        color: #555;
        flex-grow: 1;
    }

    .edit-popup {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
    }

    .popup-content {
        background: white;
        padding: 2rem;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        width: 90%;
        max-width: 500px;
        animation: popupIn 0.3s ease-out;
    }

    .form-grid {
        display: grid;
        gap: 1.5rem;
    }

    .form-field {
        display: flex;
        flex-direction: column;
    }

    .form-label {
        font-weight: 600;
        color: var(--text);
        margin-bottom: 0.5rem;
    }

    .form-input, .form-input:disabled {
        padding: 0.75rem;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 1rem;
        color: var(--text);
        background: #f9f9f9;
        transition: border-color 0.3s ease;
    }

    .form-input:focus {
        outline: none;
        border-color: var(--secondary);
        box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
    }

    .info-text, .error-text {
        font-size: 0.85rem;
        color: #7f8c8d;
        margin-top: 0.25rem;
    }

    .error-text {
        color: var(--accent);
    }

    .action-buttons {
        margin-top: 2rem;
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 6px;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.3s ease, transform 0.2s ease;
    }

    .btn-primary {
        background: var(--secondary);
        color: white;
    }

    .btn-primary:hover {
        background: #2980b9;
        transform: translateY(-2px);
    }

    .btn-secondary {
        background: #95a5a6;
        color: white;
    }

    .btn-secondary:hover {
        background: #7f8c8d;
        transform: translateY(-2px);
    }

    .btn i {
        margin-right: 0.5rem;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @keyframes popupIn {
        from { opacity: 0; transform: scale(0.9); }
        to { opacity: 1; transform: scale(1); }
    }

    @media (max-width: 768px) {
        .form-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

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