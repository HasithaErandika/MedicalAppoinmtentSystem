<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="dashboard-card" id="userDetailsSection" aria-labelledby="user-details-title">
    <h2 id="user-details-title">Your Profile Details</h2>

    <%-- Success Message (if present) --%>
    <c:if test="${not empty message}">
        <div class="toast ${messageType}" id="toastMessage" role="alert" aria-live="assertive">
            <i class="ri-${messageType == 'error' ? 'alert' : 'checkbox-circle'}-line"></i>
                ${message}
        </div>
    </c:if>

    <%-- Read-only view (default) --%>
    <c:if test="${param.edit != 'true'}">
        <div class="details-view card">
            <div class="detail-row">
                <span class="label">Username</span>
                <span class="value">${sessionScope.username}</span>
            </div>
            <div class="detail-row">
                <span class="label">Password</span>
                <span class="value">••••••••</span> <%-- Masked for security --%>
            </div>
            <div class="detail-row">
                <span class="label">Full Name</span>
                <span class="value">${sessionScope.fullname}</span>
            </div>
            <div class="detail-row">
                <span class="label">Email</span>
                <span class="value">${sessionScope.email}</span>
            </div>
            <div class="detail-row">
                <span class="label">Phone</span>
                <span class="value">${sessionScope.phone}</span>
            </div>
            <div class="detail-row">
                <span class="label">Birthday</span>
                <span class="value">${sessionScope.birthday}</span>
            </div>
            <div class="form-actions">
                <button type="button" id="editDetailsBtn" class="btn-primary" onclick="loadSection('userDetails', 'edit=true')">
                    <i class="ri-edit-line"></i> Edit Details
                </button>
            </div>
        </div>
    </c:if>

    <%-- Editable form (shown when edit=true) --%>
    <c:if test="${param.edit == 'true'}">
        <form action="<%= request.getContextPath() %>/user" method="post" id="detailsForm" class="form-grid card" novalidate>
            <input type="hidden" name="action" value="updateDetails">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${sessionScope.username}" disabled aria-describedby="username-desc">
                <small id="username-desc" class="form-hint">Username cannot be changed.</small>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" value="${sessionScope.password}" required aria-describedby="password-error">
                <span class="error-message" id="password-error"></span>
            </div>
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" value="${sessionScope.fullname}" required aria-describedby="fullName-error">
                <span class="error-message" id="fullName-error"></span>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${sessionScope.email}" required aria-describedby="email-error">
                <span class="error-message" id="email-error"></span>
            </div>
            <div class="form-group">
                <label for="phone">Phone</label>
                <input type="tel" id="phone" name="phone" value="${sessionScope.phone}" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" placeholder="123-456-7890" required aria-describedby="phone-error">
                <span class="error-message" id="phone-error"></span>
            </div>
            <div class="form-group">
                <label for="birthday">Birthday</label>
                <input type="date" id="birthday" name="birthday" value="${sessionScope.birthday}" required aria-describedby="birthday-error">
                <span class="error-message" id="birthday-error"></span>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-secondary" onclick="loadSection('userDetails')">Cancel</button>
                <button type="submit" class="btn-primary" aria-label="Save Changes">
                    <i class="ri-save-line"></i> Save Changes
                </button>
            </div>
        </form>
    </c:if>
</section>

