<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<section class="dashboard-card user-details" id="userDetailsSection" aria-labelledby="user-details-title">
    <header class="section-header">
        <h2 id="user-details-title">
            <i class="fas fa-user" aria-hidden="true"></i> Your Profile Details
        </h2>
    </header>

    <!-- Profile Picture Section -->
    <div class="profile-picture-container">
        <img src="https://static.vecteezy.com/system/resources/previews/036/193/398/non_2x/patient-flat-icon-for-personal-and-commercial-use-free-vector.jpg"
             alt="User Profile Picture"
             class="profile-picture">
    <!-- Read-only View -->
    <c:if test="${param.edit != 'true'}">
        <div class="details-container">
            <dl class="details-list">
                <div class="detail-item">
                    <dt class="detail-label">Username</dt>
                    <dd class="detail-value"><c:out value="${sessionScope.username != null ? sessionScope.username : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Password</dt>
                    <dd class="detail-value">••••••••</dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Full Name</dt>
                    <dd class="detail-value"><c:out value="${sessionScope.fullname != null ? sessionScope.fullname : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Email</dt>
                    <dd class="detail-value"><c:out value="${sessionScope.email != null ? sessionScope.email : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Phone</dt>
                    <dd class="detail-value"><c:out value="${sessionScope.phone != null ? sessionScope.phone : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Birthday</dt>
                    <dd class="detail-value"><c:out value="${sessionScope.birthday != null ? sessionScope.birthday : 'N/A'}" /></dd>
                </div>
            </dl>
            <div class="action-buttons">
                <button type="button" id="editDetailsBtn" class="btn btn-primary" aria-label="Edit Profile Details">
                    <i class="fas fa-edit" aria-hidden="true"></i> Edit Profile
                </button>
            </div>
        </div>
    </c:if>

    <!-- Editable Form -->
    <c:if test="${param.edit == 'true'}">
        <form action="<%= request.getContextPath() %>/user" method="post" id="detailsForm" class="edit-form" novalidate>
            <input type="hidden" name="action" value="updateDetails">

            <div class="form-grid">
                <div class="form-field">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" value="${sessionScope.username}" class="form-input" disabled aria-describedby="username-info">
                    <span class="info-text" id="username-info">Username cannot be changed</span>
                </div>
                <div class="form-field">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" value="${sessionScope.password}" class="form-input" required aria-required="true" aria-describedby="password-error">
                    <span class="error-text" id="password-error" aria-live="polite"></span>
                </div>
                <div class="form-field">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" id="fullName" name="fullName" value="${sessionScope.fullname}" class="form-input" required aria-required="true" aria-describedby="fullName-error">
                    <span class="error-text" id="fullName-error" aria-live="polite"></span>
                </div>
                <div class="form-field">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" value="${sessionScope.email}" class="form-input" required aria-required="true" aria-describedby="email-error">
                    <span class="error-text" id="email-error" aria-live="polite"></span>
                </div>
                <div class="form-field">
                    <label for="phone" class="form-label">Phone</label>
                    <input type="tel" id="phone" name="phone" value="${sessionScope.phone}" class="form-input" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" required aria-required="true" aria-describedby="phone-error">
                    <span class="error-text" id="phone-error" aria-live="polite">Format: XXX-XXX-XXXX</span>
                </div>
                <div class="form-field">
                    <label for="birthday" class="form-label">Birthday</label>
                    <input type="date" id="birthday" name="birthday" value="${sessionScope.birthday}" class="form-input" required aria-required="true" aria-describedby="birthday-error">
                    <span class="error-text" id="birthday-error" aria-live="polite"></span>
                </div>
            </div>

            <div class="action-buttons">
                <button type="button" id="cancelEditBtn" class="btn btn-secondary" aria-label="Cancel Editing">Cancel</button>
                <button type="submit" class="btn btn-primary" aria-label="Save Profile Changes">
                    <i class="fas fa-save" aria-hidden="true"></i> Save Changes
                </button>
            </div>
        </form>
    </c:if>
</section>

<style>
    /* General container styling */
    .user-details {
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    /* Profile picture styling */
    .profile-picture-container {
        text-align: center;
        margin-bottom: 20px;
    }

    .profile-picture {
        width: 120px;
        height: 120px;
        border-radius: 50%; /* Makes it circular */
        object-fit: cover; /* Ensures image fits nicely */
        border: 3px solid #007bff; /* Adds a subtle border */
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    /* Header styling */
    .section-header {
        text-align: center;
        margin-bottom: 20px;
    }

    .section-header h2 {
        font-size: 1.5rem;
        color: #333;
    }

    /* Details list styling */
    .details-container {
        padding: 15px;
    }

    .details-list {
        display: grid;
        gap: 15px;
    }

    .detail-item {
        display: flex;
        justify-content: space-between;
        padding: 10px;
        background-color: #f9f9f9;
        border-radius: 5px;
    }

    .detail-label {
        font-weight: bold;
        color: #555;
    }

    .detail-value {
        color: #333;
    }

    /* Button styling */
    .action-buttons {
        text-align: center;
        margin-top: 20px;
    }

    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 1rem;
    }

    .btn-primary {
        background-color: #007bff;
        color: #fff;
    }

    .btn-primary:hover {
        background-color: #0056b3;
    }
</style>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/userProfile.css">