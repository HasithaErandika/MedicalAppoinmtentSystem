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
                    <dt class="detail-label">Username</dt>
                    <dd class="detail-value"><c:out value="${sessionScope.username != null ? sessionScope.username : 'N/A'}" /></dd>
                </div>
                <div class="detail-item">
                    <dt class="detail-label">Password</dt>
                    <dd class="detail-value">••••••••</dd> <!-- Masked for security -->
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
    :root {
        --primary: #2C5282;
        --secondary: #38B2AC;
        --accent: #E53E3E;
        --bg-light: #F7FAFC;
        --text-primary: #2D3748;
        --text-muted: #718096;
        --card-bg: #FFFFFF;
        --shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
        --border: #E2E8F0;
        --hover: #EDF2F7;
        --transition: all 0.3s ease;
        --border-radius: 12px;
        --spacing-unit: 1rem;
    }

    .user-details {
        background: var(--card-bg);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        padding: calc(var(--spacing-unit) * 2);
        transition: var(--transition);
        max-width: 900px;
        margin: 0 auto;
    }

    .section-header {
        margin-bottom: calc(var(--spacing-unit) * 1.5);
        padding-bottom: var(--spacing-unit);
        border-bottom: 1px solid var(--border);
    }

    .section-header h2 {
        font-size: 1.75rem;
        font-weight: 600;
        color: var(--primary);
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .section-header h2 i {
        color: var(--secondary);
    }

    .details-container {
        padding: var(--spacing-unit);
    }

    .details-list {
        display: grid;
        gap: calc(var(--spacing-unit) * 0.75);
    }

    .detail-item {
        display: grid;
        grid-template-columns: 140px 1fr;
        align-items: center;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--border);
        transition: var(--transition);
    }

    .detail-item:hover {
        background: var(--hover);
    }

    .detail-label {
        font-weight: 600;
        color: var(--text-primary);
        font-size: 1rem;
    }

    .detail-value {
        color: var(--text-muted);
        font-size: 1rem;
        word-break: break-word;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: calc(var(--spacing-unit) * 1.5);
        margin-bottom: calc(var(--spacing-unit) * 2);
    }

    .form-field {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .form-label {
        font-weight: 500;
        color: var(--text-primary);
        font-size: 0.95rem;
    }

    .form-input {
        padding: 0.75rem;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 1rem;
        background: var(--card-bg);
        transition: var(--transition);
        width: 100%;
    }

    .form-input:focus {
        border-color: var(--secondary);
        box-shadow: 0 0 8px rgba(56, 178, 172, 0.2);
        outline: none;
    }

    .form-input:disabled {
        background: var(--bg-light);
        color: var(--text-muted);
        cursor: not-allowed;
    }

    .error-text, .info-text {
        font-size: 0.85rem;
        min-height: 1rem;
    }

    .error-text {
        color: var(--accent);
    }

    .info-text {
        color: var(--text-muted);
    }

    .action-buttons {
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        margin-top: calc(var(--spacing-unit) * 1.5);
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        cursor: pointer;
        transition: var(--transition);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .btn-primary {
        background: var(--primary);
        color: #FFFFFF;
    }

    .btn-primary:hover {
        background: #1E3A8A;
        box-shadow: 0 4px 12px rgba(44, 82, 130, 0.3);
        transform: translateY(-2px);
    }

    .btn-secondary {
        background: var(--text-muted);
        color: #FFFFFF;
    }

    .btn-secondary:hover {
        background: #5A7184;
        box-shadow: 0 4px 12px rgba(113, 128, 150, 0.3);
        transform: translateY(-2px);
    }

    @media (max-width: 768px) {
        .detail-item {
            grid-template-columns: 120px 1fr;
        }

        .form-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 480px) {
        .user-details {
            padding: var(--spacing-unit);
        }

        .detail-item {
            grid-template-columns: 1fr;
            gap: 0.25rem;
        }

        .action-buttons {
            flex-direction: column;
            gap: 0.75rem;
        }

        .btn {
            width: 100%;
            justify-content: center;
        }
    }
</style>