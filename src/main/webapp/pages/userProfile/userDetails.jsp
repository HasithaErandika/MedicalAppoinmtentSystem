<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<section class="dashboard-card" id="userDetailsSection" aria-labelledby="user-details-title">
    <h2 id="user-details-title">Your Details</h2>

    <%-- Read-only view (default) --%>
    <c:if test="${param.edit != 'true'}">
        <div class="details-view">
            <div class="detail-row">
                <span class="label">Username:</span>
                <span class="value">${sessionScope.username}</span>
            </div>
            <div class="detail-row">
                <span class="label">Password:</span>
                <span class="value">${sessionScope.password}</span>
            </div>
            <div class="detail-row">
                <span class="label">Full Name:</span>
                <span class="value">${sessionScope.fullname}</span>
            </div>
            <div class="detail-row">
                <span class="label">Email:</span>
                <span class="value">${sessionScope.email}</span>
            </div>
            <div class="detail-row">
                <span class="label">Phone:</span>
                <span class="value">${sessionScope.phone}</span>
            </div>
            <div class="detail-row">
                <span class="label">Birthday:</span>
                <span class="value">${sessionScope.birthday}</span>
            </div>
            <div class="form-actions">
                <button type="button" id="editDetailsBtn" class="btn-primary">
                    <i class="fas fa-edit"></i> Edit Details
                </button>
            </div>
        </div>
    </c:if>

    <%-- Editable form (shown when edit=true) --%>
    <c:if test="${param.edit == 'true'}">
        <form action="<%= request.getContextPath() %>/user" method="post" id="detailsForm" class="form-grid" novalidate>
            <input type="hidden" name="action" value="updateDetails">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${sessionScope.username}" disabled>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" value="${sessionScope.password}" aria-required="true">
                <span class="error-message" id="password-error"></span>
            </div>
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" value="${sessionScope.fullname}" aria-required="true">
                <span class="error-message" id="fullName-error"></span>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${sessionScope.email}" aria-required="true">
                <span class="error-message" id="email-error"></span>
            </div>
            <div class="form-group">
                <label for="phone">Phone</label>
                <input type="tel" id="phone" name="phone" value="${sessionScope.phone}" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" aria-required="true">
                <span class="error-message" id="phone-error"></span>
            </div>
            <div class="form-group">
                <label for="birthday">Birthday</label>
                <input type="date" id="birthday" name="birthday" value="${sessionScope.birthday}" aria-required="true">
                <span class="error-message" id="birthday-error"></span>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-secondary" onclick="loadSection('userDetails')">Cancel</button>
                <button type="submit" class="btn-primary" aria-label="Save Changes">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </div>
        </form>
    </c:if>
</section>

<style>
    .details-view {
        display: grid;
        gap: 1rem;
        padding: 1rem;
    }
    .detail-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.5rem 0;
        border-bottom: 1px solid #e0e0e0;
    }
    .label {
        font-weight: bold;
        color: #333;
    }
    .value {
        color: #666;
    }
    .form-actions {
        margin-top: 1rem;
        text-align: right;
    }
</style>