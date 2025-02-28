<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Appointment System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Base Styles */
        :root {
            --bg-color: #f3f4f6; /* Light mode: gray-100 */
            --text-color: #1f2937; /* Light mode: gray-800 */
            --card-bg: #ffffff; /* Light mode: white */
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --nav-bg: #ffffff;
            --btn-bg: #2563eb; /* Blue-600 */
            --btn-hover: #1d4ed8; /* Blue-700 */
            --border-color: #d1d5db; /* Gray-300 */
        }
        [data-theme="dark"] {
            --bg-color: #1f2937; /* Dark mode: gray-800 */
            --text-color: #f3f4f6; /* Dark mode: gray-100 */
            --card-bg: #374151; /* Dark mode: gray-700 */
            --card-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            --nav-bg: #111827; /* Gray-900 */
            --btn-bg: #3b82f6; /* Blue-500 */
            --btn-hover: #60a5fa; /* Blue-400 */
            --border-color: #4b5563; /* Gray-600 */
        }
        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        nav, footer {
            background-color: var(--nav-bg);
        }
        .dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown:hover .dropdown-menu {
            display: block;
            opacity: 1;
            transform: translateY(0);
        }
        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            opacity: 0;
            transform: translateY(-10px);
            transition: all 0.3s ease-in-out;
            min-width: 160px;
            background-color: var(--card-bg);
            box-shadow: var(--card-shadow);
            border-radius: 0.5rem;
            z-index: 10;
        }
        .dropdown-menu a {
            display: block;
            padding: 0.75rem 1rem;
            color: var(--text-color);
            text-decoration: none;
        }
        .dropdown-menu a:hover {
            background-color: #eff6ff;
            color: #2563eb;
        }
        .feature-card, .specialty-card {
            background-color: var(--card-bg);
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .feature-card:hover, .specialty-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        .hero-cta, .search-btn {
            background-color: var(--btn-bg);
            transition: all 0.3s ease;
        }
        .hero-cta:hover, .search-btn:hover {
            background-color: var(--btn-hover);
            transform: scale(1.05);
        }
        .search-form {
            background: var(--card-bg);
            border-radius: 1rem;
            box-shadow: var(--card-shadow);
            padding: 2rem;
            max-width: 900px;
            margin: -4rem auto 4rem;
            position: relative;
            z-index: 5;
        }
        .specialty-card img {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
        }
        .toggle-btn {
            cursor: pointer;
            transition: transform 0.3s ease;
        }
        .toggle-btn:hover {
            transform: scale(1.1);
        }
        /* Advanced Styling */
        .hero-section {
            background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%);
        }
        .input-field {
            border: 1px solid var(--border-color);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .input-field:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }
    </style>
</head>
<body class="font-sans">
<!-- Navbar with Theme Toggle -->
<nav class="shadow-lg fixed w-full z-10 top-0">
    <div class="container mx-auto px-6 py-4 flex justify-between items-center">
        <a href="index.html" class="text-2xl font-bold text-blue-600 flex items-center">
            <i class="fas fa-clinic-medical mr-2"></i>MediSchedule
        </a>
        <div class="flex items-center space-x-6">
            <div class="dropdown">
                <button class="text-white px-5 py-2 rounded-lg hover:bg-blue-700 transition-colors duration-300 flex items-center hero-cta">
                    <i class="fas fa-user mr-2"></i>Login
                </button>
                <div class="dropdown-menu">
                    <a href="login-user.html">User Login</a>
                    <a href="login-admin.html">Admin Login</a>
                    <a href="login-doctor.html">Doctor Login</a>
                </div>
            </div>
            <button id="theme-toggle" class="toggle-btn text-2xl p-2 rounded-full bg-gray-200 dark:bg-gray-700">
                <i class="fas fa-sun"></i>
            </button>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<header class="hero-section text-white text-center py-24 mt-16">
    <h1 class="text-4xl md:text-5xl font-bold mb-4 animate-fade-in">Effortless Medical Appointment Scheduling</h1>
    <p class="text-lg md:text-xl opacity-90 max-w-2xl mx-auto">Book appointments, manage schedules, and simplify healthcare access with ease.</p>
    <div class="mt-8 flex justify-center space-x-4">
        <a href="appointment.html" class="text-white px-6 py-3 rounded-lg font-semibold hero-cta shadow-md">Book an Appointment</a>
    </div>
</header>

<!-- Search Form Section -->
<section class="search-form">
    <h2 class="text-2xl font-bold mb-6 text-center">Find Your Appointment</h2>
    <form action="#" method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
            <label for="doctor" class="block font-medium mb-1">Doctor Name</label>
            <input type="text" id="doctor" name="doctor" placeholder="e.g., Dr. Smith" class="input-field w-full px-4 py-2 rounded-lg">
        </div>
        <div>
            <label for="hospital" class="block font-medium mb-1">Hospital</label>
            <input type="text" id="hospital" name="hospital" placeholder="e.g., City Hospital" class="input-field w-full px-4 py-2 rounded-lg">
        </div>
        <div>
            <label for="specialization" class="block font-medium mb-1">Specialization</label>
            <select id="specialization" name="specialization" class="input-field w-full px-4 py-2 rounded-lg">
                <option value="">Select Specialization</option>
                <option value="cardiology">Cardiology</option>
                <option value="neurology">Neurology</option>
                <option value="pediatrics">Pediatrics</option>
                <option value="orthopedics">Orthopedics</option>
            </select>
        </div>
        <div>
            <label for="date" class="block font-medium mb-1">Date</label>
            <input type="date" id="date" name="date" class="input-field w-full px-4 py-2 rounded-lg">
        </div>
        <div class="md:col-span-4 flex justify-center mt-4">
            <button type="submit" class="search-btn text-white px-6 py-3 rounded-lg font-semibold flex items-center">
                <i class="fas fa-search mr-2"></i>Search
            </button>
        </div>
    </form>
