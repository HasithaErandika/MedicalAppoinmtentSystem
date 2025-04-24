document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main-content');

    // Sidebar toggle
    document.querySelector('.sidebar-toggle')?.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    });

    // Navigation
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', async (e) => {
            e.preventDefault();
            const section = link.dataset.section.trim();
            if (section === 'bookAppointment' || section === 'appointments') {
                window.location.href = `${window.contextPath}/pages/index.jsp`;
                return;
            }
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            await loadSection(section);
        });
    });

    // Load default section
    loadSection('userDetails');
});

// Load Section
async function loadSection(section) {
    const contentArea = document.getElementById('content-area');
    contentArea.innerHTML = '<div class="loading">Loading...</div>';
    const [baseSection, query] = section.split('?');
    const url = encodeURI(`${window.contextPath}/pages/userProfile/${baseSection}.jsp${query ? '?' + query : ''}`);
    console.log("Fetching section from:", url);
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`Failed to load ${section}: ${response.status} - ${response.statusText}`);
        const text = await response.text();
        contentArea.innerHTML = text;
        initializeSection(baseSection);
    } catch (error) {
        console.error("Error loading section:", error);
        contentArea.innerHTML = `<p>Error: ${error.message}</p>`;
    }
}

function initializeSection(section) {
    if (section === 'userDetails') initUserDetails();
}

function initUserDetails() {
    console.log("Initializing User Details...");
    const form = document.getElementById('detailsForm');
    const editBtn = document.getElementById('editDetailsBtn');
    const cancelBtn = document.getElementById('cancelEditBtn');

    if (form) {
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            if (validateForm(form)) form.submit();
        });
    }
    if (editBtn) editBtn.addEventListener('click', () => loadSection('userDetails?edit=true'));
    if (cancelBtn) cancelBtn.addEventListener('click', () => loadSection('userDetails'));
}

function validateForm(form) {
    let isValid = true;
    form.querySelectorAll('[aria-required="true"]').forEach(input => {
        const error = document.getElementById(`${input.id}-error`);
        if (!input.value) {
            error.textContent = `${input.name} is required`;
            error.style.display = 'block';
            isValid = false;
        } else {
            error.style.display = 'none';
        }
    });
    return isValid;
}