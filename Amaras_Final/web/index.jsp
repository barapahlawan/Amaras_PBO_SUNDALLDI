<%-- 
    Document   : index
    Created on : 22 May 2025, 12.18.57
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yayasan Amaras Harapan Bangsa</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f5f5;
        }

        /* Header Styling */
        header {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-container {
            display: flex;
            align-items: center;
        }

        .logo-container img {
            height: 50px;
            margin-right: 10px;
        }

        .logo-text h1 {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 0;
        }

        .logo-text h2 {
            font-size: 1rem;
            font-weight: normal;
        }

        nav ul {
            display: flex;
            list-style: none;
        }

        nav ul li {
            margin-left: 2rem;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        nav ul li a:hover {
            opacity: 0.8;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 4rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            width: 55%;
        }

        .hero-content h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .donate-btn {
            background-color: white;
            color: #1a56a2;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
        }

        .donate-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .hero-image {
            width: 40%;
            display: flex;
            justify-content: center;
        }

        .hero-image img {
            width: 80%;
            max-width: 300px;
            opacity: 0.7;
        }

        /* Services Section */
        .services {
            padding: 2rem 5%;
        }

        .services-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .services-title {
            font-size: 2rem;
            color: #1a56a2;
        }

        .donation-counter {
            display: flex;
            align-items: center;
        }

        .donation-counter img {
            width: 40px;
            margin-right: 10px;
        }

        .donation-amount {
            font-size: 2rem;
            color: #1a56a2;
            font-weight: bold;
            padding-left: 20px;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }

        .service-card {
            background-color: white;
            border-radius: 10px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .service-icon {
            font-size: 3rem;
            color: #1a56a2;
            margin-bottom: 1rem;
        }

        .service-title {
            font-size: 1.5rem;
            color: #1a56a2;
            margin-bottom: 0.5rem;
        }

        .service-description {
            color: #666;
            font-size: 0.9rem;
        }

        /* Footer */
        footer {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .register-text {
            font-size: 1.2rem;
        }

        .register-btn {
            background-color: white;
            color: #1a56a2;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .register-btn:hover {
            background-color: #f5f5f5;
        }

        @media (max-width: 768px) {
            .hero {
                flex-direction: column;
                padding: 2rem 5%;
            }
            
            .hero-content, .hero-image {
                width: 100%;
                text-align: center;
            }
            
            .hero-image {
                margin-top: 2rem;
            }
            
            .services-grid {
                grid-template-columns: 1fr;
            }
            
            footer {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header with Logo and Navigation -->
    <header>
        <div class="logo-container">
            <div class="logo-icon">
                <!-- Using image file for logo -->
                <img src="logo.png" alt="Yayasan Amaras Logo" height="50">
            </div>
            <div class="logo-text">
                <h1>YAYASAN AMARAS</h1>
                <h2>HARAPAN BANGSA</h2>
            </div>
        </div>
        <nav>
            <ul>
                <li><a href="TentangKami.jsp">Tentang Kami</a></li>
                <li><a href = "Login.jsp">Masuk</a></li>
                
            </ul>
        </nav>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Pelayanan Sosial Berbasis Cinta dan Ilmu</h1>
            <p>Yayasan Amaras Harapan Bangsa hadir untuk membangun masyarakat melalui Posyandu, KBM, dan Sekolah Lansia.</p>
            <a href="Register.jsp" class="donate-btn" id="donateBtn">Donasi Sekarang!</a>
        </div>
        <div class="hero-image">
            <!-- Using image file for logo in hero section -->
            <img src="logo.png" alt="Yayasan Amaras Logo" style="width: 80%; max-width: 300px; opacity: 0.7;">
        </div>
    </section>

    <!-- Services Section -->
    <section class="services">
        <div class="services-header">
            <h2 class="services-title">Layanan Kami</h2>
            <div class="donation-counter">
                <h2 class="services-title">Total Donasi: </h2>
                <span class="donation-amount">
                    <% 
                        RequestDispatcher rd = request.getRequestDispatcher("donasiServlet?action=totalDonasi");
                        rd.include(request, response);
                    %>
                <%
                    Number total = (Number) request.getAttribute("totalDonasi");
                    String formatted = (total != null) ? String.format("%,d", total.longValue()).replace(",", ".") : "0";
                %>
                Rp.<%= formatted %>

                    
                </span>

            </div>
        </div>
        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">
                    <svg width="60" height="60" viewBox="0 0 100 100" fill="#1a56a2">
                        <path d="M35,40 C35,25 65,25 65,40 C65,55 80,60 80,75 C80,90 20,90 20,75 C20,60 35,55 35,40" stroke="#1a56a2" stroke-width="5" fill="none"></path>
                        <circle cx="50" cy="25" r="10" fill="#1a56a2"></circle>
                    </svg>
                </div>
                <h3 class="service-title">Posyandu</h3>
                <p class="service-description">Pelayanan Ibu dan Anak</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="60" height="60" viewBox="0 0 100 100" fill="#1a56a2">
                        <rect x="20" y="20" width="60" height="60" rx="5" stroke="#1a56a2" stroke-width="5" fill="none"></rect>
                        <line x1="20" y1="40" x2="80" y2="40" stroke="#1a56a2" stroke-width="5"></line>
                        <line x1="50" y1="20" x2="50" y2="80" stroke="#1a56a2" stroke-width="5"></line>
                    </svg>
                </div>
                <h3 class="service-title">KBM</h3>
                <p class="service-description">Kelompok Belajar Masyarakat</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="60" height="60" viewBox="0 0 100 100" fill="#1a56a2">
                        <circle cx="50" cy="40" r="20" stroke="#1a56a2" stroke-width="5" fill="none"></circle>
                        <path d="M30,35 L35,45 M65,45 L70,35" stroke="#1a56a2" stroke-width="3"></path>
                        <path d="M40,50 C45,55 55,55 60,50" stroke="#1a56a2" stroke-width="3" fill="none"></path>
                        <path d="M20,80 C20,65 80,65 80,80" stroke="#1a56a2" stroke-width="5" fill="none"></path>
                    </svg>
                </div>
                <h3 class="service-title">Sekolah Lansia</h3>
                <p class="service-description">Edukasi dan kegiatan aktif untuk Lansia</p>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="register-text">Daftarkan Diri Anda!</div>
        <a href="Register.jsp" class="register-btn">Daftar</a>
    </footer>

    <script>
        // JavaScript untuk menangani klik tombol donasi
        document.getElementById('donateBtn').addEventListener('click', function() {
            // Simulasi form donasi atau redirect ke halaman donasi
            alert('Terima kasih atas niat baik Anda! Halaman donasi akan segera dibuka.');
        });

        // Animasi counter donasi
        const donationAmount = document.querySelector('.donation-amount');
        const targetAmount = 12250000;
        let currentAmount = 12000000;
        const duration = 2000; // ms
        const frameRate = 20; // fps
        const increment = targetAmount / (duration / 1000 * frameRate);

        function animateDonationCounter() {
            if (currentAmount < targetAmount) {
                currentAmount += increment;
                if (currentAmount > targetAmount) {
                    currentAmount = targetAmount;
                }
                
                // Format angka dengan pemisah ribuan
                const formattedAmount = new Intl.NumberFormat('id-ID').format(Math.floor(currentAmount));
                donationAmount.textContent = Rp. ${formattedAmount};
                
                setTimeout(animateDonationCounter, 1000 / frameRate);
            }
        }

        // Mulai animasi saat halaman dimuat
        window.addEventListener('load', function() {
            setTimeout(animateDonationCounter, 500);
        });

        // Deteksi scroll untuk efek parallax sederhana
        window.addEventListener('scroll', function() {
            const heroImage = document.querySelector('.hero-image');
            const scrollPosition = window.scrollY;
            
            if (scrollPosition < 500) {
                heroImage.style.transform = translateY(${scrollPosition * 0.1}px);
            }
        });

        // Tambahkan efek hover pada kartu layanan
        const serviceCards = document.querySelectorAll('.service-card');
        serviceCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.backgroundColor = '#f0f7ff';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.backgroundColor = 'white';
            });
        });
    </script>
</body>
</html>