</section>

<!-- Features Section -->
<section class="container mx-auto px-6 my-20">
    <h2 class="text-3xl md:text-4xl font-bold text-center mb-12">Why Choose MediSchedule?</h2>
    <div class="grid md:grid-cols-3 gap-8">
        <div class="p-6 rounded-xl text-center feature-card">
            <i class="fas fa-clock text-blue-600 text-3xl mb-4"></i>
            <h3 class="text-xl font-semibold">Fast Scheduling</h3>
            <p class="mt-2">Quickly book appointments with our simple and efficient system.</p>
        </div>
        <div class="p-6 rounded-xl text-center feature-card">
            <i class="fas fa-sort-amount-up text-blue-600 text-3xl mb-4"></i>
            <h3 class="text-xl font-semibold">Priority-based Sorting</h3>
            <p class="mt-2">Emergency cases get prioritized using smart algorithms.</p>
        </div>
        <div class="p-6 rounded-xl text-center feature-card">
            <i class="fas fa-users text-blue-600 text-3xl mb-4"></i>
            <h3 class="text-xl font-semibold">User-Friendly</h3>
            <p class="mt-2">A seamless experience for patients, doctors, and admins.</p>
        </div>
    </div>
</section>

<!-- Medical Specialties Section -->
<section class="container mx-auto px-6 my-20">
    <h2 class="text-3xl md:text-4xl font-bold text-center mb-12">Solutions for Every Specialty</h2>
    <div class="grid md:grid-cols-3 gap-8">
        <div class="rounded-xl specialty-card overflow-hidden">
            <img src="https://images.unsplash.com/photo-1519494026892-80cea6e6410c" alt="Medical Clinic">
            <div class="p-6">
                <h3 class="text-xl font-semibold">Medical Clinics</h3>
                <p class="mt-2">Access your calendar and patient info at all times via the admin app.</p>
            </div>
        </div>
        <div class="rounded-xl specialty-card overflow-hidden">
            <img src="https://images.unsplash.com/photo-1666214379818-4a49d56e6bb5" alt="Physiologist">
            <div class="p-6">
                <h3 class="text-xl font-semibold">Physiologists</h3>
                <p class="mt-2">Enjoy caring for your patients and let MediSchedule handle your bookings.</p>
            </div>
        </div>
        <div class="rounded-xl specialty-card overflow-hidden">
            <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c" alt="Chiropractor">
            <div class="p-6">
                <h3 class="text-xl font-semibold">Chiropractors</h3>
                <p class="mt-2">Send booking confirmations and reminders to clients and providers.</p>
            </div>
        </div>
        <div class="rounded-xl specialty-card overflow-hidden">
            <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d" alt="Dental Clinic">
            <div class="p-6">
                <h3 class="text-xl font-semibold">Dental Clinics</h3>
                <p class="mt-2">Send automated "book soon" notifications 12 months after checkups.</p>
            </div>
        </div>
        <div class="rounded-xl specialty-card overflow-hidden">
            <img src="https://images.unsplash.com/photo-1631217868264-e6b8221a077f" alt="Psychologist">
            <div class="p-6">
                <h3 class="text-xl font-semibold">Psychologists</h3>
                <p class="mt-2">A one-stop solution: website, bookings, payments, and more.</p>
            </div>
        </div>
        <div class="rounded-xl specialty-card overflow-hidden">
            <img src="https://images.unsplash.com/photo-1592853621830-1b1b1d759676" alt="Acupuncture">
            <div class="p-6">
                <h3 class="text-xl font-semibold">Acupuncture</h3>
                <p class="mt-2">Accept bookings via website, Facebook, Instagram, and Google.</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="py-8">
    <div class="container mx-auto px-6">
        <div class="flex flex-col md:flex-row justify-between items-center">
            <p class="mb-4 md:mb-0">© 2025 MediSchedule. All rights reserved.</p>
            <div class="flex space-x-6">
                <a href="#" class="hover:text-blue-400 transition-colors duration-300">Privacy Policy</a>
                <a href="#" class="hover:text-blue-400 transition-colors duration-300">Terms of Service</a>
                <a href="#" class="hover:text-blue-400 transition-colors duration-300">Contact</a>
            </div>
        </div>
    </div>
</footer>

<script>
    // Theme Toggle Functionality
    const toggleButton = document.getElementById('theme-toggle');
    const body = document.body;
    const sunIcon = '<i class="fas fa-sun"></i>';
    const moonIcon = '<i class="fas fa-moon"></i>';

    // Check for saved theme preference
    if (localStorage.getItem('theme') === 'dark') {
        body.setAttribute('data-theme', 'dark');
        toggleButton.innerHTML = sunIcon;
    } else {
        body.removeAttribute('data-theme');
        toggleButton.innerHTML = moonIcon;
    }

    toggleButton.addEventListener('click', () => {
        if (body.getAttribute('data-theme') === 'dark') {
            body.removeAttribute('data-theme');
            toggleButton.innerHTML = moonIcon;
            localStorage.setItem('theme', 'light');
        } else {
            body.setAttribute('data-theme', 'dark');
            toggleButton.innerHTML = sunIcon;
            localStorage.setItem('theme', 'dark');
        }
    });

    // Animations and Smooth Scroll
    window.addEventListener('load', () => {
        document.querySelector('h1').classList.add('animate-fade-in');
    });

    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
</script>
</body>
</html>