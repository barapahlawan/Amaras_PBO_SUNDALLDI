<%-- 
    Document   : dashboardAdmin
    Created on : 2 Jun 2025, 00.54.58
    Author     : Alexandra Naibaho
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

        .nav-section {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: opacity 0.2s;
        }
        .nav-link:hover {
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

        .profile-dropdown {
            position: relative;
        }

        .profile-trigger {
            background: rgba(255, 255, 255, 0.15);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            transition: background-color 0.2s;
        }

        .profile-trigger:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            min-width: 200px;
            z-index: 1000;
            overflow: hidden;
            margin-top: 0.5rem;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.2s ease;
        }

        .dropdown-menu.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            color: #374151;
            text-decoration: none;
            transition: background-color 0.2s;
            gap: 0.75rem;
        }

        .dropdown-item:hover {
            background-color: #f3f4f6;
        }

        .dropdown-item svg {
            width: 16px;
            height: 16px;
            fill: #6b7280;
        }

        /* Testimonials Section */
        .testimonials {
            background: #e0f2fe;
            padding: 3rem 2rem;
            border-radius: 30px;
            margin-bottom: 3rem;
        }

        .testimonials-title {
            text-align: center;
            color: #005b9f;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 2rem;
        }

        .testimonials-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .testimonial-card {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            transition: all 0.2s ease;
        }

        .testimonial-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .testimonial-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .testimonial-name {
            font-weight: 600;
            color: #005b9f;
        }

        .testimonial-date {
            color: #64748b;
            font-size: 0.875rem;
        }

        .testimonial-message {
            color: #374151;
            margin-bottom: 0.75rem;
            line-height: 1.6;
        }

        .show-more-btn {
            display: block;
            margin: 2rem auto 0;
            background: #64748b;
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .show-more-btn:hover {
            background: #475569;
            transform: translateY(-2px);
        }

        /* Comment Section */
        .comment-section {
            padding: 2rem 5%;
            border-radius: 10px;
            margin: 2rem 0;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .comment-section h2 {
            font-size: 1.5rem;
            color: #1a56a2;
            margin-bottom: 1rem;
            text-align: center;
        }

        #commentForm {
            display: flex;
            flex-direction: column;
        }

        #commentMessage {
            padding: 0.5rem;
            margin-bottom: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            height: 100px;
            font-size: 1rem;
            resize: vertical;
        }

        .submit-comment-btn {
            background-color: #1a56a2;
            color: white;
            padding: 0.75rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1.1rem;
            transition: background-color 0.3s ease;
        }

        .submit-comment-btn:hover {
            background-color: #4285f4;
        }

        .submit-comment-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        /* Footer */
        .footer {
            background: linear-gradient(135deg, #005b9f 100%);
            color: white;
            padding: 2rem;
            text-align: center;
            border-radius: 30px 30px 0 0;
        }

        .footer h2 {
            font-size: 2rem;
            font-weight: 700;
        }

        /* Alert styles */
        .alert {
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 5px;
            display: none;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .nav-section {
                flex-wrap: wrap;
                justify-content: center;
            }

            .hero {
                padding: 2rem 1rem;
                text-align: center;
                flex-direction: column;
            }

            .hero-content {
                width: 100%;
            }

            .hero h1 {
                font-size: 2rem;
            }

            .hero-image {
                width: 100%;
                margin-top: 2rem;
            }

            .services {
                padding: 2rem 1rem;
            }

            .services-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .services-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .testimonials {
                padding: 2rem 1rem;
            }

            .comment-section {
                padding: 2rem 1rem;
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

        <nav class="nav-section">
            <a href="TentangKamiAdmin.jsp" class="nav-link">Tentang Kami</a>
             <div>
                <a href="Login.jsp" class="nav-link">Keluar</a>
                 
             </div>
        </nav>

    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Pelayanan Sosial Berbasis Cinta dan Ilmu</h1>
            <p>Yayasan Amaras Harapan Bangsa hadir untuk membangun masyarakat melalui Posyandu, KBM, dan Sekolah Lansia.</p>
            <a href="donasiServlet?action=viewDonasi" class="donate-btn" id="donateBtn">Riwayat Donasi</a>
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

    <!-- Comment Section - Form Tambah Harapan -->
    <section class="comment-section">
        <h2>Tambahkan Harapan Anda</h2>
        <div id="alertContainer"></div>
        <form id="commentForm" class="comment-form">
            <textarea id="commentMessage" name="commentMessage" placeholder="Tulis harapan Anda..." required></textarea>
            <button type="submit" class="submit-comment-btn">Kirim Komentar</button>
        </form>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials">
        <h2 class="testimonials-title">Harapan Dari Mereka</h2>
        <div class="testimonials-container">
            <div id="commentsContainer">
                <!-- Komentar akan dimuat di sini secara dinamis -->
            </div>
            <button class="show-more-btn" id="showMoreBtn">Tampilkan Lebih Banyak</button>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
       
    </footer>

    <script>
        let commentsToShow = 5;
        let isLoading = false;

        // Initialize when DOM is ready
        document.addEventListener('DOMContentLoaded', function () {
            const commentForm = document.getElementById('commentForm');
            const showMoreBtn = document.getElementById('showMoreBtn');

            if (commentForm) {
                commentForm.addEventListener('submit', handleCommentSubmit);
            }

            if (showMoreBtn) {
                showMoreBtn.addEventListener('click', loadMoreComments);
            }

            loadComments();
        });

        // Handle comment form submission
       // Handle comment form submission
function handleCommentSubmit(event) {
    event.preventDefault();

    if (isLoading) return;

    const messageField = document.getElementById('commentMessage');
    const message = messageField.value.trim();

    if (!message) {
        showAlert('Harap isi komentar!', 'error');
        return;
    }

    if (message.length < 10) {
        showAlert('Komentar minimal 10 karakter!', 'error');
        return;
    }

    setLoadingState(true);

    fetch('KomentarServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'commentMessage=' + encodeURIComponent(message)
    })
    .then(response => response.text())
    .then(result => {
        console.log('Server response:', result);
        
        const trimmedResult = result.trim();
        
        if (trimmedResult === "success") {
            showAlert('Komentar berhasil dikirim!', 'success');
            messageField.value = '';
            commentsToShow = 5;
            loadComments();
        } else if (trimmedResult === "Silahkan donasi terlebih dahulu") {
            // Redirect ke halaman donasi jika user belum donasi
            showAlert('Anda harus berdonasi terlebih dahulu sebelum dapat berkomentar.', 'error');
            setTimeout(() => {
                window.location.href = 'Donasi.jsp';
            }, 2000);
        } else if (trimmedResult.startsWith("error:")) {
            // Handle error messages from server
            const errorMessage = trimmedResult.replace("error: ", "");
            showAlert(errorMessage, 'error');
        } else {
            // Handle other responses
            showAlert('Terjadi kesalahan: ' + trimmedResult, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('Terjadi kesalahan saat mengirim komentar', 'error');
    })
    .finally(() => {
        setLoadingState(false);
    });
}

        // Load comments from server
        function loadComments() {
            if (isLoading) return;

            const container = document.getElementById('commentsContainer');
            if (!container) {
                console.error('Comments container not found');
                return;
            }

            setLoadingState(true);

            fetch('KomentarServlet?action=getComments&limit=' + commentsToShow)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    container.innerHTML = '';
                    
                    if (data.length === 0) {
                        container.innerHTML = '<p style="text-align: center; color: #666; font-style: italic;">Belum ada komentar. Jadilah yang pertama!</p>';
                    } else {
                        data.forEach(function(comment) {
                            const card = createCommentCard(comment);
                            container.appendChild(card);
                        });
                    }

                    updateShowMoreButton(data.length);
                })
                .catch(error => {
                    console.error('Error loading comments:', error);
                    container.innerHTML = '<div class="alert alert-error" style="display: block;">Gagal memuat komentar. Silakan refresh halaman.</div>';
                })
                .finally(() => {
                    setLoadingState(false);
                });
        }

        // Create comment card element
       function createCommentCard(comment) {
            const card = document.createElement('div');
            card.className = 'testimonial-card';

            const date = new Date(comment.tanggal);
            const formattedDate = formatDate(date);

            const name = comment.nama || 'Anonymous';
            const message = comment.pesan || '';

            card.innerHTML = 
                '<div class="testimonial-header">' +
                '<div class="testimonial-name">' + escapeHtml(name) + '</div>' +
                '<div class="testimonial-date">' + formattedDate + '</div>' +
                '</div>' +
                '<div class="testimonial-message">' + escapeHtml(message) + '</div>' +
                '<button class="delete-comment-btn" data-id="' + comment.id + '">Hapus</button>';

                // Tambahkan event listener untuk hapus
            card.querySelector('.delete-comment-btn').addEventListener('click', function() {
                deleteComment(comment.id);
            });

            return card;
        }


        // Load more comments
        function loadMoreComments() {
            commentsToShow += 5;
            loadComments();
        }

        // Update show more button visibility
        function updateShowMoreButton(commentsCount) {
            const showMoreBtn = document.getElementById('showMoreBtn');
            if (showMoreBtn) {
                if (commentsCount < commentsToShow) {
                    showMoreBtn.style.display = 'none';
                } else {
                    showMoreBtn.style.display = 'block';
                }
            }
        }

        // Set loading state for UI elements
        function setLoadingState(loading) {
            isLoading = loading;
            const submitBtn = document.querySelector('.submit-comment-btn');
            
            if (loading) {
                submitBtn.disabled = true;
                submitBtn.textContent = 'Mengirim...';
            } else {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Kirim Komentar';
            }
        }

        // Show alert message
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            
            alertContainer.innerHTML = '';
            
            const alert = document.createElement('div');
            alert.className = 'alert alert-' + type;
            alert.style.display = 'block';
            alert.textContent = message;
            
            alertContainer.appendChild(alert);
            
            setTimeout(function() {
                alert.style.display = 'none';
            }, 5000);
        }

        // Format date for display
        function formatDate(date) {
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            
            return day + '-' + month + '-' + year + ' ' + hours + ':' + minutes;
        }

        // Escape HTML to prevent XSS
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Toggle dropdown menu
        function toggleDropdown() {
            const dropdown = document.getElementById('profileDropdown');
            dropdown.classList.toggle('show');
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('profileDropdown');
            const trigger = document.querySelector('.profile-trigger');
            
            if (!dropdown.contains(event.target) && !trigger.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });
    </script>
    
    <script>
 function deleteComment(commentId) {
    if (!confirm('Apakah Anda yakin ingin menghapus komentar ini?')) return;

    setLoadingState(true);

    fetch('KomentarServlet?action=deleteComment&commentId=' + commentId, {
        method: 'DELETE'
    })
    .then(response => response.text())
    .then(result => {
        if (result.trim() === 'success') {
            showAlert('Komentar berhasil dihapus oleh admin!');
            loadComments(); // Refresh komentar
        } else {
            showAlert('Komentar gagal dihapus!');
        }
    })
    .catch(error => {
        console.error('Error deleting comment:', error);
        showAlert('Terjadi kesalahan saat menghapus komentar', 'error');
    })
    .finally(() => {
        setLoadingState(false);
    });
}


    </script>
</body>
</html>