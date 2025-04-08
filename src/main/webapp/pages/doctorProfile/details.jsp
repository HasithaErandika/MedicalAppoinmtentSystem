<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="dashboard-card user-details" id="userDetailsSection" aria-labelledby="user-details-title">
    <header class="section-header">
        <h2 id="user-details-title">
            <i class="fas fa-user" aria-hidden="true"></i> Your Profile Details
        </h2>
    </header>

    <!-- Read-only View -->
    <c:if test="${param.edit != 'true'}">
        <div class="details-container">
            <dl class="details-list">
                <div class="detail-item">
                    <dt class="detail-label">ID</dt>
                    <dd class="detail-value"><c:out value="${doctor.id != null ? doctor.id : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Full Name</dt>
                    <dd class="detail-value"><c:out value="${doctor.name != null ? doctor.name : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Specialization</dt>
                    <dd class="detail-value"><c:out value="${doctor.specialization != null ? doctor.specialization : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Contact</dt>
                    <dd class="detail-value"><c:out value="${doctor.contact != null ? doctor.contact : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Password</dt>
                    <dd class="detail-value">••••••••</dd>
                </div>
            </dl>
            <div class="action-buttons">
                <button type="button" id="editDetailsBtn" class="btn btn-primary" aria-label="Edit Profile Details" onclick="window.location.href='<%= request.getContextPath() %>/DoctorServlet?section=details&edit=true'">
                    <i class="fas fa-edit" aria-hidden="true"></i> Edit Profile
                </button>
            </div>
        </div>
    </c:if>

    <!-- Editable Form -->
    <c:if test="${param.edit == 'true'}">
        <form action="<%= request.getContextPath() %>/DoctorServlet" method="post" id="detailsForm" class="edit-form" novalidate>
            <input type="hidden" name="action" value="updateDetails">
            <input type="hidden" name="id" value="${doctor.id}">

            <div class="form-grid">
                <div class="form-field">
                    <label for="id" class="form-label">ID</label>
                    <input type="text" id="id" name="id" value="${doctor.id}" class="form-input" disabled aria-describedby="id-info">
                    <span class="info-text" id="id-info">ID cannot be changed</span>
                </div>
                <div class="form-field">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" id="name" name="name" value="${doctor.name}" class="form-input" required aria-required="true" aria-describedby="name-error">
                    <span class="error-text" id="name-error" aria-live="polite"></span>
                </div>
                <div class="form-field">
                    <label for="specialization" class="form-label">Specialization</label>
                    <input type="text" id="specialization" name="specialization" value="${doctor.specialization}" class="form-input" required aria-required="true" aria-describedby="specialization-error">
                    <span class="error-text" id="specialization-error" aria-live="polite"></span>
                </div>
                <div class="form-field">
                    <label for="contact" class="form-label">Contact</label>
                    <input type="tel" id="contact" name="contact" value="${doctor.contact}" class="form-input" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" required aria-required="true" aria-describedby="contact-error">
                    <span class="error-text" id="contact-error" aria-live="polite">Format: XXX-XXX-XXXX</span>
                </div>
                <div class="form-field">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input" aria-describedby="password-error">
                    <span class="error-text" id="password-error" aria-live="polite">Leave blank to keep current password</span>
                </div>
            </div>

            <div class="action-buttons">
                <button type="button" id="cancelEditBtn" class="btn btn-secondary" aria-label="Cancel Editing" onclick="window.location.href='<%= request.getContextPath() %>/DoctorServlet?section=details'">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary" aria-label="Save Profile Changes">
                    <i class="fas fa-save" aria-hidden="true"></i> Save Changes
                </button>
            </div>
        </form>
    </c:if>
</section>