<style>
    :root {
        --primary: #2F855A;        /* Forest Green */
        --secondary: #38B2AC;      /* Teal */
        --accent: #E53E3E;         /* Red */
        --bg-light: #F7FAF9;       /* Light background */
        --text-primary: #1A4731;   /* Dark green */
        --text-muted: #6B7280;     /* Gray */
        --card-bg: #FFFFFF;        /* White cards */
        --shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        --border: #D1D5DB;         /* Neutral border */
        --hover: #E6FFFA;          /* Light green hover */
        --transition: all 0.3s ease;
        --border-radius: 10px;
    }

    .dashboard-card {
        padding: 1.5rem;
        background: var(--card-bg);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        max-width: 600px;
        margin: 0 auto;
        animation: fadeIn 0.3s ease;
    }

    h2 {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    h2::before {
        content: "\e0e1"; /* Remixicon user-line */
        font-family: "remixicon";
        color: var(--primary);
    }

    /* Toast Notification */
    .toast {
        padding: 1rem 1.5rem;
        border-radius: var(--border-radius);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        box-shadow: var(--shadow);
        font-weight: 500;
        animation: slideIn 0.3s ease;
    }

    .success {
        background: #D1FAE5;
        color: var(--primary);
    }

    .error {
        background: #FEE2E2;
        color: var(--accent);
    }

    @keyframes slideIn {
        from { transform: translateY(-20px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }

    /* Details View */
    .details-view {
        padding: 1rem;
    }

    .detail-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--border);
        transition: var(--transition);
    }

    .detail-row:hover {
        background: var(--hover);
    }

    .label {
        font-weight: 500;
        color: var(--text-primary);
        font-size: 1rem;
    }

    .value {
        color: var(--text-muted);
        font-size: 1rem;
    }

    /* Form Grid */
    .form-grid {
        display: grid;
        gap: 1.25rem;
        padding: 1.5rem;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    label {
        font-weight: 500;
        color: var(--text-primary);
        font-size: 0.95rem;
    }

    input {
        padding: 0.75rem;
        border: 1px solid var(--border);
        border-radius: var(--border-radius);
        font-size: 1rem;
        color: var(--text-primary);
        transition: var(--transition);
    }

    input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(47, 133, 90, 0.2);
        outline: none;
    }

    input:disabled {
        background: #F3F4F6;
        color: var(--text-muted);
        cursor: not-allowed;
    }

    .form-hint {
        font-size: 0.85rem;
        color: var(--text-muted);
    }

    .error-message {
        font-size: 0.85rem;
        color: var(--accent);
        min-height: 1rem;
    }

    /* Form Actions */
    .form-actions {
        display: flex;
        gap: 1rem;
        justify-content: flex-end;
        margin-top: 1.5rem;
    }

    .btn-primary, .btn-secondary {
        padding: 0.75rem 1.5rem;
        border-radius: var(--border-radius);
        border: none;
        font-weight: 500;
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
        background: #276749;
        box-shadow: var(--shadow);
    }

    .btn-secondary {
        background: var(--accent);
        color: #FFFFFF;
    }

    .btn-secondary:hover {
        background: #C53030;
        box-shadow: var(--shadow);
    }

    /* Animation */
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .dashboard-card {
            padding: 1rem;
            max-width: 100%;
        }
        .form-grid {
            padding: 1rem;
        }
        .form-actions {
            flex-direction: column;
            gap: 0.75rem;
        }
        .btn-primary, .btn-secondary {
            width: 100%;
            justify-content: center;
        }
    }
</style>

<script>
    // Hide toast message after 3 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const toast = document.getElementById('toastMessage');
        if (toast && toast.classList.contains('success')) {
            setTimeout(() => {
                toast.style.opacity = '0';
                setTimeout(() => {
                    toast.style.display = 'none';
                    // Redirect to read-only view after fade-out
                    loadSection('userDetails');
                }, 300); // Match fade-out duration
            }, 3000); // 3 seconds
        }
    });

    // Basic client-side validation
    document.getElementById('detailsForm')?.addEventListener('submit', function(e) {
        let valid = true;
        const fields = [
            { id: 'password', error: 'Password is required' },
            { id: 'fullName', error: 'Full Name is required' },
            { id: 'email', error: 'Valid email is required', type: 'email' },
            { id: 'phone', error: 'Phone must be in format 123-456-7890', pattern: /^[0-9]{3}-[0-9]{3}-[0-9]{4}$/ },
            { id: 'birthday', error: 'Birthday is required' }
        ];

        fields.forEach(field => {
            const input = document.getElementById(field.id);
            const errorSpan = document.getElementById(`${field.id}-error`);
            errorSpan.textContent = '';

            if (!input.value) {
                errorSpan.textContent = field.error;
                valid = false;
            } else if (field.type === 'email' && !/^\S+@\S+\.\S+$/.test(input.value)) {
                errorSpan.textContent = field.error;
                valid = false;
            } else if (field.pattern && !field.pattern.test(input.value)) {
                errorSpan.textContent = field.error;
                valid = false;
            }
        });

        if (!valid) e.preventDefault();
    });

    // Placeholder loadSection function
    function loadSection(section, params = '') {
        window.location.href = `<%= request.getContextPath() %>/pages/userProfile.jsp?section=${section}.jsp${params ? '&' + params : ''}`;
    }
</script>